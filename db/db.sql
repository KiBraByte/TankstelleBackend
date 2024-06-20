USE [master]
GO
/****** Object:  Database [Cardserver_Schueler]    Script Date: 18.06.2024 08:31:57 ******/
CREATE DATABASE [Cardserver_Schueler]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Cardserver_Schueler', FILENAME = N'/var/opt/mssql/data/Cardserver_Schueler.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Cardserver_Schueler_log', FILENAME = N'/var/opt/mssql/data/Cardserver_Schueler_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Cardserver_Schueler] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Cardserver_Schueler].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Cardserver_Schueler] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET ARITHABORT OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Cardserver_Schueler] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Cardserver_Schueler] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Cardserver_Schueler] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Cardserver_Schueler] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET RECOVERY FULL 
GO
ALTER DATABASE [Cardserver_Schueler] SET  MULTI_USER 
GO
ALTER DATABASE [Cardserver_Schueler] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Cardserver_Schueler] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Cardserver_Schueler] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Cardserver_Schueler] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Cardserver_Schueler] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Cardserver_Schueler] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Cardserver_Schueler', N'ON'
GO
ALTER DATABASE [Cardserver_Schueler] SET QUERY_STORE = OFF
GO
USE [Cardserver_Schueler]
GO
/****** Object:  User [TankReaderWriter]    Script Date: 18.06.2024 08:31:57 ******/
CREATE USER [TankReaderWriter] FOR LOGIN [TankSysAdmin] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [TankReaderWriter]
GO
ALTER ROLE [db_datareader] ADD MEMBER [TankReaderWriter]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [TankReaderWriter]
GO
/****** Object:  UserDefinedFunction [dbo].[f_count_tankkarten]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[f_count_tankkarten] 
(
	-- Add the parameters for the function here
	@param_kundenNr int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
		-- Declare the return variable here
	DECLARE @c int;

	SET @c = (SELECT Count(Tankkarte.KNr) FROM Tankkarte WHERE Tankkarte.KNr = @param_kundenNr);

	RETURN @c;
END
GO
/****** Object:  UserDefinedFunction [dbo].[f_get_produkt_by_name]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kilian Brandstoetter
-- Create date: 08.06.2024
-- Description:	Gets a Produkt id by its name, returns -1 of none was found, CASE INSENSITIVE
-- =============================================
CREATE FUNCTION [dbo].[f_get_produkt_by_name]
(
	-- Add the parameters for the function here
	@param_produkt_name VARCHAR(20)
)
RETURNS INT
AS
BEGIN

    -- Insert statements for procedure here
	DECLARE @produkt_id int;

	SELECT @produkt_id = Produkt.PID FROM Produkt WHERE UPPER(Produkt.Produktname) = UPPER(@param_produkt_name);

	RETURN ISNULL(@produkt_id, -1);
END
GO
/****** Object:  Table [dbo].[AbrechnungsPeriode]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AbrechnungsPeriode](
	[ABNr] [int] IDENTITY(1,1) NOT NULL,
	[startDatum] [date] NULL,
	[endDatum] [date] NULL,
 CONSTRAINT [PK_AbrechnungsPeriode] PRIMARY KEY CLUSTERED 
(
	[ABNr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Kunde]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Kunde](
	[KNr] [int] IDENTITY(1,1) NOT NULL,
	[Firmenname] [varchar](50) NULL,
	[Status] [bit] NULL,
	[Kundenlimit] [smallint] NULL,
 CONSTRAINT [PK_Kunde] PRIMARY KEY CLUSTERED 
(
	[KNr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Produkt]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Produkt](
	[PID] [smallint] IDENTITY(1,1) NOT NULL,
	[Produktname] [varchar](20) NOT NULL,
	[Beschreibung] [varchar](255) NULL,
	[Einheit] [varchar](5) NULL,
 CONSTRAINT [PK_Produkt] PRIMARY KEY CLUSTERED 
(
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rabattcode]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rabattcode](
	[RCNr] [int] IDENTITY(1,1) NOT NULL,
	[PreisProEinheit] [smallmoney] NULL,
	[RabattInCent] [smallint] NULL,
	[PID] [smallint] NULL,
 CONSTRAINT [RCNr] PRIMARY KEY CLUSTERED 
(
	[RCNr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Relat_Abrechnung_Tankung]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Relat_Abrechnung_Tankung](
	[ABNr] [int] NOT NULL,
	[TNr] [int] NOT NULL,
 CONSTRAINT [PK_Relat_Abrechnung_Tankung] PRIMARY KEY CLUSTERED 
(
	[ABNr] ASC,
	[TNr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Relat_Kunde_Rabattcode]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Relat_Kunde_Rabattcode](
	[RKRNr] [int] IDENTITY(1,1) NOT NULL,
	[KNr] [int] NULL,
	[RCNr] [int] NULL,
	[gueltigVon] [date] NULL,
	[gueltigBis] [date] NULL,
 CONSTRAINT [PK_Relat_Kunde_Rabattcode] PRIMARY KEY CLUSTERED 
(
	[RKRNr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Relat_Tankkarte_Produkt]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Relat_Tankkarte_Produkt](
	[PAN] [varchar](30) NOT NULL,
	[PID] [smallint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tankkarte]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tankkarte](
	[PAN] [varchar](30) NOT NULL,
	[ausgestelltAuf] [varchar](50) NULL,
	[gueltigBis] [date] NULL,
	[KNr] [int] NOT NULL,
	[Ausstellungsdatum] [date] NULL,
	[Status] [bit] NULL,
	[Kartenlimit] [smallmoney] NULL,
 CONSTRAINT [PK_Kundenkarte] PRIMARY KEY CLUSTERED 
(
	[PAN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tankstelle]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tankstelle](
	[TSNr] [int] NOT NULL,
	[TSName] [varchar](50) NULL,
 CONSTRAINT [PK_Tankstelle] PRIMARY KEY CLUSTERED 
(
	[TSNr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tankung]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tankung](
	[TNr] [int] IDENTITY(1,1) NOT NULL,
	[PAN] [varchar](30) NULL,
	[PID] [smallint] NULL,
	[TSNr] [int] NULL,
	[Menge] [decimal](6, 2) NULL,
	[PreisProEinheit] [smallmoney] NULL,
	[Gesamtpreis] [smallmoney] NULL,
	[TDatum] [datetime] NULL,
	[abgerechnet] [bit] NULL,
 CONSTRAINT [PK_Tankung] PRIMARY KEY CLUSTERED 
(
	[TNr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AbrechnungsPeriode] ON 

INSERT [dbo].[AbrechnungsPeriode] ([ABNr], [startDatum], [endDatum]) VALUES (1, CAST(N'2024-01-01' AS Date), CAST(N'2024-12-01' AS Date))
INSERT [dbo].[AbrechnungsPeriode] ([ABNr], [startDatum], [endDatum]) VALUES (2, CAST(N'2020-01-01' AS Date), CAST(N'2024-12-01' AS Date))
SET IDENTITY_INSERT [dbo].[AbrechnungsPeriode] OFF
GO
SET IDENTITY_INSERT [dbo].[Kunde] ON 

INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (1, N'Fronius', NULL, 20000)
INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (2, N'KTM', NULL, 100)
INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (3, N'Kremsmüller', NULL, 3000)
INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (4, N'test', 1, 5000)
INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (5, N'test2', 0, 5000)
INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (6, N'test2', 0, 5000)
SET IDENTITY_INSERT [dbo].[Kunde] OFF
GO
SET IDENTITY_INSERT [dbo].[Produkt] ON 

INSERT [dbo].[Produkt] ([PID], [Produktname], [Beschreibung], [Einheit]) VALUES (1, N'Super 100', N'Superbenzin mit 100 Oktan', N'l')
INSERT [dbo].[Produkt] ([PID], [Produktname], [Beschreibung], [Einheit]) VALUES (2, N'Super 98', N'Superbenzin mit 98 Oktan', N'l')
INSERT [dbo].[Produkt] ([PID], [Produktname], [Beschreibung], [Einheit]) VALUES (3, N'Super 95', N'Superbenzin mit 95 oder 91 Oktan', N'l')
INSERT [dbo].[Produkt] ([PID], [Produktname], [Beschreibung], [Einheit]) VALUES (4, N'Premium Diesel', N'Premium Diesel mit chem. Zusätzen', N'l')
INSERT [dbo].[Produkt] ([PID], [Produktname], [Beschreibung], [Einheit]) VALUES (5, N'Diesel', N'Standard Diesel', N'l')
INSERT [dbo].[Produkt] ([PID], [Produktname], [Beschreibung], [Einheit]) VALUES (6, N'Biodiesel', N'Diesel mit Bioanteilen', N'l')
SET IDENTITY_INSERT [dbo].[Produkt] OFF
GO
SET IDENTITY_INSERT [dbo].[Rabattcode] ON 

INSERT [dbo].[Rabattcode] ([RCNr], [PreisProEinheit], [RabattInCent], [PID]) VALUES (43, 1.0100, NULL, 5)
INSERT [dbo].[Rabattcode] ([RCNr], [PreisProEinheit], [RabattInCent], [PID]) VALUES (44, 1.0200, NULL, 5)
INSERT [dbo].[Rabattcode] ([RCNr], [PreisProEinheit], [RabattInCent], [PID]) VALUES (45, NULL, 3, 5)
INSERT [dbo].[Rabattcode] ([RCNr], [PreisProEinheit], [RabattInCent], [PID]) VALUES (46, NULL, 4, 5)
INSERT [dbo].[Rabattcode] ([RCNr], [PreisProEinheit], [RabattInCent], [PID]) VALUES (47, 1.5100, NULL, 2)
INSERT [dbo].[Rabattcode] ([RCNr], [PreisProEinheit], [RabattInCent], [PID]) VALUES (48, 1.5200, NULL, 2)
INSERT [dbo].[Rabattcode] ([RCNr], [PreisProEinheit], [RabattInCent], [PID]) VALUES (49, NULL, 3, 2)
INSERT [dbo].[Rabattcode] ([RCNr], [PreisProEinheit], [RabattInCent], [PID]) VALUES (50, NULL, 5, 2)
SET IDENTITY_INSERT [dbo].[Rabattcode] OFF
GO
INSERT [dbo].[Relat_Abrechnung_Tankung] ([ABNr], [TNr]) VALUES (2, 22)
INSERT [dbo].[Relat_Abrechnung_Tankung] ([ABNr], [TNr]) VALUES (2, 23)
INSERT [dbo].[Relat_Abrechnung_Tankung] ([ABNr], [TNr]) VALUES (2, 24)
INSERT [dbo].[Relat_Abrechnung_Tankung] ([ABNr], [TNr]) VALUES (2, 25)
INSERT [dbo].[Relat_Abrechnung_Tankung] ([ABNr], [TNr]) VALUES (2, 26)
INSERT [dbo].[Relat_Abrechnung_Tankung] ([ABNr], [TNr]) VALUES (2, 27)
INSERT [dbo].[Relat_Abrechnung_Tankung] ([ABNr], [TNr]) VALUES (2, 28)
GO
SET IDENTITY_INSERT [dbo].[Relat_Kunde_Rabattcode] ON 

INSERT [dbo].[Relat_Kunde_Rabattcode] ([RKRNr], [KNr], [RCNr], [gueltigVon], [gueltigBis]) VALUES (3, 1, 45, CAST(N'2021-03-17' AS Date), CAST(N'2021-03-23' AS Date))
INSERT [dbo].[Relat_Kunde_Rabattcode] ([RKRNr], [KNr], [RCNr], [gueltigVon], [gueltigBis]) VALUES (4, 1, 46, CAST(N'2021-03-24' AS Date), CAST(N'2021-03-31' AS Date))
INSERT [dbo].[Relat_Kunde_Rabattcode] ([RKRNr], [KNr], [RCNr], [gueltigVon], [gueltigBis]) VALUES (5, 2, 43, CAST(N'2021-03-24' AS Date), CAST(N'2021-03-31' AS Date))
SET IDENTITY_INSERT [dbo].[Relat_Kunde_Rabattcode] OFF
GO
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930000010002-3', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930000010001-3', 4)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930000010003-0', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930000010004-8', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930000020002-0', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930000020003-8', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930000020004-6', 5)
GO
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930000010001-3', N'LKW-Fahrer 0001', CAST(N'2026-06-06' AS Date), 1, NULL, NULL, NULL)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930000010002-3', N'LKW-Fahrer 0002', CAST(N'2026-06-06' AS Date), 1, NULL, NULL, NULL)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930000010003-0', NULL, CAST(N'2025-06-16' AS Date), 1, CAST(N'2024-06-16' AS Date), 1, 1000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930000010004-8', NULL, CAST(N'2025-06-16' AS Date), 1, CAST(N'2024-06-16' AS Date), 1, 1000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930000020001-3', N'LKW-Fahrer 0001', CAST(N'2026-03-19' AS Date), 2, NULL, NULL, NULL)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930000020002-0', NULL, CAST(N'2027-06-17' AS Date), 2, CAST(N'2024-06-17' AS Date), 1, 10000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930000020003-8', NULL, CAST(N'2027-06-17' AS Date), 2, CAST(N'2024-06-17' AS Date), 1, 10000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930000020004-6', NULL, CAST(N'2027-06-17' AS Date), 2, CAST(N'2024-06-17' AS Date), 1, 10000.0000)
GO
INSERT [dbo].[Tankstelle] ([TSNr], [TSName]) VALUES (40100, N'TS BP Linz Frankviertel')
INSERT [dbo].[Tankstelle] ([TSNr], [TSName]) VALUES (40200, N'TS BP Traunerkreuzung')
INSERT [dbo].[Tankstelle] ([TSNr], [TSName]) VALUES (40800, N'TS Eni Eferding')
INSERT [dbo].[Tankstelle] ([TSNr], [TSName]) VALUES (50100, N'TS Shell Wels Kaserne')
INSERT [dbo].[Tankstelle] ([TSNr], [TSName]) VALUES (50200, N'TS Shell Eberstalzell')
GO
SET IDENTITY_INSERT [dbo].[Tankung] ON 

INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (22, N'7000930000020001-3', 5, 40100, CAST(20.00 AS Decimal(6, 2)), 1.0900, 21.8000, CAST(N'2021-03-26T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (23, N'7000930000020001-3', 5, 40100, CAST(20.00 AS Decimal(6, 2)), 1.0900, 21.8000, CAST(N'2021-03-26T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (24, N'7000930000020001-3', 5, 40100, CAST(20.00 AS Decimal(6, 2)), 1.0900, 21.8000, CAST(N'2021-03-26T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (25, N'7000930000020001-3', 5, 40100, CAST(20.00 AS Decimal(6, 2)), 1.0900, 21.8000, CAST(N'2021-03-26T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (26, N'7000930000020001-3', 5, 40100, CAST(20.00 AS Decimal(6, 2)), 1.0900, 21.8000, CAST(N'2021-03-26T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (27, N'7000930000020001-3', 5, 40100, CAST(20.00 AS Decimal(6, 2)), 1.0900, 21.8000, CAST(N'2021-03-26T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (28, N'7000930000020001-3', 5, 40100, CAST(20.00 AS Decimal(6, 2)), 1.0900, 21.8000, CAST(N'2021-03-26T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (32, N'7000930000010004-8', 5, 40100, CAST(60.00 AS Decimal(6, 2)), 1.5000, 90.0000, CAST(N'2024-06-17T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (33, N'7000930000010004-8', 5, 40100, CAST(60.00 AS Decimal(6, 2)), 1.5000, 90.0000, CAST(N'2024-06-17T00:00:00.000' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[Tankung] OFF
GO
ALTER TABLE [dbo].[Rabattcode]  WITH CHECK ADD  CONSTRAINT [FK_Rabattcode_Produkt] FOREIGN KEY([PID])
REFERENCES [dbo].[Produkt] ([PID])
GO
ALTER TABLE [dbo].[Rabattcode] CHECK CONSTRAINT [FK_Rabattcode_Produkt]
GO
ALTER TABLE [dbo].[Relat_Abrechnung_Tankung]  WITH CHECK ADD  CONSTRAINT [FK_Relat_Abrechnung_Tankung_AbrechnungsPeriode] FOREIGN KEY([ABNr])
REFERENCES [dbo].[AbrechnungsPeriode] ([ABNr])
GO
ALTER TABLE [dbo].[Relat_Abrechnung_Tankung] CHECK CONSTRAINT [FK_Relat_Abrechnung_Tankung_AbrechnungsPeriode]
GO
ALTER TABLE [dbo].[Relat_Abrechnung_Tankung]  WITH CHECK ADD  CONSTRAINT [FK_Relat_Abrechnung_Tankung_Tankung] FOREIGN KEY([TNr])
REFERENCES [dbo].[Tankung] ([TNr])
GO
ALTER TABLE [dbo].[Relat_Abrechnung_Tankung] CHECK CONSTRAINT [FK_Relat_Abrechnung_Tankung_Tankung]
GO
ALTER TABLE [dbo].[Relat_Kunde_Rabattcode]  WITH CHECK ADD  CONSTRAINT [FK_Relat_Kunde_Rabattcode_Kunde] FOREIGN KEY([KNr])
REFERENCES [dbo].[Kunde] ([KNr])
GO
ALTER TABLE [dbo].[Relat_Kunde_Rabattcode] CHECK CONSTRAINT [FK_Relat_Kunde_Rabattcode_Kunde]
GO
ALTER TABLE [dbo].[Relat_Kunde_Rabattcode]  WITH CHECK ADD  CONSTRAINT [FK_Relat_Kunde_Rabattcode_Rabattcode] FOREIGN KEY([RCNr])
REFERENCES [dbo].[Rabattcode] ([RCNr])
GO
ALTER TABLE [dbo].[Relat_Kunde_Rabattcode] CHECK CONSTRAINT [FK_Relat_Kunde_Rabattcode_Rabattcode]
GO
ALTER TABLE [dbo].[Relat_Tankkarte_Produkt]  WITH CHECK ADD  CONSTRAINT [FK_Relat_Tankkarte_Produkt_Produkt] FOREIGN KEY([PID])
REFERENCES [dbo].[Produkt] ([PID])
GO
ALTER TABLE [dbo].[Relat_Tankkarte_Produkt] CHECK CONSTRAINT [FK_Relat_Tankkarte_Produkt_Produkt]
GO
ALTER TABLE [dbo].[Relat_Tankkarte_Produkt]  WITH CHECK ADD  CONSTRAINT [FK_Relat_Tankkarte_Produkt_Tankkarte] FOREIGN KEY([PAN])
REFERENCES [dbo].[Tankkarte] ([PAN])
GO
ALTER TABLE [dbo].[Relat_Tankkarte_Produkt] CHECK CONSTRAINT [FK_Relat_Tankkarte_Produkt_Tankkarte]
GO
ALTER TABLE [dbo].[Tankkarte]  WITH CHECK ADD  CONSTRAINT [FK_Kundenkarte_Kunde] FOREIGN KEY([KNr])
REFERENCES [dbo].[Kunde] ([KNr])
GO
ALTER TABLE [dbo].[Tankkarte] CHECK CONSTRAINT [FK_Kundenkarte_Kunde]
GO
ALTER TABLE [dbo].[Tankung]  WITH CHECK ADD  CONSTRAINT [FK_Tankung_Produkt] FOREIGN KEY([PID])
REFERENCES [dbo].[Produkt] ([PID])
GO
ALTER TABLE [dbo].[Tankung] CHECK CONSTRAINT [FK_Tankung_Produkt]
GO
ALTER TABLE [dbo].[Tankung]  WITH CHECK ADD  CONSTRAINT [FK_Tankung_Tankkarte] FOREIGN KEY([PAN])
REFERENCES [dbo].[Tankkarte] ([PAN])
GO
ALTER TABLE [dbo].[Tankung] CHECK CONSTRAINT [FK_Tankung_Tankkarte]
GO
ALTER TABLE [dbo].[Tankung]  WITH CHECK ADD  CONSTRAINT [FK_Tankung_Tankstelle] FOREIGN KEY([TSNr])
REFERENCES [dbo].[Tankstelle] ([TSNr])
GO
ALTER TABLE [dbo].[Tankung] CHECK CONSTRAINT [FK_Tankung_Tankstelle]
GO
/****** Object:  StoredProcedure [dbo].[sp_berechne_abrechnung]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_berechne_abrechnung]
	-- Add the parameters for the stored procedure here
	@begin_date DATE,
	@end_date DATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ABNr int;
	DECLARE @TNr int;
	INSERT INTO AbrechnungsPeriode VALUES(@begin_date, @end_date);
	SET @ABNr = @@IDENTITY;


	IF (CURSOR_STATUS('global', 'TankungsCursor') >= -1)
	BEGIN
		DEALLOCATE TankungsCursor;
	END


	DECLARE TankungsCursor INSENSITIVE CURSOR FOR
	SELECT Tankung.TNr FROM Tankung 
	WHERE ISNULL(Tankung.abgerechnet, 0) = 0 AND Tankung.TDatum >= @begin_date AND Tankung.TDatum <= @end_date;

	OPEN TankungsCursor
	FETCH NEXT FROM TankungsCursor INTO @TNr;

	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		UPDATE Tankung SET Tankung.abgerechnet = 1 WHERE Tankung.TNr = @TNr;

		INSERT INTO Relat_Abrechnung_Tankung(ABNr, TNr) VALUES(@ABNr, @TNr);


		FETCH NEXT FROM TankungsCursor INTO @TNr;
	END
	RETURN @ABNr;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_abrechnung_for_id]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_abrechnung_for_id]
	-- Add the parameters for the stored procedure here
	@param_knr int,
	@param_abnr int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @param_knr, SUM(Tankung.Gesamtpreis) FROM Kunde
	LEFT JOIN Tankkarte ON Tankkarte.KNr = Kunde.KNr
	JOIN Tankung ON Tankung.PAN = Tankkarte.PAN
	JOIN Relat_Abrechnung_Tankung ON Relat_Abrechnung_Tankung.TNr = Tankung.TNr AND Relat_Abrechnung_Tankung.ABNr = @param_abnr
	WHERE Kunde.KNr = @param_knr
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_kunden_daten]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- sp_get_kunden_daten 2
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_kunden_daten]
	-- Add the parameters for the stored procedure here
	@param_kunden_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @total_fuel_cost SMALLMONEY;
	DECLARE @company_name VARCHAR(50);
	DECLARE @limit SMALLMONEY;

	SET @total_fuel_cost = ISNULL((SELECT SUM(Tankung.Menge) FROM Tankkarte
			JOIN Tankung ON Tankung.PAN = Tankkarte.PAN
			WHERE Tankkarte.KNr = @param_kunden_id), 0);

	SELECT @company_name = Kunde.Firmenname, @limit = Kunde.Kundenlimit FROM Kunde WHERE Kunde.KNr = @param_kunden_id; 



	SELECT @company_name, @limit, @total_fuel_cost, Produkt.Produktname FROM Tankkarte
	LEFT JOIN Relat_Tankkarte_Produkt ON Relat_Tankkarte_Produkt.PAN = Tankkarte.PAN
	LEFT JOIN Produkt ON Produkt.PID = Relat_Tankkarte_Produkt.PID
	WHERE Tankkarte.KNr = @param_kunden_id
	GROUP BY Produkt.Produktname;	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_letzte_abrechnung_for]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_letzte_abrechnung_for]
	-- Add the parameters for the stored procedure here
	@kundenNr int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ABNr int;

	SELECT @ABNr = AbrechnungsPeriode.ABNr FROM AbrechnungsPeriode ORDER BY AbrechnungsPeriode.ABNr ASC;

	EXEC sp_get_abrechnung_for_id @kundenNr, @ABNr;

END
GO
/****** Object:  StoredProcedure [dbo].[sp_kunde_erstellen]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_kunde_erstellen]
	-- Add the parameters for the stored procedure here
	@param_firmenname VARCHAR(50),
	@param_status BIT,
	@param_kundenlimit SMALLINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO Kunde(Firmenname, Status, Kundenlimit) VALUES(@param_firmenname, @param_status, @param_kundenlimit);
	RETURN @@IDENTITY
END
GO
/****** Object:  StoredProcedure [dbo].[sp_tankkarte_erstellen]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_tankkarte_erstellen]
	-- Add the parameters for the stored procedure here
	@param_kundenNr INT,
	@param_pan VARCHAR(30),
	@param_bis DATE,
	@param_limit SMALLMONEY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @produkt VARCHAR(20);
	DECLARE @pid SMALLINT;
	DECLARE @von DATE;

	SET @produkt = 'Diesel';
	SET @pid = [dbo].f_get_produkt_by_name(@produkt);

	SET @von = GETDATE();

	INSERT INTO Tankkarte(PAN, gueltigBis, KNr, Ausstellungsdatum, Status, Kartenlimit) VALUES(@param_pan, @param_bis, @param_kundenNr, @von, 1, @param_limit);

	INSERT INTO Relat_Tankkarte_Produkt(PAN, PID) VALUES(@param_pan, @pid);
END
GO
/****** Object:  StoredProcedure [dbo].[sp_tankung_erstellen]    Script Date: 18.06.2024 08:31:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_tankung_erstellen]
	-- Add the parameters for the stored procedure here
	@param_pan VARCHAR(30),
	@param_tsnr INT,
	@param_menge DECIMAL,
	@param_preis_pro_einheit SMALLMONEY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @produkt VARCHAR(20);
	DECLARE @pid SMALLINT;
	DECLARE @now DATE;

	SET @produkt = 'Diesel';
	SET @pid = [dbo].f_get_produkt_by_name(@produkt);
	SET @now = GETDATE();

	DECLARE @gesamt_preis SMALLMONEY;
	SET @gesamt_preis = @param_menge * @param_preis_pro_einheit;

    DECLARE @kartenLimit SMALLMONEY;
	DECLARE @kartenStatus BIT;
	DECLARE @kartenBis DATE;
	DECLARE @karteKannBezahlWerden BIT;
	DECLARE @karteCurrSpent SMALLMONEY;

	DECLARE @KNR INT;
	DECLARE @kundenLimit SMALLINT;
	DECLARE @kundenStatus BIT;
	DECLARE @kundeCurrSpent SMALLMONEY;

	SELECT @kartenLimit = Tankkarte.Kartenlimit, @kartenStatus = Tankkarte.Status, @kartenBis = Tankkarte.gueltigBis, @KNR = Tankkarte.KNr 
	FROM Tankkarte 
	WHERE Tankkarte.PAN = @param_pan;

	SET @karteKannBezahlWerden = ISNULL((SELECT Relat_Tankkarte_Produkt.PID FROM Relat_Tankkarte_Produkt 
								WHERE Relat_Tankkarte_Produkt.PAN = @param_pan AND Relat_Tankkarte_Produkt.PID = @pid), 0);


	SELECT @kundenLimit = Kunde.Kundenlimit, @kundenStatus = Kunde.Status 
	FROM Kunde 
	WHERE Kunde.KNr = @KNR;

	IF (ISNULL(@kartenBis, '1970-1-1') != '1970-1-1' AND @kartenBis < @now) 
		RETURN 1;
	
	IF (ISNULL(@kartenStatus, 1) = 0)
		RETURN 2;

	SET @karteCurrSpent = ISNULL((SELECT SUM(Tankung.Gesamtpreis) FROM Tankung WHERE Tankung.PAN = @param_pan), 0);

	IF (ISNULL(@kartenLimit, -1) != -1 AND @kartenLimit < @karteCurrSpent + @gesamt_preis)
		RETURN 3;

	IF(@karteKannBezahlWerden = 0) 
		RETURN 4;

	IF(ISNULL(@kundenStatus, 1) = 0)
		RETURN 5;

	SET @kundeCurrSpent = ISNULL((SELECT SUM(Tankung.GesamtPreis) FROM Kunde
							JOIN Tankkarte ON Tankkarte.KNr = @KNR
							JOIN Tankung ON Tankung.PAN = Tankkarte.PAN), 0);

	IF(ISNULL(@kundenLimit, -1) != -1 AND @kundenLimit < @kundeCurrSpent + @gesamt_preis)
		RETURN 6;

	DECLARE @TNr INT;
	INSERT INTO Tankung(PAN, PID, TSNr,Menge,PreisProEinheit,Gesamtpreis,TDatum, abgerechnet) 
				VALUES(@param_pan, @pid, @param_tsnr, @param_menge, @param_preis_pro_einheit, @gesamt_preis, @now, 0);
	SET @TNr = @@IDENTITY;

	RETURN 0;
END
GO
USE [master]
GO
ALTER DATABASE [Cardserver_Schueler] SET  READ_WRITE 
GO
