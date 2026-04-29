// ════════════════════════════════════════════════════════════════
// DICTIONNAIRE AR — DONNÉES PROVISOIRES MODULE M4
// ════════════════════════════════════════════════════════════════
// Ces données simulent le dictionnaire visuel de l'application.
// LOGIQUE D'AFFICHAGE :
//   → Étiquette principale : TOUJOURS en anglais (langue universelle)
//   → Traduction dessous : dans la langue choisie par l'utilisateur
//   → Exemple : objet "chair" détecté, langue = Arabe
//     Affichage : "Chair" (grand, blanc)
//                 "كرسي — Kursi" (petit, couleur langue)
//
// SOURCE RÉELLE :
//   → Table sqflite vocabulary (M2 Leçons) WHERE has_ar = 1
//   → Requête : SELECT english, translation, transliteration
//     FROM vocabulary WHERE ml_label = ? AND language = ?
// POUR REMPLACER : ARObjectService.getTranslation(mlLabel, language)
// ════════════════════════════════════════════════════════════════

class M4MockData {
  // ── DICTIONNAIRE OBJET → TRADUCTIONS PAR LANGUE ──────────────
  // Clé : label ML Kit en anglais (minuscules, tel que retourné par MLKit)
  // Valeur : Map langue → {translation, transliteration, pronunciation}
  //
  // TODO(DB) : Remplacer par une requête sqflite :
  //   SELECT * FROM vocabulary WHERE ml_label = '{mlLabel}'
  //     AND language IN ({languesActives})
  static const Map<String, Map<String, Map<String, String>>> objectDictionary = {
    // ── Maison / Bureau ───────────────────────────────────────
    'chair': {
      'Arabe': {'word': 'كرسي', 'roman': 'Kursi', 'sound': 'KUR-see'},
      'Anglais': {'word': 'Chair', 'roman': '', 'sound': 'chEHr'},
      'Espagnol': {'word': 'Silla', 'roman': '', 'sound': 'SEE-ya'},
      'Français': {'word': 'Chaise', 'roman': '', 'sound': 'shEHz'},
      'Allemand': {'word': 'Stuhl', 'roman': '', 'sound': 'shTOOL'},
      'Japonais': {'word': '椅子', 'roman': 'Isu', 'sound': 'EE-soo'},
    },
    'table': {
      'Arabe': {'word': 'طاولة', 'roman': 'Tawila', 'sound': 'TAW-ee-la'},
      'Anglais': {'word': 'Table', 'roman': '', 'sound': 'TAY-bul'},
      'Espagnol': {'word': 'Mesa', 'roman': '', 'sound': 'MEH-sa'},
      'Français': {'word': 'Table', 'roman': '', 'sound': 'TAH-bl'},
      'Allemand': {'word': 'Tisch', 'roman': '', 'sound': 'TISH'},
      'Japonais': {'word': 'テーブル', 'roman': 'Tēburu', 'sound': 'TEH-boo-roo'},
    },
    'door': {
      'Arabe': {'word': 'باب', 'roman': 'Bab', 'sound': 'BAB'},
      'Anglais': {'word': 'Door', 'roman': '', 'sound': 'dOR'},
      'Espagnol': {'word': 'Puerta', 'roman': '', 'sound': 'PWER-ta'},
      'Français': {'word': 'Porte', 'roman': '', 'sound': 'PORT'},
      'Allemand': {'word': 'Tür', 'roman': '', 'sound': 'TÜÜR'},
      'Japonais': {'word': 'ドア', 'roman': 'Doa', 'sound': 'DOH-ah'},
    },
    'window': {
      'Arabe': {'word': 'نافذة', 'roman': 'Nafidha', 'sound': 'NA-fee-tha'},
      'Anglais': {'word': 'Window', 'roman': '', 'sound': 'WIN-doh'},
      'Espagnol': {'word': 'Ventana', 'roman': '', 'sound': 'ven-TA-na'},
      'Français': {'word': 'Fenêtre', 'roman': '', 'sound': 'feh-NEH-tr'},
      'Allemand': {'word': 'Fenster', 'roman': '', 'sound': 'FEN-ster'},
      'Japonais': {'word': '窓', 'roman': 'Mado', 'sound': 'MA-doh'},
    },
    'book': {
      'Arabe': {'word': 'كتاب', 'roman': 'Kitab', 'sound': 'kee-TAB'},
      'Anglais': {'word': 'Book', 'roman': '', 'sound': 'bUUK'},
      'Espagnol': {'word': 'Libro', 'roman': '', 'sound': 'LEE-bro'},
      'Français': {'word': 'Livre', 'roman': '', 'sound': 'LEE-vr'},
      'Allemand': {'word': 'Buch', 'roman': '', 'sound': 'BOOK'},
      'Japonais': {'word': '本', 'roman': 'Hon', 'sound': 'HON'},
    },
    'pen': {
      'Arabe': {'word': 'قلم', 'roman': 'Qalam', 'sound': 'kah-LAM'},
      'Anglais': {'word': 'Pen', 'roman': '', 'sound': 'PEN'},
      'Espagnol': {'word': 'Bolígrafo', 'roman': '', 'sound': 'bo-LEE-gra-fo'},
      'Français': {'word': 'Stylo', 'roman': '', 'sound': 'STEE-loh'},
      'Allemand': {'word': 'Stift', 'roman': '', 'sound': 'SHTIFT'},
      'Japonais': {'word': 'ペン', 'roman': 'Pen', 'sound': 'PEN'},
    },
    'laptop': {
      'Arabe': {'word': 'حاسوب', 'roman': 'Hasub', 'sound': 'HA-soob'},
      'Anglais': {'word': 'Laptop', 'roman': '', 'sound': 'LAP-top'},
      'Espagnol': {'word': 'Ordenador', 'roman': '', 'sound': 'or-de-na-DOR'},
      'Français': {'word': 'Ordinateur', 'roman': '', 'sound': 'or-dee-na-TEUR'},
      'Allemand': {'word': 'Laptop', 'roman': '', 'sound': 'LAP-top'},
      'Japonais': {'word': 'ノートPC', 'roman': 'Nōto PC', 'sound': 'NOH-toh PC'},
    },
    'phone': {
      'Arabe': {'word': 'هاتف', 'roman': 'Hatif', 'sound': 'HA-teef'},
      'Anglais': {'word': 'Phone', 'roman': '', 'sound': 'FOHN'},
      'Espagnol': {'word': 'Teléfono', 'roman': '', 'sound': 'te-LEH-fo-no'},
      'Français': {'word': 'Téléphone', 'roman': '', 'sound': 'teh-leh-FON'},
      'Allemand': {'word': 'Handy', 'roman': '', 'sound': 'HAN-dee'},
      'Japonais': {'word': '電話', 'roman': 'Denwa', 'sound': 'DEN-wah'},
    },
    'cup': {
      'Arabe': {'word': 'كوب', 'roman': 'Kub', 'sound': 'KOOB'},
      'Anglais': {'word': 'Cup', 'roman': '', 'sound': 'KUP'},
      'Espagnol': {'word': 'Taza', 'roman': '', 'sound': 'TA-sa'},
      'Français': {'word': 'Tasse', 'roman': '', 'sound': 'TASS'},
      'Allemand': {'word': 'Tasse', 'roman': '', 'sound': 'TA-seh'},
      'Japonais': {'word': 'カップ', 'roman': 'Kappu', 'sound': 'KAP-poo'},
    },
    'bottle': {
      'Arabe': {'word': 'زجاجة', 'roman': 'Zujaja', 'sound': 'zoo-JA-ja'},
      'Anglais': {'word': 'Bottle', 'roman': '', 'sound': 'BOT-ul'},
      'Espagnol': {'word': 'Botella', 'roman': '', 'sound': 'bo-TEH-ya'},
      'Français': {'word': 'Bouteille', 'roman': '', 'sound': 'boo-TAY'},
      'Allemand': {'word': 'Flasche', 'roman': '', 'sound': 'FLA-sheh'},
      'Japonais': {'word': 'ボトル', 'roman': 'Botoru', 'sound': 'BOH-toh-roo'},
    },

    // ── Nature / Extérieur ───────────────────────────────────
    'tree': {
      'Arabe': {'word': 'شجرة', 'roman': 'Shajara', 'sound': 'SHA-ja-ra'},
      'Anglais': {'word': 'Tree', 'roman': '', 'sound': 'TREE'},
      'Espagnol': {'word': 'Árbol', 'roman': '', 'sound': 'AR-bol'},
      'Français': {'word': 'Arbre', 'roman': '', 'sound': 'AR-br'},
      'Allemand': {'word': 'Baum', 'roman': '', 'sound': 'BOWM'},
      'Japonais': {'word': '木', 'roman': 'Ki', 'sound': 'KI'},
    },
    'flower': {
      'Arabe': {'word': 'زهرة', 'roman': 'Zahra', 'sound': 'ZAH-ra'},
      'Anglais': {'word': 'Flower', 'roman': '', 'sound': 'FLOW-er'},
      'Espagnol': {'word': 'Flor', 'roman': '', 'sound': 'FLOR'},
      'Français': {'word': 'Fleur', 'roman': '', 'sound': 'FLEUR'},
      'Allemand': {'word': 'Blume', 'roman': '', 'sound': 'BLOO-meh'},
      'Japonais': {'word': '花', 'roman': 'Hana', 'sound': 'HA-na'},
    },
    'car': {
      'Arabe': {'word': 'سيارة', 'roman': 'Sayyara', 'sound': 'say-YA-ra'},
      'Anglais': {'word': 'Car', 'roman': '', 'sound': 'KAR'},
      'Espagnol': {'word': 'Coche', 'roman': '', 'sound': 'KO-cheh'},
      'Français': {'word': 'Voiture', 'roman': '', 'sound': 'vwa-TÜR'},
      'Allemand': {'word': 'Auto', 'roman': '', 'sound': 'OW-toh'},
      'Japonais': {'word': '車', 'roman': 'Kuruma', 'sound': 'koo-ROO-ma'},
    },

    // ── Animaux ───────────────────────────────────────────────
    'cat': {
      'Arabe': {'word': 'قطة', 'roman': 'Qitta', 'sound': 'KIT-ta'},
      'Anglais': {'word': 'Cat', 'roman': '', 'sound': 'KAT'},
      'Espagnol': {'word': 'Gato', 'roman': '', 'sound': 'GA-to'},
      'Français': {'word': 'Chat', 'roman': '', 'sound': 'SHA'},
      'Allemand': {'word': 'Katze', 'roman': '', 'sound': 'KAT-seh'},
      'Japonais': {'word': '猫', 'roman': 'Neko', 'sound': 'NEH-koh'},
    },
    'dog': {
      'Arabe': {'word': 'كلب', 'roman': 'Kalb', 'sound': 'KALB'},
      'Anglais': {'word': 'Dog', 'roman': '', 'sound': 'DOG'},
      'Espagnol': {'word': 'Perro', 'roman': '', 'sound': 'PEH-rro'},
      'Français': {'word': 'Chien', 'roman': '', 'sound': 'shee-AN'},
      'Allemand': {'word': 'Hund', 'roman': '', 'sound': 'HOONT'},
      'Japonais': {'word': '犬', 'roman': 'Inu', 'sound': 'EE-noo'},
    },
    'bird': {
      'Arabe': {'word': 'طائر', 'roman': "Ta'ir", 'sound': 'TA-ir'},
      'Anglais': {'word': 'Bird', 'roman': '', 'sound': 'BURD'},
      'Espagnol': {'word': 'Pájaro', 'roman': '', 'sound': 'PA-ha-ro'},
      'Français': {'word': 'Oiseau', 'roman': '', 'sound': 'wa-ZOH'},
      'Allemand': {'word': 'Vogel', 'roman': '', 'sound': 'FOH-gel'},
      'Japonais': {'word': '鳥', 'roman': 'Tori', 'sound': 'TOH-ree'},
    },

    // ── Nourriture ────────────────────────────────────────────
    'apple': {
      'Arabe': {'word': 'تفاحة', 'roman': 'Tuffaha', 'sound': 'tuf-FA-ha'},
      'Anglais': {'word': 'Apple', 'roman': '', 'sound': 'AP-ul'},
      'Espagnol': {'word': 'Manzana', 'roman': '', 'sound': 'man-SA-na'},
      'Français': {'word': 'Pomme', 'roman': '', 'sound': 'POM'},
      'Allemand': {'word': 'Apfel', 'roman': '', 'sound': 'AP-fel'},
      'Japonais': {'word': 'りんご', 'roman': 'Ringo', 'sound': 'REEN-goh'},
    },
    'banana': {
      'Arabe': {'word': 'موزة', 'roman': 'Mawza', 'sound': 'MOW-za'},
      'Anglais': {'word': 'Banana', 'roman': '', 'sound': 'ba-NA-na'},
      'Espagnol': {'word': 'Plátano', 'roman': '', 'sound': 'PLA-ta-no'},
      'Français': {'word': 'Banane', 'roman': '', 'sound': 'ba-NAN'},
      'Allemand': {'word': 'Banane', 'roman': '', 'sound': 'ba-NA-neh'},
      'Japonais': {'word': 'バナナ', 'roman': 'Banana', 'sound': 'ba-NA-na'},
    },
    // ── Catégories génériques MLKit Base Model ───────────────
    // Le modèle de base d'Object Detection ne retourne QUE ces 5 catégories
    'home good': {
      'Arabe': {'word': 'أثاث/أغراض', 'roman': 'Athath', 'sound': 'A-thath'},
      'Anglais': {'word': 'Home Good', 'roman': '', 'sound': 'HOME-good'},
      'Espagnol': {'word': 'Objeto de casa', 'roman': '', 'sound': 'ob-HE-to'},
      'Français': {'word': 'Objet de maison', 'roman': '', 'sound': 'ob-JEH'},
      'Allemand': {'word': 'Haushaltswaren', 'roman': '', 'sound': 'HOWS-halts'},
      'Japonais': {'word': '家庭用品', 'roman': 'Katei yōhin', 'sound': 'KA-teh'},
    },
    'fashion good': {
      'Arabe': {'word': 'ملابس', 'roman': 'Malabis', 'sound': 'ma-LA-bis'},
      'Anglais': {'word': 'Fashion Good', 'roman': '', 'sound': 'FASH-un'},
      'Espagnol': {'word': 'Ropa/Accesorios', 'roman': '', 'sound': 'RO-pa'},
      'Français': {'word': 'Vêtement', 'roman': '', 'sound': 'vet-MAN'},
      'Allemand': {'word': 'Kleidung', 'roman': '', 'sound': 'KLY-doong'},
      'Japonais': {'word': 'ファッション', 'roman': 'Fasshon', 'sound': 'FASH-on'},
    },
    'glasses': {
      'Arabe': {'word': 'نظارات', 'roman': 'Natharat', 'sound': 'na-DHA-rat'},
      'Anglais': {'word': 'Glasses', 'roman': '', 'sound': 'GLASS-ez'},
      'Espagnol': {'word': 'Gafas', 'roman': '', 'sound': 'GA-fas'},
      'Français': {'word': 'Lunettes', 'roman': '', 'sound': 'loo-NET'},
      'Allemand': {'word': 'Brille', 'roman': '', 'sound': 'BRIL-leh'},
      'Japonais': {'word': '眼鏡', 'roman': 'Megane', 'sound': 'ME-ga-ne'},
    },
    'food': {
      'Arabe': {'word': 'طعام', 'roman': "Ta'am", 'sound': 'ta-AAM'},
      'Anglais': {'word': 'Food', 'roman': '', 'sound': 'FOOD'},
      'Espagnol': {'word': 'Comida', 'roman': '', 'sound': 'ko-MEE-da'},
      'Français': {'word': 'Nourriture', 'roman': '', 'sound': 'noo-ree-TYUR'},
      'Allemand': {'word': 'Essen', 'roman': '', 'sound': 'ES-en'},
      'Japonais': {'word': '食べ物', 'roman': 'Tabemono', 'sound': 'TA-be-mo-no'},
    },
    'place': {
      'Arabe': {'word': 'مكان', 'roman': 'Makan', 'sound': 'ma-KAN'},
      'Anglais': {'word': 'Place', 'roman': '', 'sound': 'PLACE'},
      'Espagnol': {'word': 'Lugar', 'roman': '', 'sound': 'loo-GAR'},
      'Français': {'word': 'Lieu', 'roman': '', 'sound': 'LYUH'},
      'Allemand': {'word': 'Ort', 'roman': '', 'sound': 'ORT'},
      'Japonais': {'word': '場所', 'roman': 'Basho', 'sound': 'BA-sho'},
    },
    'plant': {
      'Arabe': {'word': 'نبات', 'roman': 'Nabat', 'sound': 'na-BAT'},
      'Anglais': {'word': 'Plant', 'roman': '', 'sound': 'PLANT'},
      'Espagnol': {'word': 'Planta', 'roman': '', 'sound': 'PLAN-ta'},
      'Français': {'word': 'Plante', 'roman': '', 'sound': 'PLANT'},
      'Allemand': {'word': 'Pflanze', 'roman': '', 'sound': 'PFLAN-tse'},
      'Japonais': {'word': '植物', 'roman': 'Shokubutsu', 'sound': 'SHO-koo-boot-soo'},
    },
    'unknown': {
      'Arabe': {'word': 'شيء', 'roman': "Shay'", 'sound': 'shay'},
      'Anglais': {'word': 'Object', 'roman': '', 'sound': 'OB-ject'},
      'Espagnol': {'word': 'Objeto', 'roman': '', 'sound': 'ob-HE-to'},
      'Français': {'word': 'Objet', 'roman': '', 'sound': 'ob-JEH'},
      'Allemand': {'word': 'Objekt', 'roman': '', 'sound': 'OB-yekt'},
      'Japonais': {'word': '対象', 'roman': 'Taishō', 'sound': 'TAI-shoh'},
    },
  };

