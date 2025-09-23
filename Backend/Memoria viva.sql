/* ===========================================================
   MEMORIA VIVA NICARAGUA — ESQUEMA v1.2 (SQL Server)
   =========================================================== */

-- 1) Base de datos
IF DB_ID('MemoriaVivaNicaragua') IS NULL
    CREATE DATABASE MemoriaVivaNicaragua;
GO
USE MemoriaVivaNicaragua;
GO

/* ===========================================================
   2) Tablas de apoyo (catálogos)
   =========================================================== */

-- Roles / tipos de usuario (más flexible que un CHECK fijo)
IF OBJECT_ID('dbo.Roles','U') IS NOT NULL DROP TABLE dbo.Roles;
CREATE TABLE dbo.Roles (
    RolID          INT IDENTITY(1,1) PRIMARY KEY,
    Nombre         NVARCHAR(40) UNIQUE NOT NULL,  -- Administrador, Moderador, Estudiante, Docente, Familiar, Comunidad, Aficionado
    EsInterno      BIT NOT NULL DEFAULT 0
);

-- Categorías genéricas para clasificar memorias/saberes/eventos si se desea
IF OBJECT_ID('dbo.Categorias','U') IS NOT NULL DROP TABLE dbo.Categorias;
CREATE TABLE dbo.Categorias (
    CategoriaID    INT IDENTITY(1,1) PRIMARY KEY,
    Nombre         NVARCHAR(100) NOT NULL,
    Descripcion    NVARCHAR(400),
    Tipo           NVARCHAR(30) NOT NULL  -- 'Memoria','Saber','Evento'
);
CREATE UNIQUE INDEX IX_Categorias_Nombre_Tipo ON dbo.Categorias(Nombre, Tipo);

-- Localizaciones con posibilidad de geolocalización
IF OBJECT_ID('dbo.Localizaciones','U') IS NOT NULL DROP TABLE dbo.Localizaciones;
CREATE TABLE dbo.Localizaciones (
    LocalizacionID INT IDENTITY(1,1) PRIMARY KEY,
    Pais           NVARCHAR(60) NOT NULL DEFAULT N'Nicaragua',
    Departamento   NVARCHAR(100) NULL,
    Municipio      NVARCHAR(100) NULL,
    Barrio         NVARCHAR(120) NULL,
    Latitud        DECIMAL(10,8) NULL,
    Longitud       DECIMAL(11,8) NULL
);
CREATE INDEX IX_Localizaciones_Lugar ON dbo.Localizaciones(Departamento, Municipio);
CREATE INDEX IX_Localizaciones_Geo   ON dbo.Localizaciones(Latitud, Longitud);

/* ===========================================================
   3) Núcleo de usuarios
   =========================================================== */

IF OBJECT_ID('dbo.Usuarios','U') IS NOT NULL DROP TABLE dbo.Usuarios;
CREATE TABLE dbo.Usuarios (
    UsuarioID          INT IDENTITY(1,1) PRIMARY KEY,
    Nombre             NVARCHAR(80) NOT NULL,
    Apellido           NVARCHAR(80) NULL,
    NombreUsuario      NVARCHAR(50) NOT NULL UNIQUE,
    CorreoElectronico  NVARCHAR(120) NOT NULL UNIQUE,
    ContrasenaHash     NVARCHAR(255) NOT NULL,
    RolID              INT NOT NULL FOREIGN KEY REFERENCES dbo.Roles(RolID),
    TipoUsuario        NVARCHAR(20) NULL  -- opcional: Estudiante, Docente, Familiar, Comunidad
        CONSTRAINT CK_Usuarios_Tipo CHECK (TipoUsuario IS NULL OR TipoUsuario IN (N'Estudiante',N'Docente',N'Familiar',N'Comunidad')),
    InstitucionEducativa NVARCHAR(200) NULL,
    Comunidad          NVARCHAR(150) NULL,
    LocalizacionID     INT NULL FOREIGN KEY REFERENCES dbo.Localizaciones(LocalizacionID),
    FechaRegistro      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    Activo             BIT NOT NULL DEFAULT 1
);
CREATE INDEX IX_Usuarios_Rol ON dbo.Usuarios(RolID);
CREATE INDEX IX_Usuarios_Loc ON dbo.Usuarios(LocalizacionID);

