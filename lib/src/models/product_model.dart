class ProductModel{

  String glosa;
  String idBodega;
  String idCalle;
  String idUbicacion;
  String idZona;
  String nombre;
  String nombreBodega;
  String nombreCalle;
  String nombreZona;
  String producto;
  String cantidad;
  String unidadMedida;

  ProductModel(this.glosa, this.idBodega, this.idCalle, this.idUbicacion, this.idZona, this.nombre, 
  this.nombreBodega, this.nombreCalle, this.nombreZona, this.producto, this.cantidad, this.unidadMedida);
  
  ProductModel.fromJson(Map<String, dynamic> json) {
    try{
      this.glosa = json['glosa'];
      this.idBodega = json['id_bodega'];
      this.idCalle = json['id_calle'];
      this.idUbicacion = json['id_ubicacion'];
      this.idZona = json['id_zona'];
      this.nombre = json['nombre'];
      this.nombreBodega = json['nombre_bodega'];
      this.nombreCalle = json['nombre_calle'];
      this.nombreZona = json['nombre_zona'];
      this.producto = json['producto'];
      this.cantidad = json['cantidad'];
      this.unidadMedida = json['unidad_medida'];
    }catch(ex){
      this.glosa = null;
      this.idBodega = null;
      this.idCalle = null;
      this.idUbicacion = null;
      this.idZona = null;
      this.nombre = null;
      this.nombreBodega = null;
      this.nombreCalle = null;
      this.nombreZona = null;
      this.producto = null;
      this.cantidad = null;
      this.unidadMedida = null;
    }
  }
}