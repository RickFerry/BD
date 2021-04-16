package paulistinha.model;

import java.util.Date;

public class Jogo {

	private String codigoTimeA;
	private String codigoTimeB;
	private int golsTimeA;
	private int golsTimeB;
	private Date data;
	
	public Jogo() {}

	public String getCodigoTimeA() {
		return codigoTimeA;
	}

	public void setCodigoTimeA(String codigoTimeA) {
		this.codigoTimeA = codigoTimeA;
	}

	public String getCodigoTimeB() {
		return codigoTimeB;
	}

	public void setCodigoTimeB(String codigoTimeB) {
		this.codigoTimeB = codigoTimeB;
	}

	public int getGolsTimeA() {
		return golsTimeA;
	}

	public void setGolsTimeA(int golsTimeA) {
		this.golsTimeA = golsTimeA;
	}

	public int getGolsTimeB() {
		return golsTimeB;
	}

	public void setGolsTimeB(int golsTimeB) {
		this.golsTimeB = golsTimeB;
	}

	public Date getData() {
		return data;
	}

	public void setData(Date data) {
		this.data = data;
	}

	@Override
	public String toString() {
		return "Jogo [codigoTimeA=" + codigoTimeA + ", codigoTimeB=" + codigoTimeB + ", golsTimeA=" + golsTimeA
				+ ", golsTimeB=" + golsTimeB + ", data=" + data + "]";
	}
}
