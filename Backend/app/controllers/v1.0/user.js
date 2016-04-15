var User = require('../../models/User'),
    _ = require('underscore'),
    path = require("path"),
    Notification = require('../../models/Notification'),
    util = require('../../util/utils'),
	pushUtils = require('../../util/pushUtils'),
    q = require('q'),
    passwordUtils = require('../../util/passwordUtils'),
    fbGraphSDK = require('../../util/facebook-graph-sdk'),
    async = require('async'),
    passport = require('passport'),
    LocalStrategy = require('passport-local').Strategy,
    FacebookTokenStrategy = require('passport-facebook-token'),
    JwtStrategy = require('passport-jwt').Strategy,
    jwt = require('jsonwebtoken'), 
    config = require('../../config'),
    environment = config.environment,
    mandrill = require('mandrill-api/mandrill'),
    nodemailer = require('nodemailer'), 
    request = require('request'),
    crypto = require('crypto'),
    Point = require('../../util/point');

passport.use(
    new FacebookTokenStrategy({
            clientID: config[environment].facebook.clientID,
            clientSecret: config[environment].facebook.clientSecret,
            profileFields: config[environment].facebook.profileFields,
            callbackURL: 'http://localhost:3000/auth/facebook/callback'
        },
        function(accessToken, refreshToken, profile, done) {
        
            User.findOne({
                'facebookId': profile.id
            }).exec(function(err, user) {
                if (err) {
                    console.error("Unable to authenticate: ", err);
                }
                else {
                    if (!user) {
                        done(err, null);
                    }
                    else {
                        user.fbToken = accessToken;
                        user.universalToken = jwt.sign({"_id":user._id}, 'biite');
                        user.save(function(error) {
                            done(error, user);
                        });
                    }
                }
            });
        }
    )
);

var opts = {}
opts.secretOrKey = 'biite';
opts.algorithms = ["HS256"];
passport.use(
	new JwtStrategy(opts,
			function(jwt_payload, done) {			    

				User.findOne({"_id": jwt_payload._id}, function(err, user) {
					if (err) {
						done(err, false);
					}
					if (user) {
						done(null, user);
			
					} else {
						done(null, false);
					}
				});
		}
	)
);

passport.use(new LocalStrategy(
  function(username, password, done) {
    User.findOne({$or:[{ 'username' : username },{"email":username}]}, function(err, user) {
		if (err) {
			console.error("Unable to authenticate: ", err);
			done(err, null);
		}
		else{
			if (!user) {
				done(err, null);
			}
			else{
			
			    if (user.password != password) {			    
        			done(err,null);
      			}
      			else{
                    done(err, user);
      			}      
			}		
		}
    });
  }
));

