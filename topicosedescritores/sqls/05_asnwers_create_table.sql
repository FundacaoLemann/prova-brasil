CREATE TABLE provabrasil_topics.respostas (
  id_aluno mediumint unsigned not null,
  id_item smallint unsigned not null,
  id_escola int unsigned not null,
  id_serie tinyint unsigned not null,
  id_disciplina tinyint unsigned not null,
  id_descritor tinyint unsigned not null,
  resposta char(1) not null,
  gabarito char(1) not null,
  acerto tinyint unsigned not null
) ENGINE=MyIsam DEFAULT CHARSET=utf8_general_ci;
ALTER TABLE `provabrasil_topics`.`respostas`
ADD INDEX `tudo` (`id_escola` ASC, `id_serie` ASC, `id_disciplina` ASC, `id_descritor` ASC, `acerto` ASC);