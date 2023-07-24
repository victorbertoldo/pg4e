CREATE TABLE `DIM_PRODUTO` (
  `id_dim_produto` int PRIMARY KEY AUTO_INCREMENT,
  `codigo_produto` varchar(255),
  `linha_produto` varchar(255),
  `escala_produto` varchar(255),
  `fabricante_produto` varchar(255)
);

CREATE TABLE `DIM_CLIENTE` (
  `id_dim_cliente` in PRIMARY KEY AUTO_INCREMENT,
  `codigo_cliente` varchar(255),
  `nome_cliente` varchar(255),
  `cidade_cliente` varchar(255),
  `estado_cliente` varchar(255),
  `pais_cliente` varchar(255),
  `limite_credito_cliente` double
);

CREATE TABLE `DIM_EMPREGADO` (
  `id_dim_empregado` int PRIMARY KEY AUTO_INCREMENT,
  `codigo_empregado` varchar(255),
  `nome_completo_empregado` varchar(255),
  `codigo_chefe_empregado` varchar(255),
  `nome_completo_chefe` varchar(255)
);

CREATE TABLE `DIM_ESCRITORIO` (
  `id_dim_escritorio` int PRIMARY KEY AUTO_INCREMENT,
  `codigo_ecritorio` varchar(255),
  `cidade_escritorio` varchar(255),
  `estado_escritorio` varchar(255),
  `pais_escritorio` varchar(255),
  `territorio_escritorio` varchar(255)
);

CREATE TABLE `DIM_DATA` (
  `id_dim_data` int PRIMARY KEY AUTO_INCREMENT,
  `data` int,
  `data_completa` date,
  `dia` int,
  `mes` int,
  `ano` int,
  `dia_do_ano` int,
  `dia_da_semana` int,
  `semana_do_ano` int,
  `semana_do_mes` int,
  `mes_do_ano` varchar(255),
  `bimestre` varchar(255),
  `trimestre` varchar(255),
  `semestre` varchar(255),
  `nome_mes_ano` varchar(255),
  `sigla_mes_ano` varchar(255),
  `nome_dia_semana` varchar(255),
  `sigla_dia_semana` varchar(255)
);

CREATE TABLE `FATO_VENDAS` (
  `sk_dim_produto` int,
  `sk_dim_cliente` int,
  `sk_dim_empregado` int,
  `sk_dim_escritorio` int,
  `sk_dim_data_venda` int,
  `sk_dim_data_requisicao` int,
  `sk_dim_data_entrega` int,
  `quantidade_item_pedido` int,
  `valor_item_pedido` double,
  `valor_total_item_pedido` double,
  `valor_item_compra` double,
  `valor_item_fabricando` double,
  `margem_lucro` double
);

ALTER TABLE `DIM_DATA` ADD FOREIGN KEY (`id_dim_data`) REFERENCES `FATO_VENDAS` (`sk_dim_data_venda`);

ALTER TABLE `DIM_DATA` ADD FOREIGN KEY (`id_dim_data`) REFERENCES `FATO_VENDAS` (`sk_dim_data_requisicao`);

ALTER TABLE `DIM_DATA` ADD FOREIGN KEY (`id_dim_data`) REFERENCES `FATO_VENDAS` (`sk_dim_data_entrega`);

ALTER TABLE `DIM_ESCRITORIO` ADD FOREIGN KEY (`id_dim_escritorio`) REFERENCES `FATO_VENDAS` (`sk_dim_escritorio`);

ALTER TABLE `DIM_CLIENTE` ADD FOREIGN KEY (`id_dim_cliente`) REFERENCES `FATO_VENDAS` (`sk_dim_cliente`);

ALTER TABLE `DIM_PRODUTO` ADD FOREIGN KEY (`id_dim_produto`) REFERENCES `FATO_VENDAS` (`sk_dim_produto`);

ALTER TABLE `DIM_EMPREGADO` ADD FOREIGN KEY (`id_dim_empregado`) REFERENCES `FATO_VENDAS` (`sk_dim_empregado`);
