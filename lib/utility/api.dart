class Api {
  String findKeyByTypeUser(String typeuser) {
    switch (typeuser) {
      case 'buyer':
        return '/myServiceBuyer';
        break;
      case 'shopper':
        return '/myServiceShopper';
        break;
      default:
        return null;
    }
  }

  Api();
}
