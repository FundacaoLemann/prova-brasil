CREATE TABLE provabrasil_topics.itens (
  ID_SERIE int(11) DEFAULT NULL,
  DISCIPLINA tinytext,
  ID_BLOCO int(11) DEFAULT NULL,
  ID_POSICAO int(11) DEFAULT NULL,
  ID_ITEM int(11) DEFAULT NULL,
  DESCRITOR tinyint,
  GABARITO tinytext
) ENGINE=InnoDB DEFAULT CHARSET=utf8_general_ci;