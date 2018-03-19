syntax keyword Constant True False None
syn match pythonStrFormat "{\d\+}" contained containedin=pythonString,pythonBString,pythonUniString,pythonRawString,pythonUniRawString
