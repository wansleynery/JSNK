# JSNK

> 💬 **Se sente meio esquecido por aí?** Desde a migração da plataforma oficial, o diálogo
> entre devs Sankhya ficou mais difícil. Comunidade (não oficial) no Discord:
> **<https://discord.gg/ke8DmDKdk7>** — bons códigos, amigo!

**Versão atual:** 85

---

Customização visual e funcional do Sankhya por **injeção de scripts**, sem tocar no
servidor.

Personalizar o Sankhya por script normalmente exige acesso ao servidor de aplicação
para injetar um `loader.js` em toda página e servir os arquivos de customização. O
JSNK dispensa isso: ele se instala como um **componente do próprio Sankhya** e
carrega os arquivos do **repositório de arquivos do Sankhya**. Funciona em qualquer
base, inclusive nas hospedadas pela Sankhya, onde você não tem o servidor.

São duas peças independentes:

1. **Componente de lógica** — um único arquivo, `jsnk.jsp`, entregue em
   `jsnk.zip`. Adicionado ao dashboard do usuário como **card**, carrega uma vez e
   passa a aplicar as customizações em todas as telas.
2. **Arquivos de customização** — ficam no repositório de arquivos do Sankhya, em
   `Repo://scripts/`, servidos pelo `download.mge`. São atualizados arquivo por
   arquivo pela própria UI do Sankhya, **sem redeploy do componente**.

## O que tem neste repositório

```
jsnk.zip     ← sobe como Componente BI (HTML5), entryPoint = jsnk.jsp
scripts/     ← sobe para Repo://scripts/, mantendo a árvore e os nomes
  global.css      tema: cor de destaque, modo escuro e estilos gerais
  global.js       comportamentos aplicados em toda tela
  mge/system.css  barra de tarefas e abas do shell
  mge/system.js   tema, logo, busca rápida e popup de configurações
temas/       ← galeria de temas prontos (opcional — ver "Temas customizados")
widgets/     ← galeria de widgets prontos (opcional — ver "Widgets")
bi/          ← exemplos de Componentes BI standalone, usados por alguns widgets
```

Os arquivos estão minificados, prontos para uso. Os nomes **não** levam `.min` de
propósito: o loader busca `mge/system.js`, então renomear quebra a resolução.

Esta versão traz a **customização geral da plataforma** — o que vale para o sistema
inteiro (tema, shell, comportamentos globais).

## Deploy

### 1. Componente de lógica (uma vez, e a cada nova versão)

1. No Sankhya, cadastre/atualize o **Componente BI (HTML5)** com o `jsnk.zip`,
   `entryPoint = jsnk.jsp`.
2. **Libere o acesso ao card** na tela **Acessos**, para os usuários ou grupos que
   devem receber a customização. Sem essa liberação o card não aparece para o
   usuário, e como é o card que instala o loader, nada é aplicado — é a causa mais
   comum de "instalei e não mudou nada". Liberar por **grupo** é o caminho prático:
   a customização passa a valer para quem entra no grupo, sem repetir o processo por
   usuário.
3. Adicione o componente como **card no dashboard/portal inicial** dos usuários.
   É o card que instala o loader — sem ele, nada é aplicado.
4. O componente não depende de `nuGdg` próprio: o mesmo zip funciona em qualquer
   base, sem editar nada.

O card não fica em branco. Ele mostra um painel estilo *neofetch* (logo ASCII +
`status`, `versao`, `uptime`, `tamanho` e `creditos`, mais a paleta da cor de
destaque), usa o accent escolhido pelo usuário e cabe em qualquer uma das nove
resoluções de card do Sankhya (190/390/590 × 174/265/448) sem rolagem. A linha
`creditos` leva dois links, para o autor e para este repositório — útil para quem
encontrar o card numa base e quiser saber o que é.

