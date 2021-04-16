package br.com.ferry.controller;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.SQLException;

import javax.swing.JOptionPane;
import javax.swing.JTextField;

import br.com.ferry.model.Cliente;
import br.com.ferry.persistence.ClienteDao;

public class ClienteController implements ActionListener{
	
	private JTextField txtNome;
	private JTextField txtTelefone;
	
	

	public ClienteController(JTextField txtNome, JTextField txtTellefone) {
		this.txtNome = txtNome;
		this.txtTelefone = txtTellefone;
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		
		try {
			insereCliente();
		} catch (ClassNotFoundException | SQLException e1) {
			e1.printStackTrace();
		}
	}
	
	public void insereCliente() throws ClassNotFoundException, SQLException {
		Cliente cli = new Cliente();
		cli.setNome(txtNome.getText());
		cli.setTelefone(txtTelefone.getText());
		
		ClienteDao cDao = new ClienteDao();
		String saida = cDao.procCliente(cli);
		
		JOptionPane.showMessageDialog(null, saida, "MENSAGEM", JOptionPane.INFORMATION_MESSAGE);
	}
}
