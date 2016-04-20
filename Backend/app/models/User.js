var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    ObjectId = Schema.ObjectId,
    passwordUtils = require('../util/passwordUtils'),
//     ApiToken = require('./ApiToken'),
    Point = require('../util/point').Point,
    Post = require('./Post');
    
var SALT_LENGTH = 30;

var User = new Schema({
    id                  : String,
    username            : String,
    email               : String,
    password            : String,
    firstName           : String,
    lastName            : String,
    displayName         : String,
    gender              : String,
    biography			: String,
    profileImageURL     : String,
    coverImageURL       : String,
    
    location            : { type: [Number], index: '2dsphere', default: [0, 0]},
    favorites           : [{type: ObjectId, ref: 'User'}],
    // numNotif			: Number,
    // following			:[{type: ObjectId, ref: 'User'}],
    // followers			:[{type: ObjectId, ref: 'User'}],
 //    notifications		: {
 //    						groupChat:{type: Boolean, default: true},
 //    						privateChat:{type: Boolean, default: true},
 //    						notificationAllOff:{type:Boolean, default:false}
 //    					},
	// privacy				: {
	//     					everyone:{type: Boolean, default: true},
 //    						followers:{type: Boolean, default: false},
 //    						nobody:{type: Boolean, default: false},
 //    						allowFacebookFollow:{type: Boolean, default: false}
	// 					},
    facebookId          : String,
    universalToken      : String, 
    fbToken             : String,
    fbProfileLink       : String, // The Facebook URL for this user.
    // lastLocation        : { type: [Number], index: '2dsphere', default: [0, 0]},
    // deviceToken         : String,
    // deviceType          : String,
    lastActive          : {type: Date, default: new Date()},
    onlineStatus        : Boolean
}, {
toObject: { virtuals: true },
toJSON: { virtuals: true }
});
User.set('autoIndex', false);

User.index({lastLocation: '2dsphere',displayName: 1});


module.exports = mongoose.model('User', User);