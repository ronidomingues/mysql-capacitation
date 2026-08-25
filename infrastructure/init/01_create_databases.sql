-- ============================================================
-- init/01_create_databases.sql
-- ============================================================
-- ATENÇÃO: os scripts de /docker-entrypoint-initdb.d rodam UMA ÚNICA VEZ,
-- na primeira subida, quando o volume mysql_data ainda está vazio.
-- Editou este arquivo? Para reaplicar:
--     docker compose down -v && docker compose up -d
-- (o -v apaga o volume; TODO o conteúdo do banco se perde)
-- ============================================================

-- ------------------------------------------------------------
-- 1) Banco de DEMONSTRAÇÃO do instrutor
--    Ninguém além do root recebe privilégio aqui. É onde a aula
--    é conduzida no telão.
-- ------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS cap
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

-- ------------------------------------------------------------
-- 2) Área de EXERCÍCIOS dos alunos
--
--    Não criamos um banco compartilhado de propósito: cada aluno
--    cria o PRÓPRIO banco `liga_<nome>` durante o bloco de DDL da
--    aula (§4.3 do documento). Isso evita que um aluno derrube o
--    trabalho dos outros com um DROP/DELETE.
--
--    O GRANT abaixo é sobre um PADRÃO DE NOME, não sobre um banco
--    que já exista. Em GRANT, `_` e `%` são curingas; por isso o
--    underscore literal precisa ser escapado como `\_`.
--
--    Efeito prático do padrão `liga\_%`:
--      ✔ aluno PODE criar e administrar liga_ana, liga_bruno, ...
--      ✘ aluno NÃO acessa o banco `cap` do instrutor
--      ✘ aluno NÃO cria bancos fora do padrão (ex.: `bagunca`)
--      ✔ no phpMyAdmin o aluno só enxerga bancos `liga_*`
--
--    Limite conhecido: como o login é o mesmo para toda a turma,
--    um aluno CONSEGUE abrir o banco de um colega se digitar o
--    nome dele. Não há isolamento entre alunos — apenas separação
--    de espaço de trabalho, que é o suficiente para evitar
--    colisão acidental numa aula de 2 horas.
-- ------------------------------------------------------------
GRANT ALL PRIVILEGES ON `liga\_%`.* TO 'aluno'@'%';

FLUSH PRIVILEGES;
