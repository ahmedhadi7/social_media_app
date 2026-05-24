import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final void Function()? onTap;
  const DeleteButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 150.0, ),
      child: GestureDetector(
        
        onTap: onTap,
        child:  
        const Icon(Icons.cancel, color: Colors.grey),
        
      ),
    );
  }
}
