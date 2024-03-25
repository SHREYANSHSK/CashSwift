import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class pay_page extends StatefulWidget {
  String scanBarcode;
   pay_page(String this.scanBarcode, {super.key});

  @override
  State<pay_page> createState() => _pay_pageState();
}

class _pay_pageState extends State<pay_page> {

  @override
  Widget build(BuildContext context) {
    log(widget.scanBarcode);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromRGBO(15, 15, 15, 1),
        child:  SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              const CircleAvatar(radius: 80,child: Icon(Icons.account_circle_outlined),backgroundColor: Colors.black26,),
              const SizedBox(height: 20,),
              const Text("PAYING TO",style: TextStyle(color: Colors.white70,fontSize: 30),),
              const Text("NAme",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w700),),
              Text("${widget.scanBarcode}@CodeSwift",style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 12,fontWeight: FontWeight.w700),),
              const SizedBox(height: 70,),
              Center(
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon((Icons.currency_rupee_outlined),color: Colors.white,size: 30,),
                    TextField(
                      keyboardType: TextInputType.number,style: GoogleFonts.arimo(textStyle:const TextStyle(color: Colors.white,fontSize: 20,letterSpacing: 3)),autofocus: true,
                      decoration: InputDecoration(fillColor: Colors.black45,
                          constraints: const BoxConstraints(maxWidth: 200),filled: true,
                          focusedBorder: OutlineInputBorder(gapPadding: 5,
                            borderRadius: BorderRadius.circular(12),
          
                            borderSide: const BorderSide(
                                style: BorderStyle.solid, color: Colors.white, width: 1),
                          ),
                          border: OutlineInputBorder(gapPadding: 5,
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                style: BorderStyle.solid, color: Colors.white60, width: 3),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
