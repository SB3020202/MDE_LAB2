% Declaração do predicado dinâmico
:- dynamic quinta/3.
:- dynamic sensor/3.
:- dynamic produtor/3.
:- dynamic distribuidor/3.
:- dynamic transportadora/5.
:- dynamic ligacao/3.

:- dynamic leitura/4.
:- dynamic consumo/3.

:- dynamic caminho/5.


% ---------------------------------- RF1 ------------------------

% ---- Adicionar uma quinta -------------------------------------
adicionar_quinta(Id, Nome, Local) :-
    \+ quinta(Id, _, _),
    assertz(quinta(Id, Nome, Local)).

% --- Remover uma quinta ---
remover_quinta(Id) :-
    retractall(quinta(Id, _, _)).

% --- Alterar quinta ---
alterar_quinta(Id, NovoNome, NovaLocal) :-
    retractall(quinta(Id, _, _)),
    assertz(quinta(Id, NovoNome, NovaLocal)).

% ----------------------------------- RF 2 ----------------------

% --- Adicionar um sensor ---
adicionar_sensor(IdSensor, Tipo, IdQuinta) :-
    \+ sensor(IdSensor, _, _),
    assertz(sensor(IdSensor, Tipo, IdQuinta)).

% --- Remover um sensor ---
remover_sensor(IdSensor) :-
    retractall(sensor(IdSensor, _, _)).

% --- Alterar um sensor ---
alterar_sensor(IdSensor, NovoTipo, NovaQuinta) :-
    retractall(sensor(IdSensor, _, _)),
    assertz(sensor(IdSensor, NovoTipo, NovaQuinta)).

% -------------------------------- RF 3 ---------------------------
% Produtor
adicionar_produtor(Id, Nome, Zona) :-
    \+ produtor(Id, _, _),
    assertz(produtor(Id, Nome, Zona)).

remover_produtor(Id) :-
    retractall(produtor(Id, _, _)).

alterar_produtor(Id, NovoNome, NovaZona) :-
    retractall(produtor(Id, _, _)),
    assertz(produtor(Id, NovoNome, NovaZona)).

% Distribuidores
adicionar_distribuidor(Id, Nome, Zona) :-
    \+ distribuidor(Id, _, _),
    assertz(distribuidor(Id, Nome, Zona)).

remover_distribuidor(Id) :-
    retractall(distribuidor(Id, _, _)).

alterar_distribuidor(Id, NovoNome, NovaZona) :-
    retractall(distribuidor(Id, _, _)),
    assertz(distribuidor(Id, NovoNome, NovaZona)).

% Trnsportadoras
adicionar_transportadora(Id, Nome, Capacidade, Combustivel, Area) :-
\+ transportadora(Id, _, _, _, _),
    assertz(transportadora(Id, Nome, Capacidade, Combustivel, Area)).

remover_transportadora(Id) :-
    retractall(transportadora(Id, _, _, _, _)).

alterar_transportadora(Id, NovoNome, NovaCap, NovoComb, NovaArea) :-
    retractall(transportadora(Id, _, _, _, _)),
    assertz(transportadora(Id, NovoNome, NovaCap, NovoComb, NovaArea)).

% -------------------------------- RF 4 ---------------------------

% Adicionar uma nova ligação com estrutura dados(...)
adicionar_ligacao(No1, No2, Distancia, Tempo, TipoVia, Custo) :-
    \+ ligacao(No1, No2, _),
    assertz(ligacao(No1, No2, dados(Distancia, Tempo, TipoVia, Custo))).

% Remover ligação entre dois nós
remover_ligacao(No1, No2) :-
    retractall(ligacao(No1, No2, _)).

% Alterar uma ligação existente com novos dados
alterar_ligacao(No1, No2, NovaDist, NovoTempo, NovoTipo, NovoCusto) :-
    retractall(ligacao(No1, No2, _)),
    assertz(ligacao(No1, No2, dados(NovaDist, NovoTempo, NovoTipo, NovoCusto))).



