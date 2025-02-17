USE [master]
GO
/****** Object:  Database [Cardserver_Schueler]    Script Date: 21.06.2024 00:08:49 ******/
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
/****** Object:  User [TankReaderWriter]    Script Date: 21.06.2024 00:08:49 ******/
CREATE USER [TankReaderWriter] FOR LOGIN [TankSysAdmin] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [TankReaderWriter]
GO
ALTER ROLE [db_datareader] ADD MEMBER [TankReaderWriter]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [TankReaderWriter]
GO
/****** Object:  UserDefinedFunction [dbo].[f_count_tankkarten]    Script Date: 21.06.2024 00:08:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kilian brandstoetter
-- Create date: 20.06.2024
-- Description:	zaehlt tankkarten
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
/****** Object:  UserDefinedFunction [dbo].[f_get_produkt_by_name]    Script Date: 21.06.2024 00:08:49 ******/
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
/****** Object:  Table [dbo].[AbrechnungsPeriode]    Script Date: 21.06.2024 00:08:49 ******/
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
/****** Object:  Table [dbo].[AccountRole]    Script Date: 21.06.2024 00:08:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountRole](
	[RNr] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[RNr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Kunde]    Script Date: 21.06.2024 00:08:49 ******/
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
/****** Object:  Table [dbo].[Produkt]    Script Date: 21.06.2024 00:08:49 ******/
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
/****** Object:  Table [dbo].[Rabattcode]    Script Date: 21.06.2024 00:08:49 ******/
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
/****** Object:  Table [dbo].[Relat_Abrechnung_Tankung]    Script Date: 21.06.2024 00:08:49 ******/
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
/****** Object:  Table [dbo].[Relat_Kunde_Rabattcode]    Script Date: 21.06.2024 00:08:49 ******/
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
/****** Object:  Table [dbo].[Relat_Tankkarte_Produkt]    Script Date: 21.06.2024 00:08:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Relat_Tankkarte_Produkt](
	[PAN] [varchar](30) NOT NULL,
	[PID] [smallint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Session]    Script Date: 21.06.2024 00:08:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Session](
	[SessionNr] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[Created] [datetime] NOT NULL,
	[DurationHours] [int] NOT NULL,
 CONSTRAINT [PK_Session] PRIMARY KEY CLUSTERED 
(
	[SessionNr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tankkarte]    Script Date: 21.06.2024 00:08:49 ******/
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
/****** Object:  Table [dbo].[Tankstelle]    Script Date: 21.06.2024 00:08:49 ******/
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
/****** Object:  Table [dbo].[Tankung]    Script Date: 21.06.2024 00:08:49 ******/
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
/****** Object:  Table [dbo].[UserAccount]    Script Date: 21.06.2024 00:08:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAccount](
	[UserName] [varchar](50) NOT NULL,
	[PasswordHash] [varchar](256) NOT NULL,
	[RNr] [int] NOT NULL,
	[KNr] [int] NULL,
 CONSTRAINT [PK_UserAccount] PRIMARY KEY CLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AbrechnungsPeriode] ON 

INSERT [dbo].[AbrechnungsPeriode] ([ABNr], [startDatum], [endDatum]) VALUES (1, CAST(N'2024-01-01' AS Date), CAST(N'2024-12-01' AS Date))
INSERT [dbo].[AbrechnungsPeriode] ([ABNr], [startDatum], [endDatum]) VALUES (2, CAST(N'2020-01-01' AS Date), CAST(N'2024-12-01' AS Date))
INSERT [dbo].[AbrechnungsPeriode] ([ABNr], [startDatum], [endDatum]) VALUES (3, CAST(N'2024-06-01' AS Date), CAST(N'2024-06-28' AS Date))
SET IDENTITY_INSERT [dbo].[AbrechnungsPeriode] OFF
GO
SET IDENTITY_INSERT [dbo].[AccountRole] ON 

INSERT [dbo].[AccountRole] ([RNr], [RoleName]) VALUES (1, N'User')
INSERT [dbo].[AccountRole] ([RNr], [RoleName]) VALUES (2, N'Admin')
INSERT [dbo].[AccountRole] ([RNr], [RoleName]) VALUES (3, N'Backoffice')
INSERT [dbo].[AccountRole] ([RNr], [RoleName]) VALUES (4, N'None')
SET IDENTITY_INSERT [dbo].[AccountRole] OFF
GO
SET IDENTITY_INSERT [dbo].[Kunde] ON 

INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (1, N'Fronius', NULL, 20000)
INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (2, N'KTM', NULL, 100)
INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (3, N'Kremsmüller', NULL, 3000)
INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (4, N'test', 1, 5000)
INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (5, N'test2', 0, 5000)
INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (6, N'test2', 0, 5000)
INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (7, N'PaulGmbh', 0, 5000)
INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (8, N'PaulGmbh2', 0, 5000)
INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (1007, N'Test', 0, 5000)
INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (1008, N'TestFirma2', 0, 5000)
INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (1009, N'TestUser3', 0, 5000)
INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (1010, N'TestUser4', 0, 5000)
INSERT [dbo].[Kunde] ([KNr], [Firmenname], [Status], [Kundenlimit]) VALUES (1011, N'TestUser5', 1, 5000)
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
INSERT [dbo].[Relat_Abrechnung_Tankung] ([ABNr], [TNr]) VALUES (3, 32)
INSERT [dbo].[Relat_Abrechnung_Tankung] ([ABNr], [TNr]) VALUES (3, 33)
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
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930000080001-9', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110001-2', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110002-0', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110003-8', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110004-6', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110005-3', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110006-1', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110007-9', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110008-7', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110009-5', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110010-3', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110011-1', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110012-9', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110013-7', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110014-5', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110015-2', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110016-0', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110017-8', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110018-6', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110019-4', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110020-2', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110021-0', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110022-8', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110023-6', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110024-4', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110025-1', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110026-9', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110027-7', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110028-5', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110029-3', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110030-1', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110031-9', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110032-7', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010110033-5', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010090001-6', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010090002-4', 5)
INSERT [dbo].[Relat_Tankkarte_Produkt] ([PAN], [PID]) VALUES (N'7000930010090003-2', 5)
GO
SET IDENTITY_INSERT [dbo].[Session] ON 

INSERT [dbo].[Session] ([SessionNr], [UserName], [Created], [DurationHours]) VALUES (1, N'test', CAST(N'2024-06-20T19:19:09.163' AS DateTime), 2)
INSERT [dbo].[Session] ([SessionNr], [UserName], [Created], [DurationHours]) VALUES (2, N'test', CAST(N'2024-06-20T19:19:11.173' AS DateTime), 2)
INSERT [dbo].[Session] ([SessionNr], [UserName], [Created], [DurationHours]) VALUES (3, N'test', CAST(N'2024-06-20T19:21:12.040' AS DateTime), 2)
INSERT [dbo].[Session] ([SessionNr], [UserName], [Created], [DurationHours]) VALUES (4, N'Admin', CAST(N'2024-06-20T20:15:46.600' AS DateTime), 2)
INSERT [dbo].[Session] ([SessionNr], [UserName], [Created], [DurationHours]) VALUES (5, N'admin', CAST(N'2024-06-20T20:21:04.680' AS DateTime), 2)
INSERT [dbo].[Session] ([SessionNr], [UserName], [Created], [DurationHours]) VALUES (6, N'Admin', CAST(N'2024-06-20T20:21:37.783' AS DateTime), 2)
INSERT [dbo].[Session] ([SessionNr], [UserName], [Created], [DurationHours]) VALUES (7, N'test', CAST(N'2024-06-20T20:22:15.100' AS DateTime), 2)
INSERT [dbo].[Session] ([SessionNr], [UserName], [Created], [DurationHours]) VALUES (8, N'Admin', CAST(N'2024-06-20T20:23:15.210' AS DateTime), 2)
INSERT [dbo].[Session] ([SessionNr], [UserName], [Created], [DurationHours]) VALUES (9, N'Admin', CAST(N'2024-06-20T20:24:04.370' AS DateTime), 2)
INSERT [dbo].[Session] ([SessionNr], [UserName], [Created], [DurationHours]) VALUES (10, N'Admin', CAST(N'2024-06-20T20:37:51.613' AS DateTime), 2)
INSERT [dbo].[Session] ([SessionNr], [UserName], [Created], [DurationHours]) VALUES (11, N'Backoffice', CAST(N'2024-06-20T20:45:33.963' AS DateTime), 2)
INSERT [dbo].[Session] ([SessionNr], [UserName], [Created], [DurationHours]) VALUES (12, N'test', CAST(N'2024-06-20T21:43:33.377' AS DateTime), 2)
INSERT [dbo].[Session] ([SessionNr], [UserName], [Created], [DurationHours]) VALUES (13, N'Backoffice', CAST(N'2024-06-20T21:48:18.483' AS DateTime), 2)
SET IDENTITY_INSERT [dbo].[Session] OFF
GO
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930000010001-3', N'LKW-Fahrer 0001', CAST(N'2026-06-06' AS Date), 1, NULL, NULL, NULL)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930000010002-3', N'LKW-Fahrer 0002', CAST(N'2026-06-06' AS Date), 1, NULL, NULL, NULL)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930000010003-0', NULL, CAST(N'2025-06-16' AS Date), 1, CAST(N'2024-06-16' AS Date), 1, 1000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930000010004-8', NULL, CAST(N'2025-06-16' AS Date), 1, CAST(N'2024-06-16' AS Date), 1, 1000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930000020001-3', N'LKW-Fahrer 0001', CAST(N'2026-03-19' AS Date), 2, NULL, NULL, NULL)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930000020002-0', NULL, CAST(N'2027-06-17' AS Date), 2, CAST(N'2024-06-17' AS Date), 1, 10000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930000020003-8', NULL, CAST(N'2027-06-17' AS Date), 2, CAST(N'2024-06-17' AS Date), 1, 10000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930000020004-6', NULL, CAST(N'2027-06-17' AS Date), 2, CAST(N'2024-06-17' AS Date), 1, 10000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930000080001-9', NULL, CAST(N'2027-06-19' AS Date), 8, CAST(N'2024-06-19' AS Date), 1, 1000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010090001-6', N'Fahrer1009', CAST(N'2027-06-20' AS Date), 1009, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010090002-4', N'Fahrer1009', CAST(N'2027-06-20' AS Date), 1009, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010090003-2', N'Fahrer1009', CAST(N'2027-06-20' AS Date), 1009, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110001-2', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110002-0', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110003-8', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110004-6', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110005-3', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110006-1', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110007-9', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110008-7', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110009-5', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110010-3', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110011-1', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110012-9', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110013-7', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110014-5', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110015-2', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110016-0', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110017-8', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110018-6', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110019-4', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110020-2', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110021-0', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110022-8', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110023-6', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110024-4', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110025-1', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110026-9', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110027-7', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110028-5', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110029-3', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110030-1', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110031-9', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110032-7', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
INSERT [dbo].[Tankkarte] ([PAN], [ausgestelltAuf], [gueltigBis], [KNr], [Ausstellungsdatum], [Status], [Kartenlimit]) VALUES (N'7000930010110033-5', NULL, CAST(N'2026-06-20' AS Date), 1011, CAST(N'2024-06-20' AS Date), 1, 5000.0000)
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
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (32, N'7000930000010004-8', 5, 40100, CAST(60.00 AS Decimal(6, 2)), 1.5000, 90.0000, CAST(N'2024-06-17T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (33, N'7000930000010004-8', 5, 40100, CAST(60.00 AS Decimal(6, 2)), 1.5000, 90.0000, CAST(N'2024-06-17T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (34, N'7000930000010003-0', 5, 40100, CAST(6.00 AS Decimal(6, 2)), 1.2000, 7.2000, CAST(N'2024-06-20T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (35, N'7000930000010003-0', 5, 40100, CAST(6.00 AS Decimal(6, 2)), 1.2000, 7.2000, CAST(N'2024-06-20T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (36, N'7000930000010003-0', 5, 40100, CAST(6.00 AS Decimal(6, 2)), 1.2000, 7.2000, CAST(N'2024-06-20T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (37, N'7000930000010003-0', 5, 40100, CAST(5.00 AS Decimal(6, 2)), 1.1200, 5.6000, CAST(N'2024-06-20T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (38, N'7000930000010003-0', 5, 40100, CAST(25.00 AS Decimal(6, 2)), 1.1600, 29.0000, CAST(N'2024-06-20T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (39, N'7000930000010003-0', 5, 40100, CAST(9.00 AS Decimal(6, 2)), 1.1500, 10.3500, CAST(N'2024-06-20T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (40, N'7000930000010004-8', 5, 40100, CAST(9.00 AS Decimal(6, 2)), 1.1500, 10.3500, CAST(N'2024-06-20T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (41, N'7000930000010003-0', 5, 40100, CAST(9.00 AS Decimal(6, 2)), 1.1500, 10.3500, CAST(N'2024-06-20T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (42, N'7000930000010003-0', 5, 40100, CAST(9.00 AS Decimal(6, 2)), 1.1500, 10.3500, CAST(N'2024-06-20T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (43, N'7000930000010003-0', 5, 40100, CAST(9.00 AS Decimal(6, 2)), 1.1500, 10.3500, CAST(N'2024-06-20T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (44, N'7000930000010003-0', 5, 40100, CAST(9.00 AS Decimal(6, 2)), 1.1500, 10.3500, CAST(N'2024-06-20T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (45, N'7000930000010004-8', 5, 40100, CAST(9.00 AS Decimal(6, 2)), 1.1500, 10.3500, CAST(N'2024-06-20T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (46, N'7000930000010004-8', 5, 40100, CAST(9.00 AS Decimal(6, 2)), 1.1500, 10.3500, CAST(N'2024-06-20T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[Tankung] ([TNr], [PAN], [PID], [TSNr], [Menge], [PreisProEinheit], [Gesamtpreis], [TDatum], [abgerechnet]) VALUES (47, N'7000930010110030-1', 5, 40100, CAST(9.00 AS Decimal(6, 2)), 1.4400, 12.9600, CAST(N'2024-06-20T00:00:00.000' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[Tankung] OFF
GO
INSERT [dbo].[UserAccount] ([UserName], [PasswordHash], [RNr], [KNr]) VALUES (N'Admin', N'Admin', 2, NULL)
INSERT [dbo].[UserAccount] ([UserName], [PasswordHash], [RNr], [KNr]) VALUES (N'Backoffice', N'Backoffice', 3, NULL)
INSERT [dbo].[UserAccount] ([UserName], [PasswordHash], [RNr], [KNr]) VALUES (N'Test', N'123', 1, 1007)
INSERT [dbo].[UserAccount] ([UserName], [PasswordHash], [RNr], [KNr]) VALUES (N'Test2', N'123', 1, 1008)
INSERT [dbo].[UserAccount] ([UserName], [PasswordHash], [RNr], [KNr]) VALUES (N'Test3', N'123', 1, 1009)
INSERT [dbo].[UserAccount] ([UserName], [PasswordHash], [RNr], [KNr]) VALUES (N'Test4', N'123', 1, 1010)
INSERT [dbo].[UserAccount] ([UserName], [PasswordHash], [RNr], [KNr]) VALUES (N'Test5', N'123', 1, 1011)
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
ALTER TABLE [dbo].[Session]  WITH CHECK ADD  CONSTRAINT [FK_Session_UserAccount] FOREIGN KEY([UserName])
REFERENCES [dbo].[UserAccount] ([UserName])
GO
ALTER TABLE [dbo].[Session] CHECK CONSTRAINT [FK_Session_UserAccount]
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
ALTER TABLE [dbo].[UserAccount]  WITH CHECK ADD  CONSTRAINT [FK_UserAccount_Kunde] FOREIGN KEY([KNr])
REFERENCES [dbo].[Kunde] ([KNr])
GO
ALTER TABLE [dbo].[UserAccount] CHECK CONSTRAINT [FK_UserAccount_Kunde]
GO
ALTER TABLE [dbo].[UserAccount]  WITH CHECK ADD  CONSTRAINT [FK_UserAccount_Role] FOREIGN KEY([RNr])
REFERENCES [dbo].[AccountRole] ([RNr])
GO
ALTER TABLE [dbo].[UserAccount] CHECK CONSTRAINT [FK_UserAccount_Role]
GO
/****** Object:  StoredProcedure [dbo].[sp_berechne_abrechnung]    Script Date: 21.06.2024 00:08:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kilian Brandstoetter
-- Create date: 20.06.2024
-- Description:	berechnet abrechnung in einem Zeitraum
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
/****** Object:  StoredProcedure [dbo].[sp_create_user_account]    Script Date: 21.06.2024 00:08:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kilian Brandstoetter
-- Create date: 20.06.2024
-- Description:	erstellt Konto
-- =============================================
CREATE PROCEDURE [dbo].[sp_create_user_account]
	-- Add the parameters for the stored procedure here
	@param_user_name VARCHAR(50),
	@param_password_hash VARCHAR(256),
	@param_knr int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @RNr INT;

	SELECT @RNr = AccountRole.RNr FROM AccountRole WHERE AccountRole.RoleName = 'User';

	IF (ISNULL(@RNr, -1) = -1)
	BEGIN
		RETURN -1;
	END

	INSERT INTO UserAccount(UserName, PasswordHash, RNr, KNr) VALUES(@param_user_name, @param_password_hash, @RNr, @param_knr);
	RETURN 0;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_abrechnung_for_id]    Script Date: 21.06.2024 00:08:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kilian Brandstoetter
-- Create date: 20.06.2024
-- Description:	get Abrechnung for a kunde
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
/****** Object:  StoredProcedure [dbo].[sp_get_kunden_daten]    Script Date: 21.06.2024 00:08:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kilian Brandstoetter
-- Create date: 20.06.2024
-- Description:	kunden daten von kundenNr
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
/****** Object:  StoredProcedure [dbo].[sp_get_letzte_abrechnung_for]    Script Date: 21.06.2024 00:08:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kilian Brandstoetter
-- Create date: 20.06.2024
-- Description:	letzte Abrechnung fuer einen Kunden
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
/****** Object:  StoredProcedure [dbo].[sp_kunde_erstellen]    Script Date: 21.06.2024 00:08:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kilian Brandstoetter
-- Create date: 20.06.2024
-- Description:	erstellt Kunden
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
/****** Object:  StoredProcedure [dbo].[sp_login]    Script Date: 21.06.2024 00:08:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kilian Brandstoetter
-- Create date: 20.06.2024
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_login]
	-- Add the parameters for the stored procedure here
	@param_user_name VARCHAR(50),
	@param_password_hash VARCHAR(256)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @user_count INT;
	SET @user_count = (SELECT COUNT(UserAccount.UserName) FROM UserAccount WHERE UserAccount.UserName = @param_user_name AND UserAccount.PasswordHash = @param_password_hash);
	
	IF (@user_count = 0)
	BEGIN
		RETURN -1;
	END

	INSERT INTO Session(UserName, Created, DurationHours) Values(@param_user_name, GETDATE(), 2);
	RETURN @@IDENTITY
END
GO
/****** Object:  StoredProcedure [dbo].[sp_session_role]    Script Date: 21.06.2024 00:08:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kilian Brandstoetter
-- Create date: 20.06.2024
-- Description:	Rolle fuer die Session
-- sp_session_role 9
-- =============================================
CREATE PROCEDURE [dbo].[sp_session_role]
	-- Add the parameters for the stored procedure here
	@param_session_id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @session_duration_h INT;
	DECLARE @created DATETIME;
	DECLARE @role_id INT;

	SELECT @session_duration_h = Session.DurationHours, @created = Session.Created, @role_id = AccountRole.RNr FROM Session 
	JOIN UserAccount ON UserAccount.UserName = Session.UserName
	JOIN AccountRole ON AccountRole.RNr = UserAccount.RNr
	WHERE Session.SessionNr = @param_session_id;

	IF (ISNULL(@role_id, -1) = -1 OR DATEADD(HOUR, @session_duration_h, @created) < GETDATE())
	BEGIN
		RETURN 'None';
	END


	RETURN @role_id;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_tankkarte_erstellen]    Script Date: 21.06.2024 00:08:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kilian Brandstoetter
-- Create date: 20.06.2024
-- Description:	erstellt Tankkarte
-- =============================================
CREATE PROCEDURE [dbo].[sp_tankkarte_erstellen]
	-- Add the parameters for the stored procedure here
	@param_kundenNr INT,
	@param_ausgestelltauf VARCHAR(50),
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

	INSERT INTO Tankkarte(PAN,ausgestelltAuf, gueltigBis, KNr, Ausstellungsdatum, Status, Kartenlimit) VALUES(@param_pan,@param_ausgestelltauf, @param_bis, @param_kundenNr, @von, 1, @param_limit);

	INSERT INTO Relat_Tankkarte_Produkt(PAN, PID) VALUES(@param_pan, @pid);
END
GO
/****** Object:  StoredProcedure [dbo].[sp_tankung_erstellen]    Script Date: 21.06.2024 00:08:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kilian Brandstoetter
-- Create date: 20.06.2024
-- Description:	Tankung erstellen
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
	BEGIN
		RETURN 1;
	END
	
	IF (ISNULL(@kartenStatus, 1) = 0)
	BEGIN
		RETURN 2;
	END

	SET @karteCurrSpent = ISNULL((SELECT SUM(Tankung.Gesamtpreis) FROM Tankung WHERE Tankung.PAN = @param_pan), 0);

	IF (ISNULL(@kartenLimit, -1) != -1 AND @kartenLimit < @karteCurrSpent + @gesamt_preis)
	BEGIN
		RETURN 3;
	END

	IF(@karteKannBezahlWerden = 0) 
	BEGIN
		RETURN 4;
	END

	IF(ISNULL(@kundenStatus, 1) = 0)
	BEGIN
		RETURN 5;
	END

	SET @kundeCurrSpent = ISNULL((SELECT SUM(Tankung.GesamtPreis) FROM Kunde
							JOIN Tankkarte ON Tankkarte.KNr = @KNR
							JOIN Tankung ON Tankung.PAN = Tankkarte.PAN), 0);

	IF(ISNULL(@kundenLimit, -1) != -1 AND @kundenLimit < @kundeCurrSpent + @gesamt_preis)
	BEGIN
		RETURN 6;
	END

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
