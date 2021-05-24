-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Mag 24, 2021 alle 19:31
-- Versione del server: 10.4.14-MariaDB
-- Versione PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `progetto_ristoranti`
--

DELIMITER $$
--
-- Procedure
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `p0` (IN `id_r` INTEGER, IN `id_f` INTEGER, IN `id_p` INTEGER, IN `data` DATE, IN `quantita` INTEGER)  begin
    
insert into fornitura values (id_r, id_f, id_p, data, quantita, null);
insert into temp values (id_p, (select costo from prodotto where id = id_p));
delete from temp;

end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p1` (IN `ristorante` INTEGER)  begin

select count(*) as totale_camerieri
from dipendente
where (tipo = 'cameriere') and exists (select *
									from impiego
									where id_ristorante = ristorante and tipo = 'corrente' and id = id_dipendente);

end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p2` (IN `dipendente` INTEGER)  begin

select *
from impiego
where id_dipendente = dipendente;

end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p3` (IN `dipendente` INTEGER, IN `ristorante` INTEGER, IN `data_inizio` DATE, IN `salario` INTEGER)  begin

insert into impiego values (dipendente, ristorante, data_inizio, 'corrente', null, salario);

end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p4` (IN `ristorante` INTEGER)  begin
drop table if exists temp1;
drop table if exists temp2;
create temporary table temp1(
	anno year,
    spesa_totale float
);
create temporary table temp2(
	anno year
);

set @anno_min = (select min(year(data)) from fornitura where id_ristorante = ristorante);
set @anno_max = (select max(year(data)) from fornitura where id_ristorante = ristorante);
while(@anno_min <= @anno_max)
do insert into temp2 values (@anno_min);
set @anno_min = @anno_min + 1;
end while;

insert into temp1
select t2.anno as anno, t1.spesa_totale as spesa_totale
from (select year(data) as anno, sum(spesa) as spesa_totale
	from fornitura
	where id_ristorante = ristorante
	group by anno) t1 right join temp2 t2 on t1.anno = t2.anno;

update temp1
set spesa_totale = 0
where spesa_totale is null;

select * from temp1;

end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `dipendente`
--

CREATE TABLE `dipendente` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `cognome` varchar(255) DEFAULT NULL,
  `data_nascita` date DEFAULT NULL,
  `tipo` varchar(255) NOT NULL,
  `mansione` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `dipendente`
--

INSERT INTO `dipendente` (`id`, `nome`, `cognome`, `data_nascita`, `tipo`, `mansione`) VALUES
(1, 'Mario', 'Rossi', '1980-02-14', 'cameriere', NULL),
(2, 'Giovanni', 'Verdi', '1991-04-24', 'informatico', NULL),
(3, 'Andrea', 'Bianchi', '1990-12-10', 'informatico', NULL),
(4, 'Giuseppe', 'Biachi', '1995-06-18', 'tecnico', NULL),
(5, 'Giacomo', 'Ferrari', '1984-05-19', 'cuoco', 'primi piatti'),
(6, 'Lucia', 'Gallo', '1992-07-10', 'cuoco', 'contorni'),
(7, 'Andrea', 'Russo', '1993-10-03', 'cameriere', NULL),
(8, 'Gigi', 'Fontana', '1989-08-22', 'cameriere', NULL),
(9, 'Alice', 'Bruno', '1988-11-29', 'cuoco', 'secondi piatti'),
(10, 'Sara', 'Greco', '1994-10-25', 'lavapiatti', NULL),
(11, 'Giovanni', 'Esposito', '1981-04-04', 'cameriere', NULL),
(12, 'Salvatore', 'De Luca', '1996-05-12', 'cameriere', NULL),
(13, 'Carlo', 'Lombardi', '1989-01-01', 'tecnico', NULL),
(14, 'Raimondo', 'Rinaldi', '1999-07-08', 'cameriere', NULL),
(15, 'Francesco', 'Marino', '1987-01-09', 'cuoco', 'primi piatti'),
(16, 'Alessio', 'Colombo', '1982-12-11', 'cuoco', 'contorni'),
(17, 'Luigi', 'Ferrara', '1994-11-23', 'cameriere', NULL),
(18, 'Chiara', 'Mazza', '1986-09-26', 'cuoco', 'primi piatti'),
(19, 'Federica', 'Vitale', '1983-08-19', 'cuoco', 'secondi piatti'),
(20, 'Paola', 'Fiore', '1996-02-25', 'cameriere', NULL);