var api = {
    signup: function(req, res, next) 
    {
        console.log("Signup:"+req.param('username'));

    	if(!_.isUndefined(req.body['extId']) && !_.isNull(req.body['extId']))
        {
    		console.log('Signup with Facebook');

			User.findOne({"facebookId": req.body['extId']}).exec(function(err, u) 
            {
				if (err) 
                {
					res.send(400, util.failure(err));
				} 
                else if (!_.isUndefined(u) && !_.isNull(u)) 
                {
					console.log("user found = ", u);
					res.send(util.success({
						user: u
					}));
				}
                else 
                {
					var user = new User();
					
                    user.username = req.param('username');
					user.email = req.param('email');
                    user.password = req.param('password');
                    user.firstName = req.param('firstName');
                    user.lastName = req.param('lastName');
					user.displayName = user.firstName+' '+user.lastName;
                    user.gender = req.param('gender');
                    user.biography = req.param('biography');
                    user.profileImageURL = req.param('profileImageURL');
                    user.coverImageURL = req.param('coverImageURL');
                    user.facebookId = req.param('extId');
					user.fbToken = req.param('fbToken');
					user.favorites = [];
                    user.onlineStatus = true;
					user.universalToken = jwt.sign({"_id":user._id}, 'biite');
					
                    user.save(function(err, u) 
                    {
						console.log('inside of user save');
						if (!err) 
                        {
							if (!u) 
                            {
								console.log("400 error: no user was created");
								res.send(400, util.failure("Unable to create user: no user was created"));
							}
							else 
                            {								
								res.send(util.success({
									user: u
								}));
							}							
						} 
                        else 
                        {
							res.send(400, util.failure(err));
						}
					});
				}
			});
    	}
    	else if(!_.isUndefined(req.param('username')) && !_.isNull(req.param('username'))) 
        {    	    
            console.log('Signup with Email');

    		User.findOne({"username": req.param('username')}).exec(function(err, u) 
            {    	
				if (err) 
                {
					res.send(400, util.failure(err));
				} 
				else if (!_.isUndefined(u) && !_.isNull(u)) 
                {
					res.send(430, util.failure('User already created'));
				} 
				else 
                {				
					var user = new User();
					
					user.username = req.param('username');
					user.email = req.param('email');
					user.password = req.param('password');
					user.firstName = req.param('firstName');
					user.lastName = req.param('lastName');
	                user.displayName = user.firstName+' '+user.lastName;
					user.gender = req.param('gender');
					user.biography = req.param('biography');
					user.profileImageURL = req.param('profileImageURL');
					user.coverImageURL = req.param('coverImageURL')
					user.favorites = [];
                    user.onlineStatus = true;
					user.universalToken = jwt.sign({"_id":user._id}, 'biite');

                    user.save(function(err, u) 
                    {
						if (!err) 
                        {
							if (!u) 
                            {
								res.send(400, util.failure("Unable to create user: no user was created"));							
							} 
							else 
                            {
								res.send(util.success({
									user: u
								}));
							}
						} 
						else 
                        {
							res.send(400, util.failure(err));
						}
					});
				}
			});
    	} 
    	else 
        {
			res.send(400, util.failure(err));
    	}
    },
    
    userValidation: function(req,res,next)
    {
        console.log('Check user validation');
        
        User.count({username: req.param('username')}, function(err, c) 
        {
            if(err)
            {
                res.send(400, util.failure("Count error"));
            }
            else
            {
                var isTakenBool = true;
            
                if(c<1)
                {
                    isTakenBool = false;
                }
            
                res.send({isTaken:isTakenBool});
            }        
        });
    },

    emailValidation: function(req,res,next)
    {
        console.log('Check email validation');

        User.count({email: req.param('email')}, function(err, c) 
        {
            if(err)
            {
                res.send(400, util.failure("Count error"));
            }
            else
            {
                var isTakenBool = true;
            
                if(c<1)
                {
                    isTakenBool = false;
                }
            
                res.send({isTaken:isTakenBool});
            }        
        });
    },
    
    login: function(req, res, next) {
    
            console.log("Should hit the login method: ",req.user);
        
            var latitude = req.param('latitude'),
                longitude = req.param('longitude'),
                user = req.user;
            if (!_.isUndefined(user) && !_.isNull(user)) {
                if (!_.isUndefined(latitude) &&
                    !_.isNull(latitude) &&
                    !_.isUndefined(longitude) &&
                    !_.isNull(longitude)
                ) {

                    user.lastLocation = [longitude,latitude];
                }

                /**
                 * Use UTC so time is universal.  Eliminates server / client time zone difference issues.
                 **/
                user.lastActive = util.getUtcDate();
                user.onlineStatus = true;
                user.save(function(err, user) {     
                    if (!err) {
                               res.send(util.success({
                                    user: user
                                }));    
                    }
                });
            }
    },

    logout: function(req, res, next) {
    
            console.log("Log out: ",req.user);
        
                req.user.onlineStatus = false;
                req.user.save(function(err, user) {     
                    if (!err) {
                               res.send(util.success({
                                    user: user
                                }));    
                    }
                });      
    },
    
    linkFacebook: function(req,res,next){
        var user = req.user;

        if (!_.isUndefined(req.param('extId')) &&
            !_.isNull(req.param('extId')) 
        ) {
                    
            User.findOne({
                'facebookId': req.param('extId')
            }).exec(function(err, userDuplicate) {
                if (err) {
                    res.send(500, util.failure("Unable to find"));
                }
                else {
                    if (userDuplicate) {
                    
                        userDuplicate.facebookId = undefined;
                        userDuplicate.fbToken = undefined;
                        userDuplicate.save(function(error) {});                    
                    }
    
                    user.fbToken = req.param('fbToken');
                    user.facebookId = req.param('extId');
                    user.save(function(err, u) {
            
                        if (!err) {
                            if (!u) {
                                res.send(400, util.failure("Unable to create user: no user was created"));
                            }
                            else {
                                res.send(util.success({
                                    user: u
                                }));
                            }
                        } else {
                            res.send(400, util.failure(err));
                        }        
                    });                
                }
            });
        }else{
            user.fbToken = undefined;;
            user.facebookId = undefined;;
            user.save(function(err, u) {
    
                if (!err) {
                    if (!u) {
                        res.send(400, util.failure("Unable to create user: no user was created"));
                    }
                    else {
                        res.send(util.success({
                            user: u
                        }));
                    }
                } else {
                    res.send(400, util.failure(err));
                }
            });        
        }   
    },
    
    forgotPassword: function(req,res,next){
        User.findOne({
            'email': req.param('email')
        }).exec(function(err, user) {
            if(user){
                var token = jwt.sign({"_id":user._id}, 'biite');
                var smtpTransport = nodemailer.createTransport({
                    service: 'Gmail',
                    auth: {
                      user: 'tparkerpp@gmail.com',
                      pass: 'biite2016'
                    }
                  });
                  var mailOptions = {
                    to: user.email,
                    from: 'Biite Inc. <tarperkpp@gmail.com>',
                    subject: 'Biite Password Reset',
                    text: 'You are receiving this because you (or someone else) have requested the reset of the password for your account.\n\n' +
                      'Please click on the following link (This email will expire in 1 hour for security reasons):\n\n' +
                      'http://' + req.headers.host + '/v1.0/user/resetpass/' + token + '\n\n' +
                      'If you did not request this, please ignore this email and your password will remain unchanged.\n'
                  };
                  smtpTransport.sendMail(mailOptions, function(err) {
                        
                        if(err){
                            console.log(err);
                            res.send(500, util.failure('Not found'));   
                        }
                        else{
                            res.send(util.success({
                                email:'sent'
                            }));    
                        }               
                  });
            }else{
                res.send(500, util.failure('Not found'));   
            }
        });
    },
    
    resetPassword: function(req,res,next){
        
        var token = req.param('token');

        jwt.verify(token, 'biite', function(err, decoded) {
            if (err) {
                console.error("Unable to authenticate: ", err);
            }else{
                console.log(decoded._id) // bar
            
                User.findOne({
                    '_id': decoded._id
                }).exec(function(err, user) {
                    if(err){
                        
                    }
                    else{
                        if(user){       
                            var passHash = crypto.createHash('sha256').update(req.param('password')).digest('hex');
                            user.password = passHash;
                            user.save(function(err, u) {
                                console.log('after save');

                                if(err){
                                    console.log(err);

                                    res.render(path.join(__dirname, '../../passviews/reset'), {
                                      user: user
                                    });
                                }else{
                                    if(user){
                                        console.log('success');
                                        
                                        res.render(path.join(__dirname, '../../passviews/done'), {
                                          user: user
                                        });
                                    }
                                }
                            });
                        }
                    }
                });        
            }        
        });
    },

    changePassword: function(req,res,next){
        if (!_.isUndefined(req.param('newhashpass')) &&
            !_.isNull(req.param('newhashpass')) &&
            !_.isUndefined(req.param('oldhashpass')) &&
            !_.isNull(req.param('oldhashpass')) 
        ) {
            if(req.param('oldhashpass') == req.user.password){
                req.user.password = req.param('newhashpass');
                req.user.save(function(err, user) {
                    if (!err) {
                        res.send(util.success({
                        }));
                    }
                    else{
                        res.send(401, util.failure("Your new password did not save"));
                    }
                });
            }else{
                res.send(401, util.failure("Your current password is invalid"));
            }

        }else{
           res.send(401, util.failure("Need old and new password"));
        }
    },

    resetView: function(req,res,next){
        var token = req.param('token');
        console.log('tokenis '+token);
        jwt.verify(token, 'biite', function(err, decoded) {
                
            if (err) {
                console.error("Unable to authenticate: ", err);
            }else{
                console.log(decoded._id) // bar
            
                User.findOne({
                    '_id': decoded._id
                }).exec(function(err, user) {
                    if(err){
                
                    }
                    else{
                        res.render(path.join(__dirname, '../../passviews/reset'), {
                          user: user
                        });
                    }
                });     
            }       
        });
    },

    notifications: function(req, res, next) {
        var user = req.user;
        if (
                _.isNull(req.param('deviceToken')) ||
                _.isUndefined(req.param('deviceToken')) ||
                _.isNull(req.param('deviceType')) ||
            _.isUndefined(req.param('deviceType'))
        ) {
            res.send(400, util.failure("Device Token and Device Type are required"));
        }
        else {
            user.deviceToken = req.param('deviceToken');
            user.deviceType = req.param('deviceType');
            user.save(function(err, user) {
                if (!err) {
                    if (!user) {
                        res.send(404, util.failure("User not found"));
                    }
                    else {
                        res.send(util.success({
                            user: user
                        }));
                        /**
                         * Notifications can also be sent from here.
                         **/
                    }
                }
                else {
                    res.send(400, util.failure("Unable to update device token: " + err));
                }
            });
        }
    },

    updateLocation: function(req, res, next) {
        var latitude = req.param('latitude'),
            longitude = req.param('longitude'),
            user = req.user;
        if (!_.isUndefined(user)) {
            if (!_.isUndefined(latitude) &&
                !_.isNull(latitude) &&
                !_.isUndefined(longitude) &&
                !_.isNull(longitude)
            ) {
//                 user.lastLocation.latitude = latitude;
//                 user.lastLocation.longitude = longitude;                
                
                user.lastLocation = [longitude,latitude];

//                 console.log('This is last location ',latitude,' ',longitude,' ',user.lastLocation);                
                
                user.save(function(err, user) {                
                    
                    res.send(util.success({
                        user: user
                    }));
                    
                });
            }
            else {
                res.send(400, util.failure("Location is a required parameter"));
            }
        }
        else {
            res.send(404, util.failure("User was not found"));
        }
    },
    
    updateProfileImageURL: function(req, res, next){        
        if (
                _.isNull(req.param('profileImageURL')) ||
                _.isUndefined(req.param('profileImageURL'))
        ) {
            res.send(400, util.failure("profileImageURL is required"));
        }
        else {
                        
            var userID = req.param('userID');
            User.findOne({
                "_id": userID
            })
            .exec(function(err, user) {
                if (!err) {
                    if (!user) {
                        res.send(404, util.failure('User not found'));
                    }
                    else {
                        req.user.profileImageURL = req.param('profileImageURL');
                        req.user.save(function(err, user) {

                            if(err){
                                res.send(404, util.failure('User not found'));

                            }else{          
                                res.send(util.success({
                                    user: user
                                }));
                            }
                        });
                    }
                }
            });
        }
    },
    
    updateCoverImageURL: function(req, res, next){      
        if (
                _.isNull(req.param('coverImageURL')) ||
                _.isUndefined(req.param('coverImageURL'))
        ) {
            res.send(400, util.failure("coverImageURL is required"));
        }
        else {
                        
            var userID = req.param('userID');
            User.findOne({
                "_id": userID
            })
            .exec(function(err, user) {
                if (!err) {
                    if (!user) {
                        res.send(404, util.failure('User not found'));
                    }
                    else {
                        req.user.coverImageURL = req.param('coverImageURL');
                        req.user.save(function(err, user) {

                            if(err){
                                res.send(404, util.failure('User not found'));

                            }else{          
                                res.send(util.success({
                                    user: user
                                }));
                            }
                        });
                    }
                }
            });
        }
    },
    
    updateNameBiography: function(req, res, next){      
            var userID = req.param('userID');
            User.findOne({
                "_id": userID
            })
            .exec(function(err, user) {
                if (!err) {
                    if (!user) {
                        res.send(404, util.failure('User not found'));
                    }
                    else {
                        req.user.displayName = req.param('displayName');
                        req.user.biography = req.param('biography');
                        req.user.save(function(err, user) {

                            if(err){
                                res.send(404, util.failure('User not found'));

                            }else{          
                                res.send(util.success({
                                    user: user
                                }));
                            }
                        });
                    }
                }
            });
    },
    
    getAllUsers: function(req, res, next) {
        
        User.find()     
        .exec(function(err, users) {
            if(!err){
                res.send(util.success({
                    users: users
                }));
            }else{
                res.send(400, util.failure(err));
            }        
        });
    },

    getUserInfo: function(req, res, next) {
        var userID = req.param('userID');
        User.findOne({
                "_id": userID
            })
            .select('firstName lastName lastActive fbProfileLink')
            .exec(function(err, user) {
                if (!err) {
                    if (!user || user.status < 0) {
                        res.send(404, util.failure('User not found'));
                    }
                    else {
                        res.send(util.success(user));
                    }
                }
                else {
                    res.send(400, util.failure(err));
                }
            });
    },

    auto: function(req, res, next) {
//     	User.find( { firstName: /^J/ }).exec(function(err, users) {
//     	                res.send(users);
//     	});
// 		new RegExp('^'+name+'$', "i")
// 		console.time("dbsearch");
		var q = unescape(req.param('q'));
		var re = new RegExp('^'+q+'.*','i' );
		
    	User.find( {$or:[ { displayName: re}, { username: re}]}, { _id : 1,displayName:1,username:1,profileImageUrl:1,firstName:1,lastName:1 } ).limit(7).lean().exec(function(err, users) {
//     		console.timeEnd("dbsearch");
    	    res.send(users);
    	});		
    },

    getFavorites: function(req, res, next){
        var favoritesArray = req.user.favorites;
        User.find({
            '_id': { $in: favoritesArray}
            
        }).exec(function(err, users){
            if(err){
                res.send(404, util.failure("Error!"));              
            }else{
                res.send(util.success({
                    user: users
                }));                
            }
        });         
    },

    addFavorite: function(req, res, next){
        if (
                _.isNull(req.param('favoriteID')) ||
                _.isUndefined(req.param('favoriteID'))
        ) {
            res.send(400, util.failure("favoriteID is required"));
        }
        else {
            
            var otheruserID = req.param('favoriteID');
            User.findOne({
                "_id": otheruserID
            })
            .exec(function(err, user) {
                if (!err) {
                    if (!user) {

                        res.send(404, util.failure('User not found'));
                    }
                    else {
                        var i = req.user.favorites.indexOf(user._id);
                        if(i != -1) {
                             res.send(500, util.failure("Already added"));
                        }
                        else{
                            user.save(function(err, user) {
                                req.user.favorites.push(user._id);
                                req.user.save(function(err,myuser){
                                    if (!err) {
                                        if (!myuser) {
                                            res.send(404, util.failure("User not found"));
                                        }
                                        else {                                  
                                            res.send(util.success({
                                                user: myuser
                                            }));
                                        }
                                    }
                                    else {
                                        res.send(400, util.failure("Unable send request: " + err));
                                    }                           
                                });                         
                            });                     
                        }                         
                    }
                }
                else {
                    res.send(400, util.failure(err));
                }
            });     
        }
    },

    delFavorite: function(req, res, next){
        if (
                _.isNull(req.param('favoriteID')) ||
                _.isUndefined(req.param('favoriteID'))
        ) {
            res.send(400, util.failure("favoriteID is required"));
        }
        else {
            
            var otheruserID = req.param('favoriteID');
            User.findOne({
                "_id": otheruserID
            })
            .exec(function(err, user) {
                if (!err) {
                    if (!user) {

                        res.send(404, util.failure('User not found'));
                    }
                    else {
                        var i = req.user.favorites.indexOf(user._id);                                                                   
                                                                    
                        if(j != -1) {
                            user.save(function(err, user) {
                                req.user.favorites.splice(i,1);
                                req.user.save(function(err,myuser){
                                    if (!err) {
                                        if (!myuser) {
                                            res.send(404, util.failure("User not found"));
                                        }
                                        else {                                  
                                            res.send(util.success({
                                                user: myuser
                                            }));
                                        }
                                    }
                                    else {
                                        res.send(400, util.failure("Unable send request: " + err));
                                    }                           
                                });                         
                            });
                        }
                        else
                        {
                             res.send(500, util.failure("Already deleted"));
                        }                                                
                    }
                }
                else {
                    res.send(400, util.failure(err));
                }
            });     
        }
    },

    // getNotifications : function(req, res, next) {
        
    //     Notification.find()
    //     .where('to').in([req.user._id]).sort( { _id : -1 } )
    //     .limit(10)
    //     .populate('user')
    //     .lean()
    //     .exec(function(err, notifications) {
        
    //         if (!err) {
                    
    //                 if(req.user.numNotif){
                    
    //                     req.user.numNotif = undefined;
    //                     req.user.save(function(err) {   
    //                     });                        
    //                 }
                    
    //                 res.send(util.success({
    //                      notifications: notifications
    //                 }));
    //         }
    //         else{
    //                 res.send(404, util.failure("Could not get notifications"));
    //         }        
    //     });
    // },

};

