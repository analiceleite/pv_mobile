import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;

class LocationService {
  // Coordenadas da Igreja PV Joinville
  static const double churchLatitude = -26.3376893;
  static const double churchLongitude = -48.8172902;
  static const String churchAddress =
      'Rua Fátima, 2597 - Fátima, Joinville, SC';

  /// Solicita permissão de localização e obtém a posição do usuário
  static Future<Position?> getUserLocation() async {
    try {
      // Verificar permissão
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        print('Permissão de localização negada permanentemente');
        return null;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        // Obter localização com timeout
        final position = await Geolocator.getCurrentPosition(
          timeLimit: const Duration(seconds: 10),
          forceAndroidLocationManager: true,
        );
        return position;
      }

      return null;
    } catch (e) {
      print('Erro ao obter localização: $e');
      return null;
    }
  }

  /// Calcula tempo e distância do usuário até a Igreja usando Google Maps API
  /// Nota: Requer chave de API do Google Maps configurada
  static Future<Map<String, dynamic>?> getRouteInfo(
    Position userPosition,
  ) async {
    try {
      const String apiKey =
          'AIzaSyBg4IuRJqDzX35Rs266HAKkE4ZKY-FBuRk'; // Substituir pela chave real

      final String origin =
          '${userPosition.latitude},${userPosition.longitude}';
      final String destination = '$churchLatitude,$churchLongitude';

      final String url =
          'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=$origin'
          '&destination=$destination'
          '&key=$apiKey'
          '&language=pt-BR';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['routes'].isNotEmpty) {
          final leg = json['routes'][0]['legs'][0];
          final distance = leg['distance']['text'] as String;
          final duration = leg['duration']['text'] as String;

          return {
            'distance': distance,
            'duration': duration,
            'distanceValue': leg['distance']['value'] as int,
            'durationValue': leg['duration']['value'] as int,
          };
        }
      }

      return null;
    } catch (e) {
      print('Erro ao obter informações de rota: $e');
      return null;
    }
  }

  /// Abre o Google Maps com a rota do usuário para a Igreja
  static String buildMapsUrl(double userLat, double userLng) {
    return 'https://www.google.com/maps/dir/'
        '$userLat,$userLng/'
        '$churchLatitude,$churchLongitude/'
        '?entry=ttu';
  }

  /// Calcula distância simples em km usando fórmula de Haversine
  /// Útil quando API não está disponível
  static double calculateDistanceKm(double userLat, double userLng) {
    const int earthRadiusKm = 6371;

    double dLat = _degreesToRadians(churchLatitude - userLat);
    double dLng = _degreesToRadians(churchLongitude - userLng);

    double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(userLat)) *
            math.cos(_degreesToRadians(churchLatitude)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  /// Estima tempo de chegada baseado na distância
  /// Usa velocidade média de 40 km/h em zona urbana
  static String estimateArrivalTime(int durationSeconds) {
    final minutes = (durationSeconds / 60).ceil();

    if (minutes < 1) {
      return 'Menos de 1 minuto';
    } else if (minutes < 60) {
      return '~$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '~$hours h';
      } else {
        return '~$hours h $remainingMinutes min';
      }
    }
  }
}
