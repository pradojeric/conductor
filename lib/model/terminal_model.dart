class TerminalModel {
  final int terminalId;
  final String terminalName;
  final String terminalAddress;
  final int order;

  TerminalModel({this.terminalId, this.terminalName, this.terminalAddress, this.order});

  factory TerminalModel.fromJson(Map<String, dynamic> json) {
    return TerminalModel(
      terminalId: json['id'],
      terminalName: json['terminal_name'],
      terminalAddress: json['terminal_address'],
      order: json['pivot']['order'],
    );
  }
}
