var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    ObjectId = Schema.ObjectId,
    Point = require('../util/point').Point,
    // Post = require('./Post'),
    User = require('./User'),
    util = require('../util/utils');

// mongoose.set('debug', true);

var Review = new Schema({
    from        : { type: ObjectId, ref: 'User'},
    message     : String,
    score       : Number,
    privacy     : {type: String, default: "public"},
    leaveTime   : {type: Date, default: util.getUtcDate()},
    // location    : { type: [Number], index: '2dsphere'}
});

Review.pre('save', function(next) {
    var thisThread = this;
    User.findOne({_id: this.from})
        .exec(function(err, user) {
            if (user) {
                user.save(function(err, usr) {
                    if (!err) {
                        next();
                    } 
                });
            }
        });
});

module.exports = mongoose.model('Review', Review);