-- --------------------------------------------------------

--
-- Struttura della tabella `fornitore`
--

CREATE TABLE `fornitore` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `indirizzo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `fornitore`
--

INSERT INTO `fornitore` (`id`, `username`, `password`, `email`, `nome`, `indirizzo`) VALUES
(1, 'user1', 'pass1', 'em1@gmail.com', 'Gioia s.p.a', 'Via Campoli Appennino 1'),
(2, 'user2', 'pass2', 'em2@gmail.com', 'Toscana Molluschi', 'Piazza Artom Eugenio 12'),
(3, 'user3', 'pass3', 'em3@gmail.com', 'Acquadirete', 'Piazza Lamoni Puccio 4'),
(4, 'user4', 'pass4', 'em4@gmail.com', 'Divino Sfuso', 'Via delle Panche 121'),
(5, 'user5', 'pass5', 'em5@gmail.com', 'Macelleria Soderi', 'Piazza Mercato Centrale 5'),
(6, 'user6', 'pass6', 'em6@gmail.com', 'Panificio Artigiano Cirri', 'Via Pisana 843'),
(7, 'user7', 'pass7', 'em7@gmail.com', 'Giga Grandi Cucine s.r.l.', 'Via Pisana 336');

-- --------------------------------------------------------

--
-- Struttura della tabella `fornitura`
--

CREATE TABLE `fornitura` (
  `id_ristorante` int(11) NOT NULL,
  `id_fornitore` int(11) NOT NULL,
  `id_prodotto` int(11) NOT NULL,
  `data` date NOT NULL,
  `quantita` int(11) DEFAULT NULL,
  `spesa` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `fornitura`
--

-- Per l'inserimento in 'fornitura' chiamare la procedura 0
-- INSERT INTO `fornitura` (`id_ristorante`, `id_fornitore`, `id_prodotto`, `data`, `quantita`, `spesa`)

call p0(1, 1, 1, '2019-03-15', 10);
call p0(1, 2, 2, '2018-04-25', 7);
call p0(1, 3, 4, '2019-05-13', 12);
call p0(1, 4, 3, '2017-07-22', 6);
call p0(1, 5, 5, '2015-01-12', 25);
call p0(1, 6, 6, '2018-06-14', 13);
call p0(2, 6, 7, '2016-02-19', 11);
call p0(2, 7, 8, '2017-04-23', 5);
call p0(2, 2, 1, '2019-06-13', 18);
call p0(2, 3, 4, '2017-07-28', 16);
call p0(2, 1, 5, '2014-08-12', 5);
call p0(3, 2, 7, '2019-03-15', 9);
call p0(3, 5, 8, '2018-04-25', 17);
call p0(3, 7, 3, '2019-05-13', 2);
call p0(3, 6, 2, '2017-07-22', 7);
call p0(3, 4, 5, '2015-01-12', 3);
call p0(4, 2, 1, '2019-02-15', 2);
call p0(4, 4, 6, '2018-04-12', 16);
call p0(4, 7, 8, '2016-05-17', 19);
call p0(4, 5, 8, '2013-07-22', 26);
call p0(4, 4, 3, '2015-11-12', 4);
call p0(5, 1, 3, '2019-03-13', 13);
call p0(5, 3, 5, '2018-04-28', 8);
call p0(5, 5, 7, '2019-05-15', 22);
call p0(5, 7, 8, '2016-07-12', 3);
call p0(6, 2, 4, '2012-03-15', 14);
call p0(6, 2, 3, '2013-04-25', 6);
call p0(6, 3, 6, '2015-05-13', 10);
call p0(6, 5, 7, '2017-07-22', 20);
call p0(6, 6, 7, '2015-01-12', 1);
call p0(6, 7, 8, '2019-03-15', 9);
call p0(7, 2, 1, '2019-07-15', 20);
call p0(7, 3, 1, '2018-04-25', 17);
call p0(7, 1, 4, '2014-02-13', 4);
call p0(7, 5, 3, '2017-05-21', 1);
call p0(7, 6, 8, '2015-01-22', 30);
call p0(8, 7, 1, '2019-03-25', 15);
call p0(8, 7, 2, '2012-02-20', 8);
call p0(8, 5, 7, '2015-09-23', 14);
call p0(8, 6, 8, '2017-07-08', 16);
call p0(8, 7, 8, '2015-10-12', 22);

-- --------------------------------------------------------

--
-- Struttura della tabella `giornata_lavorativa`
--

CREATE TABLE `giornata_lavorativa` (
  `id_ristorante` int(11) NOT NULL,
  `data` date NOT NULL,
  `numero_clienti` int(11) DEFAULT NULL,
  `incasso_totale` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `giornata_lavorativa`
--

INSERT INTO `giornata_lavorativa` (`id_ristorante`, `data`, `numero_clienti`, `incasso_totale`) VALUES
(1, '2019-02-10', 100, 1000),
(1, '2019-02-11', 150, 1230),
(1, '2019-02-12', 50, 750),
(1, '2019-02-13', 70, 900),
(1, '2019-02-14', 0, 0),
(2, '2019-03-20', 0, 0),
(2, '2019-03-21', 200, 2130),
(2, '2019-03-22', 160, 1750),
(2, '2019-03-23', 90, 1100),
(2, '2019-03-24', 50, 650),
(3, '2019-04-10', 90, 990),
(3, '2019-04-11', 40, 530),
(3, '2019-04-12', 0, 0),
(3, '2019-04-13', 170, 1900),
(3, '2019-04-14', 100, 1250),
(4, '2019-05-10', 120, 1400),
(4, '2019-05-11', 0, 0),
(4, '2019-05-12', 55, 800),
(4, '2019-05-13', 80, 800),
(4, '2019-05-14', 125, 1350),
(5, '2019-06-10', 300, 3500),
(5, '2019-06-11', 150, 2230),
(5, '2019-06-12', 0, 0),
(5, '2019-06-13', 40, 800),
(5, '2019-06-14', 50, 1050),
(6, '2019-07-10', 0, 0),
(6, '2019-07-11', 250, 2740),
(6, '2019-07-12', 65, 850),
(6, '2019-07-13', 170, 1900),
(6, '2019-07-14', 215, 2550),
(7, '2019-08-10', 95, 1100),
(7, '2019-08-11', 170, 2620),
(7, '2019-08-12', 150, 2550),
(7, '2019-08-13', 0, 0),
(7, '2019-08-14', 35, 650),
(8, '2019-09-15', 150, 1700),
(8, '2019-09-16', 50, 730),
(8, '2019-09-17', 0, 0),
(8, '2019-09-18', 120, 1450),
(8, '2019-09-19', 315, 3850);

-- --------------------------------------------------------

--
-- Struttura della tabella `impiego`
--

CREATE TABLE `impiego` (
  `id_dipendente` int(11) NOT NULL,
  `id_ristorante` int(11) NOT NULL,
  `data_inizio` date NOT NULL,
  `tipo` varchar(255) NOT NULL,
  `data_fine` date DEFAULT NULL,
  `salario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `impiego`
