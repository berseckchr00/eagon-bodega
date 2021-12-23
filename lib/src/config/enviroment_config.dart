class EnviromentConfig {
  String _APIKEY;
  String _APIURL;

  EnviromentConfig() {
    this._APIKEY = '767ad943570d6dce845ca37f7dee92f5';
    this._APIURL = 'http://200.54.216.196/infoela.cl/api_bodega/v1';
    //this._APIURL = 'http://infoela.cl/api_bodega/v2';
  }

  String getApiKey() {
    return this._APIKEY;
  }

  String getApiUrl() {
    return this._APIURL;
  }
}
