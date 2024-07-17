CREATE DATABASE hospedar_db;

USE hospedar_db;

CREATE TABLE Hotel (
    hotel_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    cidade VARCHAR(255) NOT NULL,
    uf VARCHAR(2) NOT NULL,
    classificacao INT NOT NULL CHECK (classificacao >= 1 AND classificacao <= 5)
);

CREATE TABLE Quarto (
    quarto_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_id INT NOT NULL,
    numero INT NOT NULL,
    tipo VARCHAR(255) NOT NULL,
    preco_diaria DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);

CREATE TABLE Cliente (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE
);

CREATE TABLE Hospedagem (
    hospedagem_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    quarto_id INT NOT NULL,
    dt_checkin DATE NOT NULL,
    dt_checkout DATE NOT NULL,
    valor_total_hosp DECIMAL(10, 2) NOT NULL,
    status_hosp VARCHAR(20) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id),
    FOREIGN KEY (quarto_id) REFERENCES Quarto(quarto_id),
    CHECK (status_hosp IN ('reserva', 'finalizada', 'hospedado', 'cancelada'))
);

INSERT INTO Hotel (nome, cidade, uf, classificacao) VALUES
('Hotel Central', 'São Paulo', 'SP', 5),
('Pousada Tranquila', 'Rio de Janeiro', 'RJ', 4);

-- Quartos para o Hotel Central (Hotel ID = 1)
INSERT INTO Quarto (hotel_id, numero, tipo, preco_diaria) VALUES
    (1, 101, 'Standard', 150.00),
    (1, 102, 'Standard', 150.00),
    (1, 201, 'Deluxe', 250.00),
    (1, 202, 'Deluxe', 250.00),
    (1, 301, 'Suíte', 400.00);

-- Quartos para a Pousada Tranquila (Hotel ID = 2)
INSERT INTO Quarto (hotel_id, numero, tipo, preco_diaria) VALUES
    (2, 501, 'Standard', 180.00),
    (2, 502, 'Standard', 180.00),
    (2, 601, 'Deluxe', 300.00),
    (2, 602, 'Deluxe', 300.00),
    (2, 701, 'Suíte', 500.00);
    
-- Inserir dados na tabela "Cliente"
INSERT INTO Cliente (nome, email, telefone, cpf) VALUES
('João Silva', 'joao.silva@email.com', '(11) 9999-8888', '12345678900'),
('Maria Santos', 'maria.santos@email.com', '(21) 9876-5432', '98765432100'),
('Pedro Oliveira', 'pedro.oliveira@email.com', '(31) 8765-4321', '45678912300');




INSERT INTO Hospedagem (cliente_id, quarto_id, dt_checkin, dt_checkout, valor_total_hosp, status_hosp) VALUES
    -- Hospedagens com status "reserva"
    (1, 1, '2024-07-01', '2024-07-03', 300.00, 'reserva'),  
    (2, 2, '2024-07-02', '2024-07-05', 540.00, 'reserva'),  
    (3, 3, '2024-07-03', '2024-07-06', 900.00, 'reserva'),  
    (1, 4, '2024-07-04', '2024-07-08', 1000.00, 'reserva'), 
    (2, 5, '2024-07-05', '2024-07-09', 1200.00, 'reserva'), 

    -- Hospedagens com status "finalizada"
    (2, 6, '2024-06-15', '2024-06-18', 750.00, 'finalizada'),  
    (3, 7, '2024-06-18', '2024-06-22', 1100.00, 'finalizada'), 
    (1, 8, '2024-06-20', '2024-06-25', 850.00, 'finalizada'),  
    (2, 9, '2024-06-25', '2024-06-30', 1300.00, 'finalizada'), 
    (3, 10, '2024-06-30', '2024-07-04', 950.00, 'finalizada'), 

    -- Hospedagens com status "hospedado"
    (3, 1, '2024-07-01', '2024-07-10', 1800.00, 'hospedado'), 
    (1, 2, '2024-07-02', '2024-07-11', 2100.00, 'hospedado'), 
    (2, 3, '2024-07-03', '2024-07-12', 2400.00, 'hospedado'), 
    (3, 4, '2024-07-04', '2024-07-13', 2700.00, 'hospedado'), 
    (1, 5, '2024-07-05', '2024-07-14', 3000.00, 'hospedado'), 

    -- Hospedagens com status "cancelada"
    (1, 6, '2024-06-25', '2024-06-26', 180.00, 'cancelada'),  
    (2, 7, '2024-06-27', '2024-06-28', 200.00, 'cancelada'),  
    (3, 8, '2024-06-29', '2024-06-30', 220.00, 'cancelada'),  
    (1, 9, '2024-07-01', '2024-07-02', 240.00, 'cancelada'),  
    (2, 10, '2024-07-03', '2024-07-04', 260.00, 'cancelada'); 


