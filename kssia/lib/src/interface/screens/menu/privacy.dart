import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy policy'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lorem ipsum dolor sit amet consectetur. Lorem non tortor diam lorem viverra at nisl purus. Nec nec velit id proin vitae tempus orci donec tortor. Vehicula morbi ultricies potenti a. Fermentum nec aliquet quam velit netus. Proin eget leo non laoreet risus viverra lorem pharetra enim. Platea massa ornare id tellus nulla id ullamcorper nisl est. Sem quam est at urna feugiat. Tristique porttitor elit ultricies orci egestas vestibulum. Nibh posuere risus a pharetra proin nunc nibh. Neque sit viverra sit pellentesque elementum hendrerit dolor.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Id turpis lacus dolor elit suscipit quisque. Pulvinar vitae sed arcu posuere turpis odio. Dicitum justo ac turpis leo consequat congue. Risus mauris scelerisque in habitant id magna lorem volutpat. Orci dictum adipiscing cras odio. Tincidunt arcu nibh maecenas nisi. Commodo dignissim dui ligula leo pulvinar. Vel volutpat pretium lectus porta tincidunt arcu dolor. Enim.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
