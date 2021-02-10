RegExp emailRegExp = new RegExp(
  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?\s^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
);
RegExp passwordRegExp = new RegExp(
  r'^(?=.*?[a-z])(?=.*?[0-9]).{9,}$',
);
