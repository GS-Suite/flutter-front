generateCreds(userHash, userEmail) {
  var cred = userHash + userEmail;
  print(cred);
  if (cred.length % 2 == 0) {
    print('even');
  } else {
    print('odd');
    cred = cred + 'x';
    print(cred);
  }
  print(cred);
  var len = cred.codeUnits.length;
  if (cred.codeUnits.length % 2 == 0) {
    var arr1 = cred.codeUnits.sublist(0, (len / 2).round());
    var arr2 = cred.codeUnits.sublist((len / 2).round(), len);
    var password = '';
    for (var i = 0; i < arr1.length; i++) {
      var s = arr1[i] ^ arr2[i];
      password += s.toString();
    }
    return password;
  } else {
    var arr1 = cred.codeUnits.sublist(0, (len / 2).round());
    var arr2 = cred.codeUnits.sublist((len / 2).round(), len);
    print(cred.codeUnits);
    print(arr1);
    print(arr2);
    print(arr1.length);
    print(arr2.length);
    var password = '';
    for (var i = 0; i < arr1.length; i++) {
      var s = arr1[i] ^ arr2[i];
      password += s.toString();
    }
    print(password);
    return password;
  }
}
