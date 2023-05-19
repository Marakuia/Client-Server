import 'dart:io';
import 'dart:typed_data';


var time = DateTime.now().toString();

void main() async {

  final ip = InternetAddress.anyIPv4;
  
  final server = await ServerSocket.bind(ip, 4571);
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
      
      var winSize = '(';
      
       if (message.indexOf(winSize)!=-1){
      	print("Client wont window size \n");
      	print("Screen resolution: Size$message");
      	client.write("Screen resolution: Size$message");
      }
      else {
         var res = pid.toString();
      	 print("\nClient wont PID");
	 print("pid: $message \n");
      	 client.write("PID: "+ res);
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
