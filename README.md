<p align="center">
  <img src="https://github.com/user-attachments/assets/02c568a9-e571-489b-9f72-963a4db4e0fc" alt="JSNK — personalização para o Sankhya" width="320">
</p>

<h1 align="center">JSNK</h1>
<p align="center"><strong>Seu Sankhya, do seu jeito.</strong><br>Personalização visual e funcional com JavaScript e CSS, sem acessar o servidor.</p>

<p align="center">
  <a href="#instalação">Instalação</a> ·
  <a href="https://youtu.be/LCmRlpRc9nA">Assistir ao tutorial</a> ·
  <a href="temas/">Temas</a> ·
  <a href="widgets/">Widgets</a> ·
  <a href="https://discord.gg/ke8DmDKdk7">Comunidade</a>
</p>

**Versão atual:** 87

O JSNK se instala como um componente BI do próprio Sankhya e carrega as customizações pelo repositório de arquivos da base. Também pode ser usado em bases hospedadas pela Sankhya, sem configuração de NGINX ou acesso ao servidor de aplicação.

| Recurso | O que você pode fazer |
| --- | --- |
| Aparência | Ajustar cores, modo escuro, logo, abas e pesquisa. |
| Temas | Instalar arquivos CSS arrastando para o card. |
| Widgets | Abrir tabelas, filtros e telas de BI em painéis laterais. |
| Preferências | Salvar configurações por usuário, entre dispositivos. |
| Administração | Definir políticas de personalização por usuário ou grupo. |

## Instalação

### Assista ao passo a passo

<p align="center">
  <a href="https://youtu.be/LCmRlpRc9nA">
    <img src="https://img.youtube.com/vi/LCmRlpRc9nA/hqdefault.jpg" alt="Assistir ao vídeo: instalação do JSNK no Sankhya, passo a passo" width="640">
  </a>
</p>

**▶ [Assistir à instalação no YouTube](https://youtu.be/LCmRlpRc9nA)**

### 1. Prepare os arquivos

Baixe o repositório em **Code → Download ZIP** e extraia os arquivos. Para a instalação básica, você precisa de `jsnk.zip` e da pasta `scripts/`. As pastas `temas/`, `widgets/` e `bi/` são opcionais.

### 2. Cadastre o componente BI

No Sankhya, cadastre ou atualize um **Componente BI (HTML5)** com o arquivo `jsnk.zip` e defina o **entryPoint** como `jsnk.jsp`. O pacote não depende de um `nuGdg` fixo: não é necessário editar esse identificador para cada base.

### 3. Libere o acesso e adicione o card

Na tela **Acessos**, libere o componente para os usuários ou grupos que vão utilizar o JSNK. Depois, adicione o card ao **dashboard/portal inicial** desses usuários. A liberação por grupo facilita a manutenção dos acessos.

> [!IMPORTANT]
> O card instala o loader. Sem acesso liberado e sem o card no dashboard, as customizações não são carregadas. O usuário **`0 - SUP` não recebe customizações**, pois não aceita cards no dashboard.

### 4. Envie os scripts

No repositório de arquivos do Sankhya, envie o conteúdo de `scripts/` para `Repo://scripts/`, preservando **todos os nomes e subpastas**:

```text
scripts/global.css      → Repo://scripts/global.css
scripts/global.js       → Repo://scripts/global.js
scripts/mge/system.css  → Repo://scripts/mge/system.css
scripts/mge/system.js   → Repo://scripts/mge/system.js
```

Os arquivos já estão minificados. Não acrescente `.min` nem renomeie os arquivos: o loader depende desses caminhos.

### 5. Confira a instalação

- Entre com um usuário autorizado, diferente de `0 - SUP`.
- Abra o dashboard e confira se o card do JSNK aparece com o status ativo.
- Abra o **botão mágico** na barra de tarefas para ajustar a aparência, caso ele não esteja oculto por uma política de administrador.

## O card do JSNK

O painel exibe logo ASCII, status, versão, tempo de atividade, tamanho e créditos. Ele acompanha a cor de destaque escolhida pelo usuário e se adapta aos tamanhos de card do Sankhya.

| Controle | Comportamento |
| --- | --- |
| **Pausar/retomar** | O switch em `status` pausa a injeção e recarrega a janela. Ao religar, reinstala as customizações. Útil para comparar com a interface original. |
| **Indicador de versão** | Vermelho indica uma versão mais nova no GitHub. A consulta depende da internet do navegador; sem conexão, mantém a cor padrão e o JSNK continua funcionando. |
| **Atualizar (⇪)** | Quando disponível, baixa o `jsnk.zip` **e os quatro arquivos de `scripts/`** mais recentes do GitHub e reinstala tudo para **todos os usuários da base**, após confirmação — nunca uma combinação de versões diferentes entre componente e scripts. |

## Atualização e cache

> [!WARNING]
> Arrastar um `.zip` local para o card atualiza **somente o componente** — os quatro arquivos de `scripts/` continuam exigindo envio manual (ou arraste deles também) para `Repo://scripts/`. Só o botão **Atualizar (⇪)** cobre os dois juntos, porque ele busca ambos do mesmo commit no GitHub.

Os arquivos de customização podem ser substituídos individualmente, sem reinstalar o componente a cada edição. Nas atualizações de versão, use o `jsnk.zip` correspondente: o loader inclui `&v=<VERSAO>` nas URLs para invalidar o cache.

<details>
<summary><strong>Como o carregamento funciona e o que há no repositório</strong></summary>

O componente `jsnk.jsp`, dentro de `jsnk.zip`, instala o loader na sessão do usuário. Os arquivos de customização são servidos pelo `download.mge`. O caminho de cada arquivo acompanha o caminho da tela; arquivos `global.css` e `global.js` são aplicados por nível de pasta, em cascata. O `global.css` da raiz alcança todos os módulos.

### Estrutura dos arquivos

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

</details>

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

<details>
<summary><strong>Criando seu próprio tema</strong></summary>


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

</details>

## Widgets

<p align="center">
  <a href="https://github.com/user-attachments/assets/477b26af-4747-4c77-9945-72669c3dc0cd">
    <img src="https://github.com/user-attachments/assets/477b26af-4747-4c77-9945-72669c3dc0cd" alt="Demonstração dos widgets Estoque Atual e Contas a Vencer no Sankhya personalizado com JSNK" width="1000">
  </a>
</p>
<p align="center"><em>Estoque Atual e Contas a Vencer no mesmo ambiente personalizado com JSNK. Imagem demonstrativa com dados ilustrativos; clique para ampliar.</em></p>

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

<details>
<summary><strong>Desenvolvimento de widgets: comandos e sintaxe suportada</strong></summary>

### Interpretador de widgets

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

</details>

## Políticas de administrador

<details>
<summary><strong>Consultar regras e campos de configuração</strong></summary>


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

</details>

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

Melhorias planejadas, sem previsão de entrega:

- Busca e autocomplete por entidade nos filtros de widgets.
- Alternativa ao popup nativo de notificações no tema Win11.
- Tratamento mais robusto de erros e casos de borda nos widgets.
- Melhorias contínuas de usabilidade e desempenho.

## Comunidade

Troque experiências com outros desenvolvedores Sankhya na [comunidade não oficial no Discord](https://discord.gg/ke8DmDKdk7). Para relatar problemas ou sugerir melhorias no JSNK, [abra uma issue](https://github.com/wansleynery/JSNK/issues).

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
