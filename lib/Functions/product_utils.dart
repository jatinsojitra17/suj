import 'package:sujin/Functions/product_data.dart';

List<String> getSizes(String mainCategory, String productName) {
  switch (mainCategory) {
    case 'Cabinet Handles':
    case 'Conceal':
      if (productName == 'SI 008') {
        return ProductData.si008sizes.toList();
      } else if (productName == 'SI 201' ||
          productName == 'SI 202' ||
          productName == 'SI 203' ||
          productName == 'SI 204' ||
          productName == 'SI 205' ||
          productName == 'SI 206' ||
          productName == 'SI 207' ||
          productName == 'SI 208' ||
          productName == 'C-6') {
        return ProductData.zinc.toList();
      } else if (productName == 'C-1' || productName == 'C-2') {
        return ProductData.concealSizes.toList();
      } else {
        return ProductData.cabinetHandlesSizes.toList();
      }

    case 'Kadi':
      return ProductData.kadiSizes.toList();

    case 'Knobs':
      switch (productName) {
        case 'Knob-1':
        case 'Knob-8':
          return ProductData.knob1Sizes.toList();
        case 'Knob-2':
          return ProductData.knob2Sizes.toList();
        case 'Knob-3':
        case 'Knob-9':
          return ProductData.knob3Sizes.toList();
        case 'Knob-4':
          return ProductData.knob4Sizes.toList();
        case 'Knob-5':
          return ProductData.knob5Sizes.toList();
        case 'Knob-6':
        case 'Knob-7':
        case 'Knob-11':
        case 'Knob-12':
          return ProductData.kadiSizes.toList();
        case 'Knob-10':
          return ProductData.knob1Sizes.toList();
        default:
          return [];
      }
    case 'Profile':
      return ProductData.profilesSizes.toList();

    case 'Glass Doors':
      return ProductData.glass_doorsSizes.toList();

    case 'Tower Bolt':
      return ProductData.tower_boltSizes.toList();

    case 'Baby Latch':
      return ProductData.baby_latchSizes.toList();

    default:
      return [];
  }
}

List<String> getFinishes(String productName) {
  switch (productName) {
    case 'SI 008':
      return ProductData.si008Finishes.toList();
    case 'SI 048':
      return ProductData.si048Finishes.toList();
    case 'SI 049':
    case 'SI 056':
    case 'SI 058':
      return ProductData.si049Finishes.toList();
    case 'SI 052':
      return ProductData.si052Finishes.toList();
    case 'SI 054':
      return ProductData.si054Finishes.toList();
    case 'SI 055':
      return ProductData.si055Finishes.toList();

    case 'SI 057':
      return ProductData.si057Finishes.toList();
    case 'SI 063':
      return ProductData.si063Finishes.toList();
    case 'SI 065':
      return ProductData.si065Finishes.toList();
    case 'SI 066':
      return ProductData.si066Finishes.toList();
    case 'SI 068':
      return ProductData.si068Finishes.toList();
    case 'SI 069':
      return ProductData.si069Finishes.toList();
    case 'SI 070':
      return ProductData.si070Finishes.toList();
    case 'SI 071':
    case 'SI 072':
    case 'SI 073':
    case 'SI 074':
      return ProductData.si071Finishes.toList();
    case 'SI 076':
    case 'SI 079':
      return ProductData.si076Finishes.toList();
    case 'SI 077':
    case 'SI 078':
    case 'SI 080':
    case 'SI 081':
      return ProductData.si077Finishes.toList();
    case 'SI 201':
    case 'SI 202':
      return ProductData.si201Finishes.toList();
    case 'SI 203':
      return ProductData.si203Finishes.toList();
    case 'SI 204':
      return ProductData.si204Finishes.toList();
    case 'SI 205':
      return ProductData.si205Finishes.toList();
    case 'SI 206':
    case 'SI 207':
      return ProductData.si206Finishes.toList();
    case 'SI 208':
      return ProductData.si208Finishes.toList();
    case 'P-1':
    case 'P-2':
    case 'P-3':
      return ProductData.profileFinishes.toList();
    case 'C-1':
      return ProductData.c1Finishes.toList();
    case 'C-2':
      return ProductData.c2Finishes.toList();
    case 'C-3':
      return ProductData.c3Finishes.toList();
    case 'C-4':
      return ProductData.c4Finishes.toList();
    case 'C-6':
      return ProductData.c6Finishes.toList();
    case 'Kadi-1':
    case 'Kadi-3':
      return ProductData.kadiFinishes.toList();
    case 'Kadi-4':
      return ProductData.kadi4Finishes.toList();
    case 'Knob-1':
      return ProductData.knob1Finishes.toList();
    case 'Knob-2':
      return ProductData.knob2Finishes.toList();
    case 'Knob-3':
    case 'Knob-4':
    case 'Knob-5':
      return ProductData.knob3Finishes.toList();
    case 'Knob-6':
    case 'Knob-7':
      return ProductData.knob6Finishes.toList();
    case 'Knob-8':
      return ProductData.knob8Finishes.toList();
    case 'Knob-9':
      return ProductData.knob9Finishes.toList();
    case 'Knob-10':
      return ProductData.knob10Finishes.toList();
    case 'Knob-11':
      return ProductData.knob11Finishes.toList();
    case 'Knob-12':
      return ProductData.knob12Finishes.toList();
    case 'SGH 1011':
      return ProductData.sgh1011Finishes.toList();
    case 'SGH 1012':
      return ProductData.sgh1012Finishes.toList();
    case 'SGH 1001':
    case 'SGH 1002':
    case 'SGH 1003':
      return ProductData.sgh1001Finishes.toList();

    case 'SGH 1004':
      return ProductData.sgh1004Finishes.toList();
    case 'SGH 1017':
      return ProductData.sgh1017Finishes.toList();
    case 'SGH 1018':
      return ProductData.sgh1018Finishes.toList();
    case 'SGH 1019':
      return ProductData.sgh1019Finishes.toList();
    case 'SGH 1020':
    case 'SGH 1021':
    case 'SGH 1023':
      return ProductData.sgh1020Finishes.toList();
    case 'SGH 1022':
      return ProductData.sgh1022Finishes.toList();
    case 'SITB-01':
      return ProductData.sitb01Finishes.toList();
    case 'SITB-02':
    case 'SITB-03':
      return ProductData.sitb02Finishes.toList();
    case 'SIBL-01':
      return ProductData.sibl01Finishes.toList();
    default:
      return [];
  }
}

