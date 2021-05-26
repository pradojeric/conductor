class EmployeeModel {
  String employeeNo;
  String firstName;
  String lastName;
  String address;
  String contact;

  EmployeeModel({this.employeeNo, this.firstName, this.lastName, this.address, this.contact});

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      employeeNo : json['employee_no'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      address: json['address'],
      contact: json['contact'],
    );
  }
}