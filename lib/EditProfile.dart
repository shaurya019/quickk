import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickk/ProfileScreen.dart';
import 'package:quickk/bloc/ProfileDetailBloc/ProfileDetailBloc.dart';
import 'package:quickk/const/colors.dart';
import 'package:quickk/repository/ProfileDetailRepository.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';

import 'shopingCart.dart';


class EditProfile extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: BlocProvider(
        create: (_) => ProfileDetailBloc(ProfileDetailRepository(Dio())),
        child: EditProfilelStateful(),
      ),
    );
  }
}

class EditProfilelStateful extends StatefulWidget {

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfilelStateful> {

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  String prefix = "mr";
  File imageFile ;
  UserDataService userDataService =  getIt<UserDataService>();


  @override
  void initState() {
    super.initState();
    firstNameController = new TextEditingController(text: userDataService.userData.firstname);
    lastNameController = new TextEditingController(text: userDataService.userData.lastname);
    emailController = new TextEditingController(text: userDataService.userData.emailid);
    prefix = userDataService.userData.prefx;

    BlocProvider.of<ProfileDetailBloc>(context).add(FirstNameChanged(firstName: userDataService.userData.firstname));
    BlocProvider.of<ProfileDetailBloc>(context).add(LastNameChanged(lastName: userDataService.userData.lastname));
    BlocProvider.of<ProfileDetailBloc>(context).add(EmailChanged(email: userDataService.userData.emailid));
  }

  _getFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Colors.white,

        body: BlocBuilder<ProfileDetailBloc,ProfileDetailState>(
          builder: (context,state){
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20.w, right: 20.h, top: 35.h ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back, size: 30, color: Colors.black,),
                          ),
                          SizedBox(width: 10.w,),

                          Text("Edit Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),),
                          /*GestureDetector(
                         onTap: (){
                           WidgetsBinding.instance.addPostFrameCallback((_){
                             Navigator.push(context, MaterialPageRoute(builder: (Context) => LocationScreen()));
                           });
                         },
                         child: Text("Skip", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),),
                       )*/
                        ]
                    ),

                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    width: 500.w,
                    height: 1,
                    color: Colors.black26,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      imageFile == null ?  CircleAvatar(
                        radius:  55.w,
                        backgroundColor: Colors.grey,
                        child: CircleAvatar(
                          radius: 50.w,
                          backgroundColor: Colors.blue,
                          child: CircleAvatar(
                            radius: 45.w,
                            backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2019/02/22/17/04/man-4013984_1280.png",  ),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ) :
                      CircleAvatar(
                        radius:  55.w,
                        backgroundColor: Colors.grey,
                        child: CircleAvatar(
                          radius: 50.w,
                          backgroundColor: Colors.blue,
                          child: CircleAvatar(
                            radius: 45.w,
                            backgroundImage: FileImage(imageFile),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w,),
                      GestureDetector(
                        onTap: (){
                          _getFromGallery();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.edit,color: ColorConstants.primaryColor3,),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              prefix = "mr";
                            });
                          },
                          child: Card(
                            elevation: 2,
                            child: Container(
                              width: 100.w,
                              height: 40.h,
                              child: Center(
                                child: Text("mr", ),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: new BorderSide(color: (prefix == "mr") ? ColorConstants.primaryColor : Colors.white)
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              prefix = "mrs";
                            });
                          },
                          child: Card(
                            elevation: 2,
                            child: Container(
                              width: 100.w,
                              height: 40.h,
                              child: Center(
                                child: Text("mrs", ),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: new BorderSide(color: (prefix == "mrs") ? ColorConstants.primaryColor : Colors.white)
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              prefix = "ms";
                            });
                          },
                          child: Card(
                            elevation: 2,
                            child: Container(
                              width: 100.w,
                              height: 40.h,
                              child: Center(
                                child: Text("ms", ),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: new BorderSide(color: (prefix == "ms") ? ColorConstants.primaryColor : Colors.white)
                            ),
                          ),
                        )




                      ]
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Card(
                    child: Container(
                        width: 300.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            SizedBox(
                              width: 10.w,
                            ),


                            Icon(Icons.person),

                            SizedBox(
                              width: 10.w,
                            ),

                            Expanded(
                                child: TextFormField(
                                    maxLines: 1,
                                    controller: firstNameController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "First Name",
                                      errorMaxLines: 1,
                                      errorText: (state.firstName == null && !state.firstName.valid && state.firstName.value == "") ? "Invalid First Name" : null,
                                      errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
                                    ),
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      context.read<ProfileDetailBloc>().add(FirstNameChanged(firstName: value));
                                    }
                                )
                            ),
                          ],
                        )
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: new BorderSide(color: (state.firstName == null && !state.firstName.valid && state.firstName.value == "") ? Colors.red : Colors.white, width: 1.0),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Card(
                    child: Container(
                        width: 300.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            SizedBox(
                              width: 10.w,
                            ),


                            Icon(Icons.person),

                            SizedBox(
                              width: 10.w,
                            ),

                            Expanded(
                                child: TextFormField(
                                    maxLines: 1,
                                    controller: lastNameController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Last Name",
                                      errorMaxLines: 1,
                                      errorText: (state.lastName == null && !state.lastName.valid && state.lastName.value == "") ? "Invalid Last Name" : null,
                                      errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
                                    ),
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      context.read<ProfileDetailBloc>().add(LastNameChanged(lastName: value));
                                    }
                                )
                            ),
                          ],
                        )
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: new BorderSide(color: (state.lastName == null && !state.lastName.valid && state.lastName.value == "") ? Colors.red : Colors.white, width: 1.0),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Card(
                    child: Container(
                        width: 300.w,
                        height: 40.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            SizedBox(
                              width: 10.w,
                            ),


                            Icon(Icons.email),

                            SizedBox(
                              width: 10.w,
                            ),

                            Expanded(
                                child: TextFormField(
                                    maxLines: 1,
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      errorMaxLines: 1,
                                      errorText: (state.email.value == null && state.email.invalid && state.email.value.length < 5 ) ? "Invalid Email" : null,
                                      errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
                                    ),
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      context.read<ProfileDetailBloc>().add(EmailChanged(email: value));
                                    }
                                )
                            ),
                          ],
                        )
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: new BorderSide(color: (state.email.value == null && !state.email.invalid && state.email.value.length < 5 ) ? Colors.red : Colors.white, width: 1.0),
                    ),
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  SubmitButton(prefix,imageFile)
                ],
              ),
            );
          },
        )
    );
  }
}


