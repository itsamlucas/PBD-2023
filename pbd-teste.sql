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
        (NOW(), CONCAT('O preço de ', produto, ' foi alterado de ', OLD.VaProduto, ' para ', NEW.VaProduto, '.'));
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
    (NOW(), CONCAT('ID do pedido deletado: ', OLD.CoPedido, '. Valor do pedido deletado: ', OLD.VaPedido));
END; $$
DELIMITER ;

-- QUARTA QUESTÃO. 

DELIMITER $$
CREATE TRIGGER tgModificaItemPedido
AFTER UPDATE ON tbpedidoitem
FOR EACH ROW
BEGIN
    DECLARE novoproduto VARCHAR(50);
    DECLARE antigoproduto VARCHAR(50);

    IF OLD.CoPedido != NEW.CoPedido THEN
        SELECT NoPedido INTO antigoproduto FROM tbproduto WHERE CoPedido = OLD.CoPedido;
        SELECT NoPedido INTO novoproduto FROM tbproduto WHERE CoPedido = NEW.CoPedido; 
        INSERT INTO TbLog(DaOperacao, TxLog) VALUES
        (NOW(), CONCAT('Produto excluído: ', antigoproduto, '. Produto adicionado: ', novoproduto));
    END IF;
END; $$
DELIMITER ;
