# Expondo o phpMyAdmin para a turma com ngrok

**Objetivo:** os alunos abrem uma URL no navegador e já começam a escrever SQL.
Nada de instalar XAMPP, MySQL ou cliente nenhum — os ~20 minutos que a instalação
comeria da aula ficam para o conteúdo.

**O que é exposto:** apenas o **phpMyAdmin** (porta 80 de dentro da rede do compose).
A porta do MySQL (`3307` no seu host) **não** entra no túnel.

> ⚠️ Isto publica uma tela de login de banco de dados na internet aberta.
> Leia a seção [Segurança](#segurança) antes da aula — ela não é opcional.

---

## Passo a passo

### 1. Token do ngrok (uma vez só)

Crie a conta gratuita e copie o token em
<https://dashboard.ngrok.com/get-started/your-authtoken>.

Cole no `infrastructure/.env`:

```bash
NGROK_AUTHTOKEN=2abc...seu_token_aqui
```

### 2. Suba o stack com o túnel

O serviço `ngrok` está num *profile*, então **não sobe por acidente**:

```bash
cd materials
docker compose --profile tunnel up -d
```

### 3. Descubra a URL gerada

No plano gratuito a URL muda a cada vez que o túnel sobe:

```bash
docker compose logs ngrok | grep -oP 'url=\Khttps://\S+'
```

Saída parecida com `https://a1b2-c3d4.ngrok-free.app`. **É essa URL que você passa
para a turma** (cole no chat da turma / projete no telão).

### 4. Credenciais que a turma usa

| Campo | Valor |
|---|---|
| URL | a do passo 3 |
| Usuário | `aluno` |
| Senha | `aluno` |

Você entra com **`root`** e a senha que está no `.env` — só você.

### 5. Página de aviso do ngrok (plano gratuito)

Na primeira visita o ngrok mostra uma tela de aviso antes do site. O aluno clica em
**"Visit Site"** uma vez e não vê mais. Avise isso na hora, senão vira 5 minutos de
"professor, deu uma tela estranha".

### 6. Derrube o túnel quando a aula acabar

```bash
docker compose --profile tunnel down    # derruba o túnel e o resto do stack
```

Ou só o túnel, mantendo o banco de pé:

```bash
docker compose stop ngrok
```

---

## Segurança

Enquanto o túnel está no ar, **qualquer pessoa com a URL** vê a tela de login.
O que já está configurado no repositório:

| Proteção | Onde | O que faz |
|---|---|---|
| Senha forte do `root` | `.env` | Impede o `root/root` que qualquer varredura automática tenta primeiro |
| `aluno` limitado a `liga_*` | `init/01_create_databases.sql` | Mesmo comprometido, o login da turma não alcança o `cap`, nem o schema `mysql` |
| `PMA_ARBITRARY: 0` | `compose.yml` | Impede usar o seu phpMyAdmin para atacar outros servidores MySQL |
| Túnel em *profile* | `compose.yml` | O túnel só sobe quando você pede explicitamente |

O que **você** precisa fazer:

- [ ] **Derrubar o túnel ao fim da aula.** É a proteção mais importante — a exposição dura só o tempo da aula.
- [ ] Não commitar o `.env` com o token e a senha reais num repositório público.
- [ ] Não usar essa instância para nada além da capacitação (é descartável: `docker compose down -v` zera tudo).
- [ ] Testar o túnel **um dia antes**, com 2 ou 3 pessoas, e não na hora da aula.

---

## Problemas comuns

### O phpMyAdmin abre mas o CSS/links estão quebrados

O phpMyAdmin não descobriu sozinho a URL pública. Corrija informando-a explicitamente
— note que é um processo de **duas etapas**, porque a URL só existe depois que o túnel sobe:

```bash
# 1. túnel no ar, pegue a URL
docker compose --profile tunnel up -d
docker compose logs ngrok | grep -oP 'url=\Khttps://\S+'

# 2. coloque a URL no .env (com a barra final!)
#    PMA_ABSOLUTE_URI=https://a1b2-c3d4.ngrok-free.app/

# 3. recrie SÓ o phpMyAdmin — o MySQL e o túnel continuam de pé
docker compose up -d --force-recreate phpmyadmin
```

> Deixe `PMA_ABSOLUTE_URI=` **vazio** para uso local. Vazio = autodetecção, que é o
> comportamento correto em `http://localhost:90`.

### "Access denied for user 'aluno'@'%' to database ..."

Isso é o comportamento **esperado** e faz parte da aula. O aluno tentou usar um banco
fora do padrão `liga_*` (o `cap`, ou um nome inventado). Peça para ele criar o dele:

```sql
CREATE DATABASE liga_seunome CHARACTER SET utf8mb4;
```

### Editei o `init/01_create_databases.sql` e nada mudou

Os scripts de `init/` rodam **uma única vez**, quando o volume está vazio. Para reaplicar:

```bash
docker compose down -v && docker compose up -d
```

### O túnel cai no meio da aula

Plano gratuito tem limites de banda e de requisições, e o phpMyAdmin carrega bastante
CSS/JS por página. Se cair, `docker compose restart ngrok` gera uma **URL nova** — que
você precisa repassar para a turma. Por isso: **teste com antecedência** e tenha o plano B abaixo.

---

## Plano B: Cloudflare Tunnel

Alternativa gratuita, **sem conta e sem página de aviso** — útil se o ngrok travar
na hora da aula:

```bash
# instale o cloudflared, depois:
cloudflared tunnel --url http://localhost:90
```

Ele imprime uma URL `https://<aleatorio>.trycloudflare.com` no terminal. Mesma lógica
de uso e as mesmas precauções de segurança acima.

---

## Plano C: sem túnel nenhum

Se a internet do local for ruim ou o túnel não colaborar, e todos estiverem **na mesma
rede (Wi-Fi da faculdade)**, sirva direto pelo IP da sua máquina:

```bash
ip addr show | grep 'inet '     # Linux — descubra seu IP, ex.: 192.168.0.42
```

A turma acessa `http://192.168.0.42:90`. Não depende de internet, só da rede local.
Pode esbarrar em isolamento de clientes ("AP isolation") na rede da instituição —
**teste antes**.