% -------------------------------- RF 5 --------------------------------

% ------------------------------------------------------------------
% adicionar_leitura(+IdSensor, +Timestamp, +Tipo, +Valor)
%
% Input:
%   IdSensor  – ID do sensor que fez a leitura
%   Timestamp – Momento da leitura (formato ISO: 'YYYY-MM-DDTHH:MM')
%   Tipo      – Tipo da leitura (ex: temperatura, humidade)
%   Valor     – Valor da leitura (ex: 34.5)
%
% Output: nenhum
%
% Funcionamento:
%   Adiciona uma nova leitura do sensor à base de conhecimento.
% ------------------------------------------------------------------
adicionar_leitura(IdSensor, Timestamp, Tipo, Valor) :-
    assertz(leitura(IdSensor, Timestamp, Tipo, Valor)).

% ------------------------------------------------------------------
% atualizar_leitura(+IdSensor, +Timestamp, +Tipo, +NovoValor)
%
% Input:
%   IdSensor    – ID do sensor
%   Timestamp   – Momento da leitura a ser atualizada
%   Tipo        – Tipo da leitura (temperatura, humidade, etc.)
%   NovoValor   – Novo valor da leitura
%
% Output: nenhum
%
% Funcionamento:
%   Remove qualquer leitura anterior do mesmo sensor no mesmo timestamp e tipo,
%   e insere o novo valor atualizado.
% ------------------------------------------------------------------
atualizar_leitura(IdSensor, Timestamp, Tipo, NovoValor) :-
    retractall(leitura(IdSensor, Timestamp, Tipo, _)),
    assertz(leitura(IdSensor, Timestamp, Tipo, NovoValor)).


% ------------------------------------------------------------------
% adicionar_consumo(+IdQuinta, +Cultura, +Litros)
%
% Input:
%   IdQuinta – ID da quinta associada ao consumo
%   Cultura  – Tipo de cultura (ex: milho, tomate)
%   Litros   – Quantidade de água consumida
%
% Output: nenhum
%
% Funcionamento:
%   Regista um novo consumo de água na base de conhecimento.
% ------------------------------------------------------------------
adicionar_consumo(IdQuinta, Cultura, Litros) :-
    assertz(consumo(IdQuinta, Cultura, Litros)).

% ------------------------------------------------------------------
% atualizar_consumo(+IdQuinta, +Cultura, +NovoLitros)
%
% Input:
%   IdQuinta    – ID da quinta
%   Cultura     – Cultura cujos dados de consumo vão ser atualizados
%   NovoLitros  – Novo valor de litros consumidos
%
% Output: nenhum
%
% Funcionamento:
%   Substitui o valor anterior de consumo dessa cultura na quinta
%   pelo novo valor fornecido.
% ------------------------------------------------------------------
atualizar_consumo(IdQuinta, Cultura, NovoLitros) :-
    retractall(consumo(IdQuinta, Cultura, _)),
    assertz(consumo(IdQuinta, Cultura, NovoLitros)).


% -------------------------------- RF 6 ---------------------------
% listar_sensores_quinta(+IdQuinta, -Lista)
%
% Input:
%   IdQuinta – ID da quinta a consultar
%
% Output:
%   Lista – Lista de tuplos (IdSensor, Tipo, NomeProdutor)
%
% Funcionamento:
%   1. Obtém o ID do produtor que é dono da quinta (relacionado via dono/2).
%   2. Obtém o nome do produtor através do predicado produtor/3.
%   3. Procura todos os sensores associados à quinta com sensor/3.
%   4. Para cada sensor, junta o ID do sensor, o seu tipo e o nome do produtor.
%   5. Devolve a lista com essa informação.
%
% Exemplo de saída:
%   Lista = [(s1, temperatura, 'João Silva'), (s2, humidade, 'João Silva')].
% ------------------------------------------------------------------

listar_sensores_quinta(IdQuinta, Lista) :-
    dono(IdProdutor, IdQuinta),
    produtor(IdProdutor, NomeProdutor, _),
    findall((IdSensor, Tipo, NomeProdutor),
            sensor(IdSensor, Tipo, IdQuinta),
            Lista).

