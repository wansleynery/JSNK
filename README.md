# JSNK

> 💬 **Se sente meio esquecido por aí?** Desde a migração da plataforma oficial, o diálogo
> entre devs Sankhya ficou mais difícil. Comunidade (não oficial) no Discord:
> **<https://discord.gg/ke8DmDKdk7>** — bons códigos, amigo!

**Versão atual:** 44

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
`status`, `uptime`, `versao`, `tamanho` e `creditos`, mais a paleta da cor de
destaque), usa o accent escolhido pelo usuário e cabe em qualquer uma das nove
resoluções de card do Sankhya (190/390/590 × 174/265/448) sem rolagem. A linha
`creditos` leva dois links, para o autor e para este repositório — útil para quem
encontrar o card numa base e quiser saber o que é.

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

## Políticas de administrador

Um admin Sankhya pode restringir a personalização por **usuário** (`TSIUSU`)
e/ou **grupo** (`TSIGRU`), cadastrando campos `AD_JSNK_*` opcionais nessas
tabelas — a base pode não ter nenhum, alguns, ou todos. Quando o grupo define
um valor, ele prevalece sobre o do usuário; se a consulta falhar (rede,
permissão, campo não cadastrado), o JSNK assume "sem nenhuma restrição" —
**fail-open** deliberado, porque isto é uma feature de personalização, não uma
fronteira de segurança.

| Campo | Tipo | Efeito |
| --- | --- | --- |
| `AD_JSNK_ATIVO` | S/N | JSNK ativado para este usuário/grupo (kill-switch: reverte tudo ao padrão nativo) |
| `AD_JSNK_INIBEPOPUP` | S/N | Esconde o botão mágico inteiro (sem desativar o JSNK) |
| `AD_JSNK_INIBEVERCONFG` | S/N | Esconde a seção "Aparência" |
| `AD_JSNK_INIBEMUDARCOR` | S/N | Bloqueia trocar a cor de destaque |
| `AD_JSNK_ACCENTPADRAO` | hex | Cor de destaque forçada |
| `AD_JSNK_INIBEMUDARDARK` | S/N | Bloqueia alternar o modo escuro |
| `AD_JSNK_DARKPADINICIAL` | S/N | Modo escuro já ligado no primeiro acesso |
| `AD_JSNK_INIBEMUDARABA` | S/N | Bloqueia trocar o estilo da aba |
| `AD_JSNK_INIBEVERLOGO` | S/N | Esconde o campo de logo |
| `AD_JSNK_INIBEMUDARLOGO` | S/N | Bloqueia customizar a logo |
| `AD_JSNK_INIBEVERBUSCA` | S/N | Esconde o campo de pesquisa |
| `AD_JSNK_INIBEMUDARBUSCA` | S/N | Bloqueia trocar o modo de busca |
| `AD_JSNK_INIBEVERBOTOES` | S/N | Esconde o bloco de botões nativos |
| `AD_JSNK_INIBEMUDARBOTOES` | S/N | Bloqueia exibir/esconder os botões nativos |
| `AD_JSNK_INIBEVERPOPUP` | S/N | Esconde a seção "Popup" |
| `AD_JSNK_INIBEMUDARPOPUP` | S/N | Bloqueia trocar o tema dos popups |
| `AD_JSNK_TEMAPADINICIAL` | texto | Nome do tema custom aplicado por padrão no primeiro acesso |
| `AD_JSNK_INIBEVERTEMA` | S/N | Esconde a seção "Temas" |
| `AD_JSNK_INIBEINSTATEMA` | S/N | Bloqueia instalar tema novo (arraste no card) |
| `AD_JSNK_INIBEMUDARTEMA` | S/N | Bloqueia trocar de tema já instalado |
| `AD_JSNK_INIBEDEBUG` | S/N | Bloqueia o console de debug |

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
