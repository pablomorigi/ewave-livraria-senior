﻿IF NOT EXISTS (SELECT name FROM [master].[dbo].[sysdatabases] WHERE name = N'ToDo')
BEGIN
	USE [master];
	CREATE DATABASE [ToDo];
END
GO

USE [ToDo];
GO

--DROP TABLE [dbo].[Telefone];
--DROP TABLE [dbo].[TelefoneTipo];
--DROP TABLE [dbo].[Email];
--DROP TABLE [dbo].[EmailTipo];
--DROP TABLE [dbo].[Endereco];
--DROP TABLE [dbo].[Emprestimo];
--DROP TABLE [dbo].[Livro];
--DROP TABLE [dbo].[Genero];
--DROP TABLE [dbo].[Autor];
--DROP TABLE [dbo].[Usuario];
--DROP TABLE [dbo].[InstituicaoDeEnsino];
--DROP TABLE [dbo].[PessoaFisica];
--DROP TABLE [dbo].[PessoaJuridica];
--DROP TABLE [dbo].[Pessoa];
--DROP TABLE [dbo].[PessoaTipo];
--DROP TABLE [dbo].[Cidade];
--DROP TABLE [dbo].[Estado];
--DROP TABLE [dbo].[Pais];

CREATE TABLE [dbo].[PessoaTipo] 
(
	[Id] INT NOT NULL,
	[Nome] VARCHAR(180) NOT NULL,
	CONSTRAINT [PK_PessoaTipo] PRIMARY KEY ([Id]) ON [PRIMARY]
)
GO

CREATE TABLE [dbo].[Pessoa] 
(
	[Id] INT NOT NULL IDENTITY(1,1),
	[AggregateId] UNIQUEIDENTIFIER NOT NULL UNIQUE, 
	[TipoId] INT NOT NULL,
	[DataCriacao] DATETIME NOT NULL,
	[Ativo] BIT NOT NULL
	CONSTRAINT [PK_Pessoa] PRIMARY KEY ([Id])
	CONSTRAINT [FK_Pessoa_PessoaTipo] FOREIGN KEY ([TipoId]) REFERENCES [dbo].[PessoaTipo]([id])
)
GO

CREATE TABLE [dbo].[PessoaFisica] 
( 
	[PessoaId] INT NOT NULL,
	[Cpf] VARCHAR(11) NOT NULL UNIQUE,
	[Nome] VARCHAR(120) NOT NULL,
	CONSTRAINT [PK_PessoaFisica] PRIMARY KEY ([PessoaId]),
	CONSTRAINT [FK_PessoaFisica_Pessoa] FOREIGN KEY ([PessoaId]) REFERENCES [dbo].[Pessoa]([Id])
)
GO

CREATE TABLE [dbo].[PessoaJuridica] 
( 
	[PessoaId] INT NOT NULL,
	[Cnpj] VARCHAR(14) NOT NULL UNIQUE,
	[RazaoSocial] VARCHAR(80) NOT NULL,
	[NomeFantasia] VARCHAR(100) NULL,
	CONSTRAINT [PK_PessoaJuridica] PRIMARY KEY ([PessoaId]),
	CONSTRAINT [FK_PessoaJuridica_Pessoa] FOREIGN KEY ([PessoaId]) REFERENCES [dbo].[Pessoa]([Id])
)
GO

CREATE TABLE [dbo].[InstituicaoDeEnsino] 
( 
	[Id] INT NOT NULL IDENTITY(1,1),
	[AggregateId] UNIQUEIDENTIFIER NOT NULL UNIQUE,
	[PessoaAggregateId] UNIQUEIDENTIFIER NOT NULL,
	[DataCriacao] DATETIME NOT NULL,
	[Ativo] BIT NOT NULL,
	CONSTRAINT [PK_InstituicaoDeEnsino] PRIMARY KEY ([Id]),
	CONSTRAINT [FK_InstituicaoDeEnsino_Pessoa] FOREIGN KEY ([PessoaAggregateId]) REFERENCES [dbo].[Pessoa]([AggregateId])
)
GO

