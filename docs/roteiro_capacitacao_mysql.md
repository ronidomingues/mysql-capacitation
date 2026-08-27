# Roteiro de Falas — Capacitação de MySQL
**SEQ · 27/08/2026 · 20:00–22:00 · for_code**

> Use este roteiro na segunda tela, junto com os slides. Cada bloco traz: horário-relógio, o que falar, o que digitar, e onde travar de propósito para deixar a turma praticar. Regra de ouro do instrutor (já no seu slide 1.3): fale no máximo 1/3 do tempo do bloco, deixe 2/3 para mão na massa.

---

## BLOCO 0 — Abertura (20:00–20:05 · 5 min)

**Fala de abertura (curta, direta):**
- Se apresente rápido (slide "Apresentação"): nome, DGOM/Marinha, Diretor de Projetos da for_code, Matemática Aplicada UFRJ.
- Trato do dia (slide "O trato de hoje"): "Em 2h ninguém vira DBA. Mas todo mundo sai daqui com o banco do primeiro projeto funcionando."
- Liste rápido o que sai sabendo (criar banco/tabela, CRUD, WHERE, JOIN) e o que fica de fora (normalização, índices, transações) — isso gerencia expectativa e corta pergunta fora de escopo mais tarde.
- Mostre a Tabela 1 (roteiro de 120 min) rapidamente — a turma precisa saber que existe um contrato de tempo.

**Cue:** não detalhe nada tecnicamente ainda. Isso é só orientação de voo.

---

## BLOCO 1 — Do que estamos falando (20:05–20:20 · 15 min)

**Sequência de fala:**
1. **Dado → Informação → Banco** (slide 7): use o exemplo pronto ('Ana', 2024-03-11, 7 → frase completa). Não invente outro, o seu já é bom e conciso.
2. **SGBD** (slide 8): bata nos 4 pontos — grava/lê em disco, garante integridade, controla concorrência, controla permissão. Enfatize "integridade" com voz mais forte — é o conceito que sustenta tudo que vem depois (constraints, FK).
3. **Correção da frase perigosa** (slide 9): "SQL é a única forma de falar com SGBD" → **falso**. Cite a porta 3306, cite ORM traduzindo objeto pra SQL. Isso já responde de antemão a pergunta "e o Python, e o ORM?" que sempre aparece.
4. **Modelo relacional** (slide 10): mostre a tabela `membro` ASCII, explique linha/coluna/chave. Feche com "relacional vem de *relação entre tabelas*, não de 'ter uma tabela'".
5. **SQL não é um bloco só** (slide 11): DDL/DML/DQL/DCL/TCL — diga só isso: "hoje é DDL uma vez, DML e DQL o tempo todo". Não precisa aprofundar DCL/TCL agora.

**Cue de tempo:** se passar de 20:18, corte exemplos extras e siga — o Bloco 3 (DDL prática) não pode atrasar.

---

## BLOCO 2 — Todo mundo conectado (20:20–20:35 · 15 min)

**Fala:**
- "Vocês não vão instalar nada. Eu rodo o servidor, vocês acessam por uma URL." (slide 13)
- Dite a URL do túnel ngrok em voz alta e devagar — deixe alguém repetir de volta antes de seguir.
- Usuário/senha: `aluno` / `aluno`.
- Avise da tela de aviso do túnel: clicar em **Visit Site** uma vez só.
- phpMyAdmin é aplicação web, não instala nada (slide 14) — mencione outros clientes (Workbench, DBeaver) só de passagem, sem se aprofundar.

**Checkpoint obrigatório antes de seguir:** pergunte "quem já está vendo a tela do phpMyAdmin?" — não avance com gente travada aqui, é a base de tudo.

---

## BLOCO 3 — Criando a estrutura (20:35–20:55 · 20 min)

**Fala + digitação ao vivo:**

1. Mostre a ordem que nunca muda (slide 18): `CREATE DATABASE → USE → CREATE TABLE → INSERT → SELECT → UPDATE → DELETE`.
2. Tipos de dados (slide 19): passe rápido pela tabela, pare só na **regra de ouro** (dinheiro em `DECIMAL`, nunca `FLOAT`) — é o ponto que mais gruda.

### 🖐️ Mão na massa #1 — criar o banco (slide 15)
```sql
SELECT VERSION(), NOW();
```
> "Voltou versão e data? Conectado. Agora troquem SEUNOME pelo primeiro nome de vocês:"
```sql
CREATE DATABASE liga_SEUNOME CHARACTER SET utf8mb4;
USE liga_SEUNOME;
```
- Reforce a regra do nome: minúsculas, sem acento, sem espaço.
- Explique rapidamente por que cada um tem seu banco (slide 16): `liga_*` é o único padrão liberado pro login `aluno`; fora disso dá `ERROR 1044`.

