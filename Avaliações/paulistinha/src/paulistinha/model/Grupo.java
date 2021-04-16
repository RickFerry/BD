package paulistinha.model;

public class Grupo {

	private String grupo;
	private int codigoTime;
	
	public Grupo() {}

	public String getGrupo() {
		return grupo;
	}

	public void setGrupo(String grupo) {
		this.grupo = grupo;
	}

	@Override
	public String toString() {
		return "Grupo [grupo=" + grupo + ", codigoTime=" + codigoTime + "]";
	}
}
