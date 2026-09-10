# Contas a Vencer — exemplo de Componente BI HTML5

Painel simples de fluxo de caixa de curto prazo: lista as contas a pagar e a
receber em aberto nos próximos N dias (3/15/30, selecionável), com total por
tipo e destaque pra quem já está atrasado. Um único arquivo, sem build.

Serve como exemplo mínimo de **Componente BI HTML5 com JSP como `entryPoint`**
(o jeito "padrão" de montar um componente desses no Sankhya — diferente do
truque específico que `jsnk.jsp` usa, de ser só uma `<script>` solta) e,
separadamente, como a tela que `dist/widgets/contas-a-vencer.jsnkw` abre
dentro do seu próprio painel — via o comando `tela (nuGdg, parametros)` do
interpretador de widgets (`Widget.PRIMITIVAS`, ver `.claude/rules/jsnk-api.md`),
que embute qualquer Componente BI num `<iframe>` dentro da minibarra
(`Repo://widgets/`). Depois de instalar este componente (passo a passo
abaixo), anote o `nuGdg` que o Sankhya atribuiu a ele e edite-o direto no
`.jsnkw` — é um número por base, então quem reaproveitar o widget noutra
base troca esse valor antes de subir o arquivo (ver o comentário do próprio
`contas-a-vencer.jsnkw`).

## Deploy

1. Não precisa buildar nada — o arquivo já é o entregável.
2. **Zipe `index.jsp`** (só ele, sem a pasta em volta nem este `README.md`) —
   o Sankhya só aceita `.zip` pra Componente BI, mesmo quando é um arquivo
   único (diferente de `Repo://temas/`/`Repo://widgets/`, que aceitam o
   arquivo solto por drag-and-drop).
3. No Sankhya, cadastre um novo **Componente BI (HTML5)**, subindo esse zip.
4. `entryPoint = index.jsp` — pode dar qualquer nome ao arquivo se quiser
   (o comando `tela` do widget descobre sozinho o `entryPoint` certo, direto
   do cadastro do componente em `TSIGDG`, ver `Widget._resolverEntryPoint`
   em `src/jsnk.js`); `index.jsp` aqui é só a convenção deste projeto, não
   uma exigência do mecanismo.
5. Adicione como card no dashboard, ou abra como tela avulsa — funciona nos
   dois formatos, e sozinho em qualquer base (não depende do JSNK estar
   instalado).

## Como funciona

Consulta `TGFFIN` (título financeiro) via `ExecQuerySP.execQuery`
(`/mge/service.sbr`), o mesmo endpoint que `jsnk.jsp` já usa internamente —
reimplementado aqui do zero porque este componente é autocontido e não pode
contar com nada do JSNK estar carregado. `RECDESP` distingue pagar (`P`) de
receber (`R`); `DHBAIXA IS NULL` filtra só o que ainda está em aberto; a data
já vem formatada em `DD/MM/YYYY` pelo próprio SQL.

**Aceita `?CODEMP=<código>` na própria URL** — filtra `TGFFIN.CODEMP`; ausente
ou `0` mostra todas as empresas. É o parâmetro que
`dist/widgets/contas-a-vencer.jsnkw` repassa através do 2º argumento de
`tela (nuGdg, { CODEMP: ... })` — o mecanismo genérico de injetar contexto de
fora pra dentro de um Componente BI aberto por um widget, lido aqui com
`URLSearchParams` puro, sem nada específico do JSNK.

Sem dependências externas, sem tema do JSNK (`--jsnk-*`) — CSS próprio, com
suporte a `prefers-color-scheme: dark` embutido.