-- Listar todos os hotéis e seus respectivos quartos, apresentando os seguintes campos: para hotel, nome e cidade; para quarto, tipo e preco_diaria;
SELECT 
    h.nome AS hotel_nome,
    h.cidade AS hotel_cidade,
    q.tipo AS quarto_tipo,
    q.preco_diaria AS quarto_preco_diaria
FROM 
    Hotel h
JOIN 
    Quarto q ON h.hotel_id = q.hotel_id
ORDER BY 
    h.nome, q.tipo;
    
-- ​Listar todos os clientes que já realizaram hospedagens (status_hosp igual á “finalizada”), e os respectivos quartos e hotéis;
SELECT
    c.nome AS cliente_nome,
    c.email AS cliente_email,
    h.nome AS hotel_nome,
    h.cidade AS hotel_cidade,
    q.tipo AS quarto_tipo,
    q.preco_diaria AS quarto_preco_diaria,
    hos.dt_checkin AS data_checkin,
    hos.dt_checkout AS data_checkout,
    hos.valor_total_hosp AS valor_total
FROM
    Hospedagem hos
INNER JOIN
    Cliente c ON hos.cliente_id = c.cliente_id
INNER JOIN
    Quarto q ON hos.quarto_id = q.quarto_id
INNER JOIN
    Hotel h ON q.hotel_id = h.hotel_id
WHERE
    hos.status_hosp = 'finalizada'
ORDER BY
    c.nome, hos.dt_checkin;

-- Mostrar o histórico de hospedagens em ordem cronológica de um determinado cliente;
SELECT
    c.nome AS cliente_nome,
    h.nome AS hotel_nome,
    h.cidade AS hotel_cidade,
    q.tipo AS quarto_tipo,
    q.preco_diaria AS quarto_preco_diaria,
    hos.dt_checkin AS data_checkin,
    hos.dt_checkout AS data_checkout,
    hos.valor_total_hosp AS valor_total,
    hos.status_hosp AS status_hospedagem
FROM
    Hospedagem hos
INNER JOIN
    Cliente c ON hos.cliente_id = c.cliente_id
INNER JOIN
    Quarto q ON hos.quarto_id = q.quarto_id
INNER JOIN
    Hotel h ON q.hotel_id = h.hotel_id
WHERE
    c.cliente_id = 2 -- Substitua  pelo ID do cliente específico desejado
ORDER BY
    hos.dt_checkin;
    
-- Apresentar o cliente com maior número de hospedagens (não importando o tempo em que ficou hospedado);
SELECT
    c.cliente_id,
    c.nome,
    c.email,
    COUNT(hos.hospedagem_id) AS numero_de_hospedagens
FROM
    Hospedagem hos
INNER JOIN
    Cliente c ON hos.cliente_id = c.cliente_id
GROUP BY
    c.cliente_id, c.nome, c.email
ORDER BY
    numero_de_hospedagens DESC
LIMIT 1;


