-- PRIMEIRA QUESTÃO. 

DELIMITER $$
CREATE TRIGGER tgEstoqueMinimo
AFTER UPDATE ON tbproduto 
FOR EACH ROW
BEGIN
    DECLARE produto VARCHAR(50);

    IF NEW.QtEstoque <= OLD.QtEstoqueMinimo THEN
        SELECT NoProduto INTO produto FROM tbproduto WHERE NEW.QtEstoque <= OLD.QtEstoqueMinimo;
        INSERT INTO TbLog(DaOperacao, TxLog) VALUES
        (NOW(), CONCAT('ATENÇÃO: estoque atual de ', produto, ' está abaixo da quantidade mínima definida. Providenciar reposição!'));
	END IF;
END; $$
DELIMITER ;

-- SEGUNDA QUESTÃO. 

DELIMITER $$
CREATE TRIGGER tgAlteraProduto
AFTER UPDATE ON tbproduto
FOR EACH ROW
BEGIN
    DECLARE produto VARCHAR(50);

    IF OLD.VaProduto != NEW.VaProduto THEN
        SELECT NoProduto INTO produto FROM tbproduto WHERE OLD.VaProduto != NEW.VaProduto;
        INSERT INTO TbLog(DaOperacao, TxLog) VALUES
        (NOW(), CONCAT('O preço de ', produto, ' foi alterado de R$', OLD.VaProduto, ' para R$', NEW.VaProduto, '.'));
    END IF;

    IF OLD.QtEstoque != NEW.QtEstoque THEN
        SELECT NoProduto INTO produto FROM tbproduto WHERE OLD.QtEstoque != NEW.QtEstoque;
        INSERT INTO TbLog(DaOperacao, TxLog) VALUES
        (NOW(), CONCAT('O estoque de ', produto, ' foi alterado de ', OLD.QtEstoque, ' unidades para ', NEW.QtEstoque, ' unidades.'));
    END IF;
END; $$
DELIMITER ;

-- TERCEIRA QUESTÃO. 

DELIMITER $$
CREATE TRIGGER tgExcluiPedido
AFTER DELETE ON tbpedido
FOR EACH ROW
BEGIN
    INSERT INTO TbLog(DaOperacao, TxLog) VALUES
    (NOW(), CONCAT('ID do pedido excluído: ', OLD.CoPedido, '. Valor do pedido excluído: ', OLD.VaPedido));
END; $$
DELIMITER ;

-- QUARTA QUESTÃO. 

DELIMITER $$
CREATE TRIGGER tgModificaItemPedido
AFTER UPDATE ON tbpedidoitem
FOR EACH ROW
BEGIN
    DECLARE novo_produto VARCHAR(50);
    DECLARE antigo_produto VARCHAR(50);

    IF OLD.NoPedido != NEW.NoPedido THEN
        SELECT NoPedido INTO antigo_produto FROM tbproduto WHERE NoPedido = OLD.NoPedido;
        SELECT NoPedido INTO novo_produto FROM tbproduto WHERE NoPedido = NEW.NoPedido; 
        INSERT INTO TbLog(DaOperacao, TxLog) VALUES
        (NOW(), CONCAT('O produto anterior ', antigo_produto, ' foi substituído pelo novo produto ', novo_produto, ' no pedido ', NEW.CoPedido, '.'));
    END IF;
END; $$
DELIMITER ;
