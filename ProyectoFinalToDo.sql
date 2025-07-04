-- Crear la base de datos
CREATE DATABASE ProyectoToDo;
GO

-- Usar la base de datos
USE ProyectoToDo;
GO

-- Tabla Usuarios
CREATE TABLE Usuarios (
    idUsuario INT PRIMARY KEY IDENTITY(1,1),
    nombreUsuario NVARCHAR(50) NOT NULL,
    correoUsuario NVARCHAR(100) UNIQUE NOT NULL,
    contrasenia NVARCHAR(255) NOT NULL,
    rol NVARCHAR(20) DEFAULT 'usuario',
    fotoPerfil NVARCHAR(255),
    tokenRecuperacion NVARCHAR(255),
    tokenExpiracion DATETIME
);

-- Tabla Proyectos
CREATE TABLE Proyectos (
    idProyecto INT IDENTITY(1,1) PRIMARY KEY,
    idUsuarioAdmin INT NOT NULL,
    nombreProyecto NVARCHAR(255) NOT NULL,
    descripcionProyecto TEXT,
    fechaCreacion DATETIME DEFAULT GETDATE(),
    fechaEntrega DATETIME,
    estadoProyecto NVARCHAR(50) DEFAULT 'Activo',
    CONSTRAINT FK_Proyecto_UsuarioAdmin FOREIGN KEY (idUsuarioAdmin) REFERENCES Usuarios(idUsuario)
);

-- Tabla ParticipantesProyecto (con clave compuesta como en el tercer script)
CREATE TABLE ParticipantesProyecto (
    idProyecto INT NOT NULL,
    idUsuario INT NOT NULL,
    rolProyecto NVARCHAR(50) NOT NULL DEFAULT 'miembro',
    estadoInvitacion NVARCHAR(50) NOT NULL DEFAULT 'pendiente',
    fechaUnido DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (idProyecto, idUsuario),
    CONSTRAINT FK_Participantes_Proyecto FOREIGN KEY (idProyecto) REFERENCES Proyectos(idProyecto) ON DELETE CASCADE,
    CONSTRAINT FK_Participantes_Usuario FOREIGN KEY (idUsuario) REFERENCES Usuarios(idUsuario) ON DELETE CASCADE
);

-- Tabla Tareas
CREATE TABLE Tareas (
    idTarea INT IDENTITY(1,1) PRIMARY KEY,
    idProyecto INT NOT NULL,
    nombreTarea NVARCHAR(255) NOT NULL,
    descripcionTarea TEXT,
    idUsuarioCreador INT NOT NULL,
    idUsuarioAsignado INT,
    fechaCreacion DATETIME DEFAULT GETDATE(),
    fechaEntrega DATETIME,
    estadoTarea NVARCHAR(50) DEFAULT 'Pendiente',
    prioridadTarea NVARCHAR(50) DEFAULT 'Media',
    CONSTRAINT FK_Tarea_Proyecto FOREIGN KEY (idProyecto) REFERENCES Proyectos(idProyecto) ON DELETE CASCADE,
    CONSTRAINT FK_Tarea_Creador FOREIGN KEY (idUsuarioCreador) REFERENCES Usuarios(idUsuario),
    CONSTRAINT FK_Tarea_Asignado FOREIGN KEY (idUsuarioAsignado) REFERENCES Usuarios(idUsuario)
);

-- Tabla Subtareas
CREATE TABLE Subtareas (
    idSubtarea INT IDENTITY(1,1) PRIMARY KEY,
    idTarea INT NOT NULL,
    nombreSubtarea NVARCHAR(255) NOT NULL,
    descripcionSubtarea TEXT,
    idUsuarioCreador INT NOT NULL,
    idUsuarioAsignado INT,
    fechaCreacion DATETIME DEFAULT GETDATE(),
    fechaEntrega DATETIME,
    estadoSubtarea NVARCHAR(50) DEFAULT 'Pendiente',
    prioridadSubtarea NVARCHAR(50) DEFAULT 'Media',
    CONSTRAINT FK_Subtarea_Tarea FOREIGN KEY (idTarea) REFERENCES Tareas(idTarea) ON DELETE CASCADE,
    CONSTRAINT FK_Subtarea_Creador FOREIGN KEY (idUsuarioCreador) REFERENCES Usuarios(idUsuario),
    CONSTRAINT FK_Subtarea_Asignado FOREIGN KEY (idUsuarioAsignado) REFERENCES Usuarios(idUsuario)
);

-- Tabla Notificaciones
CREATE TABLE Notificaciones (
    idNotificacion INT IDENTITY(1,1) PRIMARY KEY,
    idUsuarioReceptor INT NOT NULL,
    tipoNotificacion NVARCHAR(100) NOT NULL,
    mensaje NVARCHAR(MAX) NOT NULL,
    idProyectoRelacionado INT,
    idTareaRelacionada INT,
    idSubtareaRelacionada INT,
    idUsuarioEmisor INT,
    fechaCreacion DATETIME DEFAULT GETDATE(),
    leida BIT DEFAULT 0
);

-- Relaciones de Notificaciones
ALTER TABLE Notificaciones ADD CONSTRAINT FK_Notificacion_UsuarioReceptor
FOREIGN KEY (idUsuarioReceptor) REFERENCES Usuarios(idUsuario);

ALTER TABLE Notificaciones ADD CONSTRAINT FK_Notificacion_ProyectoRelacionado
FOREIGN KEY (idProyectoRelacionado) REFERENCES Proyectos(idProyecto) ON DELETE SET NULL;

ALTER TABLE Notificaciones ADD CONSTRAINT FK_Notificacion_TareaRelacionada
FOREIGN KEY (idTareaRelacionada) REFERENCES Tareas(idTarea) ON DELETE SET NULL;

ALTER TABLE Notificaciones ADD CONSTRAINT FK_Notificacion_SubtareaRelacionada
FOREIGN KEY (idSubtareaRelacionada) REFERENCES Subtareas(idSubtarea) ON DELETE SET NULL;

ALTER TABLE Notificaciones ADD CONSTRAINT FK_Notificacion_UsuarioEmisor
FOREIGN KEY (idUsuarioEmisor) REFERENCES Usuarios(idUsuario);

