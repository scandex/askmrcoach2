package Scandex.AskMrCoach;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import com.robrua.orianna.api.core.RiotAPI;
import com.robrua.orianna.type.core.common.Region;
import com.robrua.orianna.type.exception.APIException;

/**
 * Hello world!
 */
public class App {
	public static void main(String[] args) throws Exception {
		String uri = args[0];
		String key = args[1];
		RiotAPI.setRateLimit(5000, 600);
		RiotAPI.setAPIKey(key);
		DBController db = new DBController(uri, "ritochallenge", "comps");
		Properties datos = new Properties();
		FileInputStream in = new FileInputStream("seeds.properties");
		datos.load(in);
		List<MatchRetrieve> threads = new ArrayList<>();
		for (Region reg : Region.values()) {
			List<Long> a = new ArrayList<Long>();
			try {
				int n = Integer.parseInt(datos.getProperty(reg.toString()));
				for (int j = 0; j < n; j++) {
					try {
						RiotAPI.setRegion(reg);
						long id = RiotAPI.getSummonerByName(datos.getProperty(reg.toString() + "." + j)).getID();						
						a.add(id);
					} catch (APIException e) {
						System.out.println(e.getMessage());
					}
				}
				if (!a.isEmpty()) {					
						MatchRetrieve retriever = new MatchRetrieve(reg, a, db);						
						threads.add(retriever);
					
				}
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}		
		try{
			while (true) {
				for (MatchRetrieve matchRetrieve : threads) {
					matchRetrieve.getMatches();
				}			
			}
		}catch(Exception e){
			System.out.println(e.getMessage());
		}
	}
}
