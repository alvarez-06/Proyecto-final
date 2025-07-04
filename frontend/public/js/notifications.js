// frontend/public/js/notifications.js
document.addEventListener('DOMContentLoaded', () => {
    const notificationCountSpan = document.getElementById('notification-count');

    async function fetchNotificationCount() {
        if (!notificationCountSpan) return;

        try {
            const response = await fetch('/api/notifications/count');
            if (response.ok) {
                const data = await response.json();
                if (data.count > 0) {
                    notificationCountSpan.textContent = data.count;
                    notificationCountSpan.style.display = 'inline';
                } else {
                    notificationCountSpan.style.display = 'none';
                }
            } else {
                console.error('Error al obtener el conteo de notificaciones:', response.statusText);
            }
        } catch (error) {
            console.error('Error de red al obtener el conteo de notificaciones:', error);
        }
    }

    // Llama a la función al cargar la página
    fetchNotificationCount();

    // Opcional: Actualizar el conteo periódicamente (cada 30 segundos, por ejemplo)
    setInterval(fetchNotificationCount, 30000);
});