-- Datos semilla de roles mínimos
IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE Nombre = N'Administrador')
    INSERT INTO dbo.Roles(Nombre, EsInterno) VALUES (N'Administrador',1),(N'Moderador',1),(N'Aficionado',0),(N'Estudiante',0),(N'Docente',0),(N'Familiar',0),(N'Comunidad',0);
GO

/* ===========================================================
   4) MEMORIAS (relatos comunitarios) + Medios asociados
   =========================================================== */

IF OBJECT_ID('dbo.Memorias','U') IS NOT NULL DROP TABLE dbo.Memorias;
CREATE TABLE dbo.Memorias (
    MemoriaID       INT IDENTITY(1,1) PRIMARY KEY,
    Titulo          NVARCHAR(200) NOT NULL,
    Descripcion     NVARCHAR(MAX) NULL,
    UsuarioID       INT NOT NULL FOREIGN KEY REFERENCES dbo.Usuarios(UsuarioID),
    LocalizacionID  INT NULL FOREIGN KEY REFERENCES dbo.Localizaciones(LocalizacionID),
    CategoriaID     INT NULL FOREIGN KEY REFERENCES dbo.Categorias(CategoriaID),
    FechaCreacion   DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    Estado          NVARCHAR(12) NOT NULL DEFAULT N'Pendiente'
        CONSTRAINT CK_Memorias_Estado CHECK (Estado IN (N'Pendiente',N'Aprobado',N'Rechazado')),
    AprobadoPor     INT NULL FOREIGN KEY REFERENCES dbo.Usuarios(UsuarioID),
    FechaAprobacion DATETIME2 NULL,
    EsPublico       BIT NOT NULL DEFAULT 0,
    Activo          BIT NOT NULL DEFAULT 1
);
CREATE INDEX IX_Memorias_Fecha ON dbo.Memorias(FechaCreacion);
CREATE INDEX IX_Memorias_Estado ON dbo.Memorias(Estado);
CREATE INDEX IX_Memorias_Loc ON dbo.Memorias(LocalizacionID);

