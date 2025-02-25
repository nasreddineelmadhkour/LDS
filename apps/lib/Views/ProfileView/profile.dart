import 'package:LDS/Models/StaticAccount.dart';
import 'package:LDS/Widgets/colorTheme.dart';
import 'package:LDS/Widgets/line_edit.dart';
import 'package:flutter/material.dart';


class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {

 // AccountViewModel accountViewModel = AccountViewModel();
  bool readOnly = true,
      isPhoto = false,
      isName = false,
      isEmail = false,
      isPhone = false,
      isPassword = false;
  bool showPassword=false;

  TextEditingController
  nameController = TextEditingController(text: ""),
      emailController = TextEditingController(text: ""),
      phoneController = TextEditingController(text: ""),
      passwordController = TextEditingController(text: "");

String name="",email="",phone="",password="";
int status = 0;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height + 40;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This hides the back button
        title: Row(
          children: [
            // Add spacer to push the title to the right
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Profile",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: ColorTheme.appBarBigTitleColor,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: ColorTheme.backgroundNormalColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: ColorTheme.backgroundNormalColor,
          height: height,
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
              Stack(
                children: [
                  SizedBox(
                    width: width,
                    height: 125,
                    child: Container(
                      height: 125,
                      width: 125,
                      child: CircleAvatar(
                        backgroundColor: ColorTheme.firstColor,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              70), // Set the same radius as the CircleAvatar
                          child: Image.asset(
                            'assets/images/icons/avatar.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // -- Form Fields
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Personal info",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: ColorTheme.bigTitleColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    LineEdit(title: StaticAccount.staticAccount.name, icon: Icons.account_circle, readOnly: true),


                    const SizedBox(height: 20),
                    LineEdit(title: StaticAccount.staticAccount.role, icon: Icons.manage_accounts, readOnly: true)
                    ,
                    const SizedBox(height: 20),






                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  updateProfile() async{




/*
    print("photo:" +
        this.isPhoto.toString() +
        " name:" +
        this.isName.toString() +
        " phone:" +
        this.isPhone.toString() +
        " password:" +
        this.isPassword.toString()+
      " Email:"+this.isEmail.toString());
    status = await
    accountViewModel.updateProfile(imageUpload,nameController.text,phoneController.text,passwordController.text,emailController.text
        ,isPhoto,isName,isPhone,isPassword,isEmail);

    if(status == 200)
    {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.teal,
          content: Row(
            children: [
              Icon(
                Icons.verified,
                size: 30,
              ),
              Text(
                "Edditing successful",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
      );
      if(isPhone)
        {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.teal,
              content: Row(
                children: [
                  Icon(
                    Icons.logout,
                    size: 30,
                  ),
                  Text(
                    "Logout ... reconnect please .",
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            ),
          );
          StaticAccount.staticAccount.phoneNumber=phoneController.text;
          await Future.delayed(Duration(seconds: 3));
          Provider.of<AccountViewModel>(context,
              listen: false)
              .logout();
          // Navigator.of(context).pop();
          Navigator.pop(
              context,
              MaterialPageRoute(
                  builder: (context) => Login()));
        }
*/

      setState(() {
        passwordController.text="";
        emailController.text="";
        nameController.text="";
        phoneController.text="";

        isEmail = false;
        isName = false;
        isPassword = false;
        isPhoto = false;
        isPhone= false;

      });
    }/*
    else if(status == 409){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(
                Icons.dangerous_rounded,
                size: 30,
              ),
              Text(
                "Phone number Or Email already Exist",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(
                Icons.dangerous_rounded,
                size: 30,
              ),
              Text(
                "Error server ",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
      );
    }
    }
*/



}
