import 'dart:io';
import 'dart:typed_data';


var time_connection_start = DateTime.now().millisecond;
void main() async {
  final ip = InternetAddress.anyIPv4;
  
  final server = await ServerSocket.bind(ip, 4563);
  print("Server is running on: ${ip.address} 3000");

  server.listen((client) {
    handleConnection(client);
  });
}

void handleConnection(Socket client) {
  print('Connection from'
      ' ${client.remoteAddress.address}:${client.remotePort}');

  client.listen(
    (Uint8List data) async {
      await Future.delayed(Duration(seconds: 1));
      final message = String.fromCharCodes(data);

      var size = 'Size';
      
      
      if (message.indexOf(size)!=-1){
  		
      		print("Client window size \n");
      		print("window size: "+ message);
      		client.write("window size: "+ message);
      }	
      else {
      		time_connection_start = time_connection_start+DateTime.now().millisecond;
      		print("\nClient wont time");
      		print("time: $message \n");
      		client.write("Working time: $time_connection_start milliseconds");
      }
        
    },
    onError: (error) {
      print(error);
      client.close();
    },
    onDone: () {
      print('Client left');
      client.close();
    },
  );
}