module.exports = {
    routes: [
    {
        method: api.signup,
        verb: 'post',
        route: '/user/signup'
    }, {
        method: api.login,
        verb: 'post',
        route: '/user/facebooklogin',
        middleware: [
            passport.authenticate('facebook-token', {
                session: false
            }),
        ]
    }, {
        method: api.login,
        verb: 'post',
        route: '/user/usernamelogin',
        middleware: [
            passport.authenticate('local', {
                session: false
            }),
        ]
    }, {
        method: api.logout,
        verb: 'post',
        route: '/user/usernamelogout',
        middleware: [
            passport.authenticate('jwt', {
                session: false
            }),
        ]
    }, {
        method: api.linkFacebook,
        verb: 'post',
        route: '/user/linkfacebook',
        middleware: [
            passport.authenticate('jwt', {
                session: false
            })
        ]  
    }, {
        method: api.emailValidation,
        verb: 'get',
        route: '/emailvalidation'
    }, {
        method: api.userValidation,
        verb: 'get',
        route: '/uservalidation'
    }, {
        method: api.forgotPassword,
        verb: 'post',
        route: '/user/forgot'
    }, {     
        method: api.resetPassword,
        verb: 'post',
        route: '/user/resetpass/:token'
    }, {     
        method: api.resetView,
        verb: 'get',
        route: '/user/resetpass/:token'
    }, {
        method: api.changePassword,
        verb: 'post',
        route: '/user/changepass',
        middleware: [
            passport.authenticate('jwt', {
                session: false
            })
        ]  
    }, {
        method: api.updateLocation,
        verb: 'post',
        route: '/user/location',
        middleware: [
            passport.authenticate('jwt', {
                session: false
            })
        ]
    }, {
        method: api.updateProfileImageURL,
        verb: 'post',
        route: '/user/updateprofileimageurl',
        middleware: [
            passport.authenticate('jwt', {
                session: false
            })
        ]  
    }, {
        method: api.updateCoverImageURL,
        verb: 'post',
        route: '/user/updatecoverimageurl',
        middleware: [
            passport.authenticate('jwt', {
                session: false
            })
        ]  
    }, {
        method: api.updateNameBiography,
        verb: 'post',
        route: '/user/updatenamebiography',
        middleware: [
            passport.authenticate('jwt', {
                session: false
            })
        ]  
    }, {
        method: api.getAllUsers,
        verb: 'post',
        route: '/user/getallusers',
        middleware: [
            passport.authenticate('jwt', {
                session: false
            })
        ]  
    }, {
        method: api.getUserInfo,
        verb: 'get',
        route: '/user/:userID',
        middleware: [
            passport.authenticate('jwt', {
                session: false
            })
        ]
    }, {
        method: api.notifications,
        verb: 'post',
        route: '/user/notifications',
        middleware: [
            passport.authenticate('jwt', {
                session: false
            })
        ]
    }, {
        method: api.auto,
        verb: 'get',
        route: '/auto'    
    }, {
        method: api.getFavorites,
        verb: 'post',
        route: '/user/getfavorites',
        middleware: [
            passport.authenticate('jwt', {
                session: false
            })
        ]
    }, {
        method: api.addFavorite,
        verb: 'post',
        route: '/user/addfavorite',
        middleware: [
            passport.authenticate('jwt', {
                session: false
            })
        ]
    }, {
        method: api.delFavorite,
        verb: 'post',
        route: '/user/delfavorite',
        middleware: [
            passport.authenticate('jwt', {
                session: false
            })
        ]
    }  
    // }, {
    //     method: api.getNotifications,
    //     verb: 'post',
    //     route: '/user/getNotifications',
    //     middleware: [
    //         passport.authenticate('jwt', {
    //             session: false
    //         })
    //     ]  
    // }   
]};

//   app.get('/user/:userID', passport.authenticate('facebook-token', {session: false}), users.getUser);
//   app.get('/user/:userID/picture', passport.authenticate('facebook-token', {session: false}), users.getUserPicture);
//   app.post('/user/signup', users.createUser);
//   app.post('/user/location', passport.authenticate('facebook-token', {session: false}), users.updateLocation);
//   app.post('/user/login', passport.authenticate('facebook-token', {session: false}), users.loginUser);
//   app.post('/user/verify', passport.authenticate('facebook-token', {session: false}), users.verifyEmail);
//   app.post('/user/update', passport.authenticate('facebook-token', {session: false}), users.updateUserInfo);
//   app.post('/user/notifications', passport.authenticate('facebook-token', {session: false}), users.setUserDeviceToken);
