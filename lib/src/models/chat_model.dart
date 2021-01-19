class ChatModel {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;

  ChatModel({this.name, this.message, this.time, this.avatarUrl});
}

List<ChatModel> dummyData = [
  new ChatModel(
      name: "Lince ChatBots",
      message: "Hey, try me!",
      time: "15:30",
      avatarUrl:
          "https://www.weka.de/wp-content/uploads/2020/05/chatbot-scaled.jpg"),
  new ChatModel(
      name: "Harvey Spectre",
      message: "Hey I have hacked whatsapp!",
      time: "17:30",
      avatarUrl:
          "https://www.weka.de/wp-content/uploads/2020/05/chatbot-scaled.jpg"),
  new ChatModel(
      name: "Mike Ross",
      message: "Wassup !",
      time: "5:00",
      avatarUrl:
          "https://www.weka.de/wp-content/uploads/2020/05/chatbot-scaled.jpg"),
  new ChatModel(
      name: "Rachel",
      message: "I'm good!",
      time: "10:30",
      avatarUrl:
          "https://www.weka.de/wp-content/uploads/2020/05/chatbot-scaled.jpg"),
  new ChatModel(
      name: "Barry Allen",
      message: "I'm the fastest man alive!",
      time: "12:30",
      avatarUrl:
          "https://www.weka.de/wp-content/uploads/2020/05/chatbot-scaled.jpg"),
  new ChatModel(
      name: "Joe West",
      message: "Hey Flutter, You are so cool !",
      time: "15:30",
      avatarUrl:
          "https://www.weka.de/wp-content/uploads/2020/05/chatbot-scaled.jpg"),
];