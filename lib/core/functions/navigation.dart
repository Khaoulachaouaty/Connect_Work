import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void customNavigate(BuildContext context, String path) {
  context.push(path);
}

// Pour remplacer la page actuelle (ex: Splash → Login)
void customReplacementNavigate(BuildContext context, String path) {
  context.go(path); 
}