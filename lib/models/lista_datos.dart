class OpcionesLista {
  String asset;
  String titulo;
  String descripcion;
  String initialPrompt;
  String initalResponse;
  double temperature;
  int maxtokens;
  double topP;
  double frequencypenalty;
  double presencepenalty;
  int type;

  OpcionesLista(
    this.asset,
    this.titulo,
    this.descripcion,
    this.initialPrompt,
    this.initalResponse,
    this.temperature,
    this.maxtokens,
    this.topP,
    this.frequencypenalty,
    this.presencepenalty,
    this.type,
  );
}
