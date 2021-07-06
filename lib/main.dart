import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'configuracion.dart';
import 'dart:async';
import 'dart:ui' as ui;

// app para probar manejo de eventos timer
// simula el % de tiempo laborado por dia, semana y mes
// considerando los parámetros prestablecidos.
void main() {
  runApp(MaterialApp(
    //debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Russo',
      primarySwatch: Colors.green,
    ),
    title: 'Tiempo Trabajado',
    home: Principal(),
  ));
}

class Principal extends StatefulWidget {
  // widget principal de la app
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  var fecha = DateTime.now();
  var avanceDiario;
  var formatoDia = DateFormat("dd/MM/yyyy");
  var formatoHora = DateFormat("HH:mm");
  // dia de inicio fin
  var primerDia = 1; //inicio lunes
  var ultimoDia = 5; //fin viernes

  //bloques diarias por hora
  var horaInicioUno = 9; //inicio primer turno
  var horaFinUno = 13; //fin primer turno

  var horaInicioDos = 14; //inicio segundo turno
  var horaFinDos = 18; //fin segundo turno

  var z = 0;

  void timerprincipal() {
    Timer.periodic(Duration(seconds: 30), (timer) {
      // Actualizar cada 30 segundos
      z = 1;
      setState(() {
        fecha = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (z == 0) {
      timerprincipal();
    }
    String lang = ui.window.locale.languageCode;

    String ldiario = (lang == "es") ? "Diario" : "Daily";
    String lsemanal = (lang == "es") ? "Semanal" : "Weekly";
    String lmensual = (lang == "es") ? "Mensual" : "Monthly";

    // INICIA CÁLCULO

    avanceDiario = (100 / (ultimoDia - primerDia + 1)).toDouble();

    String fechacompleta = formatoDia.format(fecha);
    String horacompleta = formatoHora.format(fecha);
    var diaMes = fecha.day;
    var fecha2 = new DateTime(fecha.year, fecha.month + 1, 0);
    var ultimoDiaMes = fecha2.day;
    double diasMesCumplidos = diaMes.toDouble() / ultimoDiaMes.toDouble();

    String dia;

    String ltitulo;

    if (lang == "es") {
      ltitulo = "Tiempo Trabajado";
      dia = DateTime.now().weekday == 1
          ? "lunes"
          : DateTime.now().weekday == 2
              ? "martes"
              : DateTime.now().weekday == 3
                  ? "miércoles"
                  : DateTime.now().weekday == 4
                      ? "jueves"
                      : DateTime.now().weekday == 5
                          ? "viernes"
                          : DateTime.now().weekday == 6
                              ? "sabado"
                              : "domingo";
    } else {
      ltitulo = "Time Worked";
      dia = DateTime.now().weekday == 1
          ? "monday"
          : DateTime.now().weekday == 2
              ? "tuesday"
              : DateTime.now().weekday == 3
                  ? "wednesday"
                  : DateTime.now().weekday == 4
                      ? "thursday"
                      : DateTime.now().weekday == 5
                          ? "friday"
                          : DateTime.now().weekday == 6
                              ? "saturday"
                              : "sunday";
    }
    var horas = 0.0;

    if (fecha.hour >= horaInicioUno && fecha.hour < horaFinUno) {
      horas = (fecha.hour - horaInicioUno).toDouble();
      horas += fecha.minute.toDouble() * (1 / 60);
    }
    if (fecha.hour >= horaFinUno) {
      horas = (horaFinUno - horaInicioUno).toDouble();
    }

    if (fecha.hour >= horaInicioDos && fecha.hour < horaFinDos) {
      horas += (fecha.hour - horaInicioDos).toDouble();
      horas += fecha.minute.toDouble() * (1 / 60);
    }

    if (fecha.hour >= horaFinDos) {
      horas = ((horaFinUno - horaInicioUno) + (horaFinDos - horaInicioDos))
          .toDouble();
    }

    double ocupacion;
    double ocupacionDiaria;

    if (DateTime.now().weekday >= primerDia &&
        DateTime.now().weekday <= ultimoDia) {
      ocupacion = (DateTime.now().weekday - 1) * avanceDiario +
          (horas *
              (avanceDiario /
                  ((horaFinUno - horaInicioUno) + (horaFinDos - horaInicioDos))
                      .toDouble()));
      ocupacionDiaria = horas /
          ((horaFinUno - horaInicioUno) + (horaFinDos - horaInicioDos))
              .toDouble();
    } else {
      ocupacion = 0;
      ocupacionDiaria = 0;
    }

    var f = new NumberFormat("#00.00", "en_US");

    String porcentaje = f.format(ocupacion);
    String porcentajeDiario = "";
    String porcentajeMensual = "";
    if (ocupacionDiaria != 1) {
      porcentajeDiario = f.format(100 * ocupacionDiaria);
    } else {
      porcentajeDiario = "100.0";
    }

    if (diasMesCumplidos != 1) {
      porcentajeMensual = f.format(100 * diasMesCumplidos);
    } else {
      porcentajeMensual = "100.0";
    }

    return Scaffold(
      appBar: AppBar(title: Text('$ltitulo'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.build),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Configuracion()),
            );
          },
        ),
      ]),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.green[300]]),
          ),
          child: Column(children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: (Text(
                  "$fechacompleta",
                  textScaleFactor: 3,
                )),
              ),
            ),
            Container(
              child: (Text(
                dia,
                textScaleFactor: 3,
              )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
              child: Column(children: <Widget>[
                Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        width: 150.0,
                        height: 150.00,
                        child: CircularProgressIndicator(
                          value: ocupacionDiaria,
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Colors.orange[400]),
                          backgroundColor: Colors.orange[700],
                          strokeWidth: 40,
                        ),
                      ),
                      Container(
                        width: 230.0,
                        height: 230.00,
                        child: CircularProgressIndicator(
                          value: ocupacion / 100,
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Colors.green[700]),
                          backgroundColor: Colors.green[900],
                          strokeWidth: 40,
                        ),
                      ),
                      Container(
                        width: 310.0,
                        height: 310.00,
                        child: CircularProgressIndicator(
                          value: diasMesCumplidos,
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Colors.purple[300]),
                          backgroundColor: Colors.purple[700],
                          strokeWidth: 40,
                        ),
                      ),
                      Positioned(
                        top: 80,
                        child: Text(
                          horacompleta.trim(),
                          textScaleFactor: 8,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Positioned(
                        top: 30,
                        child: Text(
                          "$porcentaje",
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Positioned(
                        top: 260,
                        child: Text(
                          "$lsemanal",
                          textScaleFactor: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Positioned(
                        top: 70,
                        child: Text(
                          "$porcentajeDiario",
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Positioned(
                        top: 220,
                        child: Text(
                          "$ldiario",
                          textScaleFactor: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Positioned(
                        top: -10,
                        child: Text(
                          "$porcentajeMensual",
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Positioned(
                        top: 300,
                        child: Text(
                          "$lmensual",
                          textScaleFactor: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
