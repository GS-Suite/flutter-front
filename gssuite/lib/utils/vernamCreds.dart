generateCreds(userHash, userEmail) {
  var cred = userHash + userEmail;
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
  }
}
