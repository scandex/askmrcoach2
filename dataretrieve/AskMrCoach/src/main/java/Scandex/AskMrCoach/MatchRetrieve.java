package Scandex.AskMrCoach;

import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

import com.robrua.orianna.api.core.RiotAPI;
import com.robrua.orianna.type.core.common.Lane;
import com.robrua.orianna.type.core.common.Region;
import com.robrua.orianna.type.core.common.Side;
import com.robrua.orianna.type.core.common.SubType;
import com.robrua.orianna.type.core.game.Game;
import com.robrua.orianna.type.core.game.Player;
import com.robrua.orianna.type.core.match.Match;
import com.robrua.orianna.type.core.match.Participant;

public class MatchRetrieve implements Runnable{
	private Region region;
	private Queue<Long> queue;
	private Queue<Long> queue0;
	private DBController db;

	public MatchRetrieve(Region r, List<Long> seeds, DBController db) {
		this.region = r;
		this.queue = new LinkedList<Long>();
		for (Long string : seeds) {
			queue.add(string);
		}
		this.db = db;
		RiotAPI.setRegion(region);
	}

	public boolean isADC(long id) {
		return RiotAPI.getChampionByID(id).getTags().contains("Marksman");
	}

	public void getMatches() {
		long[] teamcomp;
		while (true) {
			try {
				Long summoner = queue.poll();
				if (summoner != null) {
					List<Game> games = RiotAPI.getRecentGames(summoner);
					for (Game game : games) {
						for (Player p : game.getFellowPlayers())
							queue.add(p.getSummonerID());
						if (game.getSubType().equals(SubType.RANKED_SOLO_5x5) && db.proc(game.getID(), region)) {
							db.save(game.getID(), region);
							teamcomp = new long[10];
							boolean bwin = false;
							Match match = RiotAPI.getMatch(game.getID());
							List<Participant> par = match.getParticipants();
							for (Participant participant : par) {
								Lane lane = participant.getTimeline().getLane();
								Side side = participant.getTeam();
								long champ = participant.getChampionID();
								int rol = 0;
								switch (side) {
								case BLUE:
									if (!bwin && participant.getStats().getWinner())
										bwin = true;
									switch (lane) {
									case TOP:
										rol = 0;
										break;
									case JUNGLE:
										rol = 1;
										break;
									case MIDDLE:
										rol = 2;
										break;
									case BOTTOM:
										if (isADC(champ))
											rol = 3;
										else
											rol = 4;
										break;
									default:
										break;
									}
									break;
								case PURPLE:
									switch (lane) {
									case TOP:
										rol = 5;
										break;
									case JUNGLE:
										rol = 6;
										break;
									case MIDDLE:
										rol = 7;
										break;
									case BOTTOM:
										if (isADC(champ))
											rol = 8;
										else
											rol = 9;
										break;
									default:
										break;
									}
									break;
								default:
									break;
								}
								teamcomp[rol] = champ;
							}
							Partida nueva = new Partida(teamcomp);
							nueva.addwin(bwin);
							db.save(nueva);
						}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}			
		}
	}

	@Override
	public void run() {
		getMatches();
		
	}
}
