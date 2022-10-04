import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/Login.dart';
import 'package:whatsapp/telas/AbaConversas.dart';
import 'package:whatsapp/telas/AbasContatos.dart';
import 'package:whatsapp/telas/Configuracoes.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{

  late TabController _tabController;

  List<String> itensMenu = [
    "Configurações",
    "Deslogar"
  ];


  Future _recuperarDadosUsuario()async{

    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;

    // setState(() {
    //   _emailUsuario = usuarioLogado!.email!;
    // });
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
    _tabController = TabController(
        length: 2,
        vsync: this
    );
  }

  _escolhaMenuItem(String itemEscolhido){

    switch(itemEscolhido){
      case "Configurações":
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> const Configuracoes(),
            )
        );
        break;
      case "Deslogar":
        _deslogar();
        break;

    }
  }

  _deslogar()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=> const Login(),
    ));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Whatsapp"),
        backgroundColor: const Color(0xff075E54),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Conversas",),
            Tab(text: "Contatos",)
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context){
              return itensMenu.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AbaConversas(),
          AbaContatos()
        ],
      ),
    );
  }
}
