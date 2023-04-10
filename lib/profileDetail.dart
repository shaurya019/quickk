import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quickk/BusinessDocumentsUpload.dart';
import 'package:quickk/bloc/ProfileDetailBloc/ProfileDetailBloc.dart';
import 'package:quickk/const/colors.dart';
import 'package:quickk/homeScreen.dart';
import 'package:quickk/locationScreen.dart';
import 'package:quickk/repository/OTPVerificationRepository.dart';
import 'package:quickk/repository/ProfileDetailRepository.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';


class ProfileDetail extends StatelessWidget {
  String mobileNumber;

  ProfileDetail(String _value){
    mobileNumber = _value;
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: BlocProvider(
        create: (_) => ProfileDetailBloc(ProfileDetailRepository(Dio())),
        child: ProfileDetailStateful(mobileNumber),
      ),
    );
  }
}

class ProfileDetailStateful extends StatefulWidget {
  String mobileNumber;

  ProfileDetailStateful(String _value){
    mobileNumber = _value;
  }

  @override
  _ProfileDetailStatefulState createState() => _ProfileDetailStatefulState();
}

class _ProfileDetailStatefulState extends State<ProfileDetailStateful> {

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  String prefix = "Mr";
  int _radioSelected = 1;
  String _radioVal;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,

     body: BlocBuilder<ProfileDetailBloc,ProfileDetailState>(
       builder: (context,state){
         return Padding(
           padding: EdgeInsets.only(left: 15.w,right: 15.w),
           child: ListView(
             //mainAxisAlignment: MainAxisAlignment.start,
             children: [
               Container(
                 margin: EdgeInsets.only(left: 20.w, right: 20.h, top: 15.h ),
                 child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("Profile Details", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),),
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
                 height: 20.h,
               ),
               Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     GestureDetector(
                       onTap: (){
                         setState(() {
                           prefix = "Mr";
                         });
                       },
                       child: Card(
                         elevation: 2,
                         child: Container(
                           width: 100.w,
                           height: 40.h,
                           child: Center(
                             child: Text("Mr", ),
                           ),
                         ),
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(20),
                             side: new BorderSide(color: (prefix == "Mr") ? ColorConstants.primaryColor : Colors.white)
                         ),
                       ),
                     ),
                     GestureDetector(
                       onTap: (){
                         setState(() {
                           prefix = "Mrs";
                         });
                       },
                       child: Card(
                         elevation: 2,
                         child: Container(
                           width: 100.w,
                           height: 40.h,
                           child: Center(
                             child: Text("Mrs", ),
                           ),
                         ),
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(20),
                             side: new BorderSide(color: (prefix == "Mrs") ? ColorConstants.primaryColor : Colors.white)
                         ),
                       ),
                     ),
                     GestureDetector(
                       onTap: (){
                         setState(() {
                           prefix = "Ms";
                         });
                       },
                       child: Card(
                         elevation: 2,
                         child: Container(
                           width: 100.w,
                           height: 40.h,
                           child: Center(
                             child: Text("Ms", ),
                           ),
                         ),
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(20),
                             side: new BorderSide(color: (prefix == "Ms") ? ColorConstants.primaryColor : Colors.white)
                         ),
                       ),
                     )




                   ]
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
                                 controller: firstNameController,
                                 decoration: InputDecoration(
                                   border: InputBorder.none,
                                   hintText: "First Name",
                                   errorMaxLines: 1,
                                   errorText: (firstNameController.text == null && state.firstName.valid != true) ? "Invalid First Name" : null,
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
                   side: new BorderSide(color: (firstNameController.text == null && state.firstName.valid != true) ? Colors.red : Colors.white, width: 1.0),
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
                                   errorText: (lastNameController.text == null && state.lastName.valid != true) ? "Invalid Last Name" : null,
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
                   side: new BorderSide(color: (lastNameController.text == null && state.lastName.valid != true)? Colors.red : Colors.white, width: 1.0),
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
                                   errorText: ((state.email.value.length >= 7) && state.email.valid != true) ? "Invalid Email" : null,
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
                   side: new BorderSide(color: ((state.email.value.length >= 7) && state.email.valid != true) ? Colors.red : Colors.white, width: 1.0),
                 ),
               ),
               SizedBox(
                 height: 10.h,
               ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text('Individual'),
                   Radio(
                     value: 1,
                     groupValue: _radioSelected,
                     activeColor: ColorConstants.primaryColor,
                     onChanged: (value) {
                       setState(() {
                         _radioSelected = value;
                       });
                     },
                   ),
                   Text('Business'),
                   Radio(
                     value: 2,
                     groupValue: _radioSelected,
                     activeColor: ColorConstants.primaryColor,
                     onChanged: (value) {
                       setState(() {
                         _radioSelected = value;
                       });
                     },
                   )
                 ],
               ),
               SizedBox(
                 height: 30.h,
               ),
               SubmitButton(widget.mobileNumber,prefix,_radioSelected.toString()),
               SizedBox(
                 height: 10.h,
               ),
             ],
           ),
         );
       },
     )
    );
  }
}


class SubmitButton extends StatefulWidget {
  String mobileNumber,prefix,userType;

  SubmitButton(String _value,String _prefix,String _userType){
    mobileNumber = _value;
    prefix = _prefix;
    userType = _userType;
  }

  @override
  SubmitButtonState createState() => SubmitButtonState();
}

class SubmitButtonState extends State<SubmitButton>  {

  UserDataService userDataService =  getIt<UserDataService>();

  @override
  void initState() {
    super.initState();
    print("userType====>>>"+widget.userType.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileDetailBloc, ProfileDetailState>(
        listener: (context, state) {
           if(state is ProfileDetailCompleteState){
             if(widget.userType.toString() == "1"){
               WidgetsBinding.instance.addPostFrameCallback((_){
                 Get.to(LocationScreen());
               });
             }
             else if(widget.userType.toString() == "2"){
               WidgetsBinding.instance.addPostFrameCallback((_){
                 Get.to(BusinessDocumentsUpload());
               });
             }
           }
        },
        child: InkWell(
          onTap: (){
            BlocProvider.of<ProfileDetailBloc>(context).add(SaveProfileDetailEvent(firstName:BlocProvider.of<ProfileDetailBloc>(context).state.firstName.value,lastName: BlocProvider.of<ProfileDetailBloc>(context).state.lastName.value,emailId: BlocProvider.of<ProfileDetailBloc>(context).state.email.value,mobileNumber: widget.mobileNumber,prefx: widget.prefix,userType: widget.userType,context: context));
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