A linha `versao` mostra uma bolinha (cor de destaque = tudo certo, vermelha =
existe uma versão mais nova aqui no GitHub). Essa checagem roda no **navegador do
usuário** (bate num CDN público, fora da rede do Sankhya) — **se a máquina/rede
de quem está com o navegador aberto não tiver saída à internet liberada** (VPN
corporativa, firewall restritivo), ela simplesmente falha em silêncio: a bolinha
fica na cor de destaque (padrão "sem novidade"), sem erro no console e sem
atrasar ou travar nada, porque o resto do card e do loader não depende dela em
nada. Não há como saber que existe uma versão nova sem essa
saída à internet, mas também não há nenhum efeito colateral por não ter.

O card também tem um **switch de pausar/retomar**, na linha `status` — desliga
temporariamente toda a injeção (loader, scripts e CSS de tela) e recarrega a
janela para valer, sem precisar logar como `0 - SUP` toda vez que você quiser
comparar com a tela original. Religar reinstala tudo do zero.

Quando a bolinha da linha `versao` acende vermelha (existe uma versão mais
nova publicada), aparece ao lado um **botão de atualizar** (⇪): baixa o
`jsnk.zip` mais recente direto do GitHub e reinstala o componente para
**todos os usuários da base**, sem precisar abrir a tela nativa de
"Construtor de Gadgets" e subir o zip manualmente. Pede confirmação antes de
aplicar — a única ação do JSNK com um diálogo de confirmação do navegador,
justamente porque troca o componente inteiro de uma vez.

### 2. Arquivos de customização

Suba o conteúdo de `scripts/` para `Repo://scripts/`, preservando a estrutura de
pastas e os nomes:

```
scripts/global.css      →  Repo://scripts/global.css
scripts/mge/system.js   →  Repo://scripts/mge/system.js
```

O caminho de cada arquivo espelha o caminho da tela no Sankhya, e o loader aplica um
`global.css`/`global.js` por nível de pasta, em cascata. O `global.css` da raiz é o
único que alcança todos os módulos — é por isso que o tema (cor de destaque e modo
escuro) mora nele.

Atualizar um arquivo de customização **não** exige mexer no componente — é a
vantagem de separar as duas peças.

## Personalização pelo usuário

Cada usuário abre um popup de configurações pelo **botão mágico**, que aparece na
barra de tarefas assim que o loader instala (a menos que um admin o esconda — veja
"Políticas de administrador" abaixo). As mudanças são salvas por usuário
(`TSIPAR`) e valem em qualquer dispositivo/navegador em que ele entrar.

- **Aparência**: cor de destaque (accent), modo escuro, logo (original,
  compacta, substituída por imagem própria ou oculta) e estilo da pesquisa
  (padrão ou Spotlight, estilo macOS).
- **Barra de Abas**: botões nativos da barra de tarefas (menu, ajuda,
  notificações, Aplicações Sankhya) e estilo visual das abas (linear, quadro,
  clássico, neon).
- **Popup**: tema visual dos painéis laterais que os scripts de tela criam —
  `glassify` (vidro translucido + accent) ou `metal` (degradê metálico).
- **Temas**: tema customizado (CSS) da barra de tarefas — veja a seção
  seguinte.
- **Widgets**: habilita/desabilita a minibarra de widgets e escolhe o lado
  (esquerda ou direita) em que ela e os painéis abertos flutuam — veja
  "Widgets" mais abaixo.

## Temas customizados

Além do accent/modo escuro (que qualquer usuário ajusta pelo popup acima), o
card do JSNK aceita **arraste de um arquivo `.css`** para trocar a aparência da
barra de tarefas/abas por completo — cor, textura, o que o autor do tema quiser.
O arquivo sobe para `Repo://temas/<arquivo>.css`, fica disponível pra base
inteira, e passa a aparecer no combobox da seção "Temas" do popup — inclusive
para quem não fez o upload.

Este repositório inclui uma pequena **galeria de temas prontos** em `temas/`:
baixe qualquer um e arraste no card para instalar.

```
temas/tech.css        circuito + fonte tecnológica, textura embutida
temas/midnight.css    paleta escura, só cor
temas/carbon.css      fibra de carbono, imagem embutida
temas/rose.css        paleta rosa, só cor
temas/sea-glass.css   paleta verde-água, só cor
temas/halloween.css   tema sazonal
temas/natal.css       tema sazonal
```

Cada arquivo é autocontido — não dependem uns dos outros nem de nada fora do
próprio `.css`.