List<String> getPacking(String productName) {
  switch (productName) {
    case 'SI 008':
    case 'SI 054':
    case 'SI 057':
    case 'SI 080':
      return ProductData.s2015Packing.toList();
    case 'SI 048':
    case 'SI 049':
    case 'SI 052':
    case 'SI 073':
    case 'SI 079':
      return ProductData.s2018Packing.toList();
    case 'SI 055':
      return ProductData.s15Packing.toList();
    case 'SI 056':
    case 'SI 058':
      return ProductData.s2420Packing.toList();
    case 'SI 063':
    case 'SI 069':
    case 'SI 076':
      return ProductData.s1515Packing.toList();
    case 'SI 065':
    case 'SI 066':
    case 'SI 072':
    case 'SI 074':
    case 'SI 081':
    case 'SI 202':
    case 'SI 203':
    case 'SI 204':
    case 'SI 205':
    case 'SI 206':
    case 'SI 207':
    case 'SI 208':
    case 'C-4':
      return ProductData.standardPacking.toList();
    case 'SI 068':
    case 'SI 077':
    case 'SI 078':
      return ProductData.s4020Packing.toList();
    case 'SI 070':
      return ProductData.s1815Packing.toList();
    case 'SI 071':
    case 'SI 201':
      return ProductData.s3020Packing.toList();
    case 'C-1':
    case 'C-3':
      return ProductData.cPacking.toList();
    case 'C-2':
      return ProductData.c2Packing.toList();
    case 'C-6':
      return ProductData.c6Packing.toList();
    case 'P-1':
    case 'P-2':
    case 'P-3':
      return ProductData.pPacking.toList();
    case 'Kadi-1':
    case 'Kadi-3':
    case 'Kadi-4':
    case 'Knob-1':
    case 'Knob-2':
    case 'Knob-3':
    case 'Knob-4':
    case 'Knob-5':
    case 'Knob-6':
    case 'Knob-7':
    case 'Knob-8':
    case 'Knob-9':
    case 'Knob-10':
    case 'Knob-11':
    case 'Knob-12':
      return ProductData.s36packing.toList();
    case 'SITB-01':
    case 'SITB-03':
      return ProductData.towerboltPacking.toList();
    case 'SITB-02':
      return ProductData.sitb02Packing.toList(); 
    case 'SIBL-01':
      return ProductData.babylatchPacking.toList();
    default:
      return [];
  }
}
