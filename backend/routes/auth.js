//auth
const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController.js');
const projectController = require('../controllers/projectController'); // NECESARIO para las nuevas funciones de notificaciones
const { verifyCsrfToken } = require('../middlewares/csrf');
const upload = require('../middlewares/uploads');
const { isAuthenticated } = require('../middlewares/auth'); //



router.get('/', authController.getLogin); // Formulario del login
router.get('/registro', authController.getRegister); // Formulario del registro
router.get('/index', authController.getIndex) //Pagina de inicio
router.get('/recuperar', authController.getRecoverForm); // Formulario recuperar contraseña
router.get('/reset-password/:token', authController.getResetForm); // Formulario nueva_contraseña

router.post('/login', verifyCsrfToken, authController.validateLogin, authController.postLogin); // Procesa el login

router.post('/registro', upload, verifyCsrfToken, authController.postRegister); // Procesa el registro

// Para enviar el correo de recuperación, aplicamos la validación
router.post('/enviar-recuperacion', verifyCsrfToken, authController.validateSendRecoverEmail, authController.sendRecoverEmail); // Procesa enviar correo_recuperacion

// Para procesar la nueva contraseña, aplicamos la validación
router.post('/reset-password/:token', verifyCsrfToken, authController.validateResetPassword, authController.postResetPassword); // Procesa nueva_contraseña

// Cerrar sesión
router.get('/logout', authController.logout);

router.get('/api/notifications/count', isAuthenticated, projectController.getUnreadNotificationsCount);


// Rutas de Notificaciones e Invitaciones
router.get('/notificaciones', isAuthenticated, projectController.getInvitationsAndNotifications);
router.post('/invitaciones/aceptar/:idProyecto', isAuthenticated, verifyCsrfToken, projectController.postAcceptInvitation);
router.post('/invitaciones/rechazar/:idProyecto', isAuthenticated, verifyCsrfToken, projectController.postRejectInvitation);



module.exports = router;