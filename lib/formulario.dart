import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final List horarios = [];
  final List destinos = [];
  final List aerolinea = [];
  final List listAerolenea = [];

  @override
  void initState() {
    super.initState();
    getAerolinea();

    getHorario();

    getDestinos();

    getAerolinea();

    getList();
  }

  void getHorario() async {
    CollectionReference collectionHorarios =
        FirebaseFirestore.instance.collection("horarios");
    QuerySnapshot horarios = await collectionHorarios.get();

    if (horarios.docs.length > 0) {
      for (var i in horarios.docs) {
        horarios.add(i.data());
        print(i.data());
      }
    }
  }

  void getDestinos() async {
    CollectionReference collectionHorarios =
        FirebaseFirestore.instance.collection("destinos");
    QuerySnapshot destinos = await collectionHorarios.get();

    if (destinos.docs.length > 0) {
      for (var i in destinos.docs) {
        destinos.add(i.data());
      }
    }
  }

  void getAerolinea() async {
    CollectionReference collectionHorarios =
        FirebaseFirestore.instance.collection("avion");
    QuerySnapshot aviones = await collectionHorarios.get();

    if (aviones.docs.length > 0) {
      for (var i in aviones.docs) {
        aerolinea.add(i.data());
      }
    }
  }

   void getList() async{
    QuerySnapshot reserva = await _reserva.get();
    if (reserva.docs.length > 0) {
      for (var i in reserva.docs) {
        listAerolenea.add(i.data());
        print(i.data());
      }
    }

  }

  String firstName = "";
  String lastName = "";
  String bodyTemp = "";
  var measure;
  var horario;
  var destino;
  var avion;
  //enlace a la collection:
  final CollectionReference _clientes =
      FirebaseFirestore.instance.collection('clientes');
  final CollectionReference _reserva =
      FirebaseFirestore.instance.collection("reserva");

  //controladores de los field
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _fechaNacController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  String tipo = "";
  String sexo = "";
  String fechaNac = "";
  String valor_horario = "";

  void _submit() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to close the pop up
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your information has been submitted'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Full name:",
                        style: TextStyle(fontWeight: FontWeight.w700))),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(firstName + " " + lastName),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Body Temperature:",
                        style: TextStyle(fontWeight: FontWeight.w700))),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("$bodyTemp ${measure == 1 ? "ºC" : "ºF"}"),
                )
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  child: const Text('Go to profile'),
                  onPressed: () async {
                    FocusScope.of(context)
                        .unfocus(); // unfocus last selected input field
                    Navigator.pop(context);
                    await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MyProfilePage())) // Open my profile
                        .then((_) => _formKey.currentState
                            ?.reset()); // Empty the form fields
                    setState(() {});
                  }, // so the alert dialog is closed when navigating back to main page
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    FocusScope.of(context)
                        .unfocus(); // Unfocus the last selected input field
                    _formKey.currentState?.reset(); // Empty the form fields
                  },
                )
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> _create ([DocumentSnapshot? documentSnapshot]) async{
    await showBottomSheet(context: context, 
    builder: (BuildContext ctx){
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Card(
          elevation: 15,
          shadowColor: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text("Datos Clientes.",
                      style: TextStyle(
                        fontSize: 20,
                      )),
                ),
                
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextFormField(
                        controller: _cedulaController,
                        decoration: const InputDecoration(
                            labelText: 'Cedula',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.contains(RegExp(r'^[a-zA-Z\-]'))) {
                            return 'Ingrese numeros!';
                          }
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            bodyTemp = value;
                            // bodyTempList.add(bodyTemp);
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            bodyTemp = value;
                          });
                        },
                      ),

                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(
                            labelText: 'Nombre',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        onFieldSubmitted: (value) {
                          setState(() {
                            firstName = value.capitalize();
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            firstName = value.capitalize();
                          });
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 3) {
                            return 'Debe contener 3 caracteres';
                          } else if (value
                              .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                            return 'Caracteres no admitidos';
                          }
                        },
                      ),

                      TextFormField(
                        controller: _apellidoController,
                        decoration: const InputDecoration(
                            labelText: 'Apellido',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 3) {
                            return 'Debe contener 3 caracteres';
                          } else if (value
                              .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                            return 'Caracteres no admitidos';
                          }
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            lastName = value.capitalize();
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            lastName = value.capitalize();
                          });
                        },
                      ),

                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _fechaNacController,
                        decoration: InputDecoration(
                          labelText: "Fecha",
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.black, width: 0.0),
                          ),
                          border: OutlineInputBorder(),
                          suffixIcon: GestureDetector(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2100));

                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('dd/MM/yyyy').format(pickedDate);
                                setState(() {
                                  _fechaNacController.text = formattedDate;
                                });
                              } else {}
                            },
                            child: Icon(Icons.date_range),
                          ),
                        ),
                        onFieldSubmitted: (value) {
                          setState(() {
                            fechaNac = value.capitalize();
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            fechaNac = value.capitalize();
                          });
                        },
                      ),

                      DropdownButtonFormField(
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 0.0),
                              ),
                              border: OutlineInputBorder()),
                          items: [
                            const DropdownMenuItem(
                              child: Text("Masculino"),
                              value: 1,
                            ),
                            const DropdownMenuItem(
                              child: Text("Femenino"),
                              value: 2,
                            )
                          ],
                          hint: const Text("Sexo"),
                          onChanged: (value) {
                            setState(() {
                              measure = value;
                              sexo = value == 1 ? "Masculino" : "Femenino";
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              measure = value;
                              sexo = value == 1 ? "Masculino" : "Femenino";
                            });
                          }),

                      DropdownButtonFormField(
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 0.0),
                              ),
                              border: OutlineInputBorder()),
                          items: [
                            const DropdownMenuItem(
                              child: Text("Cliente Vip"),
                              value: 1,
                            ),
                            const DropdownMenuItem(
                              child: Text("Cliente frecuente"),
                              value: 2,
                            )
                          ],
                          hint: const Text("Tipo"),
                          onChanged: (value) {
                            setState(() {
                              measure = value;
                              tipo = value == 1 ? "Cliente Vip" : "Cliente frecuente";
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              measure = value;
                              tipo = value == 1 ? "Cliente Vip" : "Cliente frecuente";
                            });
                          }),

                      TextFormField(
                        controller: _usuarioController,
                        decoration: const InputDecoration(
                            labelText: 'Usuario',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 3) {
                            return 'Debe contener 3 caracteres';
                          } else if (value
                              .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                            return 'Caracteres no admitidos';
                          }
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            lastName = value.capitalize();
                            // lastNameList.add(lastName);
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            lastName = value.capitalize();
                          });
                        },
                      ),


                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Datos Reserva.",
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ),

                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        items: horarios.map((e) {
                          return DropdownMenuItem(
                            child: Text(e['hora_Vuelo']),
                            value: Text(e['hora_Vuelo']),
                          );
                        }).toList(),
                        hint: const Text("Horario del Vuelo"),
                        onChanged: (value) {
                          horario = value;
                        },
                        onSaved: (value) {
                          horario = value;
                        },
                      ),

                      DropdownButtonFormField(
                        hint: const Text("Destinos"),
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        items: destinos.map((d) {
                          return DropdownMenuItem(
                            child: Text(d['nombre']),
                            value: Text(d['nombre']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          destino = value;
                        },
                        onSaved: (value) {
                          destino = value;
                        },
                      ),

                      DropdownButtonFormField(
                        hint: const Text("Aerolinea"),
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        items: aerolinea.map((a) {
                          return DropdownMenuItem(
                            child: Text(a['marca']),
                            value: Text(a['marca']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          avion = value;
                          print("Aerolinea" + value.toString());
                        },
                        onSaved: (value) {
                          avion = value;
                        },
                      ),


                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(60)),
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            //_submit();
                            final String nombre = _nombreController.text;
                            final String apellido = _apellidoController.text;
                            final String cedula = _cedulaController.text;
                            final String fechaNacimiento =
                                _fechaNacController.text;
                            final String tipo_ = tipo;
                            final String sexo_ = _sexoController.text;
                            final String Usuario = _usuarioController.text;

                            //horario:
                            final String nombreCompleto =
                                _nombreController.text +
                                    " " +
                                    _apellidoController.text;
                            final String destinoReserva;
                            final String horarioReserva;
                            final String vuelo;

                            horarioReserva = horario.toString();
                            destinoReserva = destino.toString();
                            vuelo = avion.toString();

                            await _reserva.add({
                              "cliente": nombreCompleto,
                              "destino": destinoReserva,
                              "horario": horarioReserva,
                              "vuelo": vuelo
                            });

                            await _clientes.add({
                              "cedula": cedula,
                              "nombre": nombre,
                              "apellido": apellido,
                              "fecha_nacimiento": fechaNacimiento,
                              "sexo": sexo,
                              "tipo": tipo_,
                              "usuario": Usuario
                            });

                        
                          }
                        },
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    );
  }


  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Agendar Vuelo"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list, size: 32.0),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyProfilePage(),
                  ));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Card(
          elevation: 15,
          shadowColor: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text("Datos del cliente.",
                      style: TextStyle(
                        fontSize: 20,
                      )),
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextFormField(
                        controller: _cedulaController,
                        decoration: const InputDecoration(
                            labelText: 'Cedula',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.contains(RegExp(r'^[a-zA-Z\-]'))) {
                            return 'Use only numbers!';
                          }
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            bodyTemp = value;
                            // bodyTempList.add(bodyTemp);
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            bodyTemp = value;
                          });
                        },
                      ),

                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(
                            labelText: 'Nombre',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        onFieldSubmitted: (value) {
                          setState(() {
                            firstName = value.capitalize();
                            // firstNameList.add(firstName);
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            firstName = value.capitalize();
                          });
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 3) {
                            return 'First Name must contain at least 3 characters';
                          } else if (value
                              .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                            return 'First Name cannot contain special characters';
                          }
                        },
                      ),

                      TextFormField(
                        controller: _apellidoController,
                        decoration: const InputDecoration(
                            labelText: 'Apellido',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 3) {
                            return 'Last Name must contain at least 3 characters';
                          } else if (value
                              .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                            return 'Last Name cannot contain special characters';
                          }
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            lastName = value.capitalize();
                            // lastNameList.add(lastName);
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            lastName = value.capitalize();
                          });
                        },
                      ),

                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _fechaNacController,
                        decoration: InputDecoration(
                          labelText: "Fecha Nacimiento",
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.black, width: 0.0),
                          ),
                          border: OutlineInputBorder(),
                          suffixIcon: GestureDetector(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2100));

                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('dd/MM/yyyy').format(pickedDate);
                                setState(() {
                                  _fechaNacController.text = formattedDate;
                                });
                              } else {}
                            },
                            child: Icon(Icons.date_range),
                          ),
                        ),
                        onFieldSubmitted: (value) {
                          setState(() {
                            fechaNac = value.capitalize();
                            // lastNameList.add(lastName);
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            fechaNac = value.capitalize();
                          });
                        },
                      ),

                      DropdownButtonFormField(
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 0.0),
                              ),
                              border: OutlineInputBorder()),
                          items: [
                            const DropdownMenuItem(
                              child: Text("Masculino"),
                              value: 1,
                            ),
                            const DropdownMenuItem(
                              child: Text("Femenino"),
                              value: 2,
                            )
                          ],
                          hint: const Text("Sexo"),
                          onChanged: (value) {
                            setState(() {
                              measure = value;
                              sexo = value == 1 ? "Masculino" : "Femenino";
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              measure = value;
                              sexo = value == 1 ? "Masculino" : "Femenino";
                            });
                          }),

                      DropdownButtonFormField(
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 0.0),
                              ),
                              border: OutlineInputBorder()),
                          items: [
                            const DropdownMenuItem(
                              child: Text("Cliente Vip"),
                              value: 1,
                            ),
                            const DropdownMenuItem(
                              child: Text("Cliente frecuente"),
                              value: 2,
                            )
                          ],
                          hint: const Text("Tipo"),
                          onChanged: (value) {
                            setState(() {
                              measure = value;
                              tipo = value == 1 ? "Cliente Vip" : "Cliente frecuente";
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              measure = value;
                              tipo = value == 1 ? "Cliente Vip" : "Cliente frecuente";
                            });
                          }),

                      TextFormField(
                        controller: _usuarioController,
                        decoration: const InputDecoration(
                            labelText: 'Usuario',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 3) {
                            return 'Last Name must contain at least 3 characters';
                          } else if (value
                              .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                            return 'Last Name cannot contain special characters';
                          }
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            lastName = value.capitalize();
                            // lastNameList.add(lastName);
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            lastName = value.capitalize();
                          });
                        },
                      ),

                      Divider(),

                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Datos de la reserva.",
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ),

                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        items: horarios.map((e) {
                          return DropdownMenuItem(
                            child: Text(e['hora_Vuelo']),
                            value: Text(e['hora_Vuelo']),
                          );
                        }).toList(),
                        hint: const Text("Horario de Vuelo"),
                        onChanged: (value) {
                          horario = value;
                        },
                        onSaved: (value) {
                          horario = value;
                        },
                      ),

                      DropdownButtonFormField(
                        hint: const Text("Destinos"),
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        items: destinos.map((d) {
                          return DropdownMenuItem(
                            child: Text(d['nombre']),
                            value: Text(d['nombre']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          destino = value;
                        },
                        onSaved: (value) {
                          destino = value;
                        },
                      ),

                      DropdownButtonFormField(
                        hint: const Text("Aerolinea"),
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        items: aerolinea.map((a) {
                          return DropdownMenuItem(
                            child: Text(a['marca']),
                            value: Text(a['marca']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          avion = value;
                          print("Valor Aerolinea" + value.toString());
                        },
                        onSaved: (value) {
                          avion = value;
                        },
                      ),


                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(60)),
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            //_submit();
                            final String nombre = _nombreController.text;
                            final String apellido = _apellidoController.text;
                            final String cedula = _cedulaController.text;
                            final String fechaNacimiento =
                                _fechaNacController.text;
                            final String tipo_ = tipo;
                            final String sexo_ = _sexoController.text;
                            final String Usuario = _usuarioController.text;

                            //horario:
                            final String nombreCompleto =
                                _nombreController.text +
                                    " " +
                                    _apellidoController.text;
                            final String destinoReserva;
                            final String horarioReserva;
                            final String vuelo;

                            horarioReserva = horario.toString();
                            destinoReserva = destino.toString();
                            vuelo = avion.toString();

                            await _reserva.add({
                              "cliente": nombreCompleto,
                              "destino": destinoReserva,
                              "horario": horarioReserva,
                              "vuelo": vuelo
                            });

                            await _clientes.add({
                              "cedula": cedula,
                              "nombre": nombre,
                              "apellido": apellido,
                              "fecha_nacimiento": fechaNacimiento,
                              "sexo": sexo,
                              "tipo": tipo_,
                              "usuario": Usuario
                            });

                            print("OK");
                          }
                        },
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

class MyProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final CollectionReference _listado =
      FirebaseFirestore.instance.collection('reserva');


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Firebase Firestore')),
        ),
        body: StreamBuilder(
          stream: _listado.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child:  ListTile(
                      title: Text(documentSnapshot['cliente'].toString()),
                      subtitle: Text(documentSnapshot['destino'].toString()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: (){}),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {}),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
    );
        
  }
}

extension StringExtension on String {
  // Method used for capitalizing the input from the form
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
