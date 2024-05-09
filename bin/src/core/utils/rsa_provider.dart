import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:pointycastle/asymmetric/api.dart';

final class RSAProvider {
  static late final Encrypter _rsaEncrypt;

  static void rsaProviderInit() async {
    final RSAPublicKey publicKey =
        await parseKeyFromFile<RSAPublicKey>('public.pem');
    final RSAPrivateKey privateKey =
        await parseKeyFromFile<RSAPrivateKey>('private.pem');

    _rsaEncrypt = Encrypter(
      RSA(
          publicKey: publicKey,
          privateKey: privateKey,
          encoding: RSAEncoding.OAEP),
    );
  }

  static Future<Encrypted> encode(String str) async => _rsaEncrypt.encrypt(str);

  static Future<String> decode(Encrypted str) async => _rsaEncrypt.decrypt(str);
}
