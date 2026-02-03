import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream do estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuário atual
  User? get currentUser => _auth.currentUser;

  // Verificar se está logado
  bool get isLoggedIn => _auth.currentUser != null;

  // Login com email e senha
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Usuário não encontrado';
        case 'wrong-password':
          return 'Senha incorreta';
        case 'invalid-email':
          return 'Email inválido';
        case 'user-disabled':
          return 'Usuário desabilitado';
        default:
          return 'Erro ao fazer login: ${e.message}';
      }
    } catch (e) {
      return 'Erro ao fazer login: $e';
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Criar usuário (apenas para uso inicial - criar admin)
  Future<String?> createUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Email já está em uso';
        case 'weak-password':
          return 'Senha muito fraca';
        case 'invalid-email':
          return 'Email inválido';
        default:
          return 'Erro ao criar usuário: ${e.message}';
      }
    } catch (e) {
      return 'Erro ao criar usuário: $e';
    }
  }
}