### Criando seu próprio tema

Qualquer `.css` funciona — arraste no card e pronto. O único contrato é
opcional: um tema pode declarar metadados num comentário, no formato
`$CHAVE: valor`, de preferência numa linha isolada no topo do arquivo (é o que
`temas/win11.css` faz). Hoje só existe uma chave reconhecida:

```css
/* $VERSAO_REQUERIDA: N */
```

`VERSAO_REQUERIDA` declara a versão mínima do componente que o tema precisa
pra funcionar por completo — útil quando o tema depende de um elemento que só
existe a partir de uma certa versão (o `win11.css` usa o relógio da barra de
tarefas, por exemplo; veja o cabeçalho do arquivo pro número real em vigor).
Sem essa linha, o tema não tem nenhuma exigência e funciona em qualquer
versão. Com ela:

- **Ao instalar** (arraste no card): se a base estiver numa versão mais
  antiga que a exigida, o upload é **bloqueado**, com aviso de qual versão o
  tema precisa.
- **Ao aplicar** (escolher o tema no popup, quando ele já está instalado):
  a checagem só **avisa**, sem bloquear — cobre o caso de um tema que já
  estava no repositório antes de existir uma base rodando uma versão velha o
  bastante pra ficar incompatível. O tema aplica normalmente; só a parte que
  depende do recurso novo é que fica quebrada até a base atualizar.

## Widgets

Uma minibarra (`#jsnk-minibar`) aparece logo abaixo da barra de tarefas, com
uma pílula para cada arquivo instalado em `Repo://widgets/`. Clicar numa
pílula abre um painel lateral com o conteúdo do widget — tabela, filtro
interativo, ou até uma tela de BI inteira embutida.

Assim como os temas, um arquivo `.jsnkw` sobe **arrastando no card** e fica
disponível pra base inteira, sem precisar de nenhum redeploy do componente.

Este repositório inclui uma pequena **galeria de widgets prontos** em
`widgets/`:

```
widgets/estoque.jsnkw                filtro (empresa/tipo/ativo) + tabela de estoque
widgets/contas-a-vencer.jsnkw        abre a tela de BI "Contas a Vencer" (dist/bi/) embutida no painel
widgets/detalhar_marcas.jsnkw        tabela com os registros selecionados na tela de Marcas
widgets/detalhar_financeiros.jsnkw   tabela com os registros selecionados na tela de Financeiro
```

No popup de configurações, a seção **Widgets** deixa **habilitar/desabilitar
a barra inteira** e escolher o lado de **flutuação** (esquerda ou direita) em
que a minibarra e os painéis abertos ficam ancorados.

### Segurança: um widget nunca roda como JavaScript de verdade

O arquivo `.jsnkw` é texto simples, numa sintaxe parecida com JavaScript
(arrow functions, `.then()`, template strings), mas quem executa é um
interpretador próprio, com um vocabulário fixo de comandos — nunca `eval`,
nunca acesso a um objeto/global real do navegador. Um widget só consegue
fazer o que os comandos abaixo permitem, nunca lógica livre.

Isso tem uma consequência prática: **nem toda sintaxe de JavaScript
funciona, mesmo parecendo válida.** Funcionam arrow functions de qualquer
número de parâmetros, `const`/`let`, `return`, template strings,
operadores aritméticos/comparação/lógicos, `? :` e `await` (tratado como
no-op). **Não funcionam** `if`/`for`/`while`, declaração de `function`/
`class`, desestruturação/spread e atribuição (`x = y`) — um widget usa
`.then()`/arrow/`? :` pra qualquer decisão condicional, em vez de `if`. Uma
construção não suportada não falha em silêncio: o painel mostra
"Widget com erro: ..." em vez do widget simplesmente não fazer nada.

### Criando seu próprio widget

Um comentário no topo do arquivo declara o título (e, opcionalmente,
descrição, largura, altura ou uma tela específica em que o widget funciona):

```js
/* $TITULO: Meu widget */
consultar (() => `SELECT ... `)
  .then (linhas => listar (linhas))
```

