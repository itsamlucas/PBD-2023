-- PRIMEIRA QUESTÃO. 

CREATE TRIGGER estoque_abaixo_minimo
AFTER UPDATE ON TbProduto
FOR EACH ROW
BEGIN
    IF NEW.estoque <= NEW.estoque_minimo THEN
        INSERT INTO Logs (mensagem) VALUES ('ATENÇÃO: estoque atual de ' || NEW.nome_produto || ' está abaixo da quantidade mínima definida. Providenciar reposição!');
    END IF;
END;

-- SEGUNDA QUESTÃO. 

CREATE TRIGGER log_alteracao_produto
AFTER UPDATE ON TbProduto
FOR EACH ROW
BEGIN
    IF NEW.preco <> OLD.preco THEN
        INSERT INTO Logs (mensagem) VALUES ('O preço de ' || NEW.nome_produto || ' foi alterado de R$ ' || OLD.preco || ' para R$ ' || NEW.preco || '.');
    END IF;
    
    IF NEW.estoque <> OLD.estoque THEN
        INSERT INTO Logs (mensagem) VALUES ('O estoque de ' || NEW.nome_produto || ' foi alterado de ' || OLD.estoque || ' unidades para ' || NEW.estoque || ' unidades.');
    END IF;
END;

-- TERCEIRA QUESTÃO. 

CREATE TRIGGER registro_exclusao_pedido
AFTER DELETE ON TbPedidos
FOR EACH ROW
BEGIN
    INSERT INTO Logs (pedido_id, valor) VALUES (OLD.pedido_id, OLD.valor);
END;

-- QUARTA QUESTÃO. 

DELIMITER $$
CREATE TRIGGER tgExcluiProduto
AFTER UPDATE ON tbpedidoitem
FOR EACH ROW
BEGIN
    DECLARE novoproduto VARCHAR(50);
    DECLARE antigoproduto VARCHAR(50);
    IF OLD.CoPedido != NEW.CoPedido THEN
        SELECT NoPedido INTO antigoproduto FROM tbproduto WHERE CoPedido = OLD.CoPedido;
        SELECT NoPedido INTO novoproduto FROM tbproduto WHERE CoPedido = NEW.CoPedido; 
        INSERT INTO TbLog(DaOperacao, TxLog) VALUES
        (NOW(), CONCAT('Produto excluído:', antigoproduto, '. Produto adicionado:', novoproduto));
    END IF;
END; $$
DELIMITER ;