-- Medios: imagen/audio/video/texto asociados a una memoria
IF OBJECT_ID('dbo.Medios','U') IS NOT NULL DROP TABLE dbo.Medios;
CREATE TABLE dbo.Medios (
    MedioID        INT IDENTITY(1,1) PRIMARY KEY,
    MemoriaID      INT NOT NULL FOREIGN KEY REFERENCES dbo.Memorias(MemoriaID) ON DELETE CASCADE,
    TipoMedio      NVARCHAR(20) NOT NULL
        CONSTRAINT CK_Medios_Tipo CHECK (TipoMedio IN (N'Imagen',N'Audio',N'Video',N'Texto')),
    URLArchivo     NVARCHAR(1000) NULL,        -- para multimedia
    ContenidoTexto NVARCHAR(MAX) NULL,         -- para relatos puramente textuales
    FechaCarga     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
CREATE INDEX IX_Medios_Memoria ON dbo.Medios(MemoriaID);

-- Interacción social en memorias
IF OBJECT_ID('dbo.ComentariosMemoria','U') IS NOT NULL DROP TABLE dbo.ComentariosMemoria;
CREATE TABLE dbo.ComentariosMemoria (
    ComentarioID   INT IDENTITY(1,1) PRIMARY KEY,
    MemoriaID      INT NOT NULL FOREIGN KEY REFERENCES dbo.Memorias(MemoriaID) ON DELETE CASCADE,
    UsuarioID      INT NOT NULL FOREIGN KEY REFERENCES dbo.Usuarios(UsuarioID),
    Comentario     NVARCHAR(600) NOT NULL,
    FechaComentario DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    Estado         NVARCHAR(10) NOT NULL DEFAULT N'Activo'
        CONSTRAINT CK_ComentariosMemoria_Estado CHECK (Estado IN (N'Activo',N'Eliminado'))
);
CREATE INDEX IX_ComentariosMemoria_Memoria ON dbo.ComentariosMemoria(MemoriaID);

IF OBJECT_ID('dbo.ReaccionesMemoria','U') IS NOT NULL DROP TABLE dbo.ReaccionesMemoria;
CREATE TABLE dbo.ReaccionesMemoria (
    ReaccionID     INT IDENTITY(1,1) PRIMARY KEY,
    MemoriaID      INT NOT NULL FOREIGN KEY REFERENCES dbo.Memorias(MemoriaID) ON DELETE CASCADE,
    UsuarioID      INT NOT NULL FOREIGN KEY REFERENCES dbo.Usuarios(UsuarioID),
    TipoReaccion   NVARCHAR(20) NOT NULL DEFAULT N'Like'
        CONSTRAINT CK_Reacciones_Tipo CHECK (TipoReaccion IN (N'Like',N'Corazon',N'Aplauso')),
    FechaReaccion  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_Reaccion_Unica UNIQUE (MemoriaID, UsuarioID)
);
CREATE INDEX IX_ReaccionesMemoria_Memoria ON dbo.ReaccionesMemoria(MemoriaID);

-- Seguimientos (seguir usuarios)
IF OBJECT_ID('dbo.Seguimientos','U') IS NOT NULL DROP TABLE dbo.Seguimientos;
CREATE TABLE dbo.Seguimientos (
    SeguimientoID INT IDENTITY(1,1) PRIMARY KEY,
    SeguidorID    INT NOT NULL FOREIGN KEY REFERENCES dbo.Usuarios(UsuarioID),
    SeguidoID     INT NOT NULL FOREIGN KEY REFERENCES dbo.Usuarios(UsuarioID),
    FechaSeguimiento DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_Seguimiento UNIQUE (SeguidorID, SeguidoID),
    CONSTRAINT CK_Seguimiento_Self CHECK (SeguidorID <> SeguidoID)
);

/* ===========================================================
   5) EVENTOS (calendario cultural)
   =========================================================== */

IF OBJECT_ID('dbo.Eventos','U') IS NOT NULL DROP TABLE dbo.Eventos;
CREATE TABLE dbo.Eventos (
    EventoID        INT IDENTITY(1,1) PRIMARY KEY,
    NombreEvento    NVARCHAR(200) NOT NULL,
    Descripcion     NVARCHAR(MAX) NULL,
    FechaInicio     DATETIME2 NOT NULL,
    FechaFin        DATETIME2 NULL,
    TipoEvento      NVARCHAR(60) NOT NULL,  -- Feria, Festividad, Tradición, etc.
    UsuarioID       INT NULL FOREIGN KEY REFERENCES dbo.Usuarios(UsuarioID),
    LocalizacionID  INT NULL FOREIGN KEY REFERENCES dbo.Localizaciones(LocalizacionID),
    CategoriaID     INT NULL FOREIGN KEY REFERENCES dbo.Categorias(CategoriaID),
    Latitud         DECIMAL(10,8) NULL,
    Longitud        DECIMAL(11,8) NULL,
    FechaCreacion   DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
CREATE INDEX IX_Eventos_Fechas ON dbo.Eventos(FechaInicio, FechaFin);
CREATE INDEX IX_Eventos_Loc    ON dbo.Eventos(LocalizacionID);

/* ===========================================================
   6) BIBLIOTECA (saberes populares)
   =========================================================== */

IF OBJECT_ID('dbo.SaberesPopulares','U') IS NOT NULL DROP TABLE dbo.SaberesPopulares;
CREATE TABLE dbo.SaberesPopulares (
    SaberID         INT IDENTITY(1,1) PRIMARY KEY,
    Titulo          NVARCHAR(200) NOT NULL,
    Contenido       NVARCHAR(MAX) NULL,
    TipoSaber       NVARCHAR(50) NOT NULL  -- Receta, Costumbre, Leyenda, Artesanía, etc.
        CONSTRAINT CK_Saberes_Tipo CHECK (TipoSaber IN (N'Receta',N'Costumbre',N'Leyenda',N'Artesanía',N'Artesania',N'Saber')),
    UsuarioID       INT NOT NULL FOREIGN KEY REFERENCES dbo.Usuarios(UsuarioID),
    LocalizacionID  INT NULL FOREIGN KEY REFERENCES dbo.Localizaciones(LocalizacionID),
    CategoriaID     INT NULL FOREIGN KEY REFERENCES dbo.Categorias(CategoriaID),
    Estado          NVARCHAR(12) NOT NULL DEFAULT N'Pendiente'
        CONSTRAINT CK_Saberes_Estado CHECK (Estado IN (N'Pendiente',N'Aprobado',N'Rechazado')),
    FechaCreacion   DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    AprobadoPor     INT NULL FOREIGN KEY REFERENCES dbo.Usuarios(UsuarioID),
    FechaAprobacion DATETIME2 NULL
);
CREATE INDEX IX_Saberes_Tipo ON dbo.SaberesPopulares(TipoSaber);
CREATE INDEX IX_Saberes_Estado ON dbo.SaberesPopulares(Estado);

-- Comentarios y reacciones para Saberes (si deseas interacción también aquí)
IF OBJECT_ID('dbo.ComentariosSaber','U') IS NOT NULL DROP TABLE dbo.ComentariosSaber;
CREATE TABLE dbo.ComentariosSaber (
    ComentarioID   INT IDENTITY(1,1) PRIMARY KEY,
    SaberID        INT NOT NULL FOREIGN KEY REFERENCES dbo.SaberesPopulares(SaberID) ON DELETE CASCADE,
    UsuarioID      INT NOT NULL FOREIGN KEY REFERENCES dbo.Usuarios(UsuarioID),
    Comentario     NVARCHAR(600) NOT NULL,
    FechaComentario DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    Estado         NVARCHAR(10) NOT NULL DEFAULT N'Activo'
        CONSTRAINT CK_ComentariosSaber_Estado CHECK (Estado IN (N'Activo',N'Eliminado'))
);
CREATE INDEX IX_ComentariosSaber_Saber ON dbo.ComentariosSaber(SaberID);

IF OBJECT_ID('dbo.ReaccionesSaber','U') IS NOT NULL DROP TABLE dbo.ReaccionesSaber;
CREATE TABLE dbo.ReaccionesSaber (
    ReaccionID     INT IDENTITY(1,1) PRIMARY KEY,
    SaberID        INT NOT NULL FOREIGN KEY REFERENCES dbo.SaberesPopulares(SaberID) ON DELETE CASCADE,
    UsuarioID      INT NOT NULL FOREIGN KEY REFERENCES dbo.Usuarios(UsuarioID),
    TipoReaccion   NVARCHAR(20) NOT NULL DEFAULT N'Like'
        CONSTRAINT CK_ReaccionesSaber_Tipo CHECK (TipoReaccion IN (N'Like',N'Corazon',N'Aplauso')),
    FechaReaccion  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_ReaccionSaber UNIQUE (SaberID, UsuarioID)
);
CREATE INDEX IX_ReaccionesSaber_Saber ON dbo.ReaccionesSaber(SaberID);

/* ===========================================================
   7) RETOS DIDÁCTICOS + Progreso
   =========================================================== */

IF OBJECT_ID('dbo.Retos','U') IS NOT NULL DROP TABLE dbo.Retos;
CREATE TABLE dbo.Retos (
    RetoID           INT IDENTITY(1,1) PRIMARY KEY,
    Titulo           NVARCHAR(200) NOT NULL,
    Descripcion      NVARCHAR(MAX) NULL,
    Preguntas        NVARCHAR(MAX) NOT NULL,  -- JSON con preguntas/respuestas
    CONSTRAINT CK_Retos_Preguntas_JSON CHECK (ISJSON(Preguntas) = 1),
    Tema             NVARCHAR(80) NOT NULL,   -- Identidad, Soberanía, Valores Patrios, etc.
    NivelDificultad  NVARCHAR(10) NOT NULL DEFAULT N'Medio'
        CONSTRAINT CK_Retos_Dificultad CHECK (NivelDificultad IN (N'Facil',N'Medio',N'Dificil')),
    PuntosBase       INT NOT NULL DEFAULT 10,
    UsuarioID        INT NULL FOREIGN KEY REFERENCES dbo.Usuarios(UsuarioID),
    FechaCreacion    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    Activo           BIT NOT NULL DEFAULT 1
);
CREATE INDEX IX_Retos_Tema ON dbo.Retos(Tema);
CREATE INDEX IX_Retos_Activo ON dbo.Retos(Activo);

IF OBJECT_ID('dbo.ProgresoRetos','U') IS NOT NULL DROP TABLE dbo.ProgresoRetos;
CREATE TABLE dbo.ProgresoRetos (
    ProgresoID      INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID       INT NOT NULL FOREIGN KEY REFERENCES dbo.Usuarios(UsuarioID),
    RetoID          INT NOT NULL FOREIGN KEY REFERENCES dbo.Retos(RetoID) ON DELETE CASCADE,
    PuntosObtenidos INT NOT NULL,
    TiempoSegundos  INT NULL,
    FechaCompletado DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_Progreso_Unico UNIQUE (UsuarioID, RetoID)
);
CREATE INDEX IX_Progreso_Usuario ON dbo.ProgresoRetos(UsuarioID);

-- Reacciones a retos (opcional)
IF OBJECT_ID('dbo.ReaccionesReto','U') IS NOT NULL DROP TABLE dbo.ReaccionesReto;
CREATE TABLE dbo.ReaccionesReto (
    ReaccionID     INT IDENTITY(1,1) PRIMARY KEY,
    RetoID         INT NOT NULL FOREIGN KEY REFERENCES dbo.Retos(RetoID) ON DELETE CASCADE,
    UsuarioID      INT NOT NULL FOREIGN KEY REFERENCES dbo.Usuarios(UsuarioID),
    TipoReaccion   NVARCHAR(20) NOT NULL DEFAULT N'Like'
        CONSTRAINT CK_ReaccionesReto_Tipo CHECK (TipoReaccion IN (N'Like',N'Corazon',N'Aplauso')),
    FechaReaccion  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_ReaccionReto UNIQUE (RetoID, UsuarioID)
);

 /* ===========================================================
   8) Notificaciones
   =========================================================== */

IF OBJECT_ID('dbo.Notificaciones','U') IS NOT NULL DROP TABLE dbo.Notificaciones;
CREATE TABLE dbo.Notificaciones (
    NotificacionID  INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID       INT NOT NULL FOREIGN KEY REFERENCES dbo.Usuarios(UsuarioID),
    Tipo            NVARCHAR(50) NOT NULL, -- 'NuevoComentario','Aprobacion','NuevoEvento', etc.
    Mensaje         NVARCHAR(600) NOT NULL,
    Enlace          NVARCHAR(600) NULL,
    Leida           BIT NOT NULL DEFAULT 0,
    FechaCreacion   DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
CREATE INDEX IX_Notificaciones_Usuario ON dbo.Notificaciones(UsuarioID, Leida);

 /* ===========================================================
   9) Vistas útiles (opcional)
   =========================================================== */

IF OBJECT_ID('dbo.vw_MemoriasPublicas','V') IS NOT NULL DROP VIEW dbo.vw_MemoriasPublicas;
GO
CREATE VIEW dbo.vw_MemoriasPublicas AS
SELECT m.MemoriaID, m.Titulo, m.Descripcion, m.Estado, m.EsPublico, m.FechaCreacion,
       u.UsuarioID, u.Nombre, u.Apellido, u.NombreUsuario,
       l.Departamento, l.Municipio, l.Barrio, l.Latitud, l.Longitud
FROM dbo.Memorias m
JOIN dbo.Usuarios u ON u.UsuarioID = m.UsuarioID
LEFT JOIN dbo.Localizaciones l ON l.LocalizacionID = m.LocalizacionID
WHERE m.Estado = N'Aprobado' AND m.EsPublico = 1 AND m.Activo = 1;
GO
 --- 

------
---
----- 6-9-25---
