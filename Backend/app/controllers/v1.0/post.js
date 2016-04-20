/**
 * The POST controller contains all of the business logic for getting and creating
 * SPOP posts.  This contains all of the logic for spops and routes for getting
 * and creating them.
 **/
var Post = require('../../models/Post'),
    User = require('../../models/User'),
    querystring = require('querystring'),
    // Notification = require('../../models/Notification'),
    _ = require('underscore'),
    passport = require('passport'),
    util = require('../../util/utils'),
    pushUtils = require('../../util/pushUtils'),
    Point = require('../../util/point').Point,
    toGeoJson = require('../../util/point').toGeoJson,
    cloudinary = require('cloudinary'),
    config = require('../../config'),
    environment = config.environment,
    fbGraphSDK = require('../../util/facebook-graph-sdk'),
    async = require('async'),
    allCriteria = require('../../util/spop_criteria/criteria'),
    geoJsonUtils = require('geojson-utils'),
    express = require('express'),
    bodyParser = require('body-parser'),
    http = require('http'),
    $q = require('q');

cloudinary.config({
    cloud_name: config[environment].cloudinary.cloud_name,
    api_key: config[environment].cloudinary.api_key,
    api_secret: config[environment].cloudinary.api_secret
});

function filterPostsByCriteria(posts, criteria, res) {
    var returnPosts = [];
    async.each(_.keys(criteria), function(criterion, criteriaCb) {
        allCriteria[criterion].filter(criteria[criterion], posts, function(finalPosts) {
            returnPosts.concat(finalPosts);
        });
    }, function(err) {
        console.log(returnPosts);
        res.send(util.success({
            "posts": returnPosts,
            "criteria": criteria
        }))
    })
            // res.send(400, util.failure(err));
};


var api = {
    getRecipesNearMe: function(req, res, next) 
    {    
        var user = req.user,
            latitude = req.param('latitude'),
            longitude = req.param('longitude'),
            radius = 21;        
                        
        // console.log("criteria = " + sutil.inspect(criteria));
        if (!user ||
            !latitude ||
            !longitude) {
            // console.log(user, latitude, longitude, radius);
            res.send(400, util.failure("Unable to get posts near user: missing required parameter"));
        }
        else {	
				var params = {};
				params.user = user;
				params.access_token = user.accessToken;
	
				// Radius is in KM, so convert from km to radians
				radius = radius / 6371;
				var point = {
					type: "Point",
					coordinates: [Number(longitude), Number(latitude)]
				};

                var queryParams = {
					spherical: true,
					// maxDistance: radius,
					distanceMultiplier: 6378.137, //before 6378137 radians to meters. (The radius of the Earth is approximately 3,959 miles or 6,371 kilometers.)
					query: {reportCount:{$ne:user._id}}
				};
					
				// Post.geoNear(point, queryParams, function(err, results, stats) {
				Post.geoNear(point, queryParams, function(err, results, stats) {
					// Post.geoNear({type: "Point", coordinates: point}, {maxDistance: radius, spherical: true, distanceMultiplier:6378.137}, function(err, results, stats) {
					if (!err) {
						if (results) {
							res.send(util.success({
								posts: results
							}));
						}
						else {
							res.send(util.success({
								"posts": []
							}));
						}
					}
					else {
						res.send(400, util.failure(err));
					}
					// console.log(err, results, stats);
				});
				// console.log("radius = " + radius);
			}
    },

    getAllRecipes: function(req, res, next)
    {
        console.log('Get all recipes');
        Post.find()
        .populate('owner')
        .lean()
        .exec(function(err, posts) 
        {        
            if(err){
                res.send(400, util.failure("Unable to get recipes: " + err));
            }
            else{
                res.send(util.success({
                    posts: posts
                }));
            
            }
        });
    },

    getRecipesByUser: function(req, res, next) 
    {
        console.log('Get recipes of seller');
        Post.find({
                "owner": req.param('userID'),
        })
        .populate('owner')
        .exec(function(err, posts) {
            if (!err) {
                if (!posts) {
                    res.send(404, util.failure("Unable to get posts: no posts found"));
                } else {
                    res.send(util.success({
                        posts: posts
                    }));
                }
            }
            else {
                res.send(400, util.failure("Unable to get posts: " + err));
            }
        });
    },

    // getRecipesByUser: function(req, res, next) 
    // {
    //     var userId = req.param('owner'),
    //         criteria = req.param('criteria');
    //     Post.find({
    //             "owner": userId,
    //     })
    //     .populate('owner')
    //     .exec(function(err, posts) {
    //         posts = posts.toObject();
    //         if (!err) {
    //             if (!posts) {
    //                 res.send(404, util.failure("Unable to get posts: no posts found"));
    //             } else if (criteria) {
    //                 filterPostsByCriteria(posts, criteria, res);
    //             } else {
    //                 res.send(util.success({
    //                     posts: posts
    //                 }));
    //             }
    //         }
    //         else {
    //             res.send(400, util.failure("Unable to get posts: " + err));
    //         }
    //     });
    // },

    createNewRecipe: function(req, res, next) 
    {
        console.log("Made it into createPost");
			
	    var post = new Post();
		post.owner = req.user;
            
        console.log("Creating New Recipe");
	 	
        post.recipeName = req.param('recipeName');
        post.ingredients = req.param('ingredients');
        post.portionSize = req.param('portionSize');
        post.prepareTime = req.param('prepareTime');
        post.orderMode = req.param('orderMode');
        post.price = req.param('price');
        post.privacyTerms = req.param('privacyTerms');
        post.imageURL.url = req.param('imageURL');
        post.imageURL.width = req.param('imageWidth');
        post.imageURL.height = req.param('imageHeight');
		post.timestamp = Date.now();

        post.save(function(err, post) {
			if (!err) {
				if (!post) {
					res.send(400, util.failure("Unable to save post: post not created"));
				}
				else {  
					res.send(util.success({
						posts: post
					}));
				}
			}
			else{
				res.send(400, util.failure("Unable to save post: post not created"));
			}
		});    
    }
}