-- ​Apresentar clientes que tiveram hospedagem “cancelada”, os respectivos quartos e hotéis.
SELECT
    c.cliente_id,
    c.nome AS cliente_nome,
    c.email AS cliente_email,
    q.numero AS quarto_numero,
    q.tipo AS quarto_tipo,
    h.nome AS hotel_nome,
    h.cidade AS hotel_cidade,
    hos.dt_checkin AS data_checkin,
    hos.dt_checkout AS data_checkout,
    hos.valor_total_hosp AS valor_total
FROM
    Hospedagem hos
INNER JOIN
    Cliente c ON hos.cliente_id = c.cliente_id
INNER JOIN
    Quarto q ON hos.quarto_id = q.quarto_id
INNER JOIN
    Hotel h ON q.hotel_id = h.hotel_id
WHERE
    hos.status_hosp = 'cancelada';


-- Calcular a receita de todos os hotéis (hospedagem com status_hosp igual a “finalizada”), ordenado de forma decrescente;
SELECT
    h.hotel_id,
    h.nome AS hotel_nome,
    h.cidade AS hotel_cidade,
    SUM(hos.valor_total_hosp) AS receita_total
FROM
    Hospedagem hos
INNER JOIN
    Quarto q ON hos.quarto_id = q.quarto_id
INNER JOIN
    Hotel h ON q.hotel_id = h.hotel_id
WHERE
    hos.status_hosp = 'finalizada'
GROUP BY
    h.hotel_id, h.nome, h.cidade
ORDER BY
    receita_total DESC;

-- Listar todos os clientes que já fizeram uma reserva em um hotel específico;
SELECT DISTINCT
    c.cliente_id,
    c.nome AS cliente_nome,
    c.email AS cliente_email
FROM
    Cliente c
INNER JOIN
    Hospedagem h ON c.cliente_id = h.cliente_id
INNER JOIN
    Quarto q ON h.quarto_id = q.quarto_id
INNER JOIN
    Hotel ho ON q.hotel_id = ho.hotel_id
WHERE
    ho.hotel_id = 1  -- Substitua pelo hotel_id específico desejado
    AND h.status_hosp = 'reserva';

-- Listar o quanto cada cliente que gastou em hospedagens (status_hosp igual a “finalizada”), em ordem decrescente por valor gasto.
SELECT
    c.cliente_id,
    c.nome AS cliente_nome,
    c.email AS cliente_email,
    SUM(h.valor_total_hosp) AS valor_gasto_total
FROM
    Cliente c
INNER JOIN
    Hospedagem h ON c.cliente_id = h.cliente_id
WHERE
    h.status_hosp = 'finalizada'
GROUP BY
    c.cliente_id, c.nome, c.email
ORDER BY
    valor_gasto_total DESC;


-- Listar todos os quartos que ainda não receberam hóspedes.
SELECT
    q.quarto_id,
    q.numero AS numero_quarto,
    q.tipo AS tipo_quarto,
    q.preco_diaria
FROM
    Quarto q
LEFT JOIN
    Hospedagem h ON q.quarto_id = h.quarto_id AND h.status_hosp <> 'cancelada'
WHERE
    h.hospedagem_id IS NULL;


-- Apresentar a média de preços de diárias em todos os hotéis, por tipos de quarto.
SELECT
    q.tipo AS tipo_quarto,
    AVG(q.preco_diaria) AS media_preco_diaria
FROM
    Quarto q
INNER JOIN
    Hotel h ON q.hotel_id = h.hotel_id
GROUP BY
    q.tipo
ORDER BY
    tipo_quarto;
    

-- Criar a coluna checkin_realizado do tipo booleano na tabela Hospedagem (via código). E atribuir verdadeiro para as Hospedagens com status_hosp “finalizada” e “hospedado”, e como falso para Hospedagens com status_hosp “reserva” e “cancelada”.

ALTER TABLE Hospedagem
ADD COLUMN checkin_realizado BOOLEAN;

UPDATE Hospedagem
SET checkin_realizado = 
    CASE 
        WHEN status_hosp IN ('finalizada', 'hospedado') THEN TRUE
        WHEN status_hosp IN ('reserva', 'cancelada') THEN FALSE
        ELSE NULL  -- Pode definir outro comportamento conforme necessidade
    END;

