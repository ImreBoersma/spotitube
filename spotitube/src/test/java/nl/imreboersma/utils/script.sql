/****** Object:  Database [Spotitube]    Script Date: 13/10/2021 18:41:36 ******/
CREATE DATABASE [Spotitube]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Spotitube', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Spotitube.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Spotitube_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Spotitube_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Spotitube] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Spotitube].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Spotitube] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Spotitube] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Spotitube] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Spotitube] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Spotitube] SET ARITHABORT OFF 
GO
ALTER DATABASE [Spotitube] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Spotitube] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Spotitube] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Spotitube] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Spotitube] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Spotitube] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Spotitube] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Spotitube] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Spotitube] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Spotitube] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Spotitube] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Spotitube] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Spotitube] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Spotitube] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Spotitube] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Spotitube] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Spotitube] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Spotitube] SET RECOVERY FULL 
GO
ALTER DATABASE [Spotitube] SET  MULTI_USER 
GO
ALTER DATABASE [Spotitube] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Spotitube] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Spotitube] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Spotitube] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Spotitube] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Spotitube] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Spotitube', N'ON'
GO
ALTER DATABASE [Spotitube] SET QUERY_STORE = OFF
GO
/****** Object:  Table [dbo].[playlist]    Script Date: 13/10/2021 18:41:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[playlist](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[owner_user_id] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_playlist] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[playlist_tracks]    Script Date: 13/10/2021 18:41:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[playlist_tracks](
	[playlist_id] [int] NOT NULL,
	[track_id] [int] NOT NULL,
	[offline_available] [tinyint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[track]    Script Date: 13/10/2021 18:41:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[track](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[title] [varchar](50) NOT NULL,
	[performer] [varchar](50) NOT NULL,
	[duration] [int] NOT NULL,
	[album] [varchar](50) NOT NULL,
	[play_count] [int] NOT NULL,
	[publication_date] [date] NULL,
	[description] [text] NULL,
 CONSTRAINT [PK_track] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user]    Script Date: 13/10/2021 18:41:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[password] [varchar](128) NOT NULL,
	[first_name] [varchar](50) NOT NULL,
	[last_name] [varchar](50) NOT NULL,
	[token] [varchar](128) NULL,
 CONSTRAINT [PK_user] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [token_UNIQUE]    Script Date: 13/10/2021 18:41:37 ******/
CREATE UNIQUE NONCLUSTERED INDEX [token_UNIQUE] ON [dbo].[user]
(
	[token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [username_UNIQUE]    Script Date: 13/10/2021 18:41:37 ******/
CREATE UNIQUE NONCLUSTERED INDEX [username_UNIQUE] ON [dbo].[user]
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[playlist_tracks] ADD  CONSTRAINT [DF_Table1_offline_available]  DEFAULT ((0)) FOR [offline_available]
GO
ALTER TABLE [dbo].[track] ADD  CONSTRAINT [DF_track_play_count]  DEFAULT ((0)) FOR [play_count]
GO
ALTER TABLE [dbo].[playlist]  WITH CHECK ADD  CONSTRAINT [FK_playlist_user] FOREIGN KEY([owner_user_id])
REFERENCES [dbo].[user] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[playlist] CHECK CONSTRAINT [FK_playlist_user]
GO
ALTER TABLE [dbo].[playlist_tracks]  WITH CHECK ADD  CONSTRAINT [FK_playlist_tracks_playlist] FOREIGN KEY([playlist_id])
REFERENCES [dbo].[playlist] ([id])
GO
ALTER TABLE [dbo].[playlist_tracks] CHECK CONSTRAINT [FK_playlist_tracks_playlist]
GO
ALTER TABLE [dbo].[playlist_tracks]  WITH CHECK ADD  CONSTRAINT [FK_playlist_tracks_track] FOREIGN KEY([track_id])
REFERENCES [dbo].[track] ([id])
GO
ALTER TABLE [dbo].[playlist_tracks] CHECK CONSTRAINT [FK_playlist_tracks_track]
GO
ALTER DATABASE [Spotitube] SET  READ_WRITE 
GO