module.exports = {
    routes: [
    {
        method: api.getRecipesNearMe,
        verb: 'get',
        route: '/post/find/:longitude/:latitude',
        middleware: [
            passport.authenticate('jwt', {
                session: false
            })
        ]
    }, {        
        method: api.getAllRecipes,
        verb: 'post',
        route: '/post/getallrecipes',
        middleware: [
            passport.authenticate('jwt', {
                session: false
            })
        ]
    }, {        
        method: api.getRecipesByUser,
        verb: 'post',
        route: '/post/getrecipesbyuser',
        middleware: [
            passport.authenticate('jwt', {
                session: false
            })
        ]
    // }, {        
    //     method: api.getRecipesByUser,
    //     verb: 'get',
    //     route: '/post/user/:owner',
    //     middleware: [
    //         passport.authenticate('jwt', {
    //             session: false
    //         })
    //     ]
    }, {
        method: api.createNewRecipe,
        verb: 'post',
        route: '/post/createnewrecipe',
        middleware: [
            passport.authenticate('jwt', {
                session: false
            })
        ]
    }
]};

//   app.get('/post/find/:longitude/:latitude/:radius', passport.authenticate('facebook-token', {session: false}), posts.getPostsNearMe);
//   app.get('/post/user', passport.authenticate('facebook-token', {session: false}), posts.myPosts);
//   app.get('/post/:id', passport.authenticate('facebook-token', {session: false}), posts.getPost);
//   app.get('/post/user/:owner', passport.authenticate('facebook-token', {session: false}), posts.getPostsByUser);
//   app.post('/post/:id/notify', passport.authenticate('facebook-token', {session: false}), posts.subscribePost);
//   app.post('/post', passport.authenticate('facebook-token', {session: false}), posts.newPost);
//   app.del('/post/:id', passport.authenticate('facebook-token', {session: false}), function(req, res) {
//     req.app = app;
//     posts.popPost(req, res);
//   });
//   app.io.route('startComment', posts.startComment);
//   app.io.route('comment', function(req){
//     req.app = app;
//     posts.postComment(req);
//   });
