import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Share',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

// Главная страница
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // Картинка
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              height: 700,
              width: 450,
              color: Colors.white,
              child: Image(
                image: AssetImage('assets/carshare.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          //

          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), // форма кнопки
                  padding: EdgeInsets.symmetric(horizontal: 65, vertical: 23), // размер
                  textStyle: TextStyle(fontSize: 15, fontFamily: 'Manrope', fontWeight: FontWeight.bold), // размер
                  primary: Color.fromARGB(255, 255, 255, 255), // цвет
                  onPrimary: const Color.fromARGB(255, 0, 0, 0), // цвет
                  side: BorderSide(color: Color.fromARGB(255, 0, 0, 0)), // рамка
                ),
                child: Text('Вход'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 45, vertical: 23), // размер
                    textStyle: TextStyle(fontSize: 15, fontFamily: 'Manrope', fontWeight: FontWeight.bold), // размер
                    primary: Color.fromARGB(255, 24, 24, 24), // -Изменил цвет
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), // форма кнопки

                    onPrimary: Colors.white
                ),
                child: Text('Регистрация'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Страница регистрации
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Не валидаторы, но контроллеры вводимых данных
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _middleNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();
  bool _passwordsDoNotMatch = false;
  List<XFile?> _selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Регистрация', style: TextStyle(fontSize: 40, fontFamily: 'Manrope', fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '   Фамилия',
                  errorText: _firstNameController.text.isEmpty ? 'Пожалуйста, введите фамилию' : null,
                ),
                maxLength: 32,
                controller: _firstNameController,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '   Имя',
                  errorText: _lastNameController.text.isEmpty ? 'Пожалуйста, введите имя' : null,
                ),
                maxLength: 16,
                controller: _lastNameController,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '   Отчество',
                  errorText: _middleNameController.text.isEmpty ? 'Пожалуйста, введите отчество' : null,
                ),
                maxLength: 32,
                controller: _middleNameController,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '   Электронная почта',
                  errorText: _emailController.text.isEmpty ? 'Пожалуйста, введите электронную почту' : null,
                ),
                maxLength: 32,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '   Пароль',
                  errorText: _passwordController.text.isEmpty ? 'Пожалуйста, введите пароль' : null,
                ),
                maxLength: 16,
                controller: _passwordController,
                obscureText: true,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '   Повторите пароль',
                  errorText: _repeatPasswordController.text.isEmpty ? 'Пожалуйста, повторите пароль' : null,
                ),
                maxLength: 16,
                controller: _repeatPasswordController,
                obscureText: true,
              ),
              if (_passwordsDoNotMatch)
                Text(
                  'Пароли не совпадают',
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 15),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _pickImages();
                    },
                    child: Text('Выбрать 2 фото с ВУ'),
                  ),
                  SizedBox(width: 5),
                  Column(
                    children: _selectedImages.map((image) {
                      return image!.name.length > 25 ? Text(image.name.substring(0, 25) + '...') : Text(image.name ?? '');
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 120, vertical: 24),
                  textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Manrope'),
                  primary: Color.fromARGB(255, 24, 24, 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  onPrimary: Colors.white,
                ),
                onPressed: () async {
                  setState(() {
                    _passwordsDoNotMatch = _passwordController.text != _repeatPasswordController.text;

                    // Проверка на пустые поля и несовпадение паролей
                    if (!_firstNameController.text.isEmpty &&
                        !_lastNameController.text.isEmpty &&
                        !_middleNameController.text.isEmpty &&
                        !_emailController.text.isEmpty &&
                        !_passwordController.text.isEmpty &&
                        !_repeatPasswordController.text.isEmpty &&
                        !_passwordsDoNotMatch && _selectedImages.length == 2) {

                      // Сохранение данных пользователя
                      _saveRegistrationData();
                      // Исчезающее уведомление об успешной регистрации
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Регистрация успешна! Проверка данных займёт не более часа, ожидайте'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }
                  });
                },
                child: Text('Регистрация'),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  'У вас уже есть аккаунт? Войдите',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Функция прикрепления фотографий
  Future<void> _pickImages() async {
    try {
      List<XFile> result = await ImagePicker().pickMultiImage();
      if (result.isNotEmpty) {
        setState(() {
          _selectedImages = result;
        });
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  // Функция сохранения данных при регистрации
  void _saveRegistrationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = _emailController.text;
    prefs.setString('email', _emailController.text);
    prefs.setString('$email.firstName', _firstNameController.text);
    prefs.setString('$email.lastName', _lastNameController.text);
    prefs.setString('$email.middleName', _middleNameController.text);
    prefs.setString('$email.password', _passwordController.text);
    prefs.setStringList('$email.imagePaths', _selectedImages.map((image) => image?.path ?? '').toList());
  }
}

// Страница авторизации
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // Контроллеры вводимых данных
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String loginStatus = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Вход', style: TextStyle(fontSize: 40, fontFamily: 'Manrope', fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '   Электронная почта',
                  errorText: _emailController.text.isEmpty ? 'Пожалуйста, введите электронную почту' : null,
                ),
                maxLength: 32,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '   Пароль',
                  errorText: _passwordController.text.isEmpty ? 'Пожалуйста, введите пароль' : null,
                ),
                maxLength: 16,
                controller: _passwordController,
                obscureText: true,
              ),
              Text(
                loginStatus,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 120, vertical: 24),
                  textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Manrope'),
                  primary: Color.fromARGB(255, 24, 24, 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  onPrimary: Colors.white,
                ),
                onPressed: () async {
                  // Проверка на пустые поля
                  if (!_emailController.text.isEmpty && !_passwordController.text.isEmpty) {

                    // Поиск данных о пользователе
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? savedPassword = prefs.getString('${_emailController.text}.password');
                    setState(() {
                      if (_passwordController.text == savedPassword) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ChooseCarPage()),
                        );
                      } else {
                        loginStatus = 'Неверная электронная почта или пароль';
                      }
                    });
                  }
                },
                child: Text('Войти'),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(
                  'Нет аккаунта? Зарегистрируйтесь',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Страница бронирования автомобиля
class ChooseCarPage extends StatefulWidget {
  @override
  ChooseCarPageState createState() => ChooseCarPageState();
}

class ChooseCarPageState extends State<ChooseCarPage> {
  // Заранее заданный двумерный массив данных для каждого автомобиля
  final List<List<String>> carDataList = [
    ['Reno Logan', '54 л', 'Хэтчбек', 'Механическая КП', 'Без кондиционера', 'с936ав799', '48.71397267415796,44.5237684249878', '0', '', ''],
    ['Hyundai Solaris', '36 л', 'Лифтбэк', 'Механическая КП', 'С кондиционером', 'м744бп34', '48.710786985571204,44.51836109161378', '1', '', ''],
    ['Volkswagen Golf', '42 л', 'Седан', 'Механическая КП', 'Без кондиционера', 'х125ом799', '48.706439965105595,44.51619386672974', '2', '', ''],
    ['Hyundai Creta', '58 л', 'Лифтбэк', 'Автоматическая КП', 'С кондиционером', 'с421еа799', '48.70571778526682,44.52284574508668', '3', '', ''],
    ['Volkswagen Polo', '44 л', 'Седан', 'Автоматическая КП', 'С кондиционером', 'о955рв799', '48.71485047289781,44.53112840652466', '4', '', ''],
    ['Nissan Almera', '56 л', 'Хэтчбек', 'Роботизированная КП', 'С кондиционером', 'к649от799', '48.71827657303453,44.53428268432617', '5', '', ''],
    ['Mercedes Sprinter', '38 л', 'Седан', 'Автоматическая КП', 'С кондиционером', 'у799кт34', '48.722028026608264,44.511644840240486', '6', '', ''],
  ];
  String selectedTarif = 'Минуты';
  String selectedPay = 'Картой онлайн';

  // Функция сохранения данных выбранного автомобиля
  Future<void> _saveSelectedCarData(List<String> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selectedCarData', data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Доступные автомобили'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: carDataList.length,
        itemBuilder: (context, index) {
          return _buildCarItem(context, index);
        },
      ),
    );
  }

  // Виджет ленты автомобилей
  Widget _buildCarItem(BuildContext context, int index) {
    List<String> carData = carDataList[index];
    // Инициализация некоторых данных автомобиля
    String carModel = carData[0];
    String detail1 = carData[1];
    String detail2 = carData[2];
    String detail3 = carData[3];
    String detail4 = carData[4];
    String location = carData[6];
    String carImage = 'assets/car$index.jpg'; // Путь к изображению автомобиля

    return Card(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            carImage,
            height: 150.0,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  carModel,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Запас топлива: $detail1'),
                Text('Тип кузова: $detail2'),
                Text('Коробка передач: $detail3'),
                Text('Кондиционер: $detail4'),
                SizedBox(height: 16),
                _buildExpandableList('Тариф', ['Минуты', 'Часы', 'Дни', 'Фикс'], selectedTarif, (value) {
                  setState(() {
                    selectedTarif = value;
                    carData[8] = value;
                  });
                }),
                SizedBox(height: 8),
                _buildExpandableList('Способ оплаты', ['Картой онлайн', 'Sber Pay', 'Mir Pay', 'СБП'], selectedPay, (value) {
                  setState(() {
                    selectedPay = value;
                    carData[9] = value;
                  });
                }),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Открытие карты с местоположением автомобиля
                        List<String> coordinates = location.split(',');
                        _openMaps(carModel, double.parse(coordinates[0]), double.parse(coordinates[1]));
                      },
                      child: Text('Местоположение'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Проверка выбора тарифа и способа оплаты
                        if (carData[8].isEmpty || carData[9].isEmpty) {
                          // Исчезающее уведомление
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Пожалуйста, выберите тариф и способ оплаты'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          // Сохранение данных забронированного автомобиля
                          _saveSelectedCarData(carData);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          );
                        }
                      },
                      child: Text('Забронировать'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Виджет раскрывающегося списка
  Widget _buildExpandableList(String title, List<String> options, String selectedValue, Function(String) onChanged) {
    return ExpansionTile(
      title: Text(title),
      children: options.map((option) {
        return ListTile(
          title: Text(option),
          onTap: () {
            onChanged(option);
          },
          tileColor: option == selectedValue ? Colors.blue.withOpacity(0.3) : null,
        );
      }).toList(),
    );
  }
}

