CREATE TABLE "DIM_PRODUTO" (
  "id_dim_produto" SERIAL PRIMARY KEY,
  "codigo_produto" varchar,
  "linha_produto" varchar,
  "escala_produto" varchar,
  "fabricante_produto" varchar
);

CREATE TABLE "DIM_CLIENTE" (
  "id_dim_cliente" SERIAL PRIMARY KEY,
  "codigo_cliente" varchar,
  "nome_cliente" varchar,
  "cidade_cliente" varchar,
  "estado_cliente" varchar,
  "pais_cliente" varchar,
  "limite_credito_cliente" double
);

CREATE TABLE "DIM_EMPREGADO" (
  "id_dim_empregado" SERIAL PRIMARY KEY,
  "codigo_empregado" varchar,
  "nome_completo_empregado" varchar,
  "codigo_chefe_empregado" varchar,
  "nome_completo_chefe" varchar
);

CREATE TABLE "DIM_ESCRITORIO" (
  "id_dim_escritorio" SERIAL PRIMARY KEY,
  "codigo_ecritorio" varchar,
  "cidade_escritorio" varchar,
  "estado_escritorio" varchar,
  "pais_escritorio" varchar,
  "territorio_escritorio" varchar
);

CREATE TABLE "DIM_DATA" (
  "id_dim_data" SERIAL PRIMARY KEY,
  "data" int,
  "data_completa" date,
  "dia" int,
  "mes" int,
  "ano" int,
  "dia_do_ano" int,
  "dia_da_semana" int,
  "semana_do_ano" int,
  "semana_do_mes" int,
  "mes_do_ano" varchar,
  "bimestre" varchar,
  "trimestre" varchar,
  "semestre" varchar,
  "nome_mes_ano" varchar,
  "sigla_mes_ano" varchar,
  "nome_dia_semana" varchar,
  "sigla_dia_semana" varchar
);

CREATE TABLE "FATO_VENDAS" (
  "sk_dim_produto" int,
  "sk_dim_cliente" int,
  "sk_dim_empregado" int,
  "sk_dim_escritorio" int,
  "sk_dim_data_venda" int,
  "sk_dim_data_requisicao" int,
  "sk_dim_data_entrega" int,
  "quantidade_item_pedido" int,
  "valor_item_pedido" double,
  "valor_total_item_pedido" double,
  "valor_item_compra" double,
  "valor_item_fabricando" double,
  "margem_lucro" double
);

ALTER TABLE "DIM_DATA" ADD FOREIGN KEY ("id_dim_data") REFERENCES "FATO_VENDAS" ("sk_dim_data_venda");

ALTER TABLE "DIM_DATA" ADD FOREIGN KEY ("id_dim_data") REFERENCES "FATO_VENDAS" ("sk_dim_data_requisicao");

ALTER TABLE "DIM_DATA" ADD FOREIGN KEY ("id_dim_data") REFERENCES "FATO_VENDAS" ("sk_dim_data_entrega");

ALTER TABLE "DIM_ESCRITORIO" ADD FOREIGN KEY ("id_dim_escritorio") REFERENCES "FATO_VENDAS" ("sk_dim_escritorio");

ALTER TABLE "DIM_CLIENTE" ADD FOREIGN KEY ("id_dim_cliente") REFERENCES "FATO_VENDAS" ("sk_dim_cliente");

ALTER TABLE "DIM_PRODUTO" ADD FOREIGN KEY ("id_dim_produto") REFERENCES "FATO_VENDAS" ("sk_dim_produto");

ALTER TABLE "DIM_EMPREGADO" ADD FOREIGN KEY ("id_dim_empregado") REFERENCES "FATO_VENDAS" ("sk_dim_empregado");
