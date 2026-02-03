# 🔧 Solução para Erro de Firebase Authentication

## ❌ Erro:
```
PlatformException(channel-error, Unable to establish connection on channel: "dev.flutter.pigeon.firebase_auth_platform_interface.FirebaseAuthHostApi.registerAuthStateListener"., null, null)
```

## ✅ Soluções:

### **1. Ativar Firebase Authentication no Console**

Este é o passo mais importante e provavelmente o que está faltando:

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Selecione o projeto: **igreja-pv-mobile**
3. No menu lateral, clique em **Authentication** (🔐)
4. Clique no botão **"Começar"** ou **"Get Started"**
5. Na aba **"Sign-in method"**:
   - Clique em **"Email/Password"**
   - **Ative** a opção "Email/Password" (primeiro toggle)
   - Clique em **"Salvar"**

⚠️ **IMPORTANTE**: Sem ativar o Authentication no Firebase Console, o serviço não funcionará!

---

### **2. Criar o Primeiro Usuário Administrador**

Após ativar o Authentication:

1. Ainda em **Authentication**, vá na aba **"Users"**
2. Clique em **"Add user"** (Adicionar usuário)
3. Preencha:
   - **Email**: `admin@igrejapv.com` (ou o que preferir)
   - **Password**: `Admin@123` (escolha uma senha forte)
4. Clique em **"Add user"**

---

### **3. Limpar Cache e Reiniciar (se necessário)**

Se após ativar o Authentication ainda houver erro:

**Para Web:**
```bash
# Parar a execução
# Limpar cache do Flutter
flutter clean

# Reinstalar dependências
flutter pub get

# Executar novamente
flutter run -d chrome
```

**No navegador:**
- Pressione `Ctrl + Shift + R` (ou `Cmd + Shift + R` no Mac) para forçar reload
- Ou abra em uma aba anônima/privada

---

### **4. Verificar Configuração do Firebase**

Certifique-se de que as credenciais em `lib/config/firebase_config.dart` estão corretas:

```dart
apiKey: "AIzaSyDdC-N-Gek0-zrTVNdj7l-x8rzLvgppf90",
authDomain: "igreja-pv-mobile.firebaseapp.com",
projectId: "igreja-pv-mobile",
```

Se você criou um novo projeto Firebase, atualize essas credenciais.

---

### **5. Testar Autenticação**

Após seguir os passos acima:

1. Execute o app: `flutter run -d chrome`
2. Abra o menu lateral (☰)
3. Clique em **"Administração"**
4. Faça login com:
   - Email: `admin@igrejapv.com`
   - Senha: `Admin@123`

---

## 🐛 Troubleshooting Adicional

### Erro persiste?

1. **Verifique o Console do Navegador**:
   - Abra DevTools (F12)
   - Veja se há outros erros relacionados

2. **Teste a Inicialização do Firebase**:
   - Ao executar o app, você deve ver no terminal:
   ```
   ✅ Firebase inicializado com sucesso
   ```

3. **Verifique as Regras do Firestore**:
   No Firebase Console → Firestore Database → Rules:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read: if true;
         allow write: if request.auth != null;
       }
     }
   }
   ```

4. **Habilite o modo de depuração**:
   No Console do navegador, verifique se há mensagens de erro mais detalhadas.

---

## 📝 Checklist Rápido

- [ ] Firebase Authentication está **ativado** no Console
- [ ] Método Email/Password está **habilitado**
- [ ] Pelo menos um usuário foi **criado**
- [ ] As credenciais do Firebase estão **corretas** no código
- [ ] Executou `flutter clean` e `flutter pub get`
- [ ] Recarregou a página com `Ctrl + Shift + R`

---

## 🎯 Resultado Esperado

Após seguir todos os passos:
- Você deve conseguir acessar a tela de login
- Fazer login com as credenciais criadas
- Acessar o painel administrativo
- Gerenciar cultos e grupos familiares

Se o problema persistir após seguir TODOS os passos acima, verifique:
1. Se está usando a versão correta do Firebase (v10+)
2. Se há conflitos de versão nas dependências
3. Logs completos do erro no console
