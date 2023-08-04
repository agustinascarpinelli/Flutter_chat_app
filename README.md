# ChatApp

Una aplicación de Flutter que permite chatear en tiempo real con diferentes usuarios de la aplicación. Utiliza un servidor propio construido con Node.js, MySQL y sockets para la comunicación en tiempo real. Puedes encontrar el servidor en el repositorio [Flutter Chat Backend](https://github.com/agustinascarpinelli/Flutter-chat-backend).


## Características

- Registro e inicio de sesión de usuarios.
- Búsqueda y solicitud de amistad a otros usuarios de la aplicación.
- Aceptación de solicitudes de amistad.
- Chat en tiempo real con amigos aceptados.
- Historial de chat persistente.
- Opción para borrar el historial de chat.
- Estado de conexión en pantalla (verde: conectado, rojo: desconectado).
- Opción para conectarse y desconectarse manualmente.

## Dependencias

- [cupertino_icons](https://pub.dev/packages/cupertino_icons): ^1.0.2
- [pull_to_refresh](https://pub.dev/packages/pull_to_refresh): ^2.0.0
- [provider](https://pub.dev/packages/provider): ^6.0.5
- [http](https://pub.dev/packages/http): ^0.13.5
- [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage): ^8.0.0
- [socket_io_client](https://pub.dev/packages/socket_io_client): ^2.0.1

## Instalación

1. Clona este repositorio en tu máquina local:

   ```
   git clone https://github.com/tu-usuario/flutter_chat_app.git
   ```

2. Navega hasta el directorio del proyecto:

   ```
   cd flutter_chat_app
   ```

3. Ejecuta el siguiente comando para obtener las dependencias:

   ```
   flutter pub get
   ```

4. Configura la conexión al servidor backend en el archivo `lib/services/socket_service.dart`. Asegúrate de proporcionar la URL correcta y los detalles de conexión al servidor.

5. Ejecuta el servidor propio siguiendo las instrucciones del repositorio [Flutter Chat Backend](https://github.com/agustinascarpinelli/Flutter-chat-backend).

6. Ejecuta la aplicación en tu dispositivo o emulador:

   ```
   flutter run
   ```


Las contribuciones son bienvenidas. Si encuentras algún error o tienes sugerencias de mejoras, siéntete libre de abrir un [issue](https://github.com/tu-usuario/flutter_chat_app/issues) o enviar un [pull request](https://github.com/tu-usuario/flutter_chat_app/pulls).

## Licencia

_Inserta aquí la licencia que deseas utilizar para tu aplicación, por ejemplo: [MIT License](https://opensource.org/licenses/MIT)._
