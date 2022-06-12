import 'package:flutter/material.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/input_component.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/view_model/login_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatefulWidget {
  final VoidCallback? onLoginSuccess;
  final String? urlPlayStore;

  const LoginView({
    Key? key,
    this.onLoginSuccess,
    this.urlPlayStore,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginViewState();
  }
}

class LoginViewState extends State<LoginView> {
  LoginViewMOdel loginViewMOdel = LoginViewMOdel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      loginViewMOdel.chekLogedIn(
        onLOginSuccess: widget.onLoginSuccess,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 80 / 100;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.teal,
        image: DecorationImage(
          image: NetworkImage(
            "https://wallpapercave.com/wp/Gf1PVhe.jpg",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CircularLoaderComponent(
          controller: loginViewMOdel.loadingController,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  color: Colors.transparent,
                  child: Image.network(
                      "assets/assets/kogo_suzuki_mobile_survey_horizontal.png"),
                ),
              ),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  height: 200,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: const Offset(3, 3),
                        blurRadius: 3,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: width > 300 ? 300 : width,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        color: Colors.transparent,
                        child: InputComponent.inputText(
                          controller: loginViewMOdel.usernameController,
                          hint: System.data.strings!.userName,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        color: Colors.transparent,
                        child: InputComponent.inputText(
                          controller: loginViewMOdel.passwordController,
                          hint: System.data.strings!.password,
                          obscureText: true,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              loginViewMOdel.login(
                                  onLOginSuccess: widget.onLoginSuccess);
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    System.data.color!.link)),
                            child: Text(
                              System.data.strings!.login,
                              style: TextStyle(
                                color: System.data.color!.lightTextColor,
                                fontSize: System.data.font!.xxxl,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse(widget.urlPlayStore ?? ""));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    color: Colors.transparent,
                    width: 100,
                    child: Image.network(
                      "assets/assets/google-play-icon.png",
                    ),
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
