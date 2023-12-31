import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:staff_cleaner/component/textfield/textfield_date_component.dart';
import 'package:staff_cleaner/values/screen_utils.dart';

import '../../../component/button/button_component.dart';
import '../../../component/button/link_component.dart';
import '../../../component/text/text_component.dart';
import '../../../component/textfield/textfield_component.dart';
import '../../../component/textfield/textfield_dropdown_component .dart';
import '../../../services/firebase_services.dart';
import '../../../values/color.dart';
import '../../../values/constant.dart';
import '../../../values/font_custom.dart';
import '../../../values/navigate_utils.dart';
import '../../../values/output_utils.dart';
import '../../../values/widget_utils.dart';
import '../admin_main.dart';

class TambahDataCustomer extends StatefulWidget {
  const TambahDataCustomer({super.key});

  @override
  State<TambahDataCustomer> createState() => _TambahDataCustomerState();
}

class _TambahDataCustomerState extends State<TambahDataCustomer> {
  final namaLengkapController = TextEditingController();
  final tanggalLahirController = TextEditingController();
  final noHpController = TextEditingController();
  final staffController = SingleValueDropDownController();
  final layananController = TextEditingController();
  final tanggalLayananController = TextEditingController();
  final jamLayananController = TextEditingController();
  final dayaController = TextEditingController();
  final mengetahuiController = TextEditingController();
  final alamatLengkapController = TextEditingController();
  final latController = TextEditingController();
  final longController = TextEditingController();

  List<Map<dynamic, dynamic>> itemYangDibersihkan = [];
  List<Map<dynamic, dynamic>> listUser = [];

  final fs = FirebaseServices();

  void getListUser() async {
    try {
      // final res = await fs.getDataCollectionByQuery("staff", "bertugas", false);
      final res = await fs.getDataCollection("staff");
      if (res.isNotEmpty) {
        List<Map<dynamic, dynamic>> user = [];
        for (var e in res) {
          user.add(e.data());
        }
        setState(() {
          listUser = user;
        });
      }
    } catch (e) {
      logO("getListUser", m: e.toString());
    }
  }

  void addItemYangDibersihkan(Map item) {
    itemYangDibersihkan.add(item);
  }

  void removeItemYangDibersihkan(Map item) {
    itemYangDibersihkan.remove(item);
  }

  void uploadData(data, String? email) async {
    try {
      showLoaderDialog(context);
      await fs.addDataCollection("data", data);
      fs.updateDataCollectionByTwoQuery(
          "staff", "email", email, "bertugas", true);
      navigatePushAndRemove(const AdminMain());
    } catch (e) {
      showToast(e);
      logO("error", m: e);
    }
  }