% -------------------------------- RF 7 ---------------------------
% Receber o nome de uma zona (ex: lisboa)
% Devolver uma lista de transportadoras que cobrem essa zona

% Input:  Zona
% Output: Lista

% Procura (Id, Nome) que satisfazem a condição transportadora(...) e
% verifica se Zona(input) está na lista de Zonas
listar_transportadoras_zona(Zona, Lista) :-
    findall((Id, Nome),
            (transportadora(Id, Nome, _, _, Zonas), member(Zona, Zonas)),
            Lista).

% -------------------------------- RF 8 -------------------------------
% leitura_mais_recente(+IdSensor, -Tipo, -Valor, -TimestampMaisRecente)
%
% Input:
%   IdSensor – Identificador do sensor cujas leituras queremos consultar
%
% Output:
%   Tipo                 – Tipo da leitura mais recente (ex: temperatura, humidade)
%   Valor                – Valor dessa leitura
%   TimestampMaisRecente – Momento (timestamp) da leitura mais recente
%
% Funcionamento:
%   1. Recolhe todas as leituras associadas ao sensor usando findall/3.
%      Cada leitura tem a forma (Timestamp, Tipo, Valor).
%
%   2. Ordena com o sort() a lista de leituras por Timestamp em ordem
%   crescente com sort/2. (assume-se que o formato do timestamp permite
%   ordenação lexicográfica)
%
%   3. Inverte a lista com reverse/2 para colocar a leitura mais recente no início.
%
%   4. Extrai o primeiro elemento da lista invertida e unifica os seus componentes
%      com as variáveis de saída: Timestamp, Tipo e Valor.
% ------------------------------------------------------------------

leitura_mais_recente(IdSensor, Tipo, Valor, TimestampMaisRecente) :-
    findall((Timestamp, Tipo, Valor),
            leitura(IdSensor, Timestamp, Tipo, Valor),
            Leituras),
    sort(Leituras, LeiturasOrdenadas),
    reverse(LeiturasOrdenadas, [(TimestampMaisRecente, Tipo, Valor)|_]).% |_ é para ignorar o resto da lista

% -------------------------------- RF 9 -------------------------------
% consumos_por_quinta(+IdQuinta, -Lista)
%
% Input:  IdQuinta – ID da quinta
% Output: Lista    – Lista de (Cultura, Litros)
%
% Devolve todos os consumos registados para essa quinta.

consumos_por_quinta(IdQuinta, Lista) :-
    findall((Cultura, Litros),
            consumo(IdQuinta, Cultura, Litros),
            Lista).

% -------------------------------- RF10 -------------------------------
% Limites críticos por tipo de sensor
% -----------------------------------------------------------------
limite(temperatura, 35).
limite(humidade, 30).
% ------------------------------------------------------------------
% recolha_sensores_fora_do_limite(-Lista)
%
% Input:
%   Nenhum. O predicado procura automaticamente em todas as leituras registadas.
%
% Output:
%   Lista – Lista de tuplos (IdSensor, Timestamp, Tipo, Valor),
%           onde cada elemento representa um sensor cuja leitura mais recente
%           ultrapassa o limite definido para o seu tipo.
%
% Funcionamento:
%   1. Recolhe todas as leituras existentes com leitura/4.
%   2. Ordena as leituras por timestamp (usando sort/2).
%   3. Inverte a lista para que a leitura mais recente venha primeiro.
%   4. Filtra a lista, verificando para cada leitura se ultrapassa o limite
%      (definido em limite/2) de acordo com o tipo de sensor.
%   5. Apenas a leitura mais recente de cada sensor/tipo é considerada.
%   6. Devolve a lista com os sensores fora dos valores aceitáveis.
% ------------------------------------------------------------------
recolha_sensores_fora_do_limite(Lista) :-
    findall((IdSensor, Timestamp, Tipo, Valor),
            leitura(IdSensor, Timestamp, Tipo, Valor),
            TodasLeituras),
    sort(TodasLeituras, LeiturasOrdenadas),
    reverse(LeiturasOrdenadas, RecentesPrimeiro),
    %lista de leituras a processar, Acumulador (onde vou guardando os válidos), Resultado final da filtragem
    filtrar_leituras_criticas(RecentesPrimeiro, [], Lista).

