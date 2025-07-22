class JobModel {
  int? rAStatus;
  String? jobNo;
  String? customerName;
  String? pickUpDate;
  String? pickUpTime;
  String? App_startDate;
  String? salesID;
  var issuedBy;
  var serviceType;
  var transferType;
  var carType;
  var carRegNo;
  var customerBookingAgent;
  String? driverName;
  String? reference;
  String? passengerName;
  var telNo;
  String? flightNo;
  var eTAETD;
  String? pickupAddress;
  String? dropoffAddress;
  String? endTime;
  String? Customer_latlong;
  String? Driver_latlong;
  var customerSignature;
  var driverSignature;
  var Remarks;
  var logo;
  int? appStatus;

  JobModel(
      {this.rAStatus,
        this.jobNo,
        this.customerName,
        this.pickUpDate,
        this.pickUpTime,
        this.App_startDate,
        this.salesID,
        this.issuedBy,
        this.serviceType,
        this.transferType,
        this.carType,
        this.carRegNo,
        this.customerBookingAgent,
        this.driverName,
        this.reference,
        this.passengerName,
        this.telNo,
        this.flightNo,
        this.eTAETD,
        this.pickupAddress,
        this.dropoffAddress,
        this.endTime,
        this.Customer_latlong,
        this.Driver_latlong,
        this.customerSignature,
        this.driverSignature,
        this.Remarks,
        this.logo,
        this.appStatus,
      });

  JobModel.fromJson(Map<String, dynamic> json) {
    rAStatus = json['RA_Status'];
    jobNo = json['Job_No'];
    customerName = json['Customer_Name'];
    pickUpDate = json['Pick_Up_Date'] ?? '0001-01-01';
    pickUpTime = json['Pick_Up_Time'];
    App_startDate = json['App_startDate'];
    salesID = json['Sales_ID'];
    issuedBy = json['Issued_By'];
    serviceType = json['Service_Type'];
    transferType = json['Transfer_Type'];
    carType = json['Car_Type'];
    carRegNo = json['Car_Reg_No'];
    customerBookingAgent = json['Customer_Booking_Agent'];
    driverName = json['Driver_Name'];
    reference = json['Reference'];
    passengerName = json['Passenger_name'];
    telNo = json['Tel_No'];
    flightNo = json['Flight_No'];
    eTAETD = json['ETA_ETD'];
    pickupAddress = json['Pickup_Address'];
    dropoffAddress = json['Dropoff_Address'];
    endTime = json['End_Time'];
    Customer_latlong = json['Customer_latlong'] ?? '';
    Driver_latlong = json['Driver_latlong'] ?? '';
    customerSignature = json['Customer_Signature'];
    driverSignature = json['Driver_Signature'];
    Remarks = json['Remarks'] ?? '';
    logo = json['logo'] ?? '';
    appStatus = json['APPStatus'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RA_Status'] = rAStatus;
    data['Job_No'] = jobNo;
    data['Customer_Name'] = customerName;
    data['Pick_Up_Date'] = pickUpDate;
    data['Pick_Up_Time'] = pickUpTime;
    data['App_startDate'] = App_startDate;
    data['Sales_ID'] = salesID;
    data['Issued_By'] = issuedBy;
    data['Service_Type'] = serviceType;
    data['Transfer_Type'] = transferType;
    data['Car_Type'] = carType;
    data['Car_Reg_No'] = carRegNo;
    data['Customer_Booking_Agent'] = customerBookingAgent;
    data['Driver_Name'] = driverName;
    data['Reference'] = reference;
    data['Passenger_name'] = passengerName;
    data['Tel_No'] = telNo;
    data['Flight_No'] = flightNo;
    data['ETA_ETD'] = eTAETD;
    data['Pickup_Address'] = pickupAddress;
    data['Dropoff_Address'] = dropoffAddress;
    data['End_Time'] = endTime;
    data['Customer_Signature'] = customerSignature;
    data['Driver_Signature'] = driverSignature;
    data['Remarks'] = Remarks;
    return data;
  }
}