CREATE TABLE [dbo].[Usuario] 
( 
	[Id] INT NOT NULL IDENTITY(1,1),
	[AggregateId] UNIQUEIDENTIFIER NOT NULL UNIQUE,
	[PessoaAggregateId] UNIQUEIDENTIFIER NOT NULL,
	[InstituicaoDeEnsinoAggregateId] UNIQUEIDENTIFIER NOT NULL,
	[DataCriacao] DATETIME NOT NULL,
	[Ativo] BIT NOT NULL,
	CONSTRAINT [PK_Usuario] PRIMARY KEY ([Id]),
	CONSTRAINT [FK_Usuario_Pessoa] FOREIGN KEY ([PessoaAggregateId]) REFERENCES [Pessoa]([AggregateId]),
	CONSTRAINT [FK_Usuario_InstituicaoDeEnsino] FOREIGN KEY ([InstituicaoDeEnsinoAggregateId]) REFERENCES [InstituicaoDeEnsino]([AggregateId])
)
GO

CREATE TABLE [dbo].[Autor] 
(
	[Id] INT NOT NULL IDENTITY(1,1),
	[AggregateId] UNIQUEIDENTIFIER NOT NULL,
	[Nome] VARCHAR(180) NOT NULL,
	[DataCriacao] DATETIME NOT NULL,
	[Ativo] BIT NOT NULL,
	CONSTRAINT [PK_Autor] PRIMARY KEY ([Id])
)
GO

CREATE TABLE [dbo].[Genero] 
(
	[Id] INT NOT NULL IDENTITY(1,1),
	[AggregateId] UNIQUEIDENTIFIER NOT NULL,
	[Nome] VARCHAR(180) NOT NULL,
	[DataCriacao] DATETIME NOT NULL,
	[Ativo] BIT NOT NULL,
	CONSTRAINT [PK_Genero] PRIMARY KEY ([Id])
)
GO

CREATE TABLE [dbo].[Livro] 
(
	[Id] INT NOT NULL IDENTITY(1,1),
	[AggregateId] UNIQUEIDENTIFIER NOT NULL UNIQUE,
	[Titulo] VARCHAR(255) NOT NULL,
	[Capa] VARCHAR(800) NOT NULL,
	[Sinopse] VARCHAR(400) NULL,
	[Paginas] INT NULL,
	[Disponivel] BIT NOT NULL,
	[DataCriacao] DATETIME NOT NULL,
	[Ativo] BIT NOT NULL,
	[AutorId] INT NOT NULL,
	[GeneroId] INT NOT NULL,
	CONSTRAINT [PK_Livro] PRIMARY KEY ([Id]),
	CONSTRAINT [FK_Livro_Autor] FOREIGN KEY ([AutorId]) REFERENCES [Autor]([Id]),
	CONSTRAINT [FK_Livro_Genero] FOREIGN KEY ([GeneroId]) REFERENCES [Genero]([Id])
)
GO

CREATE TABLE [dbo].[Emprestimo] 
(
	[Id] INT NOT NULL IDENTITY(1,1),
	[AggregateId] UNIQUEIDENTIFIER NOT NULL UNIQUE,
	[DataEmprestimo] DATETIME NOT NULL,
	[DataVencimento] DATETIME NOT NULL,
	[DataDevolucao] DATETIME NULL,
	[LivroId] INT NOT NULL,
	[UsuarioId] INT NOT NULL,
	[DataCriacao] DATETIME NOT NULL,
	[Ativo] BIT NOT NULL,
	CONSTRAINT [PK_Emprestimo] PRIMARY KEY ([Id]),
	CONSTRAINT [FK_Emprestimo_Livro] FOREIGN KEY ([LivroId]) REFERENCES [Livro]([Id]),
	CONSTRAINT [FK_Emprestimo_Usuario] FOREIGN KEY ([UsuarioId]) REFERENCES [Usuario]([Id])
)
GO

