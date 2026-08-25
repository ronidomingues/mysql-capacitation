# Capacitação de MySQL

![MySQL](https://img.shields.io/badge/MySQL-8.4_LTS-4479A1?logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Fundamentos-336791)
![LaTeX](https://img.shields.io/badge/LaTeX-abnTeX2-008080?logo=latex&logoColor=white)
![Licença](https://img.shields.io/badge/código-MIT-green)
![Conteúdo](https://img.shields.io/badge/conteúdo-CC_BY--SA_4.0-lightgrey)

Capacitação introdutória de **MySQL e SQL** para os membros da liga acadêmica.
Duração de **2 horas exatas**, sem pré-requisito de banco de dados.

📖 **[Ler o material publicado](https://andradasdev.github.io/sql/)**

> **Este é o repositório de CÓDIGO.** Aqui ficam as fontes: `.tex` do guia e
> dos slides, scripts SQL, ambiente Docker e o histórico de desenvolvimento.
> O material pronto é publicado automaticamente em
> **[andradasdev/sql](https://github.com/andradasdev/sql)**.
> Correções e contribuições vão aqui.

---

## 🎯 O que o participante sai sabendo

1. Explicar o que é um SGBD e o que significa "relacional"
2. Conectar-se a um servidor MySQL usando um cliente SQL
3. Criar banco e tabela com tipos, chave primária e restrições
4. Executar o CRUD: `INSERT`, `SELECT`, `UPDATE`, `DELETE`
5. Filtrar e ordenar com `WHERE`, `ORDER BY`, `LIMIT`
6. Relacionar duas tabelas com chave estrangeira e consultá-las com `JOIN`

**Fora do escopo:** Docker, normalização formal, índices, transações,
*views*, *procedures*, backup e NoSQL. Cada um desses é uma capacitação inteira.

## ⏱️ Os 120 minutos

| # | Bloco | Início | Duração |
|---|---|---|---|
| 0 | Abertura, objetivos e escopo | 00:00 | 5 min |
| 1 | Conceitos-base: dado, banco, SGBD, relacional, SQL | 00:05 | 15 min |
| 2 | Ambiente e cliente SQL: todos conectados | 00:20 | 15 min |
| 3 | DDL: banco, tipos, tabela, chave primária | 00:35 | 20 min |
| — | *Pausa* | 00:55 | 5 min |
| 4 | `INSERT` e `SELECT` com filtros | 01:00 | 25 min |
| 5 | `UPDATE`, `DELETE` e o perigo do `WHERE` ausente | 01:25 | 10 min |
| 6 | Chave estrangeira e `JOIN` | 01:35 | 20 min |
| 7 | Erros comuns, próximos passos e dúvidas | 01:55 | 5 min |
| | **Total** | | **120 min** |

---

## 🧑‍🎓 Para o participante

Você **não instala nada**. Basta o navegador.

1. Abra a URL do phpMyAdmin que o instrutor passar
2. Entre com usuário `aluno` e senha `aluno`
3. Na aba **SQL**, crie o seu banco — troque `SEUNOME` pelo seu primeiro nome:

   ```sql
   CREATE DATABASE liga_SEUNOME CHARACTER SET utf8mb4;
   USE liga_SEUNOME;
   ```

> ⚠️ Só letras minúsculas, sem acento e sem espaço: `liga_joao`, nunca `liga_João`.
> O login da turma só tem permissão em bancos que comecem com `liga_` — qualquer
> outro nome retorna `ERROR 1044: Access denied`.

O script completo da aula está em **[`materials/liga.sql`](materials/liga.sql)**.

## 🧑‍🏫 Para o instrutor

```bash
cd infrastructure
cp .env.example .env

# gere uma senha forte para o root e coloque no .env
openssl rand -base64 24 | tr -dc 'A-Za-z0-9' ; echo

docker compose up -d                    # MySQL + phpMyAdmin
docker compose --profile tunnel up -d   # + túnel público para a turma
```

O passo a passo de exposição para a turma, com o checklist de segurança, está
em **[`infrastructure/README.md`](infrastructure/README.md)**.

| | Banco | Acesso |
|---|---|---|
| Demonstração no telão | `cap` | só `root` |
| Exercícios da turma | `liga_<nome>` | usuário `aluno` |

---

## 📂 Estrutura

```
mysql-capacitation/
├── docs/                     conteúdo didático
│   ├── capacitacao.md        base intelectual, em Markdown
│   ├── guia.tex              apostila (abnTeX2, compilar com XeLaTeX)
│   ├── apresentacao.tex      slides de projeção
│   ├── apresentacao_notes.tex slides + notas do apresentador (2ª tela)
│   ├── pages/                capítulos, slides, preâmbulos e bibliografia
│   └── assets/               fontes, logos e imagens
├── infrastructure/           ambiente da aula
│   ├── compose.yml           MySQL 8.4 + phpMyAdmin + ngrok
│   ├── .env.example          modelo de configuração (sem segredos)
│   └── init/                 cria o banco 'cap' e libera 'liga_*' ao aluno
├── materials/
│   └── liga.sql              script completo da aula, para o participante
└── templates/                modelos LaTeX de referência (não é conteúdo)
```

## 🔁 Publicação

A cada push na `main`, o workflow `.github/workflows/build.yml`:

1. compila os `.tex` de `docs/`
2. verifica se os PDFs saíram íntegros (citação ou referência quebrada barra o build)
3. commita os PDFs aqui
4. envia `guia.pdf`, `apresentacao.pdf` e `liga.sql` para **andradasdev/sql**,
   onde um segundo workflow publica o site

A versão do apresentador (`apresentacao_notes.pdf`) **não** é publicada — ela
contém o roteiro de condução da aula e fica só aqui.

> Isso exige o secret `PUBLISH_TOKEN` neste repositório. O passo a passo está em
> [documentacao/autenticacao-github-actions.md](https://github.com/andradasdev/sql/blob/main/documentacao/autenticacao-github-actions.md),
> no repositório de publicação.

## 🔨 Compilando o guia

O PDF é gerado automaticamente pelo GitHub Actions a cada push. Para compilar
localmente:

```bash
sudo apt install -y texlive-latex-extra texlive-publishers \
                    texlive-xetex texlive-lang-portuguese \
                    fonts-lmodern latexmk

cd docs
latexmk -xelatex guia.tex               # apostila
latexmk -xelatex apresentacao.tex       # slides para o projetor
latexmk -xelatex apresentacao_notes.tex # slides com notas, para o seu monitor
```

> **Durante a aula:** abra `apresentacao.pdf` no projetor e
> `apresentacao_notes.pdf` no seu monitor. O segundo tem, em cada slide, o
> roteiro de fala, a ação esperada da turma e o relógio acumulado da
> capacitação.

> **XeLaTeX é obrigatório:** a fonte Lexend é carregada de arquivos locais via
> `fontspec`. Com `pdflatex` a compilação falha.

---

## ⚖️ Licença

Este repositório usa **licença dupla**:

- **Código** (`compose.yml`, scripts SQL, workflows, fontes LaTeX) — [MIT](LICENSE)
- **Conteúdo didático** (guia, apresentação, textos, exercícios) — [CC BY-SA 4.0](LICENSE-CONTENT)

A fonte Lexend está sob SIL Open Font License 1.1
([aviso](docs/assets/fonts/NOTICE.md)).

## 👨‍🏫 Autor

**Ronivaldo Domingues de Andrade**
LinkedIn: [ronidomingues](https://www.linkedin.com/in/ronidomingues/) ·
GitHub: [@ronidomingues](https://github.com/ronidomingues)
📍 Rio de Janeiro — RJ

### ⭐ Se este material foi útil, considere dar uma estrela no repositório!
