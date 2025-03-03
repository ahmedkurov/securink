import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

// Report Card Widget for Anonymous Reports
class ReportCard extends StatelessWidget {
  final String walletAddress;
  final String date;
  final String type;
  final String location;
  final VoidCallback onTap;

  const ReportCard({
    Key? key,
    required this.walletAddress,
    required this.date,
    required this.type,
    required this.location,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reports',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Wallet: ${walletAddress.substring(0, 6)}...${walletAddress.substring(walletAddress.length - 4)}',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    location,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.label, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    type,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Action Card Widget
class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const ActionCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Case Card Widget
class CaseCard extends StatelessWidget {
  final String caseNumber;
  final String date;
  final String status;
  final String type;

  const CaseCard({
    Key? key,
    required this.caseNumber,
    required this.date,
    required this.status,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: status == 'New' ? Colors.red[100] : Colors.blue[100],
          child: Icon(
            status == 'New' ? Icons.fiber_new : Icons.pending,
            color: status == 'New' ? Colors.red : Colors.blue,
          ),
        ),
        title: Text(
          caseNumber,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('$type • $date'),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: status == 'New' ? Colors.red[100] : Colors.blue[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: status == 'New' ? Colors.red[700] : Colors.blue[700],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          // Navigate to case details
        },
      ),
    );
  }
}

// Main Screen Widget
class HomeScreenPolice extends StatefulWidget {
  @override
  _HomeScreenPoliceState createState() => _HomeScreenPoliceState();
}

class _HomeScreenPoliceState extends State<HomeScreenPolice> {
  final TextEditingController complainantNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  File? _idProof;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Header
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.security, color: Colors.black, size: 30),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome, Officer',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Police Department',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Quick Actions Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      // FIR Registration Card
                      ActionCard(
                        icon: Icons.file_present,
                        title: 'File FIR',
                        subtitle: 'Register new case',
                        color: Colors.blue[700]!,
                        onTap: () {
                          _showFIRDialog(context);
                        },
                      ),

                      // Evidence Upload Card
                      ActionCard(
                        icon: Icons.upload_file,
                        title: 'Upload Evidence',
                        subtitle: 'Add case evidence',
                        color: Colors.blue[700]!,
                        onTap: () {
                          _showEvidenceUploadDialog(context);
                        },
                      ),

                      // Case Status Card
                      ActionCard(
                        icon: Icons.pending_actions,
                        title: 'Case Status',
                        subtitle: 'Track progress',
                        color: Colors.blue[700]!,
                        onTap: () {
                          _showCaseStatusDialog(context);
                        },
                      ),

                      // Reports Card
                      ActionCard(
                        icon: Icons.analytics,
                        title: 'Reports',
                        subtitle: 'View reports',
                        color: Colors.blue[700]!,
                        onTap: () {
                          _showReportsDialog(context);
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Recent Cases Section
                  Text(
                    'Recent Cases',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Recent Cases List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return CaseCard(
                        caseNumber: 'FIR-2024-${1000 + index}',
                        date: '${DateTime.now().subtract(Duration(days: index)).toString().substring(0, 10)}',
                        status: index == 0 ? 'New' : 'In Progress',
                        type: index == 0 ? 'Theft' : 'Assault',
                      );
                    },
                  ),
                ],
              ),
              Positioned(
                top: 16.0,
                right: 56.0, // Adjusted position for the second icon
                child: IconButton(
                  icon: Icon(Icons.notifications), // Change this to your desired icon
                  onPressed: () {
                    _showNotificationsDialog(context); // Call the notification dialog
                  },
                ),
              ),
              Positioned(
                top: 16.0,
                right: 16.0,
                child: IconButton(
                  icon: Icon(Icons.more_vert), // Change this to your desired icon
                  onPressed: () {
                    _showDrawer(context); // Call the drawer
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to show notifications dialog
  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              children: [
                ListTile(
                  title: Text('Tamper Detected'),
                  subtitle: Text('An attempt to tamper with evidence has been detected.'),
                ),
                Divider(),
                ListTile(
                  title: Text('Evidence Secured'),
                  subtitle: Text('All evidence has been secured successfully.'),
                ),
                Divider(),
                ListTile(
                  title: Text('New Report Submitted'),
                  subtitle: Text('A new anonymous report has been submitted.'),
                ),
                Divider(),
                ListTile(
                  title: Text('Case Update'),
                  subtitle: Text('The status of your case has been updated.'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Method to show the drawer
  void _showDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.security),
                title: Text('Authenticity AI'),
                onTap: () {
                  // Handle Authenticity AI action
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Handle Settings action
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
                onTap: () {
                  // Handle Help action
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the drawer
                  Navigator.pushReplacementNamed(context, '/welcomeback'); // Navigate to WelcomeBack page
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Dialog methods
  void _showFIRDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('File FIR', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: complainantNameController,
                    decoration: InputDecoration(
                      labelText: 'Complainant Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: contactNumberController,
                    decoration: InputDecoration(
                      labelText: 'Contact Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Incident Description',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: 'Incident Location',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Date of Incident',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        dateController.text = pickedDate.toString().substring(0, 10);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Submit FIR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('FIR submitted successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showEvidenceUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload Evidence', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Case Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Evidence Description',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: Icon(Icons.upload_file),
                    label: Text('Choose Files'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                    ),
                    onPressed: () {
                      // Implement file picker
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Upload'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Evidence uploaded successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showCaseStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Case Status', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Case Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: Icon(Icons.pending, color: Colors.blue),
                      ),
                      title: Text('Case Status: In Progress'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Last Updated: 2024-02-20'),
                          Text('Investigating Officer: John Doe'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text('Close'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showReportDetails(BuildContext context, String walletAddress, String type,
      String location, String date, String details) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Anonymous Report Details',
              style: TextStyle(fontWeight: FontWeight.bold)
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _detailRow('Wallet Address:', walletAddress),
                SizedBox(height: 16),
                _detailRow('Type:', type),
                SizedBox(height: 8),
                _detailRow('Location:', location),
                SizedBox(height: 8),
                _detailRow('Date:', date),
                SizedBox(height: 16),
                Text('Report Details:',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600])
                ),
                SizedBox(height: 8),
                Text(details),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange[700]),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This is an anonymous report. Please verify details before taking action.',
                          style: TextStyle(color: Colors.orange[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Mark for Investigation'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Report marked for investigation'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }

  void _showReportsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reports',
              style: TextStyle(fontWeight: FontWeight.bold)
          ),
          content: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReportCard(
                    walletAddress: '0x742d35Cc6634C0532925a3b844Bc454e4438f44e',
                    date: '2024-02-20',
                    type: 'Suspicious Activity',
                    location: 'Central Park Area',
                    onTap: () => _showReportDetails(
                      context,
                      '0x742d35Cc6634C0532925a3b844Bc454e4438f44e',
                      'Suspicious Activity',
                      'Central Park Area',
                      'February 20, 2024',
                      'Observed suspicious individuals repeatedly visiting an abandoned building during late hours. Multiple vehicles with covered license plates were spotted.',
                    ),
                  ),
                  SizedBox(height: 8),
                  ReportCard(
                    walletAddress: '0x9B3af05C76AAF4AAD04527BE8b5f3874982f0CA9',
                    date: '2024-02-19',
                    type: 'Drug Related',
                    location: 'Downtown District',
                    onTap: () => _showReportDetails(
                      context,
                      '0x9B3af05C76AAF4AAD04527BE8b5f3874982f0CA9',
                      'Drug Related',
                      'Downtown District',
                      'February 19, 2024',
                      'Regular gatherings of suspicious groups near the abandoned warehouse. Possible drug-related activities observed with frequent exchanges happening.',
                    ),
                  ),
                  SizedBox(height: 8),
                  ReportCard(
                    walletAddress: '0x1A2B3C4D5E6F7G8H9I0J1K2L3M4N5O6P7Q8R9S0',
                    date: '2024-02-18',
                    type: 'Theft',
                    location: 'Shopping Mall',
                    onTap: () => _showReportDetails(
                      context,
                      '0x1A2B3C4D5E6F7G8H9I0J1K2L3M4N5O6P7Q8R9S0',
                      'Theft',
                      'Shopping Mall',
                      'February 18, 2024',
                      'Witnessed organized shoplifting activity. Group of individuals systematically targeting high-value items and using emergency exits for escape.',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text('Close'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}