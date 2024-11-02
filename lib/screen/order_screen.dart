import 'package:flutter/material.dart';
import 'package:vape_store/screen/home_screen.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        title: Text('Order Screen'),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: BackButton(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: FilledButton(
            style: FilledButton.styleFrom(
              fixedSize: Size(240, 100),
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: Text('CHECKOUT (RP 123.456)')),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Cart',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Card(
                        child: Image.asset(
                      'lib/images/banner1.png',
                      height: 150,
                      width: 150,
                    )),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Monkey Busines',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'Option : 30ML',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[500]),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'RP 123.456',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[500]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                                margin: EdgeInsets.all(0),
                                child: Row(children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.remove)),
                                  Text('1'),
                                  IconButton(
                                      onPressed: () {}, icon: Icon(Icons.add)),
                                ])),
                            SizedBox(width: 20),
                            IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor: Colors.grey[200],
                                    fixedSize: Size(50, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                onPressed: () {},
                                icon: Icon(Icons.delete)),
                          ],
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text(
                    'My Cart',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            style: IconButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                                fixedSize: Size(50, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: () {},
                            icon: Icon(Icons.location_on)),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Jl Simongan 63 RT 005/008,',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700])),
                              SizedBox(height: 2),
                              Text('Jl Kedungjati 12, Jawa Tengah ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[500])),
                            ]),
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.arrow_forward)),
                      ])
                ])),
            SizedBox(height: 30),
            Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            style: IconButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                                fixedSize: Size(50, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: () {},
                            icon: Icon(Icons.payment)),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Jl Simongan 63 RT 005/008,',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700])),
                              SizedBox(height: 2),
                              Text('Jl Kedungjati 12, Jawa Tengah ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[500])),
                            ]),
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.arrow_forward)),
                      ])
                ])),
            SizedBox(height: 30),
            Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(
                    children: [
                      const Text(
                        'Order Info',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal : ',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700])),
                        Text('Rp 123.456',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500]))
                      ]),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping Cost : ',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700])),
                        Text('+ Rp 123.456',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500]))
                      ]),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discount : ',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700])),
                        Text('- Rp 123.456',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500]))
                      ]),
                  const SizedBox(height: 15),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total : ',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700])),
                        Text('Rp 123.456',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]))
                      ])
                ])),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
