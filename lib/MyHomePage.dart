import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dersAdi;
  int dersKredi = 1;
  double dersHarfDegeri = 4;
  List<Ders> tumDersler;
  var formKey = GlobalKey<FormState>();
  double ortalama=0;
  static int sayac=0;
  Color renk;

  @override
  void initState() {



    super.initState();
    tumDersler = [];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: uygulamaGovdesi(),
    );
  }

  void dersEkleMethodu() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
    }
  }

  Widget uygulamaGovdesi() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //Static formu tutan container
          Container(
            padding: EdgeInsets.only(top: 10, left: 15, right: 15),
            //all(15)
            child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.grey[200],
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Ders Adı",
                          hintText: "Ders Adını Giriniz",
                          // labelStyle: TextStyle(fontSize: 22),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          //enabbledborder ve focusedborder var yarala kırmızı yeşil yapman için gerekli
                        ),

                        validator: (girilenDeger) {
                          if (girilenDeger.length < 0) {
                            return null;
                          } else
                            "Ders Adı Boş Olamaz";
                        },
                        onSaved: (kaydedilecekDeger) {
                          dersAdi = kaydedilecekDeger;
                          renk=NotaGoreRenk(dersHarfDegeri); ///      ders renk donus
                          setState(() {
                            tumDersler
                                .add(Ders(dersAdi, dersHarfDegeri, dersKredi,renk));
                            ortalama=0;
                            ortalamayiHesapla();
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width/2-100,
                          height: 56,
                          child: Center(child: RichText(textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(text: tumDersler.length==0 ? "Not Yok" : "Ortalama",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black26)),
                                TextSpan(text: tumDersler.length==0 ? "" : "\n"+"${ortalama.toStringAsFixed(2)}",style: TextStyle(fontSize: 20,color: Colors.black)),
                              ],
                            ),
                          )),
                          decoration: BoxDecoration(
                            //border: Border.all(),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            gradient: linearRenkDonus(),
                          ),
                        ),
                        SizedBox(width: 2.5,),
                        Container(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                                items: dersKredileriItems(),
                                value: dersKredi,
                                onChanged: (secilenKredi) {
                                  setState(() {
                                    dersKredi = secilenKredi;
                                  });
                                }),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2.5),
                          margin: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 2.5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 2,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                        ),
                        Container(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<double>(
                                items: dersHarfDegerleriItems(),
                                value: dersHarfDegeri,
                                onChanged: (secilenHarfNot) {
                                  setState(() {
                                    dersHarfDegeri = secilenHarfNot;
                                  });
                                }),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2.5),
                          margin: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 2.5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 2,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                        ),

                        ButtonTheme(
                          minWidth: 30,
                          height: 56,
                          child: RaisedButton(onPressed: (){
                            dersEkleMethodu();
                          },
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0),side: BorderSide(color: Colors.black38,width: 2)),
                              color: Colors.white,
                              child: Icon(Icons.add,color: Colors.black,size: 45,)
                          ),
                        ),
                      ],
                    ),

                    /*Divider(
                      color: Colors.purple,
                      height: 20,
                    ),*/
                  ],
                )),
          ),
          //dinamik liste tutan container
          Expanded(
              child: Container(
                //color: Colors.green.shade200,
                child: ListView.builder(
                  itemBuilder: _listeElemanlariBuilder,
                  itemCount: tumDersler.length,
                ),
              )),
        ],
      ),
    );
  }

  dersKredileriItems() {
    List<DropdownMenuItem<int>> krediler = [];

    for (int i = 1; i <= 12; i++) {
      krediler.add(DropdownMenuItem<int>(
        value: i,
        child: Text(
          "$i kredi",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ));
    }

    return krediler;
  }

  dersHarfDegerleriItems() {
    List<DropdownMenuItem<double>> harfNotlari = [];

    harfNotlari.add(DropdownMenuItem(
      child: Text(
        " AA ",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      value: 4,
    ));
    harfNotlari.add(DropdownMenuItem(
      child: Text(
        " BA ",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      value: 3.50,
    ));
    harfNotlari.add(DropdownMenuItem(
      child: Text(
        " BB ",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      value: 3.0,
    ));
    harfNotlari.add(DropdownMenuItem(
      child: Text(
        " CB ",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      value: 2.5,
    ));
    harfNotlari.add(DropdownMenuItem(
      child: Text(
        " CC ",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      value: 2.0,
    ));
    harfNotlari.add(DropdownMenuItem(
      child: Text(
        " DC ",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      value: 1.5,
    ));
    harfNotlari.add(DropdownMenuItem(
      child: Text(
        " DD ",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      value: 1.0,
    ));
    harfNotlari.add(DropdownMenuItem(
      child: Text(
        " FD ",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      value: 0.5,
    ));
    harfNotlari.add(DropdownMenuItem(
      child: Text(
        " FF ",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      value: 0.0,
    ));

    return harfNotlari;
  }

  Widget _listeElemanlariBuilder(BuildContext context, int index) {

    sayac++;
    //Color notaGoreOLusanRenk=NotaGoreRenk(index);

    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        setState(() {
          tumDersler.removeAt(index);
          ortalamayiHesapla();
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: tumDersler[index].renk,width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Card(
          elevation: 7,
          child: ListTile(
            trailing: Icon(Icons.arrow_forward_ios),
            title: Text(tumDersler[index].ad,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            subtitle: Text("Dersin Kredisi : "+tumDersler[index].kredi.toString() +
                "\n" +
                "Notunuza Denk Gelen Kredi Değeri : "+ tumDersler[index].harfDegeri.toString()),
          ),
        ),
      ),);
  }

  void ortalamayiHesapla() {

    double toplamKredi=0;
    double toplamNot=0;

    for(var oankiDers in tumDersler){
      toplamKredi=toplamKredi+oankiDers.kredi;
      toplamNot=toplamNot+(oankiDers.harfDegeri*oankiDers.kredi);
    }

    ortalama=toplamNot/toplamKredi;

  }

  LinearGradient linearRenkDonus(){

    if(ortalama>=2){
      return LinearGradient(
        // Where the linear gradient begins and ends
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        // Add one stop for each color. Stops should increase from 0 to 1
        stops: [0.1, 0.5, 0.7, 0.9],
        colors: [
          // Colors are easy thanks to Flutter's Colors class.
          Colors.green[300],
          Colors.green[200],
          Colors.green[100],
          Colors.green[50],
        ],
      );
    }else if(ortalama<2 && ortalama>=1.5){
      return LinearGradient(
        // Where the linear gradient begins and ends
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        // Add one stop for each color. Stops should increase from 0 to 1
        stops: [0.1, 0.5, 0.7, 0.9],
        colors: [
          // Colors are easy thanks to Flutter's Colors class.
          Colors.orange[300],
          Colors.orange[200],
          Colors.orange[100],
          Colors.orange[50],

        ],
      );
    }else if(ortalama<1.5 && ortalama>0){
      return LinearGradient(
        // Where the linear gradient begins and ends
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        // Add one stop for each color. Stops should increase from 0 to 1
        stops: [0.1, 0.5, 0.7, 0.9],
        colors: [
          // Colors are easy thanks to Flutter's Colors class.
          Colors.red[300],
          Colors.red[200],
          Colors.red[100],
          Colors.red[50],

        ],
      );
    }else{
      return LinearGradient(
        // Where the linear gradient begins and ends
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        // Add one stop for each color. Stops should increase from 0 to 1
        stops: [0.1, 0.5, 0.7, 0.9],
        colors: [
          // Colors are easy thanks to Flutter's Colors class.
          Colors.grey[600],
          Colors.grey[500],
          Colors.grey[400],
          Colors.grey[200],

        ],
      );

    }


  }

  Color NotaGoreRenk(double kredi) {
    if(kredi>=2){
      return Colors.green[300];
    }else if(kredi<2 && kredi>=1.5){
      return Colors.orange[300];
    }else if(kredi<1.5 && kredi>=0){
      return Colors.red[300];
    }else{
      return Colors.grey[400];
    }
  }
}

class Ders {
  String ad;
  double harfDegeri;
  int kredi;
  Color renk;


  Ders(this.ad, this.harfDegeri, this.kredi,this.renk);
}
