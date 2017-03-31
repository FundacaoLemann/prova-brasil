CREATE TABLE provabrasil_topics.desempenho_escola_descritor (
  id_escola int unsigned not null,
  id_serie tinyint unsigned not null,
  id_disciplina tinyint unsigned not null,
  id_descritor tinyint unsigned not null,
  itens_aplicados int unsigned not null,
  acertos int unsigned not null
) ENGINE=MyIsam DEFAULT CHARSET=utf8_general_ci;