import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youtube_metadata/youtube_metadata.dart';
// import 'package:html/parser.dart';

void main() => runApp(YoutubeDownloaderApp());

class YoutubeDownloaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Downloader',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: YoutubeDownloaderScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class YoutubeDownloaderScreen extends StatefulWidget {
  @override
  _YoutubeDownloaderScreenState createState() => _YoutubeDownloaderScreenState();
}

class _YoutubeDownloaderScreenState extends State<YoutubeDownloaderScreen> {
  TextEditingController _urlController = TextEditingController();

  var metaData;
  String title='';
  bool _ismetaData = false;
  bool _isSearch = false; //Search suffix is clicked or not

  Future<void> _fetchMetadata(String link) async {
    try {
      setState(() {
        _isSearch = true;
      });
      metaData = await YoutubeMetaData.getData(link);
    } catch (e) {
      metaData = null;
    }
    setState(() {
      title = metaData.title;
      _ismetaData = true;
      _isSearch = false;
      title += '.';
      print(title);
    });
    
  }

  Future<void> _downloadVideo() async {
    _fetchMetadata(_urlController.text.trim());
    try{
      Fluttertoast.showToast(
        msg: "Downloading...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 238, 87, 76),
        textColor: Colors.white,
        fontSize: 16.0
    );
      await FlutterYoutubeDownloader.downloadVideo(
            _urlController.text.trim(), title, 18);
    }catch(e){
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 238, 87, 76),
        textColor: Colors.white,
        fontSize: 16.0
    );
    }
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Video Downloader'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
        child:Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ismetaData 
            ?  
              !_isSearch
              ? Container(child: Image.network(metaData.thumbnailUrl),)
              : CircularProgressIndicator(color: Colors.red,)
            : 
              _isSearch
              ? CircularProgressIndicator(color: Colors.red,)
              : Container(child: Image(image: AssetImage('assets/placeholder.jpg'))),

            SizedBox(height: 16.0),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'YouTube Video URL',
              suffixIcon: Padding(
              padding: EdgeInsetsDirectional.only(end: 12.0),
              child: GestureDetector(
                child:
                Icon(Icons.search, color: Colors.red,),
                onTap: (){
                  _fetchMetadata(_urlController.text.trim());
                },
              )
            )
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: (){
                _downloadVideo();
              },
              child: Text('Download'),
            ),
          ],
        ),
      ),
    
      )
      ,
      ),
      );
  }
}