-- Mudar o nome da coluna “classificacao” da tabela Hotel para “ratting” (via código).
-- Remover a restrição de verificação da coluna classificacao
ALTER TABLE Hotel
DROP CONSTRAINT hotel_chk_1;

-- Renomear a coluna classificacao para ratting na tabela Hotel
ALTER TABLE Hotel
CHANGE COLUMN classificacao ratting INT NOT NULL;

-- Adicionar a restrição de verificação para a nova coluna ratting
ALTER TABLE Hotel
ADD CONSTRAINT hotel_chk_ratting CHECK (ratting >= 1 AND ratting <= 5);


-- Criar uma procedure chamada "RegistrarCheckIn" que aceita hospedagem_id e data_checkin como parâmetros. A procedure deve atualizar a data de check-in na tabela "Hospedagem" e mudar o status_hosp para "hospedado".​
DELIMITER //

CREATE PROCEDURE RegistrarCheckIn(
    IN p_hospedagem_id INT,
    IN p_data_checkin DATE
)
BEGIN
    UPDATE Hospedagem
    SET dt_checkin = p_data_checkin,
        status_hosp = 'hospedado'
    WHERE hospedagem_id = p_hospedagem_id;
END //

DELIMITER ;

CALL RegistrarCheckIn(227, '2024-07-01');

-- Criar uma procedure chamada "CalcularTotalHospedagem" que aceita hospedagem_id como parâmetro. A procedure deve calcular o valor total da hospedagem com base na diferença de dias entre check-in e check-out e o preço da diária do quarto reservado. O valor deve ser atualizado na coluna valor_total_hosp.​
DELIMITER //

CREATE PROCEDURE CalcularTotalHospedagem(
    IN p_hospedagem_id INT
)
BEGIN
    DECLARE v_dt_checkin DATE;
    DECLARE v_dt_checkout DATE;
    DECLARE v_preco_diaria DECIMAL(10, 2);
    DECLARE v_numero_dias INT;
    DECLARE v_valor_total DECIMAL(10, 2);

    SELECT H.dt_checkin, H.dt_checkout, Q.preco_diaria
    INTO v_dt_checkin, v_dt_checkout, v_preco_diaria
    FROM Hospedagem H
    JOIN Quarto Q ON H.quarto_id = Q.quarto_id
    WHERE H.hospedagem_id = p_hospedagem_id;

    SET v_numero_dias = DATEDIFF(v_dt_checkout, v_dt_checkin);

    SET v_valor_total = v_numero_dias * v_preco_diaria;

    UPDATE Hospedagem
    SET valor_total_hosp = v_valor_total
    WHERE hospedagem_id = p_hospedagem_id;
END //

DELIMITER ;

CALL CalcularTotalHospedagem(220);


-- Criar uma procedure chamada "RegistrarCheckout" que aceita hospedagem_id e data_checkout como parâmetros. A procedure deve atualizar a data de check-out na tabela "Hospedagem" e mudar o status_hosp para "finalizada".​
DELIMITER //

CREATE PROCEDURE RegistrarCheckout(
    IN p_hospedagem_id INT,
    IN p_data_checkout DATE
)
BEGIN
    -- Atualizar a data de check-out e o status_hosp na tabela Hospedagem
    UPDATE Hospedagem
    SET dt_checkout = p_data_checkout,
        status_hosp = 'finalizada'
    WHERE hospedagem_id = p_hospedagem_id;
END //

DELIMITER ;

CALL RegistrarCheckout(219, '2024-07-10');


-- Efetue a criação das seguintes funções utilizando PL/MySQL:
-- Criar uma function chamada "TotalHospedagensHotel" que aceita hotel_id como parâmetro. A função deve retornar o número total de hospedagens realizadas em um determinado hotel.​
DELIMITER //