  @override
  void initState() {
    super.initState();

    getListUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.0.w,
        height: 1.0.h,
        color: primaryColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const TextComponent(
                "Input Data Customer",
                color: Colors.white,
              ),
              V(32),
              TextfieldComponent(
                hintText: "Nama lengkap...",
                onChanged: (value) {},
                color: Colors.white,
                controller: namaLengkapController,
              ),
              V(16),
              TextfieldDateComponent(
                  hintText: "Tanggal lahir...",
                  onChanged: (value) {},
                  controller: tanggalLahirController,
                  color: Colors.white),
              V(16),
              TextfieldComponent(
                hintText: "No. handphone...",
                onChanged: (value) {},
                color: Colors.white,
                controller: noHpController,
                inputType: TextInputType.phone,
              ),
              V(16),
              TextfieldDropdownComponent(
                hintText: "Staff yang melayani...",
                onChanged: (value) {},
                items: listUser
                    .map(
                        (e) => {"name": e["nama_lengkap"], "value": e["email"]})
                    .toList(),
                controller: staffController,
              ),
              V(16),
              TextfieldDateComponent(
                  hintText: "Tanggal layanan...",
                  onChanged: (value) {},
                  controller: tanggalLayananController,
                  color: Colors.white),
              V(16),
              TextfieldDateComponent(
                hintText: "Jam layanan...",
                onChanged: (value) {},
                controller: jamLayananController,
                color: Colors.white,
                type: "time",
              ),
              V(16),
              const TextComponent(
                "Item yang akan di bersihkan: ",
                size: 18,
                color: Colors.white,
              ),
              V(8),
              Column(
                  children: itemYangDibersihkan
                      .asMap()
                      .map((i, e) => MapEntry(
                          i,
                          Stack(
                            children: [
                              Column(
                                children: [
                                  Card(
                                    elevation: 8,
                                    clipBehavior: Clip.hardEdge,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextComponent(
                                            "${i + 1}. [${e["service"]}] ${e["item"]}",
                                            size: 10,
                                            weight: Lato.Light,
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  removeItemYangDibersihkan(
                                                      itemYangDibersihkan[i]);
                                                });
                                              },
                                              icon: Icon(Icons.remove))
                                        ],
                                      ),
                                    ),
                                  ),
                                  V(8)
                                ],
                              )
                            ],
                          )))
                      .values
                      .toList()),
              V(8),
              Center(
                child: ButtonElevatedComponent(
                  "Tambah item",
                  onPressed: () {
                    return dialogList(
                        title: "Services",
                        item: listItemLayanan,
                        onGetItem: (service) {
                          logO("service", m: service);

                          String title = service["title"];
                          List<Map<String, dynamic>> itemYangDibersihkan =
                              listItemDibershikan[title]!;

                          return dialogList(
                              title: "Item",
                              item: itemYangDibersihkan,
                              onGetItem: (item) {
                                setState(() {
                                  addItemYangDibersihkan({
                                    "service": title,
                                    "item": item["title"],
                                    "harga": item["harga"]
                                  });
                                });

                                logO("item", m: item);
                              });
                        });
                  },
                ),
              ),
              V(24),
              TextfieldComponent(
                hintText: "Daya listrik (watt)...",
                onChanged: (value) {},
                color: Colors.white,
                controller: dayaController,
                inputType: TextInputType.number,
              ),
              V(16),
              TextfieldComponent(
                hintText: "Mengetahui Yukbersihin dari ?...",
                onChanged: (value) {},
                color: Colors.white,
                controller: mengetahuiController,
              ),
              V(16),
              TextfieldComponent(
                hintText: "Alamat lengkap...",
                onChanged: (value) {},
                color: Colors.white,
                controller: alamatLengkapController,
              ),
              V(32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 0.4.w,
                    child: TextfieldComponent(
                      hintText: "Latitude...",
                      onChanged: (value) {},
                      color: Colors.white,
                      controller: latController,
                      inputType: TextInputType.streetAddress,
                    ),
                  ),
                  Container(
                    width: 0.4.w,
                    child: TextfieldComponent(
                        hintText: "Longitude...",
                        onChanged: (value) {},
                        color: Colors.white,
                        controller: longController,
                        inputType: TextInputType.streetAddress),
                  ),
                ],
              ),
              V(48),
              Center(
                child: ButtonElevatedComponent(
                  "Tambah Data",
                  onPressed: () {
                    final user = fs.getUser();
                    final data = {
                      "email": user?.email,
                      "selesai": false,
                      "nama_lengkap": namaLengkapController.text,
                      "tanggal_lahir": tanggalLahirController.text,
                      "no_hp": noHpController.text,
                      "nama_staff": staffController.dropDownValue?.name,
                      "email_staff": staffController.dropDownValue?.value,
                      "tanggal_layanan": tanggalLayananController.text,
                      "jam_layanan": jamLayananController.text,
                      "item_yang_dibersihkan": itemYangDibersihkan,
                      "daya": dayaController.text,
                      "mengetahui": mengetahuiController.text,
                      "alamat_lengkap": alamatLengkapController.text,
                      "lokasi": {
                        "latitude": latController.text,
                        "longitude": longController.text
                      },
                    };

                    uploadData(data, staffController.dropDownValue?.value);
                  },
                ),
              )
            ]),
          ),
        ),
      ),
    );
    ;
  }
}