  // ── CORRESPONDANCE LABELS MLKIT → CLÉS DICTIONNAIRE ─────────
  static const Map<String, String> mlLabelNormalization = {
    // Labels de base MLKit
    'home good': 'home good',
    'fashion good': 'fashion good',
    'food': 'food',
    'place': 'place',
    'plant': 'plant',
    'unknown': 'unknown',
    'chair': 'chair',
    'seat': 'chair',
    'office chair': 'chair',
    'table': 'table',
    'desk': 'table',
    'coffee table': 'table',
    'glasses': 'glasses',
    'sunglasses': 'glasses',
    'spectacles': 'glasses',
    'eyeglasses': 'glasses',
    'door': 'door',
    'window': 'window',
    'book': 'book',
    'notebook': 'book',
    'pen': 'pen',
    'pencil': 'pen',
    'ballpoint pen': 'pen',
    'laptop': 'laptop',
    'computer': 'laptop',
    'notebook computer': 'laptop',
    'phone': 'phone',
    'mobile phone': 'phone',
    'smartphone': 'phone',
    'cup': 'cup',
    'mug': 'cup',
    'bottle': 'bottle',
    'water bottle': 'bottle',
    'tree': 'tree',
    'flower': 'flower',
    'car': 'car',
    'vehicle': 'car',
    'automobile': 'car',
    'cat': 'cat',
    'kitten': 'cat',
    'dog': 'dog',
    'puppy': 'dog',
    'bird': 'bird',
    'apple': 'apple',
    'banana': 'banana',
  };

  // ── LANGUES DISPONIBLES ──────────────────────────────────────
  static const List<String> availableLanguages = [
    'Arabe',
    'Anglais',
    'Français',
    'Espagnol',
    'Allemand',
    'Japonais',
  ];

  static const String defaultTargetLanguage = 'Arabe';

  // ── MESSAGES UI ───────────────────────────────────────────────
  static const Map<String, String> uiMessages = {
    'scanPrompt': 'Pointez vers un objet',
    'textScanPrompt': 'Pointez vers du texte',
    'scanning': 'Analyse en cours...',
    'translating': 'Traduction en cours...',
    'unknownObject': 'Objet non reconnu',
    'quotaExceeded': 'Quota API atteint (5/jour)',
    'cameraPermission': 'Autorisez la caméra pour scanner',
    'modeObject': 'Objets',
    'modeText': 'Texte',
  };
}
