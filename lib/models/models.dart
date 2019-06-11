class Gol {
  String jogador;
  String tipo;
  String time;

  Gol(this.jogador, this.tipo, this.time);


  Map<String, dynamic> toMap() {
    return {"jogador": this.jogador, "tipo": this.tipo, "time": this.time};
  }

}

// CARTÃO


class Cartao {

  String jogador;
  String tipo;
  String time;

  Cartao(this.jogador, this.tipo, this.time);


  Map<String, dynamic> toMap() {
    return {"jogador": this.jogador, "tipo": this.tipo, "time": this.time};
  }

}