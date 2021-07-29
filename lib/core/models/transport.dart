class Transport {
  final String id;
  final int currentNumOfCarriers;
  final int totalNumOfCarriers;
  final List<String> carriers;
  final List<String> products;
  final DateTime datePickUp;
  final String pickUpAddress;
  final String destinationAddress;
  final TransportStatus status;
  final List<String> pictures;
  final String notes;
  final String sumUp;

  Transport({
    this.id = '',
    this.currentNumOfCarriers = 0,
    this.totalNumOfCarriers = 0,
    this.destinationAddress = '',
    this.pickUpAddress = '',
    this.notes = '',
    this.carriers = const [],
    this.products = const [],
    this.pictures = const [],
    this.status = TransportStatus.waitingForVolunteers,
    this.sumUp = '',
    required this.datePickUp,
  });

  static Transport transportFromDocument(
      Map<dynamic, dynamic> trasnportMap, String id) {
    return Transport(
      id: id,
      currentNumOfCarriers: trasnportMap['Current Number Of Carriers'] ?? 0,
      totalNumOfCarriers: trasnportMap['Total Number Of Carriers'] ?? 0,
      destinationAddress: trasnportMap['Destination Address'] ?? '',
      pickUpAddress: trasnportMap['Pick Up Address'] ?? '',
      datePickUp: DateTime.parse(trasnportMap['Date For Pick Up']),
      carriers: List.from(trasnportMap['Carriers']),
      products: List.from(trasnportMap['Products']),
      status: Transport.transportStatusFromString(
          trasnportMap["Status Of Transport"]),
      pictures: List.from(trasnportMap['Pictures']),
      notes: trasnportMap['Notes'] ?? '',
      sumUp: trasnportMap['SumUp'] ?? '',
    );
  }

  static TransportStatus transportStatusFromString(String status) {
    TransportStatus res = TransportStatus.waitingForVolunteers;
    TransportStatus.values.forEach((element) => {
          if (element.toString().split('.')[1] == status) {res = element}
        });

    return res;
  }
}

enum TransportStatus {
  waitingForVolunteers,
  waitingForDueDate,
  carriedOut,
}
