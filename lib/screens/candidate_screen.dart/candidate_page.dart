import 'package:flutter/material.dart';
import 'package:votiface/screens/candidate_screen.dart/components/candidate_card.dart';

import '../../constants.dart';

class CandidatePage extends StatefulWidget {
  static const routeName = '/candidate';
  const CandidatePage({Key? key}) : super(key: key);

  @override
  State<CandidatePage> createState() => _CandidatePageState();
}

class _CandidatePageState extends State<CandidatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    child: Image.asset('assets/ElectionBanner.png'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Icon(Icons.data_array),
                      const Text(
                        'Total Votes',
                        style: const TextStyle(
                          color: Color.fromARGB(87, 0, 0, 0),
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    '299658',
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.timer,
                      ),
                      const Text(
                        'Voting Closes at 4pm Aug 04, 2022',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      CandidateCard(
                        candidate_image_url: 'assets/ElectionBanner.png',
                        candidate_name: 'Biraj Motherfucker',
                        candidate_party_url: 'assets/logo.png',
                        candidate_party_name: 'Nepali Congress',
                      ),
                      CandidateCard(
                        candidate_image_url: 'assets/ElectionBanner.png',
                        candidate_name: 'Biraj Motherfucker',
                        candidate_party_url: 'assets/logo.png',
                        candidate_party_name: 'Nepali Congress',
                      ),
                      CandidateCard(
                        candidate_image_url: 'assets/ElectionBanner.png',
                        candidate_name: 'Biraj Motherfucker',
                        candidate_party_url: 'assets/logo.png',
                        candidate_party_name: 'Nepali Congress',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: kPrimaryColor,
                            fixedSize: const Size(300, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                          ),
                          child: Text(
                            'Submit Vote',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
