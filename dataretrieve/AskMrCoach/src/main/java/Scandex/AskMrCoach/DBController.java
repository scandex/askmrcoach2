package Scandex.AskMrCoach;

import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import org.bson.Document;

import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.robrua.orianna.type.core.common.Region;

public class DBController {

	private MongoClient mongoClient;
	private MongoDatabase db;
	private MongoCollection<Document> col;
	private MongoCollection<Document> col2;

	public DBController(String uri, String dbs, String cols) {
		this.mongoClient = new MongoClient(new MongoClientURI(uri));
		this.db = mongoClient.getDatabase(dbs);
		this.col = db.getCollection(cols);
		this.col2 = db.getCollection("processed");
	}

	public void save(Map<String, Partida> data) {
		Iterator<Entry<String, Partida>> it = data.entrySet().iterator();

		while (it.hasNext()) {

			Partida tmp = it.next().getValue();
			it.remove();
			Document actual = new Document("_id", tmp.toString());
			if (col.find(actual).first() == null) {

				actual = new Document("_id", tmp.toString2());
				if (col.find(actual).first() == null) {

					col.insertOne(tmp.getDocument());
				} else
					col.updateOne(actual,
							new Document("$inc", new Document("wb", tmp.getWr()).append("wr", tmp.getWb())));
			} else {

				col.updateOne(actual, new Document("$inc", new Document("wb", tmp.getWb()).append("wr", tmp.getWr())));
			}
		}
	}
	public void save(Partida tmp) {			
			Document actual = new Document("_id", tmp.toString());
			if (col.find(actual).first() == null) {
				actual = new Document("_id", tmp.toString2());
				if (col.find(actual).first() == null) {

					col.insertOne(tmp.getDocument());
				} else
					col.updateOne(actual,
							new Document("$inc", new Document("wb", tmp.getWr()).append("wr", tmp.getWb())));
			} else {

				col.updateOne(actual, new Document("$inc", new Document("wb", tmp.getWb()).append("wr", tmp.getWr())));
			}
			System.out.println(tmp.toString());
	}
	public void save(long id, Region r){		
		col2.insertOne(new Document().append("_id", r.toString()+id));
	}
	
	public boolean proc(long id, Region r){
		return col2.find(new Document("_id", r.toString()+id)).first()==null;
	}

}
