//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:quizapp/services/database.dart';
import 'package:quizapp/views/create_quiz.dart';
import 'package:quizapp/views/play_quiz.dart';
import 'package:quizapp/widgets/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();

  Widget quizList(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(

        stream: quizStream,

        builder: (context, snapshot){
          return snapshot.data == null ? Container() : ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){

                return QuizTile(ImgUrl: snapshot.data.docs[index].data()["quizImgUrl"],
                                desc: snapshot.data.docs[index].data()["quizDesc"],
                                title: snapshot.data.docs[index].data()["quizTitle"],
                                quizid: snapshot.data.docs[index].data()["quizId"],);

          });
        },

      ),
    );
  }

  @override
  void initState() {
    databaseService.getQuizesData().then((val){
      setState(() {
        quizStream =val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
      ),
      body: quizList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => createQuiz()));
        },
      ),
    );
  }
}

class QuizTile extends StatelessWidget {
 final String ImgUrl;
 final String title;
 final String desc;
 final String quizid;

 QuizTile({@required this.ImgUrl,@required this.title,@required this.desc,@required this.quizid});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => PlayQuiz(quizid)
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8, top: 10),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(ImgUrl,width: MediaQuery.of(context).size.width - 48, fit: BoxFit.cover, )),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black26,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(title, style: TextStyle(color: Colors.white, fontSize: 17,fontWeight: FontWeight.w500),),
                SizedBox(height: 6),
                Text(desc,style: TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w400),)
              ],),
            )
          ],
        ),
      ),
    );
  }
}