// Личный кабинет
class ProfilePage extends StatefulWidget {

  final List<String>? selectedCarData;
  ProfilePage({this.selectedCarData});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstName = '';
  String lastName = '';
  String middleName = '';
  String email = '';
  // Заранее заданные данные ВУ
  String dateBirth = '23.12.1976 Гор.Горький';
  String dateVU = '22.05.2019';
  String whoVU = 'ГИБДД 5201';
  String numVU = '99 08 622492';
  String adrVU = 'Нижегородская обл.';
  String rights = 'В В1 М';

  List<String>? selectedCarData;
  int _bookingDurationInSeconds = 2 * 60;
  double currentLatitude = 48.7128400079918;
  double currentLongitude = 44.526879787445075;

  // Установка начального состояния - получение данных пользователя
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Функция получения данных пользователя и выбранного автомобиля
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? '';
      firstName = prefs.getString('$email.firstName') ?? '';
      lastName = prefs.getString('$email.lastName') ?? '';
      middleName = prefs.getString('$email.middleName') ?? '';
      selectedCarData = prefs.getStringList('selectedCarData');
    });
    // Вычисление времени действия брони в зависимости от удалённости автомобиля
    if (selectedCarData != null && selectedCarData!.isNotEmpty) {
      List<String> coordinates = selectedCarData![6].split(',');
      if (calculateDistance(currentLatitude, currentLongitude, double.parse(coordinates[0]), double.parse(coordinates[1])) < 0.5) {
        _bookingDurationInSeconds = 8 * 60;
      } else if (calculateDistance(currentLatitude, currentLongitude, double.parse(coordinates[0]), double.parse(coordinates[1])) < 1.0) {
        _bookingDurationInSeconds = 17 * 60;
      } else if (calculateDistance(currentLatitude, currentLongitude, double.parse(coordinates[0]), double.parse(coordinates[1])) < 1.5) {
        _bookingDurationInSeconds = 23 * 60;
      } else {
        _bookingDurationInSeconds = 30 * 60;
      }
    }
  }

  // Функция отмены бронирования
  void _removeSelectedCarData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('selectedCarData');
  }

  // Функция вычисления расстояния между двумя объектами по координатам
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      selectedCarData = widget.selectedCarData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Личный кабинет'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Отмена бронирования
              _removeSelectedCarData();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Имя: $firstName'),
            Text('Фамилия: $lastName'),
            Text('Отчество: $middleName'),
            Text('Email: $email'),
            Text('Дата и место рождения: $dateBirth'),
            Text('Дата выдачи ВУ: $dateVU'),
            Text('Кем выдано ВУ: $whoVU'),
            Text('Номер ВУ: $numVU'),
            Text('Место жительства: $adrVU'),
            Text('Категории ТС: $rights'),
            SizedBox(height: 20),
            // Проверка на существование забронированного автомобиля
            if (selectedCarData != null && selectedCarData!.isNotEmpty) ...[
              Text('Информация о бронируемом автомобиле:'),
              Card(
                margin: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/car${selectedCarData![7]}.jpg',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedCarData![0],
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('Регистрационный номер: ${selectedCarData![5]}'),
                          Text('Запас топлива: ${selectedCarData![1]}'),
                          Text('Тип кузова: ${selectedCarData![2]}'),
                          Text('Коробка передач: ${selectedCarData![3]}'),
                          Text('Кондиционер: ${selectedCarData![4]}'),
                          SizedBox(height: 16),
                          Text('Тариф: ${selectedCarData![8]}'),
                          SizedBox(height: 8),
                          Text('Способ оплаты: ${selectedCarData![9]}'),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Открытие карты с местоположением автомобиля
                                  List<String> coordinates = selectedCarData![6].split(',');
                                  _openMaps(selectedCarData![0], double.parse(coordinates[0]), double.parse(coordinates[1]));
                                },
                                child: Text('Местоположение'),
                              ),
                              SizedBox(width: 25),
                              ElevatedButton(
                                onPressed: () {
                                  // Отмена бронирования
                                  _removeSelectedCarData();
                                  // Исчезающее уведомление
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Бронирование отменено'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                child: Text('Отменить бронь'),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Text('Бронь заканчивается через: '),
                              // Обратный отсчёт
                              CountdownTimer(
                                endTime: DateTime.now().millisecondsSinceEpoch + _bookingDurationInSeconds * 1000,
                                textStyle: TextStyle(fontSize: 15, color: Colors.black),
                                onEnd: () {
                                  // Отмена бронирования
                                  _removeSelectedCarData();
                                  // Исчезающее уведомление
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Бронирование отменено'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Выбрать автомобиль'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Функция для открытия карты во внешнем картографическом приложении
Future<void> _openMaps(String carModel, double latitude, double longitude) async {
  final availableMaps = await MapLauncher.installedMaps;

  if (availableMaps.isNotEmpty) {
    await MapLauncher.showMarker(
      mapType: MapType.google,
      coords: Coords(latitude, longitude),
      title: carModel,
    );
  } else {
    print('Нет установленных картографических приложений');
  }
}