### 🖐️ Mão na massa #2 — as duas tabelas (slide 20)
```sql
CREATE TABLE curso (
  id   INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(80) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE membro (
  id            INT           AUTO_INCREMENT PRIMARY KEY,
  nome          VARCHAR(120)  NOT NULL,
  email         VARCHAR(160)  NOT NULL UNIQUE,
  periodo       TINYINT       NOT NULL,
  data_ingresso DATE          NOT NULL,
  ativo         BOOLEAN       NOT NULL DEFAULT TRUE,
  curso_id      INT           NULL
) ENGINE=InnoDB;
```
- Enquanto digitam, passe pela Tabela 7 (restrições) verbalmente: PK identifica, AUTO_INCREMENT gera sozinho, NOT NULL obrigatório, UNIQUE não repete, DEFAULT assume valor.
- **Não entre em FOREIGN KEY agora** — isso é Bloco 6, a tabela `membro` que vocês criam aqui ainda não tem a constraint (ela entra depois via `ALTER TABLE`, igual ao script completo do Apêndice B).

### Conferindo (slide 22)
```sql
SHOW TABLES;
DESCRIBE membro;
SHOW CREATE TABLE membro;
```
> "Confirma as duas tabelas na tela antes de eu liberar a pausa."

**Cue de tempo:** este é o bloco mais arriscado de estourar. Se passar de 20:53, corte a explicação de `SHOW CREATE TABLE` e vá direto pra pausa — dá pra retomar rapidinho depois.

---

## ⏸ PAUSA (20:55–21:00 · 5 min)
"Deixem o phpMyAdmin aberto." Não precisa falar mais nada.

---

## BLOCO 4 — Inserindo e consultando (21:00–21:25 · 25 min)

**Fala:**
- CRUD (slide 25): Create/Read/Update/Delete → INSERT/SELECT/UPDATE/DELETE. Rápido, a turma já viu DML no Bloco 1.

### 🖐️ Mão na massa #3 — povoando as tabelas (slide 26)
```sql
INSERT INTO curso (nome) VALUES
  ('Engenharia de Software'),
  ('Ciência da Computação'),
  ('Sistemas de Informação'),
  ('Engenharia de Produção');

INSERT INTO membro (nome, email, periodo, data_ingresso, curso_id) VALUES
  ('Ana Souza',   'ana@liga.edu.br',   7, '2024-03-11', 1),
  ('Bruno Lima',  'bruno@liga.edu.br', 3, '2025-02-20', 2),
  ('Carla Dias',  'carla@liga.edu.br', 5, '2024-08-05', 1),
  ('Diego Rocha', 'diego@liga.edu.br', 9, '2023-09-14', 3),
  ('Elisa Prado', 'elisa@liga.edu.br', 1, '2026-03-02', NULL);
```
> Aponte: "id e ativo não foram informados — quem preenche é o AUTO_INCREMENT e o DEFAULT."
> Nota: como a FK ainda não existe neste ponto (ela só entra no Bloco 6), o `curso_id` aceita qualquer INT aqui — é proposital, não precisa justificar em detalhe agora.

**SELECT — estrutura completa (slide 27):**
```sql
SELECT colunas FROM tabela WHERE condicao ORDER BY coluna LIMIT n;
```
```sql
SELECT * FROM membro;
SELECT nome, email FROM membro;
SELECT nome AS aluno, periodo AS sem FROM membro;
```

**WHERE — filtros (slide 28):** digite os 7 exemplos em sequência, comente cada operador da Tabela 9 em uma frase só. Pare com ênfase em:
```sql
SELECT * FROM membro WHERE curso_id IS NULL;
```
> "`WHERE curso_id = NULL` NUNCA funciona. NULL não é comparável com `=`. Decorem `IS NULL`."

**ORDER BY / LIMIT (slide 29):**
```sql
SELECT nome, periodo FROM membro ORDER BY periodo DESC;
SELECT nome FROM membro ORDER BY data_ingresso ASC LIMIT 3;
```

### 🖐️ Exercício relâmpago (slide 30) — 3 minutos, cronometre no relógio
1. Membros ativos, só nome e e-mail
2. Membros do 1º ao 5º período, do mais novo pro mais antigo
3. Quantos ingressaram a partir de 2025 (dica: `COUNT(*)`)

> Depois dos 3 min, resolva na tela junto com eles — não deixe ninguém travado sem ver a resposta.

**Cue de tempo:** se sobrar tempo no fim do bloco, aproveite pra reforçar `LIKE` — é o que mais gera dúvida depois.

---

## BLOCO 5 — Alterando e apagando (21:25–21:35 · 10 min)

**Fala + digitação (slide 32):**
```sql
UPDATE membro SET periodo = 8 WHERE id = 1;

INSERT INTO membro (nome, email, periodo, data_ingresso)
VALUES ('Registro Teste', 'teste@liga.edu.br', 1, '2026-01-01');

DELETE FROM membro WHERE email = 'teste@liga.edu.br';
```

**O erro mais caro (slide 33) — pare, olhe pra câmera/turma, fale devagar:**
```sql
UPDATE membro SET periodo = 1;  -- zera TODOS
DELETE FROM membro;             -- apaga TODOS
```
> "Sem WHERE, vale para a tabela inteira. Não existe Ctrl+Z em SQL."