--

INSERT INTO `impiego` (`id_dipendente`, `id_ristorante`, `data_inizio`, `tipo`, `data_fine`, `salario`) VALUES
(1, 1, '2015-02-10', 'corrente', NULL, 1500),
(1, 2, '2016-03-13', 'corrente', NULL, 1400),
(1, 3, '2013-02-10', 'passato', '2015-02-09', NULL),
(1, 4, '2014-03-13', 'passato', '2015-02-09', NULL),
(2, 1, '2015-02-14', 'corrente', NULL, 1400),
(2, 2, '2014-03-03', 'corrente', NULL, 1200),
(2, 3, '2016-05-13', 'corrente', NULL, 1350),
(2, 4, '2014-02-15', 'corrente', NULL, 1050),
(2, 5, '2013-02-14', 'passato', '2015-02-13', NULL),
(2, 6, '2012-03-03', 'passato', '2015-02-13', NULL),
(2, 7, '2014-05-13', 'passato', '2016-05-12', NULL),
(2, 8, '2013-02-15', 'passato', '2016-05-12', NULL),
(3, 1, '2014-02-17', 'passato', '2016-02-17', NULL),
(3, 2, '2013-11-12', 'passato', '2016-02-17', NULL),
(3, 3, '2013-05-29', 'passato', '2016-02-17', NULL),
(3, 4, '2014-07-19', 'passato', '2016-02-17', NULL),
(3, 5, '2014-02-17', 'corrente', NULL, 1500),
(3, 6, '2018-11-12', 'corrente', NULL, 1400),
(3, 7, '2016-05-29', 'corrente', NULL, 1600),
(3, 8, '2017-07-19', 'corrente', NULL, 1400),
(4, 1, '2012-02-10', 'passato', '2013-02-09', NULL),
(4, 2, '2011-06-15', 'passato', '2013-02-09', NULL),
(4, 3, '2013-02-10', 'corrente', NULL, 950),
(4, 5, '2016-06-15', 'corrente', NULL, 1100),
(5, 3, '2012-02-12', 'passato', '2014-02-11', NULL),
(5, 5, '2014-02-12', 'corrente', NULL, 1850),
(5, 6, '2016-06-13', 'corrente', NULL, 2100),
(5, 7, '2013-06-13', 'passato', '2014-02-11', NULL),
(6, 4, '2013-12-11', 'passato', '2015-12-10', NULL),
(6, 5, '2015-12-11', 'corrente', NULL, 1550),
(6, 6, '2016-05-14', 'corrente', NULL, 1600),
(6, 8, '2012-05-14', 'passato', '2015-12-10', NULL),
(7, 1, '2015-03-20', 'passato', '2017-03-19', NULL),
(7, 6, '2016-03-23', 'passato', '2017-03-19', NULL),
(7, 7, '2017-03-20', 'corrente', NULL, 900),
(7, 8, '2016-03-23', 'corrente', NULL, 800),
(8, 1, '2013-02-21', 'passato', '2015-02-20', NULL),
(8, 3, '2016-07-17', 'corrente', NULL, 1000),
(8, 4, '2014-07-17', 'passato', '2015-02-20', NULL),
(8, 8, '2015-02-21', 'corrente', NULL, 1400),
(9, 2, '2015-05-10', 'corrente', NULL, 1700),
(9, 3, '2014-05-10', 'passato', '2015-05-09', NULL),
(9, 5, '2016-09-30', 'corrente', NULL, 2000),
(9, 6, '2012-09-30', 'passato', '2015-05-09', NULL),
(10, 1, '2015-01-29', 'corrente', NULL, 950),
(10, 2, '2013-01-29', 'passato', '2015-01-28', NULL),
(10, 7, '2012-08-24', 'passato', '2015-01-28', NULL),
(10, 8, '2016-08-24', 'corrente', NULL, 1050),
(11, 2, '2015-05-15', 'corrente', NULL, 1200),
(11, 3, '2018-02-19', 'corrente', NULL, 1100),
(11, 4, '2012-05-15', 'passato', '2015-05-14', NULL),
(11, 6, '2012-02-19', 'passato', '2015-05-14', NULL),
(12, 5, '2011-02-10', 'passato', '2013-02-09', NULL),
(12, 6, '2019-02-10', 'corrente', NULL, 1400),
(12, 7, '2013-04-03', 'corrente', NULL, 1350),
(12, 8, '2010-04-03', 'passato', '2013-02-09', NULL),
(13, 1, '2017-07-09', 'passato', '2019-07-08', NULL),
(13, 3, '2016-01-03', 'passato', '2019-07-08', NULL),
(13, 4, '2019-07-09', 'corrente', NULL, 1500),
(13, 5, '2018-01-03', 'corrente', NULL, 1100),
(14, 1, '2012-02-17', 'passato', '2014-02-16', NULL),
(14, 2, '2014-02-17', 'corrente', NULL, 1150),
(14, 5, '2013-05-24', 'passato', '2014-02-16', NULL),
(14, 8, '2016-05-24', 'corrente', NULL, 1300),
(15, 2, '2017-06-18', 'passato', '2019-06-17', NULL),
(15, 4, '2019-06-18', 'corrente', NULL, 2500),
(15, 6, '2011-06-20', 'passato', '2013-06-17', NULL),
(15, 7, '2012-06-20', 'corrente', NULL, 2150),
(16, 1, '2013-11-20', 'corrente', NULL, 1900),
(16, 3, '2011-11-20', 'passato', '2013-11-19', NULL),
(16, 4, '2014-10-15', 'corrente', NULL, 1750),
(16, 7, '2010-10-15', 'passato', '2013-11-19', NULL),
(17, 4, '2014-11-27', 'corrente', NULL, 950),
(17, 5, '2012-11-27', 'passato', '2014-11-26', NULL),
(17, 7, '2017-10-28', 'corrente', NULL, 1300),
(17, 8, '2013-10-28', 'passato', '2014-11-26', NULL),
(18, 1, '2014-09-26', 'passato', '2015-09-25', NULL),
(18, 2, '2015-09-26', 'corrente', NULL, 2250),
(18, 5, '2014-07-25', 'passato', '2015-09-25', NULL),
(18, 6, '2016-07-25', 'corrente', NULL, 2500),
(19, 3, '2018-06-30', 'corrente', NULL, 2200),
(19, 4, '2016-06-30', 'passato', '2018-06-29', NULL),
(19, 5, '2019-02-14', 'corrente', NULL, 2600),
(19, 7, '2017-02-14', 'passato', '2018-06-29', NULL),
(20, 1, '2014-10-30', 'corrente', NULL, 1450),
(20, 3, '2012-10-30', 'passato', '2014-10-29', NULL),
(20, 7, '2017-12-01', 'corrente', NULL, 1000),
(20, 8, '2011-12-01', 'passato', '2014-10-29', NULL);