Comandos disponíveis: `consultar` (roda uma consulta `SELECT`), `filtrar`
(campos editáveis que alimentam a consulta), `listar` (desenha o resultado
como tabela), `dados` (lê os registros selecionados na tela atual, sem
consulta nova) e `tela` (embute uma tela de BI inteira via iframe). Veja os
arquivos da galeria acima para exemplos completos.

## Políticas de administrador

Um admin Sankhya pode restringir a personalização por **usuário** (`TSIUSU`)
e/ou **grupo** (`TSIGRU`), cadastrando campos `AD_JSNK_*` opcionais nessas
tabelas — a base pode não ter nenhum, alguns, ou todos. Quando o grupo define
um valor, ele prevalece sobre o do usuário; se a consulta falhar (rede,
permissão, campo não cadastrado), o JSNK assume "sem nenhuma restrição" —
**fail-open** deliberado, porque isto é uma feature de personalização, não uma
fronteira de segurança.

| Campo                      | Tipo  | Efeito                                                                            |
|----------------------------|-------|-----------------------------------------------------------------------------------|
| `AD_JSNK_ATIVO`            | S/N   | JSNK ativado para este usuário/grupo (kill-switch: reverte tudo ao padrão nativo) |
| `AD_JSNK_INIBEPOPUP`       | S/N   | Esconde o botão mágico inteiro (sem desativar o JSNK)                             |
| `AD_JSNK_INIBEVERCONFG`    | S/N   | Esconde a seção "Aparência"                                                       |
| `AD_JSNK_INIBEMUDARCOR`    | S/N   | Bloqueia trocar a cor de destaque                                                 |
| `AD_JSNK_ACCENTPADRAO`     | hex   | Cor de destaque forçada                                                           |
| `AD_JSNK_INIBEMUDARDARK`   | S/N   | Bloqueia alternar o modo escuro                                                   |
| `AD_JSNK_DARKPADINICIAL`   | S/N   | Modo escuro já ligado no primeiro acesso                                          |
| `AD_JSNK_INIBEMUDARABA`    | S/N   | Bloqueia trocar o estilo da aba                                                   |
| `AD_JSNK_INIBEVERLOGO`     | S/N   | Esconde o campo de logo                                                           |
| `AD_JSNK_INIBEMUDARLOGO`   | S/N   | Bloqueia customizar a logo                                                        |
| `AD_JSNK_INIBEVERBUSCA`    | S/N   | Esconde o campo de pesquisa                                                       |
| `AD_JSNK_INIBEMUDARBUSCA`  | S/N   | Bloqueia trocar o modo de busca                                                   |
| `AD_JSNK_INIBEVERBOTOES`   | S/N   | Esconde o bloco de botões nativos                                                 |
| `AD_JSNK_INIBEMUDARBOTOES` | S/N   | Bloqueia exibir/esconder os botões nativos                                        |
| `AD_JSNK_INIBEVERPOPUP`    | S/N   | Esconde a seção "Popup"                                                           |
| `AD_JSNK_INIBEMUDARPOPUP`  | S/N   | Bloqueia trocar o tema dos popups                                                 |
| `AD_JSNK_TEMAPADINICIAL`   | texto | Nome do tema custom aplicado por padrão no primeiro acesso                        |
| `AD_JSNK_INIBEVERTEMA`     | S/N   | Esconde a seção "Temas"                                                           |
| `AD_JSNK_INIBEINSTATEMA`   | S/N   | Bloqueia instalar tema novo (arraste no card)                                     |
| `AD_JSNK_INIBEMUDARTEMA`   | S/N   | Bloqueia trocar de tema já instalado                                              |
| `AD_JSNK_INIBEINSTAWIDGET` | S/N   | Bloqueia instalar widget novo (arraste no card)                                   |
| `AD_JSNK_INIBEDEBUG`       | S/N   | Bloqueia o console de debug                                                       |

## Cache

Toda URL do loader leva `&v=<VERSAO>`, e a `VERSAO` está dentro do componente. Ao
publicar uma nova versão dos arquivos, use o `jsnk.zip` correspondente: isso
invalida o cache do navegador de tudo de uma vez, sem pedir para o usuário limpar
cache.

