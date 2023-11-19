import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
    height: 115,
    width: 115,
    child: Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage('assets/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg'),
        ),
        Positioned(
          right: -10,
          bottom: 0,
          child: SizedBox(
          height: 46,
          width: 46,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:const Color(0xFFF5F6F9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: const BorderSide(color: Colors.white),
              )
            ),
            onPressed: () {},
            child: SvgPicture.asset("assets/photo-camera-svgrepo-com.svg"),
            ),
        ),
        ),
      ],
    ),
        );
  }
}