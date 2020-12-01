--4)A quatidade de usuarios em cada departamento, 
-- em uma saída (depto | qtdUsuarios). 
--A saída deve ser ordenada, de maneira crescente, por qtdUsuarios

SELECT depto.idDepto, COUNT(depto.idDepto) AS qtdUsuarios
FROM depto INNER JOIN usuario ON usuario.depto = depto.idDepto
GROUP BY depto.idDepto
ORDER BY depto.idDepto


--1)Nomes distintos dos softwares usados pelos desenvolvedores (Usar o termo desenvolvimento para a filtragemm da busca)

SELECT DISTINCT software.nome AS software, usuario.nome AS desenvolvedor
FROM software INNER JOIN usuarioMaquina ON software.idSoftware = usuarioMaquina.idMaquina
INNER JOIN usuario ON usuario.idUsuario = usuarioMaquina.idUsuario


--3)Nome de usuário (nomeUsuario), nome do Depto (nomeDepto), capacidadeHd dos usuários de tablet no período da tarde. Usar os termos tablet e tarde para filtrar a busca.
SELECT u.nome, d.depto, m.capacidadeHd
FROM usuario u, depto d, maquina m, tipoMaquina tm, usuarioMaquina um, horario h
WHERE u.depto = d.idDepto
AND um.idUsuario = u.idUsuario
AND um.idMaquina = m.idMaquina
AND m.tipo = tm.idTipo
AND tm.tipo = 'tablet'
AND um.horario = h.idHorario
AND h.horario ='tarde'


--2)ClockCpu, capacidadeHd, txRede e MemoriaRam das maquinas sem nenhum usuário alocado 

SELECT maquina.clockCpu, maquina.capacidadeHd, maquina.txRede, maquina.memoriaRam FROM
maquina LEFT OUTER JOIN usuarioMaquina ON usuarioMaquina.idMaquina = maquina.idMaquina LEFT OUTER JOIN
usuario ON usuarioMaquina.idUsuario = usuario.idUsuario
WHERE usuarioMaquina.idUsuario IS NULL