## Requisitos e limitações

- **Sessão necessária**: o watcher só funciona com o usuário logado, porque é o
  card que o instala.
- **O usuário `0 - SUP` não recebe nenhuma customização.** Ele não aceita cards no
  dashboard, e o card é justamente o que instala o loader — então numa sessão logada
  como SUP nada é injetado. Isso não tem contorno pelo lado do JSNK, mas é útil na
  prática: o SUP passa a ser a forma garantida de ver a tela **original**, sem
  customização alguma, quando você precisa isolar se um problema é do Sankhya ou da
  customização.
- **Momento da aplicação**: a injeção ocorre até ~500ms depois de a tela aparecer,
  e não durante o carregamento dela.
- **Same-origin**: a injeção atravessa iframes, então só alcança frames de mesma
  origem. Frames de outros cards BI (`html5component.mge`) são pulados de
  propósito.
- Telas antigas (Angular) e as novas (React sobre web components `snk-*`/`ez-*`)
  são ambas suportadas.

## Bugs conhecidos

- **Notificação abre com o conteúdo vazio**: com o JSNK ativo, clicar numa
  notificação da barra de tarefas pra ver o detalhe abre o popup nativo sem
  conteúdo — acontece com qualquer notificação, não é de um tipo específico.
  Causa ainda não identificada. Contorno enquanto não há correção: pausar o
  JSNK pelo switch do próprio card antes de abrir a notificação, ou conferir
  numa sessão `0 - SUP` (não recebe nenhuma injeção — ver "Requisitos e
  limitações" acima).

## Roadmap

Ideias e melhorias já mapeadas, sem data — ficam aqui pra quem quiser
acompanhar (ou contribuir) por onde o projeto tende a andar:

- **Campo de busca/autocomplete nos filtros de widget**: hoje `filtrar`
  aceita número, texto, booleano, data e uma lista fixa de opções
  (`opcoes`), mas não o tipo de campo mais comum nas telas do próprio
  Sankhya — busca por entidade (ex.: digitar e escolher um Parceiro ou
  Produto pelo nome, não pelo código). Sem ele, filtrar um widget por uma
  entidade exige que o usuário já saiba o código de cor. A ideia é levar
  esse mesmo tipo de campo (o que já existe pra tela clássica) pro
  vocabulário de `filtrar`.
- **Atualização do componente levando `global`/`mge/system` junto**: o
  botão de atualizar (⇪) e o drag-and-drop de `.zip` no card hoje só trocam
  o `jsnk.zip` — os quatro scripts publicados
  (`global.css`/`global.js`/`mge/system.css`/`mge/system.js`) continuam
  exigindo upload manual em `Repo://scripts/` toda vez que mudam junto com
  uma versão nova do componente. Sem isso, é fácil uma base ficar com o
  componente atualizado mas os scripts antigos (ou vice-versa), rodando uma
  combinação que nunca foi testada junta. A ideia é a mesma ação de
  atualizar já cobrir os quatro arquivos, não só o zip.
- **Popup de notificação próprio no tema win11**: o bug conhecido acima
  (notificação abre vazia) ainda não tem causa identificada — ele é do
  JSNK como um todo, não do tema. Enquanto a causa raiz não aparece, a
  ideia é reconstruir esse popup especificamente dentro do `win11.css`
  (que já reestiliza boa parte da shell) em vez de continuar dependendo do
  popup nativo do Sankhya, contornando o bug ali sem esperar a correção
  definitiva.
- **Mais robustez na implementação dos widgets**: cobrir casos de borda
  ainda não tratados no interpretador/execução das receitas (`Widget`) —
  falhas de rede a meio de uma consulta, um `.jsnkw` editado pra um formato
  inesperado, esse tipo de coisa — pra que o painel sempre mostre um erro
  claro em vez de travar ou ficar num estado inconsistente.
- **Melhorias gerais**: ajustes contínuos de usabilidade e performance pela
  base do projeto, sem uma feature específica associada ainda.

## Agradecimentos
Um agradecimento especial a [Maycon Gehlen](https://www.linkedin.com/in/maycon-gehlen) com o processo
de injeção via NGINX e tema escuro.
Um agradecimento também a todos da comunidade em geral que ajudaram em vários pontos que tornaram
essa funcionalidade possível.

## Licença e crédito

Autoria: **Wansley Nery Soto** — [LinkedIn](https://www.linkedin.com/in/wansleynery/).

Em uma frase: **use e implante à vontade, adapte para a sua base, mas não
redistribua.**

- **Livre e gratuito**: usar e implantar em quantas bases quiser, inclusive em bases
  de clientes e para fins comerciais.
- **Pode editar** os arquivos para adequar a customização à sua base, preservando os
  avisos de autoria.
- **Não pode**, sem autorização por escrito: redistribuir (nem editado, nem embutido
  em outro produto), remover os avisos de autoria, ou vender.

Não é uma licença open source: o código-fonte não é distribuído nem licenciado — este
repositório contém apenas os artefatos de build prontos para deploy.

Precisa de algo que a licença não cobre (redistribuir, embutir em outro produto, uma
parceria)? Abra uma issue.

### Termos completos

> **JSNK — Licença de Uso**
>
> Copyright (c) 2026 Wansley Nery Soto. Todos os direitos reservados.
>
> Este repositório distribui apenas **artefatos de build** (arquivos compilados e
> minificados). O código-fonte não é distribuído nem licenciado.
>
> **1. Permitido**, gratuitamente e sem necessidade de aviso prévio
>
> a) usar e implantar estes artefatos em qualquer número de bases, ambientes e
> usuários, inclusive para fins comerciais e em bases de clientes;
> b) copiar os arquivos na medida necessária para essa implantação, incluindo backup;
> c) **editar e adaptar** os arquivos para adequar a customização à base onde eles
> serão usados, desde que os avisos de autoria e de copyright sejam preservados. Esta
> permissão é para uso próprio: o arquivo editado continua sujeito à cláusula 2.
>
> **2. Não permitido**, sem autorização prévia e por escrito do titular
>
> a) redistribuir estes artefatos, editados ou não, integral ou parcialmente, por
> qualquer meio ou canal, inclusive embutidos em outro produto, componente, pacote ou
> oferta de serviço;
> b) descompilar, desofuscar ou reconstruir o código-fonte a partir dos artefatos;
> c) remover, alterar ou ocultar os avisos de autoria e de copyright presentes nos
> arquivos, no componente ou na interface exibida ao usuário;
> d) sublicenciar, vender, alugar ou oferecer os artefatos como serviço.
>
> **3. Autoria**
>
> A autoria e a titularidade permanecem integralmente com Wansley Nery Soto. Nenhuma
> permissão acima transfere direito autoral, marca ou qualquer outro direito de
> propriedade intelectual. As adaptações feitas sob a cláusula 1.c não geram
> titularidade sobre os artefatos originais.
>
> **4. Ausência de garantia**
>
> OS ARTEFATOS SÃO FORNECIDOS "COMO ESTÃO", SEM GARANTIA DE QUALQUER NATUREZA,
> EXPRESSA OU IMPLÍCITA, INCLUINDO MAS NÃO SE LIMITANDO A GARANTIAS DE ADEQUAÇÃO A UM
> PROPÓSITO ESPECÍFICO E DE NÃO VIOLAÇÃO. EM NENHUMA HIPÓTESE O TITULAR RESPONDERÁ POR
> QUALQUER RECLAMAÇÃO, DANO OU OUTRA RESPONSABILIDADE DECORRENTE DO USO OU DA
> IMPOSSIBILIDADE DE USO DOS ARTEFATOS.
>
> A implantação ocorre em ambiente de terceiros (base Sankhya do usuário), sob
> responsabilidade exclusiva de quem implanta, inclusive quanto a testes, homologação e
> backup prévios. Arquivos editados sob a cláusula 1.c são de responsabilidade
> exclusiva de quem os editou.
>
> **5. Rescisão**
>
> O descumprimento de qualquer item da cláusula 2 encerra automaticamente, e de
> imediato, as permissões concedidas na cláusula 1.
>
> **6. Contato**
>
> Autorizações, exceções e parcerias: abra uma issue neste repositório.
