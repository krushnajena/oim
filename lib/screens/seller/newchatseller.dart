import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SellerChatnew extends StatefulWidget {
  const SellerChatnew({Key? key}) : super(key: key);


 @override
  State<SellerChatnew> createState() => _SellerChatnewState();

}

class _SellerChatnewState extends State<SellerChatnew> {
late IO.Socket socket;

@override
void initState(){
  super.initState();
  connect();
}

void connect(){
  socket = IO.io("https://4030-119-160-97-24.ngrok.io/", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect;
    socket.onConnect((data) => print("conected"));
    print(socket.connected);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: 
       PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              backgroundColor: Colors.white,
              leadingWidth: 70,
              titleSpacing:5,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Colors.black,
                    ),
                    SizedBox(width: 5,),
                    CircleAvatar(
                      child: Image.asset(
                       'images/splash_logo2.png',
                        color: Colors.black,
                        height: 36,
                        width: 36,
                      ),
                      radius: 20,
                      backgroundColor: Colors.blueGrey,
                    ),
                  ],
                ),
              ),
              
              title: InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'name',
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(icon: const Icon(Icons.call,color: Colors.black,), onPressed: () {}),
                  PopupMenuButton<String>(
                  icon:Icon(Icons.more_vert,color: Colors.black,),
                  padding: EdgeInsets.all(0),
                  onSelected: (value) {
                    print(value);
                  },
                   itemBuilder: (BuildContext contesxt) {
                    return [
                      PopupMenuItem(
                        
                        child: Text("View Contact"),
                        value: "View Contact",
                      ),
                    ];
                   }

                  )
              
                  
                
                
              ],
            ),
       ),
       body: Column(children: [

   Container(
    height: 50,
   color: Colors.white,
   child: Padding(
     padding: const EdgeInsets.only(left: 10,right: 10),
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
       Text("Oneplus9t"),

       Text("\$ 3499"),
     ]),
   ),
  
),
Expanded(
  child:   Container(
  
    color: Colors.grey,
  
  ),
),
Align(
  alignment: Alignment.bottomCenter,
    child:TextFormField(
      
      decoration: InputDecoration(
        hintText: "Type here",
        prefixIcon: Icon(Icons.attach_file,color: Colors.black,),
        suffixIcon: Icon(Icons.mic,color: Colors.black,),
      ),

  
  ),
)


       ]),

    );
  }


}