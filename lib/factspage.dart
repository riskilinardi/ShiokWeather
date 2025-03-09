import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Factspage extends StatefulWidget {
  @override
  State<Factspage> createState() => _FactspageState();
}

//To save the articles from json
class articles{
  String title;
  String imagePath;
  String description;

  articles (
      this.title, this.imagePath, this.description
      );
}

class _FactspageState extends State<Factspage> {
  List<articles> articlesList = [];

  @override
  void initState()  {
    super.initState();
  }

  //Decode the articles json
  Future<void> loadJsonAsset() async {
    final String jsonString = await rootBundle.loadString('assets/articles.json');
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    for (var x = 0; x < 6; x++) {
      var list = articles(
          data['articles'][x]['title'].toString(),
        data['articles'][x]['imagePath'].toString(),
        data['articles'][x]['description'].toString()
      );
      print(list.title);
      articlesList.add(list);
    }
  }

  //Display pop up dialog when article is pressed
  void _showDialog(String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Article Content"),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Cloudy Minds, Sunny Souls",
          style: TextStyle(color: Colors.white),
        ),
      ),
      //Call JSON so that we can use it to populate the list
      body: FutureBuilder(future: loadJsonAsset(), builder: (BuildContext context, AsyncSnapshot snapshot){
        if(articlesList.isNotEmpty){
          return Container(
        color: Colors.black87,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    //If list is empty, return text message
                  new List.generate(2, (index) =>
                  articlesList.isNotEmpty? _buildArticleHorizontal(
                      articlesList[index].title,
                      articlesList[index].imagePath,
                      articlesList[index].description
                  ) : Text('List empty'))
              ),
            ),
            SizedBox(height: 50),
            Column(
              children: [
                ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        itemBuilder: (context, i){
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: _buildArticleVertical(
                                articlesList[i+2].title,
                                articlesList[i+2].imagePath,
                                articlesList[i+2].description),
                          );
                        }
                    ),
                  ],
                ),
              ],
            ),
          );
          //If list is empty
        } else {
          return Container(
            child: Column(
              children: <Widget>[
                Padding(padding: new EdgeInsets.only(top: 200.0)),
                Center(child: Text(snapshot.error.toString())),
              ],
            ),
          );
        }
      }
      ),
    );
  }

  //Reduce code redundancy for horizontal articles
  Widget _buildArticleHorizontal(String title, String path, String description){
    return GestureDetector(
      onTap: () {
        _showDialog(description);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 180,
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(path),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Reduce code redundancy for vertical articles
  Widget _buildArticleVertical(String title, String path, String description){
    return GestureDetector(
      onTap: () {
        _showDialog(description);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: [
            Container(
              height: 100,
              width: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(
                    path,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
