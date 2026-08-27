# Fundamentos do MySQL e Projetos de Bancos de Dados

> **Capacitação — Liga Acadêmica**
> **Duração:** 2 horas (120 minutos cravados) · **Nível:** iniciante, sem pré-requisito de banco de dados
> **Formato:** exposição curta + prática guiada no phpMyAdmin

---

## Sumário

1. [Introdução](#1-introdução)
   - [1.1 Objetivos](#11-objetivos-de-aprendizagem)
   - [1.2 O que NÃO entra](#12-o-que-não-entra-nesta-capacitação)
   - [1.3 Roteiro de 2 horas](#13-roteiro-de-2-horas)
   - [1.4 Conceitos-base](#14-conceitos-base-dado-banco-sgbd-modelo-relacional)
2. [MySQL](#2-mysql)
   - [2.1 O que é](#21-o-que-é-o-mysql)
   - [2.2 MySQL x MariaDB](#22-mysql-x-mariadb-a-confusão-mais-comum)
   - [2.3 Como executar o MySQL](#23-como-executar-o-mysql)
3. [Clientes SQL](#3-clientes-sql)
   - [3.1 Panorama](#31-panorama-de-clientes)
   - [3.2 phpMyAdmin](#32-phpmyadmin)
   - [3.3 Conectando](#33-conectando-na-aula)
4. [SQL — o assunto principal](#4-sql--o-assunto-principal)
   - [4.1 Sublinguagens](#41-sql-não-é-um-bloco-só-ddl-dml-dql-dcl-tcl)
   - [4.2 Ordem de trabalho](#42-a-ordem-de-trabalho)
   - [4.3 DDL — criando o banco](#43-ddl--criando-o-banco)
   - [4.4 Tipos de dados](#44-tipos-de-dados-o-que-você-realmente-usa)
   - [4.5 DDL — criando a tabela](#45-ddl--criando-a-tabela)
   - [4.6 CRUD](#46-crud--create-read-update-delete)
   - [4.7 Relacionamentos e JOIN](#47-relacionamentos-a-parte-relacional-do-negócio)
   - [4.8 Bônus: agregação](#48-bônus-contar-e-agrupar)
5. [Erros comuns](#5-erros-comuns-de-quem-está-começando)
6. [Conclusão e próximos passos](#6-conclusão-e-próximos-passos)
- [Anexo A — Colinha de sintaxe](#anexo-a--colinha-de-sintaxe)
- [Anexo B — Script completo da aula](#anexo-b--script-completo-da-aula)
- [Anexo C — Exercícios](#anexo-c--exercícios)

---

## 1. Introdução

Todo sistema que você vai construir na liga — um cadastro de membros, um app de projetos,
um dashboard de pesquisa — precisa **guardar dados e recuperá-los depois**. Essa capacitação
é sobre a ferramenta padrão da indústria para isso: um banco de dados relacional (MySQL)
operado pela linguagem SQL.

Em 2 horas não dá para formar um DBA. Dá, sim, para você sair daqui **criando uma tabela,
inserindo dados, consultando com filtro e relacionando duas tabelas** — que é exatamente
o mínimo necessário para o primeiro projeto real.

### 1.1 Objetivos de aprendizagem

Ao final, o participante deve ser capaz de:

1. Explicar o que é um SGBD e o que significa "relacional".
2. Conectar-se a um servidor MySQL usando um cliente SQL.
3. Criar um banco e uma tabela com tipos, chave primária e restrições adequadas.
4. Executar as quatro operações do CRUD com `INSERT`, `SELECT`, `UPDATE` e `DELETE`.
5. Filtrar e ordenar resultados com `WHERE`, `ORDER BY` e `LIMIT`.
6. Relacionar duas tabelas com chave estrangeira e consultá-las com `JOIN`.

### 1.2 O que NÃO entra nesta capacitação

Dito explicitamente para não gerar expectativa errada — cada item destes é uma capacitação
inteira por si só:

- Docker e containers (usados aqui apenas como meio de subir o ambiente).
- Normalização formal (1FN, 2FN, 3FN) e modelagem ER completa.
- Índices, planos de execução e otimização de performance.
- Transações, `views`, `procedures`, `triggers`, backup e replicação.
- Segurança, gestão de usuários e privilégios além do básico.
- NoSQL (MongoDB, Redis, etc.).

### 1.3 Roteiro de 2 horas

Este é o contrato de tempo da aula. Cada bloco tem um tempo fechado; se um bloco estourar,
o corte sai do **bônus (4.8)**, nunca do bloco de `JOIN`.

| # | Bloco | Início | Duração |
|---|---|---|---|
| 0 | Abertura, objetivos e escopo | 00:00 | 5 min |
| 1 | Conceitos-base: dado, banco, SGBD, relacional, SQL (§1.4, §4.1) | 00:05 | 15 min |
| 2 | Ambiente + cliente SQL: todo mundo conectado (§2, §3) | 00:20 | 15 min |
| 3 | DDL: `CREATE DATABASE`, tipos, `CREATE TABLE`, chave primária (§4.3–4.5) | 00:35 | 20 min |
| — | **Pausa** | 00:55 | 5 min |
| 4 | `INSERT` + `SELECT` com `WHERE`, `ORDER BY`, `LIMIT` (§4.6) | 01:00 | 25 min |
| 5 | `UPDATE` + `DELETE` e o perigo do `WHERE` ausente (§4.6) | 01:25 | 10 min |
| 6 | Chave estrangeira e `JOIN` (§4.7) | 01:35 | 20 min |
| 7 | Erros comuns, próximos passos, materiais, dúvidas (§5, §6) | 01:55 | 5 min |
| | **Total** | | **120 min** |

> **Regra prática do instrutor:** blocos 3 a 6 são *mão na massa*. Fale no máximo 1/3 do
> tempo do bloco e deixe 2/3 para o pessoal digitar. Não avance enquanto a maioria não tiver
> o resultado na tela.

### 1.4 Conceitos-base: dado, banco, SGBD, modelo relacional

**Dado** é um valor bruto: `"Ana"`, `2024-03-11`, `7`. Sozinho ele não diz nada.
**Informação** é o dado dentro de um contexto: *"Ana ingressou na liga em 11/03/2024 e está no 7º período"*.
Um **banco de dados** é uma coleção organizada de dados, guardada de forma persistente e
estruturada para ser consultada.

O **SGBD** (Sistema de Gerenciamento de Banco de Dados — em inglês, *DBMS*) é o **software
servidor** que cuida desse banco. Ele é quem de fato:

- grava e lê os dados em disco;
- garante a integridade (não deixa entrar dado que viola as regras que você definiu);
- controla acesso concorrente (várias pessoas escrevendo ao mesmo tempo sem corromper nada);
- controla permissões de usuários.

> ⚠️ **Correção de um erro comum:** SQL **não** é a única forma de conversar com um SGBD.
> A comunicação real acontece por um **protocolo de rede binário** (o MySQL escuta na porta
> 3306). O SQL é a linguagem que trafega por dentro desse protocolo — é a interface *padrão
> e dominante*, mas não a única: o MySQL também expõe o **X DevAPI / Document Store**, uma API
> de CRUD sem SQL. E quando você usa um ORM (Prisma, Eloquent, Hibernate, SQLAlchemy), você
> escreve objetos — o ORM é que traduz aquilo para SQL antes de enviar.

**Modelo relacional** (proposto por Edgar F. Codd, 1970) é a ideia central: os dados são
organizados em **tabelas** (relações). Cada **linha** (registro/tupla) é uma ocorrência do
mundo real; cada **coluna** (campo/atributo) é uma característica dela, com um **tipo** fixo.
Tabelas se ligam a outras tabelas por meio de **chaves** — daí o nome "relacional".

```
TABELA membro
┌────┬──────────────┬────────────────────┬─────────┐
│ id │ nome         │ email              │ periodo │  ← colunas (atributos, com tipo)
├────┼──────────────┼────────────────────┼─────────┤
│  1 │ Ana Souza    │ ana@liga.edu.br    │       7 │  ← linha (registro)
│  2 │ Bruno Lima   │ bruno@liga.edu.br  │       3 │
└────┴──────────────┴────────────────────┴─────────┘
   ↑
 chave primária: identifica cada linha de forma única
```

Um **SGBD relacional** é um SGBD que implementa esse modelo — é o que a sigla **RDBMS**
significa. MySQL, PostgreSQL, SQL Server, Oracle Database e SQLite são todos RDBMS.

---

## 2. MySQL

### 2.1 O que é o MySQL

O MySQL é um **SGBD relacional (RDBMS)** de código aberto, criado em 1995 e hoje mantido
pela Oracle. É o motor que armazena e gerencia os dados; você conversa com ele em SQL.

É provavelmente o banco relacional mais usado em aplicações web — WordPress, boa parte dos
sistemas PHP e uma infinidade de APIs rodam sobre ele. A versão usada nesta capacitação é a
**8.4 LTS**, e o *storage engine* padrão é o **InnoDB** (importante: é ele que dá suporte a
chaves estrangeiras e transações; o antigo MyISAM não suporta chave estrangeira).

### 2.2 MySQL x MariaDB (a confusão mais comum)

|  | MySQL | MariaDB |
|---|---|---|
| Origem | Original, 1995 | *Fork* de 2009, feito pelos criadores do MySQL após a compra pela Oracle |
| Licença da edição livre | Community Edition — **GPLv2, gratuita** | Server — **GPLv2, gratuita** |
| Edições pagas | Sim (Standard / Enterprise, da Oracle) | Sim (suporte e produtos da MariaDB plc) |
| Compatibilidade | — | Altíssima nos comandos básicos: tudo desta capacitação funciona igual nos dois |

> ⚠️ **Correção:** dizer que "MariaDB é livre e MySQL é comercial" é impreciso. **Ambos têm
> uma edição livre em GPLv2 e ambos têm ofertas comerciais.** A diferença que interessa a
> você agora é outra: várias distribuições Linux (Debian, Ubuntu, Fedora, RHEL) empacotam o
> **MariaDB** como padrão nos repositórios oficiais, e o XAMPP também entrega MariaDB. Se
> você quer o MySQL da Oracle especificamente, precisa adicionar o repositório oficial do
> MySQL ou usar Docker.
>
> Para o conteúdo desta aula, **tanto faz**: se o seu ambiente for MariaDB, siga normalmente.

### 2.3 Como executar o MySQL

Existem três caminhos. Escolha **um**.

#### Opção A — Pacote tudo-em-um (mais fácil para quem está começando)

Instala servidor web + PHP + banco + phpMyAdmin de uma vez só.

- **[XAMPP](https://www.apachefriends.org/)** — Windows, Linux e macOS. É o mais popular.
  A sigla é **X** (*cross-platform*) + **A**pache + **M**ariaDB + **P**HP + **P**erl.
  *(Em versões antigas o "M" era MySQL; hoje é MariaDB.)*
- **[WampServer](https://www.wampserver.com/)** — só Windows. Aí sim: **W**indows + **A**pache +
  **M**ySQL + **P**HP.
- **[Laragon](https://laragon.org/)** — só Windows, alternativa mais leve e moderna.

> **Conflito de portas:** se o MySQL não subir, quase sempre há outro serviço na porta 3306
> (outra instalação de MySQL, ou o SQL Server). Solução: mude a porta no `my.ini`/`my.cnf`
> (`port=3307`) e lembre de informar essa porta no cliente.

#### Opção B — Instalação nativa do servidor

- **Windows:** [MySQL Installer for Windows](https://dev.mysql.com/downloads/installer/).
- **macOS:** `brew install mysql` (Homebrew) ou o `.dmg` oficial.
- **Linux (Debian/Ubuntu):** `sudo apt install mysql-server` — atenção: em várias distros esse
  pacote resolve para MariaDB. Para o MySQL da Oracle, adicione antes o
  [repositório APT oficial](https://dev.mysql.com/downloads/repo/apt/).

Depois de instalar, rode `sudo mysql_secure_installation` para definir a senha do `root`.

#### Opção C — Docker (o que será usado na apresentação)

> **Aviso de escopo:** Docker **não** faz parte desta capacitação. Está aqui só para
> documentar como o ambiente da aula foi montado e para estimular quem quiser pesquisar
> depois. O arquivo pronto está em `infrastructure/compose.yml` no repositório da capacitação.

O arquivo abaixo é um **`compose.yml`** — que é uma coisa **diferente de um `Dockerfile`**.
O `Dockerfile` descreve *como construir uma imagem*; o `compose.yml` descreve *quais serviços
prontos subir e como conectá-los*. Aqui só usamos imagens prontas, então só existe `compose.yml`.

`infrastructure/compose.yml`:

```yaml
# ============================================================
# compose.yml — ambiente da capacitação de MySQL
# ============================================================
#   docker compose up -d                    # MySQL + phpMyAdmin (uso local)
#   docker compose --profile tunnel up -d   # o mesmo + túnel ngrok público
#   docker compose down                     # para tudo, PRESERVA os dados
#   docker compose down -v                  # para tudo e APAGA o volume
# ============================================================

services:
  mysql:
    image: mysql:8.4
    container_name: mysql-capacitation
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
      TZ: America/Sao_Paulo
    ports:
      # Porta do SGBD no seu host, para clientes desktop (DBeaver, Workbench).
      # O ngrok NÃO expõe esta porta — ele só publica o phpMyAdmin.
      - "${MYSQL_PORT}:3306"
    volumes:
      - mysql_data:/var/lib/mysql
      # Scripts de inicialização: rodam UMA VEZ, com o volume vazio.
      - ./init:/docker-entrypoint-initdb.d:ro
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${MYSQL_ROOT_PASSWORD}"]
      interval: 10s
      timeout: 5s
      retries: 5

  phpmyadmin:
    image: phpmyadmin:5.2
    container_name: phpmyadmin-capacitation
    restart: unless-stopped
    environment:
      PMA_HOST: mysql
      PMA_PORT: 3306
      UPLOAD_LIMIT: 64M
      # Impede que alguém use esta instância para se conectar a QUALQUER
      # servidor MySQL da internet. Relevante porque a página fica pública.
      PMA_ARBITRARY: 0
      # Preenchido só se os links quebrarem atrás do ngrok (ver ngrok/README.md).
      PMA_ABSOLUTE_URI: ${PMA_ABSOLUTE_URI}
    ports:
      - "${PHPMYADMIN_PORT}:80"
    depends_on:
      mysql:
        condition: service_healthy

  # ----------------------------------------------------------
  # Túnel público. NÃO sobe por padrão — só com:
  #     docker compose --profile tunnel up -d
  # ----------------------------------------------------------
  ngrok:
    image: ngrok/ngrok:latest
    container_name: ngrok-capacitation
    profiles: ["tunnel"]
    restart: unless-stopped
    environment:
      NGROK_AUTHTOKEN: ${NGROK_AUTHTOKEN}
    # Publica o phpMyAdmin (porta 80 DENTRO da rede do compose).
    command: ["http", "phpmyadmin:80", "--log", "stdout"]
    depends_on:
      - phpmyadmin

volumes:
  mysql_data:
```

`infrastructure/.env` (as variáveis referenciadas acima):

```bash
MYSQL_ROOT_PASSWORD=<senha longa e aleatória>   # só o instrutor
MYSQL_USER=aluno                                 # login da turma
MYSQL_PASSWORD=aluno
MYSQL_PORT=3307
PHPMYADMIN_PORT=90
NGROK_AUTHTOKEN=                                 # só se for usar o túnel
PMA_ABSOLUTE_URI=                                # vazio = autodetecção
```

E `infrastructure/init/01_create_databases.sql`, que roda automaticamente na primeira subida:

```sql
-- Banco de demonstração do instrutor: só o root tem acesso.
CREATE DATABASE IF NOT EXISTS cap CHARACTER SET utf8mb4;

-- Área dos alunos. O GRANT é sobre um PADRÃO de nome, não sobre um banco
-- que já exista: `_` e `%` são curingas em GRANT, por isso o `\_` escapado.
-- Resultado: 'aluno' pode criar/administrar liga_ana, liga_bruno, ... e mais nada.
GRANT ALL PRIVILEGES ON `liga\_%`.* TO 'aluno'@'%';
FLUSH PRIVILEGES;
```

> Scripts de `init/` rodam **uma única vez**, com o volume vazio. Editou? Reaplique com
> `docker compose down -v && docker compose up -d`.

Subindo:

```bash
cd materials
docker compose up -d      # sobe MySQL + phpMyAdmin em segundo plano
docker compose ps         # confere se estão de pé e saudáveis
docker compose logs -f mysql
```

Para publicar o phpMyAdmin na internet e a turma acessar sem instalar nada
(passo a passo completo em `infrastructure/README.md`):

```bash
docker compose --profile tunnel up -d                    # sobe também o túnel ngrok
docker compose logs ngrok | grep -oP 'url=\Khttps://\S+'  # a URL para passar à turma
```

Derrubando:

```bash
docker compose down       # para os containers, PRESERVA os dados
docker compose down -v    # para e APAGA o volume (perde tudo — use para zerar a aula)
```

> **Nota:** o comando é `docker compose` (v2, plugin do Docker). O antigo `docker-compose`
> com hífen é a v1, descontinuada desde 2023.

---

## 3. Clientes SQL

Um **cliente SQL** é o programa pelo qual **você** conversa com o servidor: ele abre a conexão,
envia os comandos SQL e exibe o resultado em tabela. O servidor (MySQL) e o cliente são
programas separados — podem inclusive estar em máquinas diferentes.

### 3.1 Panorama de clientes

| Cliente | Tipo | Plataformas | Custo |
|---|---|---|---|
| `mysql` (CLI) | Terminal | Win / Linux / macOS | Gratuito — vem com o servidor |
| [MySQL Workbench](https://www.mysql.com/products/workbench/) | Desktop | Win / Linux / macOS | Gratuito (GPL) |
| [DBeaver](https://dbeaver.io/) | Desktop | Win / Linux / macOS | Community gratuito; PRO pago |
| [HeidiSQL](https://www.heidisql.com/) | Desktop | Windows | Gratuito |
| [phpMyAdmin](https://www.phpmyadmin.net/) | **Web** | roda no servidor, acessa pelo navegador | Gratuito |
| [TablePlus](https://tableplus.com/) | Desktop | Win / Linux / macOS | Versão gratuita limitada; pago |
| [DBVisualizer](https://www.dbvis.com/) | Desktop | Win / Linux / macOS | Versão gratuita limitada; Pro pago |
| [Navicat](https://www.navicat.com/) | Desktop | Win / Linux / macOS | **Pago** (só teste grátis) |

> ⚠️ **Correção:** Navicat, DBVisualizer e SQLPro Studio **não são gratuitos** — são comerciais,
> com versão de teste ou edição gratuita limitada. Não os recomende como "gratuitos".

### 3.2 phpMyAdmin

O phpMyAdmin **não é um programa que você instala no seu sistema operacional** como os
outros da lista: é uma **aplicação web escrita em PHP** que roda num servidor web e que
você acessa pelo **navegador**. É por isso que ele aparece junto do Apache/PHP nos pacotes
tipo XAMPP.

Vamos usá-lo na aula por três motivos: não exige instalação na máquina do participante
(basta uma URL), mostra a estrutura do banco visualmente enquanto se aprende, e tem uma
aba **SQL** onde os comandos são digitados de verdade.

**Como obter:**

- **Com XAMPP / WampServer / Laragon:** já vem instalado. Acesse `http://localhost/phpmyadmin`.
- **Com Docker:** já está no `compose.yml` acima (serviço `phpmyadmin`).
- **Instalação manual (Linux):** exige um servidor web + PHP:
  ```bash
  sudo apt update
  sudo apt install apache2 php php-mysqli php-mbstring
  ```
  Depois baixe o pacote em [phpmyadmin.net](https://www.phpmyadmin.net/) e extraia em
  `/var/www/html/phpmyadmin`.
  *(Se o seu gerenciador de pacotes não for o APT, use o comando equivalente.)*

### 3.3 Conectando (na aula)

Nesta capacitação **ninguém instala nada**. O instrutor roda o MySQL e o phpMyAdmin na
máquina dele e publica só o phpMyAdmin na internet por um túnel (ngrok). Você acessa por
uma URL, no navegador.

| Campo | Valor |
|---|---|
| URL do phpMyAdmin | *ditada pelo instrutor no início da aula* — algo como `https://a1b2-c3d4.ngrok-free.app` |
| Usuário | `aluno` |
| Senha | `aluno` |

> Na primeira visita o ngrok mostra uma **tela de aviso**. Clique em **"Visit Site"** e siga.

#### Cada aluno tem o seu próprio banco

O servidor é um só, compartilhado pela turma inteira. Se todos trabalhassem no mesmo
banco, o `CREATE TABLE` do segundo aluno já falharia com `ERROR 1050: Table already exists`,
e um `DELETE` de qualquer um apagaria o dado de todos.

Por isso **cada participante cria o próprio banco**, chamado `liga_` + seu primeiro nome:

```
liga_ana      liga_bruno      liga_carla      liga_diego
```

> **Regra do nome:** só letras minúsculas, sem acento e sem espaço. `liga_joao`, nunca
> `liga_João` nem `liga_joao silva`.
>
> **Onde este documento escrever `liga_SEUNOME`, use o seu.** O login `aluno` só tem
> permissão em bancos que comecem com `liga_` — qualquer outro nome dá
> `ERROR 1044: Access denied`. Isso é proposital: protege o banco de demonstração do
> instrutor (`cap`) e os dados internos do MySQL.

#### Rodando na sua própria máquina (opcional, depois da aula)

Se você montar o ambiente em casa (§2.3), o servidor é seu e você entra como `root`.
Aí o banco pode se chamar só `liga`.

| Campo | Valor |
|---|---|
| URL do phpMyAdmin | `http://localhost:90` |
| Servidor (clientes desktop) | `localhost`, porta `3307` |
| Usuário / senha | os que você definiu no `.env` |

**Teste de sanidade** — abra a aba **SQL** e rode:

```sql
SELECT VERSION(), NOW();
```

Se voltou a versão do servidor e a data/hora, está tudo certo. Pode começar.

---

## 4. SQL — o assunto principal

**SQL** (*Structured Query Language*, "Linguagem de Consulta Estruturada") é a linguagem
padronizada (ANSI/ISO) para definir e manipular dados em bancos relacionais. Ela é
**declarativa**: você descreve **o que** quer, não **como** buscar. O SGBD decide o caminho.

Cada SGBD tem seu "sotaque" (dialeto), mas o núcleo é o mesmo — o que você aprender aqui
vale, com ajustes pequenos, para PostgreSQL, SQL Server e SQLite.

### 4.1 SQL não é um bloco só: DDL, DML, DQL, DCL, TCL

Os comandos SQL são agrupados por finalidade. Saber esse mapa evita muita confusão:

| Sigla | Nome | Para quê | Comandos |
|---|---|---|---|
| **DDL** | *Data Definition Language* | Define a **estrutura** | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` |
| **DML** | *Data Manipulation Language* | Manipula os **dados** | `INSERT`, `UPDATE`, `DELETE` |
| **DQL** | *Data Query Language* | **Consulta** os dados | `SELECT` |
| **DCL** | *Data Control Language* | Controla **permissões** | `GRANT`, `REVOKE` |
| **TCL** | *Transaction Control Language* | Controla **transações** | `COMMIT`, `ROLLBACK`, `SAVEPOINT` |

> Muitos autores tratam o `SELECT` como parte do DML. Os dois usos existem na literatura;
> o importante é entender a diferença entre **mexer na estrutura** (DDL) e **mexer nos
> dados** (DML/DQL). Nesta capacitação: **DDL + DML/DQL**.

### 4.2 A ordem de trabalho

Como o MySQL é relacional, sempre existe uma estrutura antes do dado. A ordem nunca muda:

```
1. CREATE DATABASE  →  criar o banco             ┐
2. USE              →  selecionar o banco        │  DDL — a estrutura,
3. CREATE TABLE     →  criar a(s) tabela(s)      ┘  feita uma vez
                    ↓
4. INSERT           →  inserir dados             ┐
5. SELECT           →  consultar dados           │  DML/DQL — o dia a dia,
6. UPDATE           →  alterar dados             │  repetido o tempo todo
7. DELETE           →  remover dados             ┘
```

> ⚠️ **Ponto que costuma passar batido:** a lista original desta seção misturava criar tabela
> com inserir/atualizar/apagar dados como se fossem o mesmo tipo de operação. **Não são.**
> Criar tabela é DDL, feito uma vez no projeto. `INSERT`/`UPDATE`/`DELETE` são DML, executados
> milhares de vezes pela aplicação.

**Nosso cenário na aula:** cadastro de membros da liga acadêmica, com duas tabelas —
`curso` e `membro`.

### 4.3 DDL — criando o banco

> ⚠️ **Troque `SEUNOME` pelo seu primeiro nome** — aqui e em todo o resto do documento.
> Se você é a Ana, seu banco é `liga_ana`. Ver §3.3.

```sql
CREATE DATABASE IF NOT EXISTS liga_SEUNOME
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE liga_SEUNOME;
```

- `IF NOT EXISTS` evita erro se o banco já existir.
- `utf8mb4` é o *charset* que suporta **acentos e emojis** corretamente. É o padrão do MySQL 8,
  mas declarar explicitamente é boa prática — em servidores antigos o padrão era `latin1`, que
  quebra acentuação.
- `USE liga_SEUNOME;` define o banco corrente. **Sem isso, os comandos seguintes não sabem
  onde agir** e você toma `ERROR 1046: No database selected`. No phpMyAdmin, clicar no banco
  na barra lateral tem o mesmo efeito.

> **Deu `ERROR 1044: Access denied`?** Seu banco não começa com `liga_`. O login da turma
> só tem permissão nesse padrão de nome — confira se não digitou `liga-ana` (hífen) ou
> esqueceu o `liga_`.

Comandos úteis de inspeção:

```sql
SHOW DATABASES;              -- lista os bancos do servidor
SHOW TABLES;                 -- lista as tabelas do banco corrente
DESCRIBE membro;             -- mostra as colunas e tipos de uma tabela
SHOW CREATE TABLE membro;    -- mostra o CREATE TABLE completo, como o servidor o guardou
```

### 4.4 Tipos de dados (o que você realmente usa)

Cada coluna tem um **tipo**, e é ele que garante que a coluna `periodo` nunca receba
`"banana"`. Escolher bem o tipo é 80% da qualidade de uma tabela.

| Tipo | Guarda | Quando usar |
|---|---|---|
| `INT` | Inteiro (~ ±2,1 bi) | IDs, contadores, quantidades |
| `TINYINT` | Inteiro de 0 a 255 (ou −128 a 127) | Valores pequenos: período, idade |
| `BIGINT` | Inteiro muito grande | IDs de sistemas de altíssimo volume |
| `DECIMAL(p,s)` | Número exato com casas decimais | **Dinheiro** — `DECIMAL(10,2)` |
| `FLOAT` / `DOUBLE` | Número aproximado | Medidas científicas. **Nunca para dinheiro** |
| `VARCHAR(n)` | Texto de tamanho variável, até `n` | Nome, e-mail, título — o caso mais comum |
| `CHAR(n)` | Texto de tamanho **fixo** | Siglas: `CHAR(2)` para UF |
| `TEXT` | Texto longo (até 64 KB) | Descrições, observações |
| `DATE` | Data (`AAAA-MM-DD`) | Data de nascimento, data de ingresso |
| `DATETIME` | Data + hora | Agendamentos, registro de eventos |
| `TIMESTAMP` | Data + hora, sensível a fuso | `criado_em`, `atualizado_em` |
| `BOOLEAN` | Verdadeiro/falso | Flags. *(No MySQL é apelido de `TINYINT(1)`: `TRUE`=1, `FALSE`=0)* |
| `ENUM(...)` | Um valor de uma lista fixa | Status: `ENUM('ativo','inativo')` |

> **Regra de ouro:** dinheiro em `DECIMAL`, **nunca** em `FLOAT`. `FLOAT` é aproximado e
> `0.1 + 0.2` pode não dar exatamente `0.3`.

**`NULL` não é zero e não é string vazia.** `NULL` significa "valor desconhecido / não
informado". Por isso `WHERE curso_id = NULL` **nunca** funciona — o certo é
`WHERE curso_id IS NULL`.

### 4.5 DDL — criando a tabela

```sql
CREATE TABLE curso (
  id   INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(80) NOT NULL UNIQUE
) ENGINE=InnoDB;
```

```sql
CREATE TABLE membro (
  id            INT           AUTO_INCREMENT PRIMARY KEY,
  nome          VARCHAR(120)  NOT NULL,
  email         VARCHAR(160)  NOT NULL UNIQUE,
  periodo       TINYINT       NOT NULL,
  data_ingresso DATE          NOT NULL,
  ativo         BOOLEAN       NOT NULL DEFAULT TRUE,
  curso_id      INT           NULL,
  criado_em     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
```

**As restrições (*constraints*), que é onde mora a qualidade do dado:**

| Restrição | O que faz |
|---|---|
| `PRIMARY KEY` | Identifica cada linha de forma **única**. Não aceita `NULL`, não repete. Uma por tabela |
| `AUTO_INCREMENT` | O MySQL gera o próximo número sozinho. Você não informa esse campo no `INSERT` |
| `NOT NULL` | O campo é obrigatório |
| `UNIQUE` | O valor não pode se repetir na coluna (dois membros não podem ter o mesmo e-mail) |
| `DEFAULT x` | Valor assumido quando o `INSERT` não informa a coluna |
| `FOREIGN KEY` | Liga esta tabela a outra — ver §4.7 |

> **`PRIMARY KEY` vs `UNIQUE`:** as duas impedem repetição. A diferença: só existe **uma**
> chave primária por tabela e ela **não aceita `NULL`**; já `UNIQUE` pode haver várias e
> aceita `NULL`.

Alterando a estrutura depois (também DDL):

```sql
ALTER TABLE membro ADD COLUMN telefone VARCHAR(20) NULL;
ALTER TABLE membro MODIFY COLUMN nome VARCHAR(150) NOT NULL;
ALTER TABLE membro DROP COLUMN telefone;

DROP TABLE membro;    -- ⚠️ apaga a tabela E todos os dados. Sem desfazer.
```

### 4.6 CRUD — Create, Read, Update, Delete

**CRUD** é o acrônimo das quatro operações básicas sobre dados. Todo sistema que você
escrever na vida faz essas quatro coisas.

| CRUD | SQL | Categoria |
|---|---|---|
| **C**reate | `INSERT` | DML |
| **R**ead | `SELECT` | DQL |
| **U**pdate | `UPDATE` | DML |
| **D**elete | `DELETE` | DML |

#### 4.6.1 CREATE — `INSERT`

```sql
-- Uma linha
INSERT INTO curso (nome) VALUES ('Engenharia de Software');

-- Várias linhas de uma vez (mais eficiente)
INSERT INTO curso (nome) VALUES
  ('Ciência da Computação'),
  ('Sistemas de Informação'),
  ('Engenharia de Produção');

INSERT INTO membro (nome, email, periodo, data_ingresso, curso_id) VALUES
  ('Ana Souza',    'ana@liga.edu.br',    7, '2024-03-11', 1),
  ('Bruno Lima',   'bruno@liga.edu.br',  3, '2025-02-20', 2),
  ('Carla Dias',   'carla@liga.edu.br',  5, '2024-08-05', 1),
  ('Diego Rocha',  'diego@liga.edu.br',  9, '2023-09-14', 3),
  ('Elisa Prado',  'elisa@liga.edu.br',  1, '2026-03-02', NULL);
```

Repare: `id`, `ativo` e `criado_em` **não** foram informados — são preenchidos pelo
`AUTO_INCREMENT` e pelos `DEFAULT`.

- Datas vão sempre no formato **`'AAAA-MM-DD'`** e entre aspas.
- Texto entre aspas simples: `'Ana'`. Números sem aspas: `7`.
- A ordem dos valores em `VALUES` deve bater exatamente com a ordem das colunas listadas.

#### 4.6.2 READ — `SELECT`

O comando mais usado da linguagem. Estrutura completa:

```sql
SELECT   colunas
FROM     tabela
WHERE    condição          -- filtra LINHAS
ORDER BY coluna [ASC|DESC] -- ordena
LIMIT    n;                -- limita a quantidade
```

```sql
SELECT * FROM membro;                          -- tudo (útil para explorar, ruim em produção)
SELECT nome, email FROM membro;                -- só as colunas que interessam
SELECT nome AS aluno, periodo AS sem FROM membro;  -- AS renomeia a coluna no resultado
```

**Filtrando com `WHERE`:**

```sql
SELECT * FROM membro WHERE periodo > 5;
SELECT * FROM membro WHERE ativo = TRUE AND periodo >= 5;
SELECT * FROM membro WHERE periodo = 1 OR periodo = 3;
SELECT * FROM membro WHERE periodo IN (1, 3, 5);            -- mesmo que o OR acima
SELECT * FROM membro WHERE periodo BETWEEN 3 AND 7;         -- inclusivo nas duas pontas
SELECT * FROM membro WHERE nome LIKE 'A%';                  -- começa com A
SELECT * FROM membro WHERE email LIKE '%@liga.edu.br';      -- termina com
SELECT * FROM membro WHERE nome LIKE '%ana%';               -- contém
SELECT * FROM membro WHERE curso_id IS NULL;                -- sem curso informado
SELECT * FROM membro WHERE data_ingresso >= '2025-01-01';
```

| Operador | Significado |
|---|---|
| `=` `<>` (ou `!=`) | Igual / diferente |
| `>` `<` `>=` `<=` | Comparação |
| `AND` `OR` `NOT` | Combinação lógica |
| `IN (a, b, c)` | Está na lista |
| `BETWEEN a AND b` | Está no intervalo (inclusivo) |
| `LIKE` | Padrão de texto — `%` = qualquer coisa, `_` = um caractere |
| `IS NULL` / `IS NOT NULL` | Testa ausência de valor |

**Ordenando e limitando:**

```sql
SELECT nome, periodo FROM membro ORDER BY periodo DESC;
SELECT nome, periodo FROM membro ORDER BY periodo DESC, nome ASC;
SELECT nome FROM membro ORDER BY data_ingresso ASC LIMIT 3;   -- os 3 mais antigos
```

> `ASC` = crescente (padrão, pode omitir). `DESC` = decrescente.

#### 4.6.3 UPDATE — alterar

```sql
UPDATE membro
SET    periodo = 8
WHERE  id = 1;

UPDATE membro
SET    ativo = FALSE, periodo = 10
WHERE  email = 'diego@liga.edu.br';
```

#### 4.6.4 DELETE — remover

Para praticar sem destruir os dados da aula, crie um registro descartável e apague **ele**:

```sql
INSERT INTO membro (nome, email, periodo, data_ingresso)
VALUES ('Registro Teste', 'teste@liga.edu.br', 1, '2026-01-01');

SELECT * FROM membro WHERE email = 'teste@liga.edu.br';   -- confira ANTES
DELETE FROM membro WHERE email = 'teste@liga.edu.br';
```

#### 4.6.5 ⚠️ O erro mais caro da carreira de quem começa

```sql
UPDATE membro SET periodo = 1;   -- ❌ zera o período de TODOS os membros
DELETE FROM membro;              -- ❌ apaga TODOS os membros da tabela
```

**Sem `WHERE`, o comando vale para a tabela inteira.** E não existe "Ctrl+Z" em SQL.

**Hábito obrigatório — teste com `SELECT` antes:**

```sql
-- 1º) veja EXATAMENTE quais linhas serão afetadas
SELECT * FROM membro WHERE id = 5;

-- 2º) só então troque o SELECT * pelo DELETE / UPDATE, mantendo o mesmo WHERE
DELETE FROM membro WHERE id = 5;
```

> **Dica:** o MySQL Workbench tem o *safe update mode*, que **bloqueia** `UPDATE`/`DELETE` sem
> `WHERE` em coluna-chave. O phpMyAdmin **não** protege — no phpMyAdmin, a disciplina é sua.
>
> `DELETE FROM tabela;` apaga as linhas (é DML, uma a uma). `TRUNCATE TABLE tabela;` esvazia
> a tabela de forma muito mais rápida e reinicia o `AUTO_INCREMENT` — mas é DDL e não pode ser
> desfeito por `ROLLBACK`.

### 4.7 Relacionamentos: a parte "relacional" do negócio

Até aqui só usamos uma tabela — isso é uma planilha, não um banco relacional. O que muda tudo
é **relacionar** tabelas.

**O problema que a FK resolve.** Se guardássemos o nome do curso dentro de `membro`, teríamos
`"Engenharia de Software"` repetido em dezenas de linhas. Aí alguém digita
`"Eng. de Software"`, outro digita `"engenharia de software"`, e a consulta por curso quebra.
Corrigir o nome exigiria alterar todas as linhas.

**A solução.** O curso vira uma tabela própria, e `membro` guarda apenas o **`id`** do curso:

```
   curso                          membro
┌────┬─────────────────────┐   ┌────┬────────────┬──────────┐
│ id │ nome                │   │ id │ nome       │ curso_id │
├────┼─────────────────────┤   ├────┼────────────┼──────────┤
│  1 │ Eng. de Software    │◄──┼─ 1 │ Ana Souza  │        1 │
│  2 │ Ciência da Comp.    │◄──┼─ 2 │ Bruno Lima │        2 │
└────┴─────────────────────┘   │  3 │ Carla Dias │        1 │
        ▲                       └────┴────────────┴──────────┘
   chave primária (PK)                            chave estrangeira (FK)
```

- **Chave primária (PK):** identifica a linha **dentro** da própria tabela.
- **Chave estrangeira (FK):** uma coluna que **aponta** para a PK de outra tabela. O SGBD passa
  a **garantir** que aquele valor existe do outro lado — isso se chama **integridade referencial**.

Declarando a FK:

```sql
ALTER TABLE membro
  ADD CONSTRAINT fk_membro_curso
  FOREIGN KEY (curso_id) REFERENCES curso(id)
  ON DELETE SET NULL
  ON UPDATE CASCADE;
```

Com a FK ativa, isto passa a **falhar** — e é exatamente o que queremos:

```sql
INSERT INTO membro (nome, email, periodo, data_ingresso, curso_id)
VALUES ('Fake', 'fake@liga.edu.br', 1, '2026-01-01', 999);
-- ERROR 1452: Cannot add or update a child row: a foreign key constraint fails
```

`ON DELETE` / `ON UPDATE` definem o que acontece com os filhos quando o pai muda:

| Ação | Efeito ao apagar/alterar o curso |
|---|---|
| `RESTRICT` (padrão) | Impede a operação enquanto houver membro apontando para ele |
| `SET NULL` | Os membros ficam com `curso_id = NULL` (exige coluna que aceite `NULL`) |
| `CASCADE` | Propaga: apagar o curso apagaria os membros. **Use com muito cuidado** |

**Cardinalidades** (como as tabelas se ligam):

- **1:N (um-para-muitos)** — o caso mais comum. Um curso tem vários membros; cada membro tem
  um curso. **A FK fica no lado "muitos"** (em `membro`). É o nosso caso.
- **1:1** — FK com `UNIQUE`. Raro.
- **N:N (muitos-para-muitos)** — ex.: um membro participa de vários projetos e um projeto tem
  vários membros. Resolve-se com uma **tabela intermediária** (`membro_projeto`) que guarda
  duas FKs. *(Conceito citado; não praticado nesta capacitação.)*

#### `JOIN` — consultando as duas tabelas juntas

`JOIN` combina linhas de tabelas diferentes usando a condição de ligação (`ON`).

```sql
-- INNER JOIN: só os membros QUE TÊM curso
SELECT m.nome AS membro,
       c.nome AS curso,
       m.periodo
FROM   membro m
INNER  JOIN curso c ON m.curso_id = c.id
ORDER  BY c.nome, m.nome;
```

```sql
-- LEFT JOIN: TODOS os membros, tenham curso ou não (Elisa aparece com curso = NULL)
SELECT m.nome AS membro,
       c.nome AS curso
FROM   membro m
LEFT   JOIN curso c ON m.curso_id = c.id;
```

| Tipo | Retorna |
|---|---|
| `INNER JOIN` | Só as linhas com correspondência **nos dois lados** |
| `LEFT JOIN` | **Todas** as da tabela da esquerda + as correspondentes da direita (`NULL` se não houver) |
| `RIGHT JOIN` | O espelho do `LEFT` — raro, basta inverter a ordem das tabelas |

> `membro m` e `curso c` são **apelidos** (*aliases*). Com duas tabelas em jogo, `m.nome` e
> `c.nome` deixam claro de qual tabela é cada coluna — sem isso o MySQL responde
> `ERROR 1052: Column 'nome' in field list is ambiguous`.
>
> **A condição do `ON` é sempre `FK = PK`.** Esqueceu o `ON`? Você acabou de fazer um produto
> cartesiano: cada membro cruzado com cada curso.

### 4.8 Bônus: contar e agrupar

*(Só se o cronograma permitir. Caso contrário, fica como material de estudo.)*

Funções de agregação resumem várias linhas em um valor: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`.

```sql
SELECT COUNT(*) FROM membro;                        -- quantos membros existem
SELECT AVG(periodo) FROM membro;                    -- período médio
SELECT MIN(data_ingresso), MAX(data_ingresso) FROM membro;
```

`GROUP BY` aplica a agregação **por grupo**:

```sql
SELECT c.nome        AS curso,
       COUNT(m.id)   AS total_membros
FROM   curso c
LEFT   JOIN membro m ON m.curso_id = c.id
GROUP  BY c.id, c.nome
ORDER  BY total_membros DESC;
```

> `WHERE` filtra **linhas antes** de agrupar; `HAVING` filtra **grupos depois** de agregar.
> Ex.: `... GROUP BY c.id, c.nome HAVING COUNT(m.id) >= 2;`

---

## 5. Erros comuns de quem está começando

| Erro / mensagem | Causa | Correção |
|---|---|---|
| `ERROR 1046: No database selected` | Faltou escolher o banco | `USE liga_SEUNOME;` ou clicar no banco na lateral |
| `ERROR 1044: Access denied ... to database` | Nome do banco fora do padrão `liga_*`, ou tentativa de abrir o banco `cap` do instrutor | Use `liga_SEUNOME` (underscore, minúsculas, sem acento) |
| `ERROR 1050: Table already exists` | A tabela já foi criada (você rodou o `CREATE TABLE` duas vezes) | `DROP TABLE membro;` antes, ou rode o Anexo B inteiro para zerar |
| `UPDATE`/`DELETE` afetou a tabela toda | `WHERE` esquecido | Sempre testar com `SELECT` antes |
| `WHERE campo = NULL` não retorna nada | `NULL` não é comparável com `=` | `WHERE campo IS NULL` |
| `ERROR 1062: Duplicate entry` | Violou `PRIMARY KEY` ou `UNIQUE` | O valor já existe; use outro ou faça `UPDATE` |
| `ERROR 1452: foreign key constraint fails` | FK apontando para id inexistente | Insira primeiro na tabela-pai (`curso`) |
| `ERROR 1452` ao apagar da tabela-pai | Há filhos referenciando | Trate os filhos antes, ou defina `ON DELETE` |
| Acentuação vira `Ã©` / `?` | *Charset* errado (`latin1`) | Crie o banco com `utf8mb4` |
| `ERROR 1052: Column ... is ambiguous` | Duas tabelas com coluna de mesmo nome | Qualifique: `m.nome`, `c.nome` |
| Datas não filtram direito | Formato ou tipo errado | Use `DATE`/`DATETIME` e `'AAAA-MM-DD'` |
| Valores monetários "erram" centavos | Coluna em `FLOAT` | Use `DECIMAL(10,2)` |
| Comando não executa | Falta `;` no fim | Termine todo comando com ponto e vírgula |

---

## 6. Conclusão e próximos passos

Em 2 horas percorremos o caminho completo de um banco relacional: **entender o modelo →
subir o servidor → conectar por um cliente → definir a estrutura (DDL) → manipular os dados
(CRUD) → relacionar tabelas (FK + JOIN)**. Isso é o suficiente para modelar e operar o banco
de um primeiro projeto da liga.

O que estudar depois, nesta ordem:

1. **Normalização (1FN, 2FN, 3FN)** — como decidir quantas tabelas o seu projeto precisa.
2. **Modelagem ER** — desenhar o modelo antes de escrever SQL (dbdiagram.io, DBeaver, Workbench).
3. **Relacionamento N:N** com tabela intermediária, e `JOIN` de três ou mais tabelas.
4. **Agregação avançada:** `GROUP BY`, `HAVING`, subconsultas.
5. **Índices** — por que uma consulta fica lenta e como acelerá-la (`EXPLAIN`).
6. **Transações** — `START TRANSACTION`, `COMMIT`, `ROLLBACK` e o conceito de ACID.
7. **Integração com aplicação** — conectar via linguagem (Python, PHP, Node) e conhecer ORMs.
8. **Backup e restauração** — `mysqldump`.

**Para praticar sem instalar nada:**

- [SQLite Online](https://sqliteonline.com/) — vários bancos direto no navegador
- [DB Fiddle](https://www.db-fiddle.com/) — MySQL/PostgreSQL no navegador
- [OneCompiler MySQL](https://onecompiler.com/mysql/)
- [SQL Fiddle](http://sqlfiddle.com/)
- [SQLZoo](https://sqlzoo.net/) e [SQLBolt](https://sqlbolt.com/) — exercícios interativos guiados
- [HackerRank — SQL](https://www.hackerrank.com/domains/sql) — desafios com correção automática

**Documentação oficial:** [dev.mysql.com/doc/refman/8.4/en/](https://dev.mysql.com/doc/refman/8.4/en/)

**Materiais desta capacitação:** pasta `infrastructure/` do repositório (`compose.yml`, `.env`,
scripts de inicialização) e este documento em `docs/md/`.

---

## Anexo A — Colinha de sintaxe

```sql
-- ESTRUTURA (DDL)
CREATE DATABASE nome CHARACTER SET utf8mb4;
USE nome;
CREATE TABLE t (id INT AUTO_INCREMENT PRIMARY KEY, campo VARCHAR(100) NOT NULL);
ALTER TABLE t ADD COLUMN novo VARCHAR(50);
ALTER TABLE t MODIFY COLUMN campo VARCHAR(200) NOT NULL;
ALTER TABLE t DROP COLUMN novo;
DROP TABLE t;

-- INSPEÇÃO
SHOW DATABASES;   SHOW TABLES;   DESCRIBE t;   SHOW CREATE TABLE t;

-- DADOS (DML/DQL)
INSERT INTO t (c1, c2) VALUES (v1, v2), (v3, v4);
SELECT c1, c2 FROM t WHERE cond ORDER BY c1 DESC LIMIT 10;
UPDATE t SET c1 = v WHERE id = 1;      -- SEMPRE com WHERE
DELETE FROM t WHERE id = 1;            -- SEMPRE com WHERE

-- FILTROS
WHERE a = 1 AND b <> 2
WHERE a IN (1,2,3)          WHERE a BETWEEN 1 AND 10
WHERE nome LIKE 'A%'        WHERE campo IS NULL

-- RELACIONAMENTO
FOREIGN KEY (curso_id) REFERENCES curso(id) ON DELETE SET NULL;
SELECT m.nome, c.nome FROM membro m INNER JOIN curso c ON m.curso_id = c.id;
SELECT m.nome, c.nome FROM membro m LEFT  JOIN curso c ON m.curso_id = c.id;

-- AGREGAÇÃO
SELECT c.nome, COUNT(*) FROM curso c JOIN membro m ON m.curso_id = c.id
GROUP BY c.id, c.nome HAVING COUNT(*) >= 2;
```

---

## Anexo B — Script completo da aula

Rode do início ao fim para reconstruir todo o cenário da capacitação.

> ⚠️ **Antes de colar:** substitua as **3 ocorrências de `liga_SEUNOME`** (linhas 8, 9 e 10)
> pelo seu banco — `liga_ana`, `liga_joao`, etc. Se você colar sem trocar, vai criar um banco
> literalmente chamado `liga_seunome` e brigar com quem fez o mesmo.

```sql
-- ============================================================
-- Capacitação MySQL — Liga Acadêmica
-- Cenário: cadastro de membros e cursos
-- ============================================================

-- 1. BANCO ---------------------------------------------------
-- O DROP zera SÓ o seu banco, para o script poder ser rodado de novo.
DROP DATABASE IF EXISTS liga_SEUNOME;
CREATE DATABASE liga_SEUNOME CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE liga_SEUNOME;

-- 2. ESTRUTURA (DDL) -----------------------------------------
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
  curso_id      INT           NULL,
  criado_em     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_membro_curso
    FOREIGN KEY (curso_id) REFERENCES curso(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. DADOS (INSERT) ------------------------------------------
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

-- 4. CONSULTAS (SELECT) --------------------------------------
SELECT * FROM membro;
SELECT nome, email FROM membro WHERE periodo > 5;
SELECT * FROM membro WHERE nome LIKE 'A%';
SELECT * FROM membro WHERE curso_id IS NULL;
SELECT nome, periodo FROM membro ORDER BY periodo DESC;
SELECT nome FROM membro ORDER BY data_ingresso ASC LIMIT 3;

-- 5. ALTERAÇÃO E REMOÇÃO -------------------------------------
SELECT * FROM membro WHERE id = 1;          -- confira ANTES
UPDATE membro SET periodo = 8 WHERE id = 1;

-- registro descartável, criado só para ser apagado
INSERT INTO membro (nome, email, periodo, data_ingresso)
VALUES ('Registro Teste', 'teste@liga.edu.br', 1, '2026-01-01');

SELECT * FROM membro WHERE email = 'teste@liga.edu.br';   -- confira ANTES
DELETE FROM membro WHERE email = 'teste@liga.edu.br';

-- 6. RELACIONAMENTO (JOIN) -----------------------------------
SELECT m.nome AS membro, c.nome AS curso, m.periodo
FROM   membro m
INNER  JOIN curso c ON m.curso_id = c.id
ORDER  BY c.nome, m.nome;

SELECT m.nome AS membro, c.nome AS curso
FROM   membro m
LEFT   JOIN curso c ON m.curso_id = c.id;

-- 7. BÔNUS: AGREGAÇÃO ----------------------------------------
SELECT c.nome AS curso, COUNT(m.id) AS total_membros
FROM   curso c
LEFT   JOIN membro m ON m.curso_id = c.id
GROUP  BY c.id, c.nome
ORDER  BY total_membros DESC;
```

---

## Anexo C — Exercícios

Faça no seu banco `liga_SEUNOME`, já construído pelo Anexo B. As respostas estão logo abaixo — tente antes de olhar.

1. Liste o nome e o e-mail de todos os membros **ativos**.
2. Mostre os membros do **1º ao 5º período**, do mais novo para o mais antigo na liga.
3. Quantos membros ingressaram **a partir de 2025**?
4. Cadastre um novo curso, `'Engenharia Elétrica'`, e um membro nele.
5. Corrija o e-mail da Carla para `carla.dias@liga.edu.br`.
6. Liste **membro + nome do curso**, incluindo quem está sem curso.
7. Desative (`ativo = FALSE`) todo membro que ingressou antes de `2024-01-01`.
8. Tente inserir um membro com `curso_id = 999`. Explique a mensagem de erro.

<details>
<summary><b>Respostas</b></summary>

```sql
-- 1
SELECT nome, email FROM membro WHERE ativo = TRUE;

-- 2
SELECT * FROM membro
WHERE periodo BETWEEN 1 AND 5
ORDER BY data_ingresso DESC;

-- 3
SELECT COUNT(*) FROM membro WHERE data_ingresso >= '2025-01-01';

-- 4  (o curso PRIMEIRO — a FK exige que o pai exista)
INSERT INTO curso (nome) VALUES ('Engenharia Elétrica');
INSERT INTO membro (nome, email, periodo, data_ingresso, curso_id)
VALUES ('Felipe Nunes', 'felipe@liga.edu.br', 2, '2026-03-10',
        (SELECT id FROM curso WHERE nome = 'Engenharia Elétrica'));

-- 5
SELECT * FROM membro WHERE nome = 'Carla Dias';           -- confira antes
UPDATE membro SET email = 'carla.dias@liga.edu.br' WHERE nome = 'Carla Dias';

-- 6  (LEFT JOIN, porque INNER JOIN esconderia quem não tem curso)
SELECT m.nome AS membro, c.nome AS curso
FROM   membro m LEFT JOIN curso c ON m.curso_id = c.id;

-- 7
SELECT * FROM membro WHERE data_ingresso < '2024-01-01';  -- confira antes
UPDATE membro SET ativo = FALSE WHERE data_ingresso < '2024-01-01';

-- 8
INSERT INTO membro (nome, email, periodo, data_ingresso, curso_id)
VALUES ('Teste', 'teste@liga.edu.br', 1, '2026-01-01', 999);
-- ERROR 1452: a chave estrangeira exige que exista um curso com id = 999.
-- Como não existe, o SGBD REJEITA a inserção — é a integridade referencial
-- protegendo o banco contra dado órfão.
```

</details>
