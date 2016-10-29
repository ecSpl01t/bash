var MongoClient = require('mongodb').MongoClient;

var url = 'mongodb://localhost:27017/altme_system';

MongoClient.connect(url, function(err, db) {
  var collection = db.collection('anProjects');
	  collection.find({}).toArray(function(err, docs) {
	    docs.forEach(function (post) {
	    	if (post.type == 'meteor'){
		    	console.log(post.connect.forever.name+"|"+post.connect.port+"|"+post.paths.pm+"|"+post.paths.pn);
	    	}		    	
	    });
    
  });
  db.close();
});
