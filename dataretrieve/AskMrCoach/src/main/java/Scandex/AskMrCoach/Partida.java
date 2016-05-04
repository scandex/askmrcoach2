package Scandex.AskMrCoach;

import org.bson.Document;

public class Partida {
	private int wr;
	private int wb;
	private long tb;
	private long jb;
	private long mb;
	private long ab;
	private long sb;
	private long tr;
	private long jr;
	private long mr;
	private long ar;
	private long sr;
	
	
	public Partida(long[] teamcomp){
		this.wr = 0;
		this.wb = 0;
		this.tb=teamcomp[0];
		this.jb=teamcomp[1];
		this.mb=teamcomp[2];
		this.ab=teamcomp[3];
		this.sb=teamcomp[4];
		this.tr=teamcomp[5];
		this.jr=teamcomp[6];
		this.mr=teamcomp[7];
		this.ar=teamcomp[8];
		this.sr=teamcomp[9];
	}
	
	public void addwin(boolean bwin){
		if(bwin)
			wb++;
		else
			wr++;
	}
	
	public Document getDocument(){
		Document resp = new Document()               
                .append("wr", wr)
                .append("wb", wb)
                .append("tb", tb)
                .append("jb", jb)
                .append("mb", mb)
                .append("ab", ab)
                .append("sb", sb)
                .append("tr", tr)
                .append("jr", jr)
                .append("mr", mr)
                .append("ar", ar)
                .append("sr", sr)                
        		.append("_id", toString());
		return resp;
	}
	
	
	
	public int getWr() {
		return wr;
	}

	public int getWb() {
		return wb;
	}

	public String toString(){
		return tb+"."+jb+"."+mb+"."+ab+"."+sb+"."+tr+"."+jr+"."+mr+"."+ar+"."+sr;
	}
	public String toString2(){
		return tr+"."+jr+"."+mr+"."+ar+"."+sr+"."+tb+"."+jb+"."+mb+"."+ab+"."+sb;
	}

}
