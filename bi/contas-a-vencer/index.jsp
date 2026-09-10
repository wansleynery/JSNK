<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<%--
    Contas a Vencer — exemplo de Componente BI HTML5 (JSP como entryPoint).

    Painel compacto com as contas a pagar/receber em aberto nos próximos N
    dias (fluxo de caixa de curto prazo) — uma das customizações mais pedidas
    por clientes Sankhya, e que cabe bem num espaço pequeno (card de
    dashboard, ou uma tela dentro de um widget multitelas).

    Arquivo único, sem build: sobe direto como Componente BI (HTML5),
    entryPoint = index.jsp. Nenhuma dependência do JSNK — funciona sozinho em
    qualquer base, com ou sem o loader instalado. Ver README.md desta pasta.

    A diretiva `page` acima é necessária além do `<meta charset>` — sem ela o
    Sankhya serve o JSP com o charset default do servidor (geralmente
    ISO-8859-1), que na resposta HTTP vence o `<meta charset>` da própria
    página (o header sempre tem prioridade sobre a meta tag), corrompendo
    acentos.

    O emoji do título, porém, continuou corrompido MESMO com a diretiva
    acima — sinal de que não é (só) charset de resposta HTTP: acento comum
    (BMP, 2 bytes em UTF-8) sobrevive a praticamente qualquer charset de
    single-byte/legado, mas um emoji como 💰 (U+1F4B0, plano suplementar, 4
    bytes em UTF-8) é exatamente o tipo de caractere que se corrompe quando
    o Oracle por trás do Sankhya guarda o arquivo numa coluna com o charset
    de banco `UTF8` (o alias antigo da Oracle — só 3 bytes por caractere,
    não cobre plano suplementar nenhum) em vez de `AL32UTF8` (UTF-8
    completo, 4 bytes) — um problema de ARMAZENAMENTO, não de resposta
    HTTP, que a diretiva `page` não alcança. Contornado usando a referência
    numérica HTML `&#128176;` em vez do caractere bruto no `<h1>` abaixo:
    são só dígitos ASCII, sobrevivem a QUALQUER charset (single-byte
    legado, UTF8 de 3 bytes, o que for) porque o próprio NAVEGADOR decodifica
    o código Unicode no fim, não depende de byte nenhum ter sobrevivido ao
    caminho arquivo → banco → resposta HTTP intactos.
