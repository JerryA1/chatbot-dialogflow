import 'package:chatbar/chatbar.dart';
import 'package:flutter/material.dart';
import 'package:practica_chatbot/src/app.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({Key key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  final DialogFlowtter _dialogFlowtter = DialogFlowtter();

  /// Crea la función sendMessage el cuál manejará 
  /// la lógica de nuestros mensajes
  void sendMessage(String text) async {
    
    // Verifica que el texto del usuario no esté vacío
    // si lo está, termina de ejecutar la función
    if (text.isEmpty) return;
    
    /// Añade nuestro texto enviado por el usuario en forma de 
    /// [Message] a nuestra lista y actualiza el estado del widget
    setState(() {
      Message userMessage = Message(text: DialogText(text: [text]));
      addMessage(userMessage, true);
    });


    /// Creamos la [query] que le enviaremos al agente
    /// a partir del texto del usuario
    QueryInput query = QueryInput(text: TextInput(text: text));

    /// Esperamos a que el agente nos responda
    /// El keyword [await] indica a la función que espere a que [detectIntent]
    /// termine de ejecutarse para después continuar con lo que resta de la función
    DetectIntentResponse res = await _dialogFlowtter.detectIntent(
      queryInput: query,
    );

    /// Si el mensaje de la respuesta es nulo, no continuamos con la ejecución
    /// de la función
    if (res.message == null) return;

    /// Si hay un mensaje de respuesta, lo agregamos a la lista y actualizamos
    /// el estado de la app
    setState(() {
      addMessage(res.message);
    });
  }

  /// La función recibe un mensaje de tipo [Message].
  /// El segundo parámetro entre corchetes quiere decir que ese parámetro 
  /// es opcional y que si no se le pasa a la función, será falso
  void addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

   void show() {
    final context = navigatorKey.currentState.overlay.context;
    final dialog = AlertDialog(
      content: Container(
        child: Image.network(
            "https://s3-eu-west-1.amazonaws.com/userlike-cdn-blog/do-i-need-a-chatbot/header-chat-box.png"),
      ),
    );
    showDialog(context: context, builder: (x) => dialog);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
        home: Scaffold(
        appBar: ChatBar(
          onprofileimagetap: () => show(),
          profilePic: Image.network(
            'https://www.weka.de/wp-content/uploads/2020/05/chatbot-scaled.jpg',
            height: 50,
            width: 50,
            fit: BoxFit.contain,
          ),
          username: "Lince ChatBot",
          status: Text(''),
          color: Colors.green.shade400,
          backbuttoncolor: Colors.white,
          backbutton: IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            color: Colors.white,
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.phone),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.videocam),
              color: Colors.white,
            ),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              enabled: true,
              onSelected: (str) {},
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                const PopupMenuItem<String>(
                  value: 'View Contact',
                  child: Text('View Contact'),
                ),
                const PopupMenuItem<String>(
                  value: 'Media',
                  child: Text('Media'),
                ),
                const PopupMenuItem<String>(
                  value: 'Search',
                  child: Text('Search'),
                ),
                const PopupMenuItem<String>(
                  value: 'Wallpaper',
                  child: Text('Wallpaper'),
                ),
              ],
            )
          ],
        ),
        body: Column(
          children: [
            /// Esta parte se asegura que la caja de texto se posicione hasta abajo de la pantalla
            Expanded(
              /// Cambiamos el container anterior por nuestro componente
              /// [MessagesList] y le pasamos la lista de mensajes
              child: _MessagesList(messages: messages),
            ), 
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5,),
              color: Colors.blue,
              child: Row(
                children: [
                  /// El Widget [Expanded] se asegura que el campo de texto ocupe
                  /// toda la pantalla menos el ancho del [IconButton]
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _controller, 
                    ),
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.send),
                    onPressed: () {
                      /// Mandamos a llamar la función [sendMessage]
                      sendMessage(_controller.text);
                      
                      /// Limpiamos nuestro campo de texto 
                      _controller.clear();
                    },
                  ),
                ],
              ), // Fin de la fila
            ), // Fin del contenedor
          ],
        ),
      ),
    );
  }
} 

class _MessagesList extends StatelessWidget {
  /// El componente recibirá una lista de mensajes
  final List<Map<String, dynamic>> messages;

  const _MessagesList({
    Key key,
    
    /// Le indicamos al componente que la lista estará vacía en
    /// caso de que no se le pase como argumento alguna otra lista
    this.messages = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Regresaremos una [ListView] con el constructor [separated]
    /// para que después de cada elemento agregue un espacio
    return ListView.separated(
      /// Indicamos el número de items que tendrá
      itemCount: messages.length,
      
      // Agregamos espaciado
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      
      /// Indicamos que agregue un espacio entre cada elemento
      separatorBuilder: (_, i) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        /// Obtenemos el objecto actual
        var obj = messages[messages.length - 1 - i];
        return _MessageContainer(
          /// Cambiamos el orden por el cuál iterará en los mensajes
          /// de nuestra lista de atrás hacia adelante
          /// Obtenemos el mensaje del objecto actual
          message: obj['message'],
          /// Diferenciamos si es un mensaje o una respuesta
          isUserMessage: obj['isUserMessage'],
        );
      },
      /// Indicamos que pinte la lista al revés
      reverse: true,
    );
  }
}

class _MessageContainer extends StatelessWidget {
  final Message message;
  final bool isUserMessage;

  const _MessageContainer({
    Key key,
    
    /// Indicamos que siempre se debe mandar un mensaje
    @required this.message,
    this.isUserMessage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      /// Cambia el lugar del mensaje
      mainAxisAlignment:
          isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          /// Limita nuestro contenedor a un ancho máximo de 250
          constraints: BoxConstraints(maxWidth: 250),
          child: Container(
            decoration: BoxDecoration(
              /// Cambia el color del contenedor del mensaje
              color: isUserMessage ? Colors.blue : Colors.orange,
              
              /// Le agrega border redondeados
              borderRadius: BorderRadius.circular(20),
            ),
            
            /// Espaciado
            padding: const EdgeInsets.all(10),
            child: Text(
              /// Obtenemos el texto del mensaje y lo pintamos. 
              /// Si es nulo, enviamos un string vacío.
              message?.text?.text[0] ?? '',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}