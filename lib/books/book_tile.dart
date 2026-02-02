import 'package:flutter/material.dart';
import 'package:testapp3/books/preview.dart';

class BookTile extends StatelessWidget {
  final String bookImageurl;
  final String title;
  final String author;
  final int pages;
  final String grade;
  final String shopurl;
  final bool review;
  final int rating;
  final String ReviewText;
  const BookTile({super.key,required this.bookImageurl,required this.title,required this.author,required this.pages,required this.grade,required this.shopurl,this.review=false,this.rating=0,this.ReviewText=""});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>BookPreview(
          title: title,
          author: author,
          pages: pages,
          grade: grade,
          bookImageurl: bookImageurl,
          shopurl:shopurl,review: review,rating: rating,ReviewText: ReviewText
        )));
      },
      child: Container(
        height:230 , width: 350,
        margin: EdgeInsets.only(top: 20, bottom:19),
        padding: EdgeInsets.all(0.1),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Color(0xfff2f2f7)
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [


            SizedBox(
              width: 100,
              height: 150,
              child: bookImageurl.isNotEmpty
                  ? Image.network(bookImageurl, fit: BoxFit.cover)
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.menu_book, size: 40, color: Colors.grey[600]),
                          SizedBox(height: 5),
                          Text("No Cover", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                    ),
            ),
            SizedBox(
              width: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 25,fontFamily: "Voltaire"),),
                    Text(author,style: TextStyle(fontSize: 22,fontFamily: "Voltaire"),),
                    (review)?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(rating, (index)=>Icon(Icons.star,size: 30,color: Colors.yellow,)),
                    ):
                    Text(pages.toString()+" pages",style: TextStyle(fontSize: 21,fontFamily: "Voltaire"),),
                    //Text(grade,style: TextStyle(fontSize: 25,fontFamily: "Voltaire"),),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