% ------------------------------------------------------------------
% filtrar_leituras_criticas(+Leituras, +Acc, -Resultado)
%
% Input:
%   Leituras – Lista de tuplos (IdSensor, Timestamp, Tipo, Valor),
%              já ordenada por timestamp (mais recente primeiro).
%   Acc      – Acumulador interno que começa como lista vazia ([]).
%
% Output:
%   Resultado – Lista final com sensores cuja leitura mais recente
%               ultrapassa o limite definido em limite/2.
%
% Funcionamento:
%   1. Percorre a lista de leituras.
%   2. Para cada leitura:
%      - Verifica se ultrapassa o limite (com valor_fora_do_limite/3).
%      - Garante que esse sensor/tipo ainda não foi adicionado.
%   3. Se estiver fora do limite e ainda não foi adicionado, guarda.
%   4. No final, devolve todas as leituras críticas (sem duplicados).
%
%
% ------------------------------------------------------------------
% 3 vezes o nome é como se tivesse if, else if, else if
% % caso base: lista vazia
filtrar_leituras_criticas([], Acc, Acc).
% Caso: leitura fora do limite/ não adicionada -> adiciona ao Acc
filtrar_leituras_criticas([(Id, Timestamp, Tipo, Value)|Resto], Acc, Resultado) :-
    limite(Tipo, Limite),
    valor_fora_do_limite(Tipo, Value, Limite),
    \+ member((Id, _, Tipo, _), Acc),    % para evitar duplicados
    filtrar_leituras_criticas(Resto, [(Id, Timestamp, Tipo, Value)|Acc], Resultado).
% Caso: leitura não está fora do limite/já foi adicionada.-> ignora e
filtrar_leituras_criticas([_|Resto], Acc, Resultado) :-
    filtrar_leituras_criticas(Resto, Acc, Resultado).


% -------------------------------- RF11 -------------------------------
% rota_mais_curta_quinta_distri(+Inicio, +Destino, -Caminho,
% -DistanciaTotal)
%
% Input:
%   Inicio         – Identificador do nó de origem (ex: q1)
%   Destino        – Identificador do nó de destino (ex: d1)
%
% Output:
%   Caminho        – Lista de nós percorridos do início até ao destino
%   DistanciaTotal – Soma total das distâncias (em km) entre os nós do caminho
%
% Funcionamento:
%   1. Percorre o grafo (ligacao/3) para encontrar todos os caminhos possíveis.
%   2. Usa busca em profundidade com acumulação da distância total.
%   3. Devolve o caminho com menor distância (menor custo acumulado em 'dados').
%
% Extra:
%   setof(Elemento, Condicao, ListaOrdenada)
%      recolhe todos valores de Elemento para qnd Condicao é True
%      devolve lista ordenada sem duplicados
% ------------------------------------------------------------------
rota_mais_curta_quinta_distri(Inicio, Destino, Caminho, DistanciaTotal) :-
    setof((Distancia, CaminhoValido),
          caminho(Inicio, Destino, [Inicio], CaminhoValido, Distancia),
          [(DistanciaTotal, Caminho)|_]).

% Caso: já estamos no destino
caminho(Destino, Destino, Visitados, Caminho, 0) :-
    reverse(Visitados, Caminho).

% Passo recursivo: continuar a explorar o grafo
caminho(Atual, Destino, Visitados, Caminho, DistTotal) :-
    ligacao(Atual, Proximo, dados(Dist, _, _, _)),
    \+ member(Proximo, Visitados),
    caminho(Proximo, Destino, [Proximo|Visitados], Caminho, DistAcumulada),
    DistTotal is Dist + DistAcumulada.