CREATE FUNCTION TotalHospedagensHotel(
    p_hotel_id INT
) RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total_hospedagens INT;

    -- Contar o número total de hospedagens para o hotel especificado
    SELECT COUNT(*)
    INTO v_total_hospedagens
    FROM Hospedagem H
    JOIN Quarto Q ON H.quarto_id = Q.quarto_id
    WHERE Q.hotel_id = p_hotel_id;

    RETURN v_total_hospedagens;
END //

DELIMITER ;

SELECT TotalHospedagensHotel(1);

-- Criar uma function chamada "ValorMedioDiariasHotel" que aceita hotel_id como parâmetro. A função deve calcular e retornar o valor médio das diárias dos quartos deste hotel.
DELIMITER //

CREATE FUNCTION ValorMedioDiariasHotel(
    p_hotel_id INT
) RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_valor_medio DECIMAL(10,2);

    SELECT AVG(preco_diaria)
    INTO v_valor_medio
    FROM Quarto
    WHERE hotel_id = p_hotel_id;

    RETURN v_valor_medio;
END //

DELIMITER ;

SELECT ValorMedioDiariasHotel(1);

-- Criar uma function chamada "VerificarDisponibilidadeQuarto" que aceita quarto_id e data como parâmetros. A função deve retornar um valor booleano indicando se o quarto está disponível ou não para reserva na data especificada.​

DELIMITER //

CREATE FUNCTION VerificarDisponibilidadeQuarto(
    p_quarto_id INT,
    p_data DATE
) RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_disponivel BOOLEAN;

    IF EXISTS (
        SELECT 1
        FROM Hospedagem
        WHERE quarto_id = p_quarto_id
          AND p_data BETWEEN dt_checkin AND dt_checkout
          AND status_hosp IN ('reserva', 'hospedado')
    ) THEN
        SET v_disponivel = FALSE;
    ELSE
        SET v_disponivel = TRUE;
    END IF;

    RETURN v_disponivel;
END //

DELIMITER ;

SELECT VerificarDisponibilidadeQuarto(2, '2024-07-01');


-- Criar um trigger chamado "AntesDeInserirHospedagem" que é acionado antes de uma inserção na tabela "Hospedagem". O trigger deve verificar se o quarto está disponível na data de check-in. Se não estiver, a inserção deve ser cancelada.

DELIMITER //

CREATE TRIGGER AntesDeInserirHospedagem
BEFORE INSERT ON Hospedagem
FOR EACH ROW
BEGIN
    DECLARE v_disponivel BOOLEAN;

    -- Verificar se o quarto está disponível na data de check-in
    SET v_disponivel = VerificarDisponibilidadeQuarto(NEW.quarto_id, NEW.dt_checkin);

    -- Se o quarto não estiver disponível, cancelar a inserção
    IF v_disponivel = FALSE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O quarto não está disponível na data de check-in especificada';
    END IF;
END //

DELIMITER ;

INSERT INTO Hospedagem (cliente_id, quarto_id, dt_checkin, dt_checkout, valor_total_hosp, status_hosp)
VALUES (3, 2, '2024-08-01', '2024-08-03', 300.00, 'reserva');


-- Cria um trigger chamado "AposDeletarCliente" que é acionado após a exclusão de um cliente na tabela "Cliente". O trigger deve registrar a exclusão em uma tabela de log.​
CREATE TABLE LogExclusaoCliente (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    cpf VARCHAR(11) NOT NULL,
    data_exclusao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER AposDeletarCliente
AFTER DELETE ON Cliente
FOR EACH ROW
BEGIN
    INSERT INTO LogExclusaoCliente (cliente_id, nome, email, telefone, cpf)
    VALUES (OLD.cliente_id, OLD.nome, OLD.email, OLD.telefone, OLD.cpf);
END //

DELIMITER ;


DELETE FROM Hospedagem WHERE cliente_id = 3;
DELETE FROM Cliente WHERE cliente_id = 3;

SELECT * FROM LogExclusaoCliente;