class SubmitButton extends StatefulWidget {
  String prefix;
  File imageFile;

  SubmitButton(String _prefix,File _imageFile){
    prefix = _prefix;
    imageFile = _imageFile;
  }

  @override
  SubmitButtonState createState() => SubmitButtonState();
}

class SubmitButtonState extends State<SubmitButton>  {

  UserDataService userDataService =  getIt<UserDataService>();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileDetailBloc, ProfileDetailState>(
        listener: (context, state) {
          if(state is ProfileDetailCompleteState){
            WidgetsBinding.instance.addPostFrameCallback((_){
              //Navigator.push(context, MaterialPageRoute(builder: (Context) => ProfileScreen()));
              Get.to(ProfileScreen());
            });
          }
        },
        child: InkWell(
          onTap: (){
            BlocProvider.of<ProfileDetailBloc>(context).add(EditProfileDetailEvent(firstName:BlocProvider.of<ProfileDetailBloc>(context).state.firstName.value,lastName: BlocProvider.of<ProfileDetailBloc>(context).state.lastName.value,emailId: BlocProvider.of<ProfileDetailBloc>(context).state.email.value,prefx: widget.prefix,userId: userDataService.userData.customerid,context: context,imageFile:widget.imageFile));
          },
          child: Container(
            height: 50.h,
            width: 300.w,

            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),

            ),

            child: Center(
                child: Text("Confirm", style: TextStyle( fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.bold),)
            ),

          ),
        )
    );
  }

}