CREATE TABLE [dbo].[Pais] 
(
	[Id] INT NOT NULL,
	[Nome] VARCHAR(240) NOT NULL,
	CONSTRAINT [PK_Pais] PRIMARY KEY ([Id])
)
GO

CREATE TABLE [dbo].[Estado] 
(
	[Id] INT NOT NULL,
	[Nome] VARCHAR(240) NOT NULL,
	[Sigla] VARCHAR(2) NOT NULL UNIQUE,
	[PaisId] INT NOT NULL,
	CONSTRAINT [PK_Estado] PRIMARY KEY ([Id]),
	CONSTRAINT [FK_Estado_Pais] FOREIGN KEY ([PaisId]) REFERENCES [Pais]([Id])
)
GO

CREATE TABLE [dbo].[Cidade] 
(
	[Id] INT NOT NULL,
	[Nome] VARCHAR(240) NOT NULL,
	[EstadoId] INT NOT NULL,
	CONSTRAINT [PK_Cidade] PRIMARY KEY ([Id]),
	CONSTRAINT [FK_Cidade_Estado] FOREIGN KEY ([EstadoId]) REFERENCES [Estado]([Id]))
GO

CREATE TABLE [dbo].[Endereco] (
	[PessoaId] INT NOT NULL,
	[Cep] VARCHAR(8) NOT NULL,
	[Logradouro] VARCHAR(180) NOT NULL,
	[Numero] VARCHAR(6) NULL,
	[Bairro] VARCHAR(180) NOT NULL,
	[Complemento] VARCHAR(255) NULL,
	[CidadeId] INT NOT NULL
  CONSTRAINT [PK_Endereco] PRIMARY KEY ([PessoaId]) ON [PRIMARY],
  CONSTRAINT [FK_Endereco_Pessoa] FOREIGN KEY ([PessoaId]) REFERENCES [Pessoa]([Id]),
  CONSTRAINT [FK_Endereco_Cidade] FOREIGN KEY ([CidadeId]) REFERENCES [Cidade]([Id])
)
GO

CREATE TABLE [dbo].[TelefoneTipo] 
(
	[Id] INT NOT NULL,
	[Nome] VARCHAR(80) NOT NULL
	CONSTRAINT [PK_TelefoneTipo] PRIMARY KEY ([Id]) ON [PRIMARY]
)
GO

CREATE TABLE [dbo].[Telefone] 
(
	[Id] INT NOT NULL IDENTITY(1, 1),
	[PessoaId] INT NOT NULL,
	[Numero] VARCHAR(11) NOT NULL,
	[TipoId] INT NOT NULL
	CONSTRAINT [PK_Telefone] PRIMARY KEY ([Id]) ON [PRIMARY],
	CONSTRAINT [FK_Telefone_TelefoneTipo] FOREIGN KEY ([TipoId]) REFERENCES [dbo].[TelefoneTipo] ([Id]),
	CONSTRAINT [FK_Telefone_Pessoa] FOREIGN KEY ([PessoaId]) REFERENCES [dbo].[Pessoa] ([Id])
)
GO

CREATE TABLE [dbo].[EmailTipo] 
(
	[Id] INT NOT NULL,
	[Nome] VARCHAR(80) NOT NULL
	CONSTRAINT [PK_EmailTipo] PRIMARY KEY ([Id]) ON [PRIMARY]
)
GO

CREATE TABLE [dbo].[Email] 
(
	[Id] INT NOT NULL IDENTITY(1, 1),
	[PessoaId] INT NOT NULL,
	[Endereco] VARCHAR(80) NOT NULL,
	[TipoId] INT NOT NULL
	CONSTRAINT [PK_Email] PRIMARY KEY ([Id]) ON [PRIMARY],
	CONSTRAINT [FK_Email_EmailTipo] FOREIGN KEY ([TipoId]) REFERENCES [dbo].[EmailTipo] ([Id]),
	CONSTRAINT [FK_Email_Pessoa] FOREIGN KEY ([PessoaId]) REFERENCES [dbo].[Pessoa] ([Id])
)
GO
