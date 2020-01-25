enum AnimeGenre {
  ACCION,
  ARTES_MARCIALES,
  AVENTURA,
  CARRERAS,
  CIENCIA_FICCION,
  COMEDIA,
  DEMENCIA,
  DEMONIOS,
  DEPORTES,
  DRAMA,
  ECCHI,
  ESCOLARES,
  ESPACIAL,
  FANTASIA,
  HAREM,
  HISTORICO,
  INFANTIL,
  JOSEI,
  JUEGOS,
  MAGIA,
  MECHA,
  MILITAR,
  MISTERIO,
  MUSICA,
  PARODIA,
  POLICIA,
  PSICOLOGICO,
  RECUENTOS_DE_LA_VIDA,
  ROMANCE,
  SAMURAI,
  SEINEN,
  SHOUJO,
  SHOUNEN,
  SOBRENATURAL,
  SUPERPODERES,
  SUSPENSO,
  TERROR,
  VAMPIROS,
  YAOI,
  YURI,
}

extension AnimeGenreExtension on AnimeGenre {
  String get name {
    switch (this) {
      case (AnimeGenre.ACCION):
        return 'Acción';
      case (AnimeGenre.ARTES_MARCIALES):
        return 'Artes Marciales';
      case (AnimeGenre.AVENTURA):
        return 'Aventuras';
      case (AnimeGenre.CARRERAS):
        return 'Carreras';
      case (AnimeGenre.CIENCIA_FICCION):
        return 'Ciencia Ficción';
      case (AnimeGenre.COMEDIA):
        return 'Comedia';
      case (AnimeGenre.DEMENCIA):
        return 'Demencia';
      case (AnimeGenre.DEMONIOS):
        return 'Demonios';
      case (AnimeGenre.DEPORTES):
        return 'Deportes';
      case (AnimeGenre.DRAMA):
        return 'Drama';
      case (AnimeGenre.ECCHI):
        return 'Ecchi';
      case (AnimeGenre.ESCOLARES):
        return 'Escolares';
      case (AnimeGenre.ESPACIAL):
        return 'Espacial';
      case (AnimeGenre.FANTASIA):
        return 'Fantasía';
      case (AnimeGenre.HAREM):
        return 'Harem';
      case (AnimeGenre.HISTORICO):
        return 'Historico';
      case (AnimeGenre.INFANTIL):
        return 'Infantil';
      case (AnimeGenre.JOSEI):
        return 'Josei';
      case (AnimeGenre.JUEGOS):
        return 'Juegos';
      case (AnimeGenre.MAGIA):
        return 'Magia';
      case (AnimeGenre.MECHA):
        return 'Mecha';
      case (AnimeGenre.MILITAR):
        return 'Militar';
      case (AnimeGenre.MISTERIO):
        return 'Misterio';
      case (AnimeGenre.MUSICA):
        return 'Música';
      case (AnimeGenre.PARODIA):
        return 'Parodia';
      case (AnimeGenre.POLICIA):
        return 'Policía';
      case (AnimeGenre.PSICOLOGICO):
        return 'Psicológico';
      case (AnimeGenre.RECUENTOS_DE_LA_VIDA):
        return 'Recuentos de la vida';
      case (AnimeGenre.ROMANCE):
        return 'Romance';
      case (AnimeGenre.SAMURAI):
        return 'Samurai';
      case (AnimeGenre.SEINEN):
        return 'Seinen';
      case (AnimeGenre.SHOUJO):
        return 'Shoujo';
      case (AnimeGenre.SHOUNEN):
        return 'Shounen';
      case (AnimeGenre.SOBRENATURAL):
        return 'Sobrenatural';
      case (AnimeGenre.SUPERPODERES):
        return 'Superpoderes';
      case (AnimeGenre.SUSPENSO):
        return 'Suspenso';
      case (AnimeGenre.TERROR):
        return 'Terror';
      case (AnimeGenre.VAMPIROS):
        return 'Vampiros';
      case (AnimeGenre.YAOI):
        return 'Yaoi';
      case (AnimeGenre.YURI):
        return 'Yuri';
      default:
        return null;
    }
  }
}

final animeGenreString = {
  AnimeGenre.ACCION: 'ACCION',
  AnimeGenre.ARTES_MARCIALES: 'ARTES_MARCIALES',
  AnimeGenre.AVENTURA: 'AVENTURA',
  AnimeGenre.CARRERAS: 'CARRERAS',
  AnimeGenre.CIENCIA_FICCION: 'CIENCIA_FICCION',
  AnimeGenre.COMEDIA: 'COMEDIA',
  AnimeGenre.DEMENCIA: 'DEMENCIA',
  AnimeGenre.DEMONIOS: 'DEMONIOS',
  AnimeGenre.DEPORTES: 'DEPORTES',
  AnimeGenre.DRAMA: 'DRAMA',
  AnimeGenre.ECCHI: 'ECCHI',
  AnimeGenre.ESCOLARES: 'ESCOLARES',
  AnimeGenre.ESPACIAL: 'ESPACIAL',
  AnimeGenre.FANTASIA: 'FANTASIA',
  AnimeGenre.HAREM: 'HAREM',
  AnimeGenre.HISTORICO: 'HISTORICO',
  AnimeGenre.INFANTIL: 'INFANTIL',
  AnimeGenre.JOSEI: 'JOSEI',
  AnimeGenre.JUEGOS: 'JUEGOS',
  AnimeGenre.MAGIA: 'MAGIA',
  AnimeGenre.MECHA: 'MECHA',
  AnimeGenre.MILITAR: 'MILITAR',
  AnimeGenre.MISTERIO: 'MISTERIO',
  AnimeGenre.MUSICA: 'MUSICA',
  AnimeGenre.PARODIA: 'PARODIA',
  AnimeGenre.POLICIA: 'POLICIA',
  AnimeGenre.PSICOLOGICO: 'PSICOLOGICO',
  AnimeGenre.RECUENTOS_DE_LA_VIDA: 'RECUENTOS_DE_LA_VIDA',
  AnimeGenre.ROMANCE: 'ROMANCE',
  AnimeGenre.SAMURAI: 'SAMURAI',
  AnimeGenre.SEINEN: 'SEINEN',
  AnimeGenre.SHOUJO: 'SHOUJO',
  AnimeGenre.SHOUNEN: 'SHOUNEN',
  AnimeGenre.SOBRENATURAL: 'SOBRENATURAL',
  AnimeGenre.SUPERPODERES: 'SUPERPODERES',
  AnimeGenre.SUSPENSO: 'SUSPENSO',
  AnimeGenre.TERROR: 'TERROR',
  AnimeGenre.VAMPIROS: 'VAMPIROS',
  AnimeGenre.YAOI: 'YAOI',
  AnimeGenre.YURI: 'YURI',
};