--%>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Contas a Vencer</title>
<style>
    :root {
        --cor-fundo: #f4f6f8;
        --cor-cartao: #ffffff;
        --cor-texto: #26313d;
        --cor-texto-fraco: #6b7885;
        --cor-borda: #e2e6ea;
        --cor-pagar: #d0433f;
        --cor-receber: #2f9e5c;
        --cor-atrasado: #b3261e;
        --cor-accent: #2980b9;
    }
    @media (prefers-color-scheme: dark) {
        :root {
            --cor-fundo: #1b1f23;
            --cor-cartao: #24292d;
            --cor-texto: #e7ebee;
            --cor-texto-fraco: #9aa5ae;
            --cor-borda: #343b41;
            --cor-pagar: #ef6b64;
            --cor-receber: #4bc27f;
            --cor-atrasado: #ff8a80;
            --cor-accent: #5aa9d6;
        }
    }
    * { box-sizing: border-box; }
    /* `html` E `body` transparentes, de propósito — quando aberto de dentro
       de um widget (via `tela`, ver dist/widgets/contas-a-vencer.jsnkw),
       isto deixa o fundo do PRÓPRIO painel do widget aparecer por trás em
       vez de uma caixa opaca "flutuando" por cima; aberto direto como
       card/tela avulsa, mostra o fundo branco padrão do dashboard por trás,
       que já é próximo de `--cor-fundo` mesmo. Os dois elementos, não só
       `body`: se `html` tivesse um fundo próprio (não tem, por padrão, mas
       é barato deixar explícito), ele venceria a propagação de fundo pro
       canvas do documento em vez de `body`. `--cor-fundo` continua
       existindo só pro `.tipo-tag` (mais abaixo) — não é mais usada pela
       página inteira. */
    html, body { width: 100%; background: transparent; }
    body {
        margin: 0;
        font-family: 'Segoe UI', Tahoma, Arial, sans-serif;
        color: var(--cor-texto);
        font-size: 13px;
    }
    #painel { padding: 12px; }
    header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 8px;
        flex-wrap: wrap;
        margin-bottom: 10px;
    }
    h1 { font-size: 15px; margin: 0; font-weight: 600; }
    select, button {
        font: inherit;
        border: 1px solid var(--cor-borda);
        background: var(--cor-cartao);
        color: var(--cor-texto);
        border-radius: 6px;
        padding: 4px 8px;
        cursor: pointer;
    }
    #resumo { display: flex; gap: 8px; margin-bottom: 10px; flex-wrap: wrap; }
    .badge {
        flex: 1;
        min-width: 120px;
        background: var(--cor-cartao);
        border: 1px solid var(--cor-borda);
        border-radius: 8px;
        padding: 8px 10px;
    }
    .badge .rotulo { color: var(--cor-texto-fraco); font-size: 11px; text-transform: uppercase; letter-spacing: .03em; }
    .badge .valor { font-size: 16px; font-weight: 700; margin-top: 2px; }
    .badge.pagar .valor { color: var(--cor-pagar); }
    .badge.receber .valor { color: var(--cor-receber); }
    #lista { display: flex; flex-direction: column; gap: 6px; }
    .linha {
        display: flex;
        align-items: center;
        gap: 10px;
        background: var(--cor-cartao);
        border: 1px solid var(--cor-borda);
        border-left: 4px solid var(--cor-accent);
        border-radius: 8px;
        padding: 8px 10px;
    }
    .linha.pagar { border-left-color: var(--cor-pagar); }
    .linha.receber { border-left-color: var(--cor-receber); }
    .linha .data { width: 62px; font-weight: 600; }
    .linha.atrasado .data { color: var(--cor-atrasado); }
    .linha .parceiro { flex: 1; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    .linha .tipo-tag { font-size: 10px; padding: 2px 6px; border-radius: 999px; background: var(--cor-fundo); color: var(--cor-texto-fraco); }
    .linha .valor { font-weight: 600; white-space: nowrap; }
    .linha.pagar .valor { color: var(--cor-pagar); }
    .linha.receber .valor { color: var(--cor-receber); }
    #estado { padding: 24px 8px; text-align: center; color: var(--cor-texto-fraco); }
    footer { margin-top: 12px; text-align: center; font-size: 11px; color: var(--cor-texto-fraco); }
    footer a { color: var(--cor-accent); }
</style>
</head>
<body>
<div id="painel">
    <header>
        <h1>&#128176; Contas a Vencer</h1>
        <div>
            <select id="filtroDias">
                <option value="3">3 dias</option>
                <option value="7" selected>7 dias</option>
                <option value="15">15 dias</option>
                <option value="30">30 dias</option>
            </select>
            <button id="btnAtualizar" title="Atualizar">&#8635;</button>
        </div>
    </header>

    <div id="resumo">
        <div class="badge pagar">
            <div class="rotulo">A pagar</div>
            <div class="valor" id="totalPagar">R$ 0,00</div>
        </div>
        <div class="badge receber">
            <div class="rotulo">A receber</div>
            <div class="valor" id="totalReceber">R$ 0,00</div>
        </div>
    </div>

    <div id="lista"></div>
    <div id="estado" hidden></div>

    <footer>
        Exemplo de Componente BI HTML5 (JSP) &mdash;
        <a href="https://github.com/wansleynery/JSNK" target="_blank" rel="noopener noreferrer">JSNK</a>
    </footer>
</div>

<script>
(function () {
    'use strict';

    var elLista         = document.getElementById('lista');
    var elEstado         = document.getElementById('estado');
    var elTotalPagar     = document.getElementById('totalPagar');
    var elTotalReceber   = document.getElementById('totalReceber');
    var elFiltro         = document.getElementById('filtroDias');
    var elBtn            = document.getElementById('btnAtualizar');

    var moeda = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' });

    // CODEMP opcional na query string (?CODEMP=1) — é assim que quem abre esta
    // tela de fora (ex.: o widget `tela (nuGdg, { CODEMP: ... })` da minibarra,
    // ver dist/widgets/contas-a-vencer.jsnkw) passa contexto pra dentro do
    // Componente BI sem precisar de nada além de uma URL. 0/ausente = todas as
    // empresas — nunca faltando o parâmetro por acidente.
    var codemp = parseInt(new URLSearchParams(location.search).get('CODEMP'), 10) || 0;

    // Mesmo endpoint/formato de resposta usado em jsnk.jsp (ExecQuerySP.execQuery
    // via service.sbr) — reimplementado aqui porque este componente é
    // autocontido, sem depender do jsnk estar instalado na base.
    function consultar(sql) {
        return window.fetch(
            location.origin + '/mge/service.sbr?serviceName=ExecQuerySP.execQuery&outputType=json',
            {
                method: 'POST',
                credentials: 'include',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    serviceName: 'ExecQuerySP.execQuery',
                    requestBody: { querydata: { query: sql.replace(/\n/g, ' ') } }
                })
            }
        )
            .then(function (resposta) { return resposta.json(); })
            .then(function (dados) {
                var corpo = (dados && dados.responseBody) || dados;
                var paraArray = function (v) { return Array.isArray(v) ? v : (v ? [v] : []); };
                var linhas = paraArray(corpo && corpo.entity && corpo.entity.line);
                return linhas.map(function (linha) {
                    var colunas = paraArray(linha && linha.column);
                    var obj = {};
                    colunas.forEach(function (c) { obj[c.name] = (c.value === undefined ? null : c.value); });
                    return obj;
                });
            });
    }

    // TGFFIN = título financeiro (RECDESP: 'P' a pagar, 'R' a receber;
    // DHBAIXA nula = ainda em aberto). Data já formatada em pt-BR no
    // próprio SQL (TO_CHAR), pra não depender de parsing de data no JS.
    function montarQuery(dias) {
        return (
            'SELECT F.NUFIN AS NUFIN, ' +
            '       TO_CHAR (F.DTVENC, \'DD/MM/YYYY\') AS VENCIMENTO, ' +
            '       CASE WHEN F.DTVENC < TRUNC (SYSDATE) THEN \'S\' ELSE \'N\' END AS ATRASADO, ' +
            '       1234 AS VALOR, ' +
            '       F.RECDESP AS TIPO, ' +
            '       P.CODPARC || \'. \' || SUBSTR (P.NOMEPARC, 0, 1) || \'*****\' AS PARCEIRO ' +
            '  FROM TGFFIN F ' +
            ' INNER JOIN TGFPAR P ON P.CODPARC = F.CODPARC ' +
            ' WHERE F.DHBAIXA IS NULL ' +
            '   AND F.DTVENC <= TRUNC (SYSDATE) + ' + dias +
            '   AND (' + codemp + ' = 0 OR F.CODEMP = ' + codemp + ') ' +
            ' ORDER BY F.DTVENC ASC'
        );
    }

    function numero(valor) {
        return parseFloat(String(valor == null ? 0 : valor).replace(',', '.')) || 0;
    }

    function renderizar(linhas) {
        elLista.innerHTML = '';

        if (!linhas.length) {
            elEstado.hidden = false;
            elEstado.textContent = 'Nenhuma conta em aberto no período.';
            elTotalPagar.textContent = moeda.format(0);
            elTotalReceber.textContent = moeda.format(0);
            return;
        }
        elEstado.hidden = true;

        var totalPagar = 0, totalReceber = 0;

        linhas.forEach(function (linha) {
            var ehPagar  = linha.TIPO === 'P';
            var valor    = numero(linha.VALOR);
            var atrasado = linha.ATRASADO === 'S';

            if (ehPagar) { totalPagar += valor; } else { totalReceber += valor; }

            var div = document.createElement('div');
            div.className = 'linha ' + (ehPagar ? 'pagar' : 'receber') + (atrasado ? ' atrasado' : '');
            div.innerHTML =
                '<span class="data">' + (linha.VENCIMENTO || '-') + '</span>' +
                '<span class="parceiro" title="' + (linha.PARCEIRO || '') + '">' + (linha.PARCEIRO || 'Sem parceiro') + '</span>' +
                '<span class="tipo-tag">' + (atrasado ? 'atrasado' : (ehPagar ? 'pagar' : 'receber')) + '</span>' +
                '<span class="valor">' + moeda.format(valor) + '</span>';
            elLista.appendChild(div);
        });

        elTotalPagar.textContent = moeda.format(totalPagar);
        elTotalReceber.textContent = moeda.format(totalReceber);
    }

    function carregar() {
        elEstado.hidden = false;
        elEstado.textContent = 'Carregando...';
        elLista.innerHTML = '';

        var dias = parseInt(elFiltro.value, 10) || 7;

        consultar(montarQuery(dias))
            .then(renderizar)
            .catch(function (erro) {
                console.error('[BI] Erro ao consultar contas a vencer:', erro);
                elEstado.hidden = false;
                elEstado.textContent = 'Nao foi possivel carregar. Verifique se esta logado no Sankhya.';
            });
    }

    elFiltro.addEventListener('change', carregar);
    elBtn.addEventListener('click', carregar);

    carregar();
})();
</script>
</body>
</html>
