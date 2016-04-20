var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    ObjectId = Schema.ObjectId,
    Mixed = Schema.Types.Mixed,
    Point = require('../util/point').Point,
    sutil = require('util'),
    allCriteria = require('../util/spop_criteria/criteria'),
    async = require('async'),
    _ = require('underscore'),
    User = require('./User');

var Post = new Schema({

    recipeName              : String,
    ingredients             : String,
    portionSize             : String,
    prepareTime             : String,
    orderMode               : String,
    price                   : String,
    privacyTerms            : String,
    imageURL                : {url:String, width:Number, height:Number},
    owner                   : {type: ObjectId, ref: 'User'},
    timestamp               : {type: Date, default: (function() { // Default to UTC for timestamp
                                return Date.now();
                            })()},
    // radius                  : Number,
}, {
toObject: { virtuals: true },
toJSON: { virtuals: true }
});

// Post.options.toJSON = {
//     transform: function(doc, ret, options) {
//         ret.id = ret._id;
//         delete ret._id;
//         delete ret.__v;
//         return ret;
//     }
// };

// Post.pre('save', function(next) {
//     var now = new Date();
//     var that = this;
//     this.lastModifiedByOwner = new Date(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(),  now.getUTCHours(), now.getUTCMinutes(), now.getUTCSeconds());
// next();
//     // This seems to get registered before the rest of the file.  To avoid a race condition, add the require
//     // here.  Require uses an object cache so this will not affect performance by being called more than
//     // once.
// //     Comment = require('./Comment'),
// //     Comment.aggregate()
// //       .group({ _id: "$from"})
// //       .exec(function (err, res) {
// //         next();
// //     });

// });

// Post.virtual('numPosts').get(function() {
//     return this.thread.length;
//     // // [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [FBuser objectID]];
//     // var userPictureUrl = "http://graph.facebook.com/v2.0/" + this.id + "/picture?type=large";
//     // console.log("****** User picture URL would be ", userPictureUrl);
//     // console.log("User id = ", this.accessToken);
//     // return userPictureUrl;
// });

// Post.pre('save', function(next) {
//     var that = this;
//     User = require('./User');
//     var owner = User.findById(this.owner).exec(function(err, owner) {
//         if (!err) {
//                 next();
//         } else {
//             console.error(err);
//             next();
//         }
//     });
// });

module.exports = mongoose.model('Post', Post);

// Post.plugin(allCriteria['gender'].plugin);
// Post.plugin(allCriteria['facebook_friends'].plugin);
// Post.plugin(allCriteria['facebook_groups'].plugin);