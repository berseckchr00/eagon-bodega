import 'dart:convert';

bool isJson(str) {
    try {
        dynamic _data = jsonDecode(str);
        return (_data != null || _data != '')?true:false;
    } catch (e) {
        return false;
    }
}