**O hábito que salva:**
```sql
SELECT * FROM membro WHERE id = 5;   -- 1) veja antes
DELETE FROM membro WHERE id = 5;     -- 2) só então troque SELECT * por DELETE
```
> Enfatize: mesmo WHERE nos dois comandos, sempre.

**Cue:** este bloco é curto de propósito — não abra exceção pra explicar `TRUNCATE` agora (está no rodapé do guia, não nos slides). Se perguntarem, responda em uma frase e siga.

---

## BLOCO 6 — Ligando tabelas (21:35–21:55 · 20 min)

**Fala:**
- "Até agora isso é uma planilha" (slide 35): reforce o problema de repetir nome de curso em texto livre — inconsistência, consulta quebrada, correção custosa.
- Chave primária x estrangeira (slide 36): PK identifica dentro da própria tabela; FK aponta pra PK de outra; o SGBD passa a **garantir** que o valor existe do outro lado.

### 🖐️ Mão na massa #4 — declarando a FK (slide 37)
```sql
ALTER TABLE membro
  ADD CONSTRAINT fk_membro_curso
  FOREIGN KEY (curso_id) REFERENCES curso(id)
  ON DELETE SET NULL
  ON UPDATE CASCADE;
```
Teste de erro proposital — deixe a turma ver o `ERROR 1452` acontecer:
```sql
INSERT INTO membro (nome, email, periodo, data_ingresso, curso_id)
VALUES ('Fake', 'fake@liga.edu.br', 1, '2026-01-01', 999);
```
> "O erro é o sucesso: o banco recusou guardar lixo. É a integridade referencial funcionando."

**JOIN (slide 38):**
```sql
-- INNER JOIN: só quem tem curso
SELECT m.nome AS membro, c.nome AS curso, m.periodo
FROM membro m
INNER JOIN curso c ON m.curso_id = c.id
ORDER BY c.nome, m.nome;

-- LEFT JOIN: todo mundo, Elisa aparece com curso NULL
SELECT m.nome AS membro, c.nome AS curso
FROM membro m
LEFT JOIN curso c ON m.curso_id = c.id;
```
> Regra fixa pra decorar: "a condição do ON é sempre FK = PK."
> Se sobrar tempo (bônus, slide 39 — corte primeiro se o relógio apertar):
```sql
SELECT c.nome AS curso, COUNT(m.id) AS total_membros
FROM curso c
LEFT JOIN membro m ON m.curso_id = c.id
GROUP BY c.id, c.nome
ORDER BY total_membros DESC;
```

**Cue de tempo:** conforme seu próprio guia — se este bloco estourar, o corte sai do bônus (agregação), NUNCA do JOIN em si.

---

## BLOCO 7 — Erros comuns e encerramento (21:55–22:00 · 5 min)

**Fala rápida, tom de "cola de bolso" (slide 41):**
- Passe a lista de erros em voz alta, sem se alongar — é referência, não aula:
  - `ERROR 1046` → faltou `USE`
  - `ERROR 1044` → banco fora do padrão `liga_`
  - `ERROR 1050` → `CREATE TABLE` duplicado
  - `ERROR 1062` → violou `UNIQUE`/`PRIMARY KEY`
  - `ERROR 1452` → FK apontando pra id inexistente
  - `ERROR 1052` → coluna ambígua, faltou qualificar `m.nome`
  - Acento quebrado → banco sem `utf8mb4`

**Fechamento (slide 42):**
- Próximos passos, nesta ordem: normalização → modelagem ER → N:N → `GROUP BY`/subconsultas → índices/`EXPLAIN` → transações/ACID.
- Onde praticar de graça: SQLBolt, SQLZoo, DB Fiddle, HackerRank SQL.
- Aponte o QR code / links do slide final: `db-fiddle.com`, `andradasdev.github.io/sql/`, Instagram `@forcodeufrj`.
- "Obrigado!" — encerra no horário certo, 22:00.

---

## Notas gerais de instrutor

- **Se o cronograma atrasar em algum bloco**, a ordem de corte é: bônus de agregação (6.5) → exemplos extras de WHERE (Bloco 4) → aprofundamento de `SHOW CREATE TABLE` (Bloco 3). **Nunca corte o bloco de JOIN.**
- **Scripts de init rodam uma vez só** — se precisar resetar o ambiente entre uma turma de teste e a aula real, lembre que é preciso `docker compose down -v && docker compose up -d`.
- **Se alguém pedir pra usar o script completo (Apêndice B / `liga.sql`) direto**, ele já inclui a FK dentro do `CREATE TABLE membro` (diferente da sequência did��tica do slide, que separa `CREATE TABLE` do `ALTER TABLE ... ADD FOREIGN KEY`). Avise que é a versão "tudo de uma vez" pra quem quiser reconstruir o cenário sozinho depois da aula.
- **phpMyAdmin não tem safe update mode** (diferente do Workbench) — reforce isso junto com o slide 33, é o motivo concreto de exigir SELECT antes de UPDATE/DELETE.