--
-- Trigger `impiego`
--
DELIMITER $$
CREATE TRIGGER `trigger1` BEFORE INSERT ON `impiego` FOR EACH ROW begin
if (new.tipo = 'corrente') then
	if (select count(*)
		from impiego
		where id_ristorante = new.id_ristorante and tipo = 'corrente') >= 8
	then signal sqlstate '45000' set message_text = 'Il ristorante non può avere più di 8 dipendenti';
	end if;
end if;

end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `preferiti`
--

CREATE TABLE `preferiti` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `costo` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- --------------------------------------------------------

--
-- Struttura della tabella `prodotto`
--

CREATE TABLE `prodotto` (
  `id` int(11) NOT NULL,
  `merce` varchar(255) DEFAULT NULL,
  `costo` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `prodotto`
--

INSERT INTO `prodotto` (`id`, `merce`, `costo`) VALUES
(1, 'Pasta barilla', 1.5),
(2, 'Carne di suino', 9.8),
(3, 'Pesce spada', 27.9),
(4, 'Acqua san benedetto', 0.7),
(5, 'Pane', 2),
(6, 'Coca cola', 1.2),
(7, 'Polpa di pomodoro', 0.9),
(8, 'Tovaglie', 3.4);

-- --------------------------------------------------------

--
-- Struttura della tabella `ristorante`
--

CREATE TABLE `ristorante` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `indirizzo` varchar(255) DEFAULT NULL,
  `descrizione` varchar(255) DEFAULT NULL,
  `immagine` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `ristorante`
--

INSERT INTO `ristorante` (`id`, `username`, `password`, `email`, `nome`, `indirizzo`, `descrizione`, `immagine`) VALUES
(1, 'admin1', 'pass1', 'em1@gmail.com', 'Osteria del pesce', 'Via Verdi 18', 'L\'Osteria del pesce è un ristorante in cui il culto del pesce viene curato nel dettaglio, una cucina semplice ma gustosa. Piatti abbondanti, ricchi di varietà di pesce di qualità.', 'Immagini/ristoranti0.jpg'),
(2, 'admin2', 'pass2', 'em2@gmail.com', 'Orient Express', 'Via Pisa 7', 'Riscoprite il piacere di viaggiare in treno mentre attraversate le città più affascinanti d\'Europa.', 'Immagini/ristoranti1.jpg'),
(3, 'admin3', 'pass3', 'em3@gmail.com', 'Pataclara', 'Via Roma 53', 'Locale piccolo e tranquillo con cucina ricercata. Ottimo servizio al tavolo del cameriere e le sue proposte sui vini da abbinare. Scelta del menù molto buona con un paio di pietanze fuori menù assolutamente da assaggiare.', 'Immagini/ristoranti2.jpg'),
(4, 'admin4', 'pass4', 'em4@gmail.com', 'French Laundry', 'Via Etna 21', 'Uno chef di alto livello, cibo fantastico, la pasticceria sublime e il servizio accurato. Un esperienza indimenticabile.', 'Immagini/ristoranti3.jpg'),
(5, 'admin5', 'pass5', 'em5@gmail.com', 'Pizza Pazza', 'Via Empedocle 36', 'Personale gentile e disponibile, pizzaioli bravissimi, pizza buonissima e a buon prezzo. Ottima pizzeria !', 'Immagini/ristoranti4.jpg'),
(6, 'admin6', 'pass6', 'em6@gmail.com', 'Ai spaghettari', 'Via Roma 6', 'Ristorante piacevole, personale cortese, cibo di ottima qualità, sia specialità romane che menù di pesce. Prezzi leggermente più cari di altri ristoranti ma ne vale davvero la pena !', 'Immagini/ristoranti5.jpg'),
(7, 'admin7', 'pass7', 'em7@gmail.com', 'La porta', 'Via Bologna 10', 'Staff preparato e veloce, piatti fatti alla perfezione. Ristorante molto raffinato, le porzioni sono abbondanti e l\' abbinamento con i vini e\' perfetto. Da provare assolutamente !', 'Immagini/ristoranti6.jpg'),
(8, 'admin8', 'pass8', 'em8@gmail.com', 'Morelli', 'Via Milano 42', 'Bellissima e raffinata location che permette di scegliere sale raffinate ed eleganti o sale interne ed esterne stile bistrot raffinato. Qualità dei piatti eccelsa, ampia e molto valida carta dei vini, personale simpatico e cordiale. Da consigliare !', 'Immagini/ristoranti7.jpg');

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `ristoranti_fornitori_prodotti`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `ristoranti_fornitori_prodotti` (
`codice_ristorante` int(11)
,`nome_ristorante` varchar(255)
,`indirizzo_ristorante` varchar(255)
,`codice_fornitore` int(11)
,`nome_fornitore` varchar(255)
,`indirizzo_fornitore` varchar(255)
,`codice_prodotto` int(11)
,`descrizione_prodotto` varchar(255)
,`costo_prodotto` float
,`data_acquisto` date
,`quantita` int(11)
,`spesa_totale` float
);

-- --------------------------------------------------------

--
-- Struttura della tabella `temp`
--

CREATE TABLE `temp` (
  `id` int(11) DEFAULT NULL,
  `costo` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Trigger `temp`
--
DELIMITER $$
CREATE TRIGGER `trigger2` AFTER INSERT ON `temp` FOR EACH ROW begin

update fornitura
set spesa = quantita * new.costo
where id_prodotto = new.id;

end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura per vista `ristoranti_fornitori_prodotti`
--
DROP TABLE IF EXISTS `ristoranti_fornitori_prodotti`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ristoranti_fornitori_prodotti`  AS SELECT `r`.`id` AS `codice_ristorante`, `r`.`nome` AS `nome_ristorante`, `r`.`indirizzo` AS `indirizzo_ristorante`, `f2`.`id` AS `codice_fornitore`, `f2`.`nome` AS `nome_fornitore`, `f2`.`indirizzo` AS `indirizzo_fornitore`, `p`.`id` AS `codice_prodotto`, `p`.`merce` AS `descrizione_prodotto`, `p`.`costo` AS `costo_prodotto`, `f1`.`data` AS `data_acquisto`, `f1`.`quantita` AS `quantita`, `f1`.`spesa` AS `spesa_totale` FROM (((`ristorante` `r` join `fornitura` `f1` on(`r`.`id` = `f1`.`id_ristorante`)) join `fornitore` `f2` on(`f2`.`id` = `f1`.`id_fornitore`)) join `prodotto` `p` on(`p`.`id` = `f1`.`id_prodotto`)) ;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `dipendente`
--
ALTER TABLE `dipendente`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `fornitore`
--
ALTER TABLE `fornitore`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indici per le tabelle `fornitura`
--
ALTER TABLE `fornitura`
  ADD PRIMARY KEY (`id_ristorante`,`id_fornitore`,`id_prodotto`,`data`),
  ADD KEY `idx_id_ristorante_fornitura` (`id_ristorante`),
  ADD KEY `idx_id_fornitore_fornitura` (`id_fornitore`),
  ADD KEY `idx_id_prodotto_fornitura` (`id_prodotto`);

--
-- Indici per le tabelle `giornata_lavorativa`
--
ALTER TABLE `giornata_lavorativa`
  ADD PRIMARY KEY (`id_ristorante`,`data`),
  ADD KEY `idx_id_ristorante_giornata_lavorativa` (`id_ristorante`);

--
-- Indici per le tabelle `impiego`
--
ALTER TABLE `impiego`
  ADD PRIMARY KEY (`id_dipendente`,`id_ristorante`,`data_inizio`),
  ADD KEY `idx_id_dipendente_impiego` (`id_dipendente`),
  ADD KEY `idx_id_ristorante_impiego` (`id_ristorante`);

--
-- Indici per le tabelle `preferiti`
--
ALTER TABLE `preferiti`
  ADD PRIMARY KEY (`id`,`nome`),
  ADD KEY `idx_id_preferiti` (`id`);

--
-- Indici per le tabelle `prodotto`
--
ALTER TABLE `prodotto`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `ristorante`
--
ALTER TABLE `ristorante`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Limiti per le tabelle scaricate
--
--
-- Limiti per la tabella `fornitura`
--
ALTER TABLE `fornitura`
  ADD CONSTRAINT `fornitura_ibfk_1` FOREIGN KEY (`id_ristorante`) REFERENCES `ristorante` (`id`),
  ADD CONSTRAINT `fornitura_ibfk_2` FOREIGN KEY (`id_fornitore`) REFERENCES `fornitore` (`id`),
  ADD CONSTRAINT `fornitura_ibfk_3` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotto` (`id`);

--
-- Limiti per la tabella `giornata_lavorativa`
--
ALTER TABLE `giornata_lavorativa`
  ADD CONSTRAINT `giornata_lavorativa_ibfk_1` FOREIGN KEY (`id_ristorante`) REFERENCES `ristorante` (`id`);

--
-- Limiti per la tabella `impiego`
--
ALTER TABLE `impiego`
  ADD CONSTRAINT `impiego_ibfk_1` FOREIGN KEY (`id_dipendente`) REFERENCES `dipendente` (`id`),
  ADD CONSTRAINT `impiego_ibfk_2` FOREIGN KEY (`id_ristorante`) REFERENCES `ristorante` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
