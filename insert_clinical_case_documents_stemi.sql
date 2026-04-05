BEGIN;
SET search_path TO riskm_manager_model_evaluation, public;

/*
Load 2 clinical cases from episode JSON files and rebuild their documents from healthRecords.
Each clinical_case.body stores the entire episode JSON (including healthRecords).
Each document row stores one healthRecord JSON in body and date extracted from healthRecord.dateTime.
*/
WITH source_cases(identifier, body) AS (
    VALUES
        ('CARDIO-STEMI-VANILLA', $case_CARDIO_STEMI_VANILLA$
{
  "paziente": {
    "nome": "Mario",
    "cognome": "Rossi",
    "dataDiNascita": "1958-07-12",
    "sesso": "M",
    "codiceFiscale": "RSSMRA58L12H501X",
    "residenza": "Via Appia Nuova 145, 00183 Roma"
  },
  "ricovero": {
    "dataIngresso": "2026-03-18T08:02:00+01:00",
    "dataDimissione": "2026-03-22T11:30:00+01:00",
    "reparto": "UTIC / Cardiologia Degenza",
    "diagnosiPrincipale": "I21.0 - Infarto miocardico acuto con sopraslivellamento del tratto ST della parete anteriore, trattato con PCI primaria su IVA prossimale",
    "diagnosiSecondarie": [
      "E11.65 - Diabete mellito tipo 2 con iperglicemia",
      "I10 - Ipertensione arteriosa essenziale",
      "E78.5 - Dislipidemia"
    ],
    "esito": "dimissione_ordinaria"
  },
  "healthRecords": [
    {
      "id": 1,
      "dateTime": "2026-03-18T07:44:00+01:00",
      "type": "Referto ECG",
      "humanResource": "Dr.ssa Elisa Gori",
      "role": "Medico 118",
      "narrative": "ECG pre-ospedaliero a 12 derivazioni: ritmo sinusale a 96 bpm; sopraslivellamento del tratto ST di circa 3 mm in V2-V4 e di 2 mm in V5-V6, I e aVL; sottoslivellamento reciproco in II, III e aVF. Assenza di blocchi di branca o di disturbi maggiori della conduzione. Quadro elettrocardiografico compatibile con STEMI acuto antero-laterale; referto trasmesso alla rete IMA e condiviso con emodinamista reperibile.",
      "observations": [
        "Ritmo sinusale 96 bpm",
        "ST elevato 3 mm V2-V4",
        "ST elevato 2 mm V5-V6",
        "ST elevato 2 mm I-aVL",
        "ST depresso 1.5 mm II-III-aVF",
        "QTc 438 ms"
      ]
    },
    {
      "id": 2,
      "dateTime": "2026-03-18T07:46:00+01:00",
      "type": "Verbale Intervento 118",
      "humanResource": "Dr.ssa Elisa Gori",
      "role": "Medico 118",
      "narrative": "Intervento 118 per dolore toracico insorto alle ore 07:10 a riposo, oppressivo, irradiato a spalla e braccio sinistro, associato a sudorazione fredda e nausea. Paziente vigile, collaborante, GCS 15, cute marezzata assente. Eseguito ECG a 12 derivazioni sul posto con quadro compatibile con STEMI antero-laterale; attivata immediatamente rete IMA con preallerta del centro HUB di emodinamica alle ore 07:47. Somministrati secondo protocollo ASA 300 mg p.o., ticagrelor 180 mg p.o., eparina sodica 5.000 UI e.v.; praticato accesso venoso periferico e morfina 2 mg e.v. per persistenza di dolore. Non indicata ossigenoterapia in assenza di ipossiemia. Trasporto protetto in codice rosso direttamente verso Pronto Soccorso con contestuale allertamento sala di emodinamica.",
      "observations": [
        "Dolore toracico NRS 9/10",
        "PA 158/92 mmHg",
        "FC 96 bpm",
        "SpO2 96 % in aria ambiente",
        "FR 22 atti/min",
        "Glicemia capillare 248 mg/dL",
        "Temperatura 36.2 °C"
      ]
    },
    {
      "id": 3,
      "dateTime": "2026-03-18T08:02:00+01:00",
      "type": "Scheda Triage Pronto Soccorso",
      "humanResource": "Paola Conti",
      "role": "Infermiere Triage",
      "narrative": "Accesso in Pronto Soccorso da 118 con preallerta rete STEMI. Assegnato codice rosso per dolore toracico in atto e ECG diagnostico per STEMI; paziente instradato immediatamente in area emergenza e percorso diretto verso emodinamica, con attivazione contestuale cardiologo ed equipe dedicata. Confermata terapia pre-ospedaliera già eseguita e monitoraggio continuo all'arrivo.",
      "observations": [
        "Codice di priorità Rosso",
        "PA 150/88 mmHg",
        "FC 92 bpm",
        "SpO2 97 % in aria ambiente",
        "FR 20 atti/min",
        "Dolore toracico NRS 6/10",
        "Temperatura 36.3 °C"
      ]
    },
    {
      "id": 4,
      "dateTime": "2026-03-18T08:07:00+01:00",
      "type": "Valutazione Medica Pronto Soccorso",
      "humanResource": "Dr. Andrea Bellini",
      "role": "Medico Pronto Soccorso",
      "narrative": "Paziente maschio di 67 anni condotto dal 118 per STEMI antero-laterale diagnosticato sul territorio. All'arrivo ancora algico ma emodinamicamente stabile, Killip I, senza segni di scompenso acuto né shock. Presa visione dell'ECG pre-ospedaliero e della terapia già praticata; confermata indicazione a coronarografia urgente con PCI primaria. Non indicazione a fibrinolisi per disponibilità immediata di emodinamica. Informata la sala di emodinamica, eseguiti prelievi urgenti, consenso e trasferimento immediato.",
      "observations": [
        "Killip class I",
        "PA 148/86 mmHg",
        "FC 90 bpm",
        "SpO2 97 %",
        "Tempo door-in 08:02",
        "Tempo trasferimento in emodinamica 08:20"
      ]
    },
    {
      "id": 5,
      "dateTime": "2026-03-18T08:10:00+01:00",
      "type": "Anamnesi",
      "humanResource": "Dr. Andrea Bellini",
      "role": "Medico Pronto Soccorso",
      "narrative": "Anamnesi patologica remota: diabete mellito tipo 2 noto da circa 12 anni in trattamento domiciliare con metformina 1.000 mg x 2/die e gliclazide RM 60 mg al mattino; ultimo valore noto di HbA1c riferito dal paziente 8.1 % circa due mesi prima. Ipertensione arteriosa in terapia con ramipril 5 mg/die. Dislipidemia in trattamento irregolare con atorvastatina 20 mg/die. Ex fumatore, pregresso tabagismo circa 20 pack/years, sospeso nel 2016. Nessuna pregressa rivascolarizzazione coronarica, nessun ictus/TIA, nessuna storia di sanguinamenti maggiori. Anamnesi familiare positiva per cardiopatia ischemica: padre con IMA a 62 anni. Nessuna allergia farmacologica nota. Anamnesi fisiologica: vive con la moglie, autonomo nelle ADL, BMI in sovrappeso. Anamnesi patologica prossima: dolore toracico oppressivo insorto a riposo alle 07:10, persistente per oltre 30 minuti, con irradiazione al braccio sinistro, nausea e sudorazione.",
      "observations": [
        "Diabete mellito tipo 2 da 12 anni",
        "HbA1c ultimo noto 8.1 %",
        "Terapia domiciliare metformina 1000 mg BID",
        "Terapia domiciliare gliclazide RM 60 mg/die",
        "Ramipril 5 mg/die",
        "Atorvastatina 20 mg/die irregolare",
        "Ex fumatore 20 pack-years",
        "BMI 28.4 kg/m²"
      ]
    },
    {
      "id": 6,
      "dateTime": "2026-03-18T08:12:00+01:00",
      "type": "Esame Obiettivo",
      "humanResource": "Dr. Andrea Bellini",
      "role": "Medico Pronto Soccorso",
      "narrative": "Paziente vigile, orientato, collaborante. Cute lievemente sudata, normoperfusa. Torace eupnoico, murmure vescicolare presente bilateralmente senza rantoli. Toni cardiaci validi, ritmici, pause libere; non soffi di nuova insorgenza apprezzabili. Addome trattabile, indolente. Estremità calde, polsi periferici validi e simmetrici, assenza di edemi declivi. Quadro generale compatibile con STEMI in classe Killip I.",
      "observations": [
        "PA 146/84 mmHg",
        "FC 88 bpm",
        "SpO2 97 %",
        "FR 18 atti/min",
        "Temperatura 36.4 °C",
        "GCS 15",
        "Segni di scompenso assenti"
      ]
    },
    {
      "id": 7,
      "dateTime": "2026-03-18T08:15:00+01:00",
      "type": "Referto Laboratorio",
      "humanResource": "Dr.ssa Giulia Orsini",
      "role": "Medico Laboratorio",
      "narrative": "Esami urgenti all'ingresso processati in urgenza. Quadro ematochimico senza controindicazioni alla procedura invasiva. Biomarcatori di necrosi miocardica inizialmente già positivi in fase precoce; glicemia elevata in noto diabetico. Funzione renale conservata.",
      "observations": [
        "Emoglobina 14.8 g/dL",
        "Leucociti 10.9 x10^9/L",
        "Piastrine 234 x10^9/L",
        "INR 1.02",
        "aPTT 29 s",
        "Creatinina 1.06 mg/dL",
        "eGFR 77 mL/min/1.73m²",
        "Sodio 138 mmol/L",
        "Potassio 4.3 mmol/L",
        "Glucosio 244 mg/dL",
        "hs-cTnI 68 ng/L",
        "CK-MB 6.2 ng/mL"
      ]
    },
    {
      "id": 8,
      "dateTime": "2026-03-18T08:18:00+01:00",
      "type": "Consenso Informato",
      "humanResource": "Dr. Matteo Ferretti",
      "role": "Cardiologo Emodinamista",
      "narrative": "Il paziente, vigile e pienamente capace di intendere e di volere, viene informato circa indicazione urgente a coronarografia con possibilità di PCI ad hoc per STEMI acuto. Illustrati finalità, benefici attesi, alternative terapeutiche, rischi principali della procedura e dell'uso di mezzo di contrasto (sanguinamento, complicanze vascolari, dissezione/perforazione, aritmie, necessità di rivascolarizzazione chirurgica urgente, nefropatia da contrasto, ictus, morte). Spiegata scelta preferenziale di accesso radiale destro e necessità di doppia antiaggregazione protratta dopo eventuale impianto di stent. Il paziente dichiara di aver compreso, pone domande pertinenti, riceve risposta esaustiva e sottoscrive il consenso.",
      "observations": [
        "Consenso alla coronarografia acquisito",
        "Consenso alla PCI acquisito",
        "Accesso previsto radiale destro",
        "Stato di coscienza vigile e orientato"
      ]
    },
    {
      "id": 9,
      "dateTime": "2026-03-18T08:58:00+01:00",
      "type": "Referto Emodinamica",
      "humanResource": "Dr. Matteo Ferretti",
      "role": "Cardiologo Emodinamista",
      "narrative": "Coronarografia urgente eseguita in regime di emergenza per STEMI antero-laterale. Accesso radiale destro 6F previo test di Allen indiretto favorevole. Tronco comune indenne; IVA con occlusione trombotica acuta del tratto prossimale (TIMI 0) quale lesione colpevole; circonflessa con placche non significative; coronaria destra con stenosi non critica del 40 % nel tratto medio. Eseguita PCI primaria su IVA: attraversamento della lesione con guida coronarica, predilatazione con pallone 2.5 x 15 mm, impianto di DES 3.5 x 28 mm nel tratto prossimale-medio e successiva post-dilatazione con pallone non compliante 3.75 x 15 mm. Buon risultato angiografico finale con stenosi residua 0 %, flusso TIMI 3 e blush miocardico 3. Somministrata ulteriore eparina e.v. intra-procedurale fino ad ACT terapeutico. Nessuna complicanza immediata, emostasi con dispositivo compressivo radiale. Tempo door-to-balloon 53 minuti.",
      "observations": [
        "Accesso radiale destro 6F",
        "Lesione culprit IVA prossimale 100 %",
        "TIMI pre-PCI 0",
        "Stent DES 3.5 x 28 mm",
        "Post-dilatazione NC 3.75 x 15 mm",
        "Stenosi residua 0 %",
        "TIMI post-PCI 3",
        "Myocardial blush 3",
        "ACT 286 s",
        "Door-to-balloon 53 min"
      ]
    },
    {
      "id": 10,
      "dateTime": "2026-03-18T10:15:00+01:00",
      "type": "Referto ECG",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "ECG post-PCI: ritmo sinusale a 78 bpm. Persistenza di modesto sopraslivellamento residuo del tratto ST in sede anteriore con riduzione > 50 % rispetto al tracciato pre-riperfusione; iniziale comparsa di onde Q in V2-V3. Non aritmie, non nuovi disturbi di conduzione atrio-ventricolare o intraventricolare. Quadro compatibile con riperfusione efficace dopo PCI primaria.",
      "observations": [
        "Ritmo sinusale 78 bpm",
        "Riduzione ST >50 %",
        "Onde Q iniziali V2-V3",
        "QTc 432 ms",
        "Nessun BAV",
        "Nessuna aritmia ventricolare"
      ]
    },
    {
      "id": 11,
      "dateTime": "2026-03-18T10:30:00+01:00",
      "type": "Diario Clinico UTIC",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "Ingresso in UTIC post-PCI primaria su IVA prossimale. Paziente vigile, eupnoico, asintomatico per dolore toracico, emodinamicamente stabile, Killip I. Accesso radiale destro in ordine con bendaggio compressivo, assenza di sanguinamento. Impostata terapia con ASA 100 mg/die, ticagrelor 90 mg x 2, atorvastatina 80 mg serale; pianificato avvio di beta-bloccante a basse dosi dopo ulteriore osservazione. Metformina sospesa per 48 ore in relazione a mezzo di contrasto; attivato monitoraggio glicemico preprandiale e notturno con schema insulinico correttivo.",
      "observations": [
        "PA 132/78 mmHg",
        "FC 76 bpm",
        "SpO2 98 %",
        "Dolore toracico 0/10",
        "Diuresi conservata",
        "Glicemia capillare 212 mg/dL"
      ]
    },
    {
      "id": 12,
      "dateTime": "2026-03-18T10:45:00+01:00",
      "type": "Diario Infermieristico UTIC",
      "humanResource": "Sara Vitale",
      "role": "Infermiere UTIC",
      "narrative": "Paziente accolto in UTIC da emodinamica, collegato a monitor multiparametrico e telemetria continua. Posizionato a letto con riposo assoluto iniziale; controllata sede di accesso radiale destro con dispositivo compressivo, asciutta e senza ematoma. Educato a segnalare immediatamente dolore toracico, dispnea o sanguinamento. Eseguito stick glicemico e somministrata terapia prescritta.",
      "observations": [
        "PA 130/78 mmHg",
        "FC 76 bpm",
        "SpO2 98 %",
        "Glicemia capillare 212 mg/dL",
        "Sede radiale integra"
      ]
    },
    {
      "id": 13,
      "dateTime": "2026-03-18T14:30:00+01:00",
      "type": "Referto Laboratorio",
      "humanResource": "Dr.ssa Giulia Orsini",
      "role": "Medico Laboratorio",
      "narrative": "Secondo controllo seriato dei biomarcatori cardiaci post-riperfusione. Incremento enzimatico coerente con evoluzione di infarto miocardico acuto in fase subacuta. Assetto coagulativo nei limiti; nessuna alterazione metabolica severa oltre a iperglicemia in progressivo controllo.",
      "observations": [
        "hs-cTnI 5460 ng/L",
        "CK-MB 92 ng/mL",
        "AST 78 U/L",
        "ALT 34 U/L",
        "Glucosio 218 mg/dL",
        "Potassio 4.1 mmol/L",
        "Magnesio 1.9 mg/dL"
      ]
    },
    {
      "id": 14,
      "dateTime": "2026-03-18T15:30:00+01:00",
      "type": "Diario Clinico UTIC",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "Decorso regolare nelle prime ore post-rivascolarizzazione. Paziente apiretico, senza recidiva algica né dispnea; telemetria con ritmo sinusale stabile, sporadiche extrasistoli ventricolari isolate non ripetitive. Biomarcatori di necrosi in salita come atteso. Avviato bisoprololo 1.25 mg/die in assenza di segni di basso output; prosegue DAPT e statina ad alta intensità. Gestione glicemica con rapida correzione insulinica sottocutanea secondo schema.",
      "observations": [
        "PA 128/76 mmHg",
        "FC 72 bpm",
        "SpO2 98 %",
        "Temperatura 36.5 °C",
        "Glicemia capillare 226 mg/dL",
        "Extrasistolia ventricolare isolata assente clinicamente significativa"
      ]
    },
    {
      "id": 15,
      "dateTime": "2026-03-18T18:00:00+01:00",
      "type": "Diario Infermieristico UTIC",
      "humanResource": "Marco Fabbri",
      "role": "Infermiere UTIC",
      "narrative": "Monitoraggio pomeridiano regolare. Paziente collaborante, in assenza di dolore, alimentazione leggera tollerata. Rimosso progressivamente presidio compressivo radiale secondo protocollo, senza sanguinamento né tumefazione; polso radiale presente e valido. Somministrata terapia orale serale e insulina rapida correttiva come da schema.",
      "observations": [
        "PA 128/74 mmHg",
        "FC 72 bpm",
        "SpO2 98 %",
        "Glicemia capillare 198 mg/dL",
        "Diuresi 700 mL",
        "NRS dolore 0/10"
      ]
    },
    {
      "id": 16,
      "dateTime": "2026-03-18T21:00:00+01:00",
      "type": "Diario Clinico UTIC",
      "humanResource": "Dr. Paolo Riva",
      "role": "Cardiologo",
      "narrative": "Controllo serale: paziente tranquillo, riferisce netta regressione della sintomatologia, riposo notturno impostato. Monitoraggio continuo senza episodi ischemici, senza aritmie complesse, pressione adeguata. Sede radiale asciutta, polso radiale valido. Prosegue monitoraggio seriato di ECG, enzimi e glicemie. Confermata sospensione di gliclazide e metformina nella fase acuta.",
      "observations": [
        "PA 126/74 mmHg",
        "FC 70 bpm",
        "SpO2 97 %",
        "Dolore toracico 0/10",
        "Glicemia capillare 184 mg/dL"
      ]
    },
    {
      "id": 17,
      "dateTime": "2026-03-18T23:00:00+01:00",
      "type": "Diario Infermieristico UTIC",
      "humanResource": "Sara Vitale",
      "role": "Infermiere UTIC",
      "narrative": "Turno notturno iniziale: paziente a riposo, tranquillo, vigile, non algico. Telemetria continua in ritmo sinusale. Controllata sede radiale: medicazione pulita, asciutta, non segni di sanguinamento. Eseguito stick glicemico serale e terapia secondo prescrizione. Informato il paziente sulla necessità di non flettere eccessivamente il polso destro nelle prime ore.",
      "observations": [
        "PA 126/72 mmHg",
        "FC 69 bpm",
        "SpO2 97 %",
        "Glicemia capillare 184 mg/dL",
        "Temperatura 36.5 °C"
      ]
    },
    {
      "id": 18,
      "dateTime": "2026-03-19T06:00:00+01:00",
      "type": "Referto Laboratorio",
      "humanResource": "Dr.ssa Giulia Orsini",
      "role": "Medico Laboratorio",
      "narrative": "Controllo ematochimico del primo giorno post-PCI. Picco dei biomarcatori di necrosi miocardica in attesa evolutiva; funzione renale e ionogramma stabili. Eseguiti assetto lipidico e HbA1c per inquadramento del rischio cardiovascolare e della comorbidità diabetica.",
      "observations": [
        "Emoglobina 14.2 g/dL",
        "Leucociti 9.8 x10^9/L",
        "Creatinina 1.01 mg/dL",
        "eGFR 79 mL/min/1.73m²",
        "Sodio 139 mmol/L",
        "Potassio 4.2 mmol/L",
        "Magnesio 2.0 mg/dL",
        "Glucosio 176 mg/dL",
        "hs-cTnI 18940 ng/L",
        "CK-MB 156 ng/mL",
        "HbA1c 8.0 %",
        "Colesterolo totale 214 mg/dL",
        "LDL-colesterolo 136 mg/dL",
        "HDL-colesterolo 38 mg/dL",
        "Trigliceridi 182 mg/dL"
      ]
    },
    {
      "id": 19,
      "dateTime": "2026-03-19T07:00:00+01:00",
      "type": "Diario Infermieristico UTIC",
      "humanResource": "Marco Fabbri",
      "role": "Infermiere UTIC",
      "narrative": "Notte trascorsa senza eventi. Paziente riferisce sonno discreto, nessun episodio di dolore toracico o dispnea. Igiene al letto eseguita, alzata assistita in poltrona ben tollerata. Prosegue monitoraggio telemetrico continuo e rilevazione parametri; glicemia pre-colazione comunicata al medico di guardia per adeguamento insulinico.",
      "observations": [
        "PA 124/72 mmHg",
        "FC 68 bpm",
        "SpO2 98 %",
        "Glicemia capillare 172 mg/dL",
        "Diuresi notturna 850 mL"
      ]
    },
    {
      "id": 20,
      "dateTime": "2026-03-19T08:00:00+01:00",
      "type": "Diario Clinico UTIC",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "Notte tranquilla, assenza di dolore toracico o dispnea, nessuna aritmia significativa in telemetria. Paziente emodinamicamente stabile, mobilizzazione passiva/attiva in letto ben tollerata. Alla luce della stabilità pressoria avviato ramipril 2.5 mg x 2/die. Richiesto ecocardiogramma di controllo per valutazione funzione ventricolare e complicanze meccaniche post-IMA. Continuano stick glicemici pluriquotidiani e terapia insulinica correttiva; TEV-profilassi con enoxaparina 4.000 UI s.c./die fino a piena mobilizzazione.",
      "observations": [
        "PA 124/72 mmHg",
        "FC 68 bpm",
        "SpO2 98 %",
        "Temperatura 36.4 °C",
        "Glicemia capillare 172 mg/dL"
      ]
    },
    {
      "id": 21,
      "dateTime": "2026-03-19T11:30:00+01:00",
      "type": "Referto Ecocardiogramma",
      "humanResource": "Dr.ssa Simona Greco",
      "role": "Cardiologo Ecocardiografista",
      "narrative": "Ecocardiogramma transtoracico: ventricolo sinistro di dimensioni nei limiti superiori della norma, cinesi segmentaria alterata con acinesia dei segmenti antero-settali medio-apicali e apice, ipocinesia della parete anteriore. Funzione sistolica globale moderatamente ridotta con FEVS biplana stimata 40 %. Non evidenza di trombi endoventricolari. Ventricolo destro di dimensioni e funzione conservate. Insufficienza mitralica lieve, non stenosi valvolari significative. Setti e pareti integri, assenza di versamento pericardico, VCI normocollassabile. Nessun segno ecocardiografico di complicanze meccaniche post-infartuali.",
      "observations": [
        "FEVS 40 %",
        "TAPSE 22 mm",
        "Insufficienza mitralica lieve",
        "PAPs stimata 28 mmHg",
        "Versamento pericardico assente",
        "Trombi endocavitari assenti"
      ]
    },
    {
      "id": 22,
      "dateTime": "2026-03-19T14:30:00+01:00",
      "type": "Diario Clinico UTIC",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "Ecocardiogramma eseguito in mattinata: FE ventricolare sinistra moderatamente ridotta (40 %) con acinesia antero-setto-apicale, assenza di trombi endocavitari e di versamento pericardico. In paziente diabetico e con FE 40 %, dopo verifica di funzione renale e potassiemia nella norma, avviato eplerenone 25 mg/die. Prosegue decorso regolare senza segni di scompenso; richiesta consulenza diabetologica per ottimizzazione della terapia ipoglicemizzante alla dimissione.",
      "observations": [
        "PA 122/70 mmHg",
        "FC 67 bpm",
        "SpO2 98 %",
        "FEVS 40 %",
        "Potassio 4.2 mmol/L",
        "Creatinina 1.01 mg/dL",
        "Glicemia capillare 168 mg/dL"
      ]
    },
    {
      "id": 23,
      "dateTime": "2026-03-19T15:00:00+01:00",
      "type": "Diario Infermieristico UTIC",
      "humanResource": "Sara Vitale",
      "role": "Infermiere UTIC",
      "narrative": "Paziente seduto in poltrona e successivamente deambulazione in camera con minima assistenza, ben tollerata. Nessuna sintomatologia riferita. Sede radiale integra, polso periferico presente, assenza di ematoma. Somministrata terapia pomeridiana comprensiva di nuova prescrizione con eplerenone. Eseguiti stick glicemici e registrati in cartella.",
      "observations": [
        "PA 122/70 mmHg",
        "FC 66 bpm",
        "SpO2 98 %",
        "Glicemia capillare 168 mg/dL",
        "Deambulazione assistita 20 metri"
      ]
    },
    {
      "id": 24,
      "dateTime": "2026-03-19T16:30:00+01:00",
      "type": "Consulenza Diabetologica",
      "humanResource": "Dr.ssa Francesca Leone",
      "role": "Diabetologo",
      "narrative": "Valutazione diabetologica richiesta per diabete mellito tipo 2 noto, scompensato all'ingresso in corso di evento coronarico acuto. Paziente riferisce aderenza variabile alla dieta e alla terapia domiciliare con metformina e gliclazide. HbA1c attuale 8.0 %, compatibile con controllo non ottimale. In fase acuta appropriata sospensione di metformina per 48 ore dopo contrasto iodato e sospensione di sulfanilurea. Durante ricovero indicato schema basal-bolus semplificato con insulina glargine 14 UI ore 22 e correzioni con insulina rapida ai pasti. Alla dimissione, in presenza di funzione renale stabile, raccomandata ripresa di metformina 1000 mg due volte/die dopo 48 ore complete dall'esposizione al contrasto; non riprendere gliclazide. Educato il paziente all'automonitoraggio glicemico quattro volte/die per la prima settimana, dieta ipoglucidica e follow-up diabetologico entro 30 giorni.",
      "observations": [
        "HbA1c 8.0 %",
        "Schema glargine 14 UI h22",
        "Target glicemico preprandiale 100-180 mg/dL",
        "Ripresa metformina dopo 48 h se creatinina stabile",
        "Sospensione gliclazide"
      ]
    },
    {
      "id": 25,
      "dateTime": "2026-03-19T20:30:00+01:00",
      "type": "Diario Clinico UTIC",
      "humanResource": "Dr. Paolo Riva",
      "role": "Cardiologo",
      "narrative": "Valutazione serale: paziente in buone condizioni generali, vigile, collaborante, autonomo ai passaggi posturali, senza angor né equivalenti ischemici. Telemetria negativa per aritmie significative; non segni di congestione. Terapia ben tollerata, nessuna ipotensione sintomatica dopo introduzione di ACE-inibitore ed eplerenone. Educazione iniziale su necessità di aderenza a doppia antiaggregazione, statina ad alta intensità e controllo dei fattori di rischio.",
      "observations": [
        "PA 120/70 mmHg",
        "FC 66 bpm",
        "SpO2 97 %",
        "Temperatura 36.6 °C",
        "Glicemia capillare 149 mg/dL"
      ]
    },
    {
      "id": 26,
      "dateTime": "2026-03-19T23:00:00+01:00",
      "type": "Diario Infermieristico UTIC",
      "humanResource": "Marco Fabbri",
      "role": "Infermiere UTIC",
      "narrative": "Fine turno serale/notturno: paziente in condizioni stabili, orientato, non dolore, non nausea. Monitoraggio cardiaco senza alterazioni rilevanti. Terapia serale assunta regolarmente. Educazione rinforzata su chiamata infermieristica in caso di dolore toracico, palpitazioni o lipotimia.",
      "observations": [
        "PA 120/68 mmHg",
        "FC 65 bpm",
        "SpO2 97 %",
        "Glicemia capillare 154 mg/dL",
        "NRS dolore 0/10"
      ]
    },
    {
      "id": 27,
      "dateTime": "2026-03-20T06:15:00+01:00",
      "type": "Referto Laboratorio",
      "humanResource": "Dr.ssa Giulia Orsini",
      "role": "Medico Laboratorio",
      "narrative": "Controllo seriato in seconda giornata post-infarto: trend decrescente dei biomarcatori, emocromo stabile, funzione renale conservata dopo esposizione a mezzo di contrasto. Dati compatibili con prosecuzione terapia cardioattiva e con rivalutazione della ripresa della metformina al compimento delle 48 ore.",
      "observations": [
        "Emoglobina 13.9 g/dL",
        "Leucociti 9.1 x10^9/L",
        "Piastrine 226 x10^9/L",
        "Creatinina 0.98 mg/dL",
        "eGFR 82 mL/min/1.73m²",
        "Potassio 4.4 mmol/L",
        "Glucosio 149 mg/dL",
        "hs-cTnI 12360 ng/L",
        "CK-MB 84 ng/mL"
      ]
    },
    {
      "id": 28,
      "dateTime": "2026-03-20T06:45:00+01:00",
      "type": "Diario Clinico UTIC",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "Controllo mattutino: notte tranquilla, nessun evento aritmico o ischemico. Paziente mobilizzato al bordo letto e in poltrona senza sintomi; non dolore, non dispnea, non segni di sanguinamento. Esami ematici in miglioramento, funzione renale stabile dopo mezzo di contrasto. Se confermata stabilità clinica nelle ore successive, programmato trasferimento in degenza cardiologica ordinaria.",
      "observations": [
        "PA 118/68 mmHg",
        "FC 64 bpm",
        "SpO2 98 %",
        "Glicemia capillare 146 mg/dL",
        "Diuresi 1650 mL/24h"
      ]
    },
    {
      "id": 29,
      "dateTime": "2026-03-20T07:15:00+01:00",
      "type": "Diario Infermieristico UTIC",
      "humanResource": "Sara Vitale",
      "role": "Infermiere UTIC",
      "narrative": "Paziente collaborante, autonomo nelle cure di base con supervisione, alzato dal letto e mobilizzato senza sintomi. Parametri stabili. Preparata documentazione e terapia per trasferimento in degenza cardiologica; consegne infermieristiche effettuate. Stick glicemico in miglioramento. Nessuna criticità assistenziale in atto.",
      "observations": [
        "PA 118/70 mmHg",
        "FC 64 bpm",
        "SpO2 98 %",
        "Glicemia capillare 146 mg/dL",
        "Temperatura 36.4 °C"
      ]
    },
    {
      "id": 30,
      "dateTime": "2026-03-20T08:15:00+01:00",
      "type": "Diario Clinico UTIC",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "Paziente stabile dal punto di vista emodinamico ed elettrico, mobilizzazione ben tollerata, autonomia nei trasferimenti assistiti. Nessuna recidiva anginosa, sede radiale in ordine, esami ematici compatibili con prosecuzione percorso in area ordinaria. Si dispone trasferimento in degenza cardiologica con prosecuzione di DAPT, bisoprololo, ramipril, eplerenone, statina e monitoraggio glicemico. Rivalutazione della ripresa di metformina dopo completamento delle 48 ore post-contrasto e conferma di creatinina stabile.",
      "observations": [
        "PA 118/70 mmHg",
        "FC 65 bpm",
        "SpO2 98 %",
        "Dolore toracico 0/10",
        "Glicemia capillare 144 mg/dL"
      ]
    },
    {
      "id": 31,
      "dateTime": "2026-03-20T12:00:00+01:00",
      "type": "Diario Clinico Degenza",
      "humanResource": "Dr. Paolo Riva",
      "role": "Cardiologo",
      "narrative": "Trasferito oggi da UTIC a degenza cardiologica ordinaria. Paziente in buone condizioni generali, vigile, orientato, eupnoico, asintomatico per dolore toracico. Deambulazione in corridoio assistita ben tollerata, nessuna aritmia riferita, alvo e diuresi regolari. Prosegue terapia ottimizzata post-STEMI con DAPT, beta-bloccante, ACE-inibitore, eplerenone e statina ad alta intensità. Alla luce della creatinina stabile e del compimento delle 48 ore post-contrasto, programmata ripresa della metformina in serata secondo indicazione diabetologica.",
      "observations": [
        "PA 118/70 mmHg",
        "FC 66 bpm",
        "SpO2 98 %",
        "Peso 84 kg",
        "Glicemia pre-pranzo 140 mg/dL"
      ]
    },
    {
      "id": 32,
      "dateTime": "2026-03-20T16:00:00+01:00",
      "type": "Valutazione Fisioterapica",
      "humanResource": "Alessia Marchetti",
      "role": "Fisioterapista",
      "narrative": "Valutazione fisioterapica in seconda giornata post-PCI. Paziente collaborante, stabile, senza dispnea né angor durante mobilizzazione progressiva. Eseguiti esercizi di respirazione diaframmatica, mobilizzazione attiva degli arti e deambulazione controllata in corridoio con incremento graduale del carico. Tolleranza buona, nessuna desaturazione o sintomatologia. Fornite indicazioni su progressione dell'attività fisica, risparmio energetico nelle prime settimane e opportunità di programma di riabilitazione cardiologica strutturata.",
      "observations": [
        "Cammino assistito 120 metri",
        "FC pre-esercizio 68 bpm",
        "FC post-esercizio 82 bpm",
        "SpO2 pre 98 %",
        "SpO2 post 97 %",
        "Scala Borg 11/20"
      ]
    },
    {
      "id": 33,
      "dateTime": "2026-03-21T06:20:00+01:00",
      "type": "Referto Laboratorio",
      "humanResource": "Dr.ssa Giulia Orsini",
      "role": "Medico Laboratorio",
      "narrative": "Esami di controllo in degenza ordinaria: ulteriore stabilizzazione del quadro laboratoristico, funzione renale invariata, potassiemia nella norma in terapia con ACE-inibitore ed eplerenone. Parametri compatibili con prosecuzione della terapia prescritta e con ripresa della metformina.",
      "observations": [
        "Emoglobina 14.1 g/dL",
        "Leucociti 8.4 x10^9/L",
        "Creatinina 0.96 mg/dL",
        "eGFR 84 mL/min/1.73m²",
        "Potassio 4.5 mmol/L",
        "Sodio 139 mmol/L",
        "Glucosio 132 mg/dL"
      ]
    },
    {
      "id": 34,
      "dateTime": "2026-03-21T09:00:00+01:00",
      "type": "Diario Clinico Degenza",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "Decorso in reparto ordinario regolare. Paziente autonomo nella deambulazione in reparto, senza dolore toracico, dispnea o lipotimie. Ripresa metformina dalla serata precedente, ben tollerata; glicemie capillari in progressivo miglioramento. Sede radiale cicatrizzata, senza ematoma né parestesie. Eseguita educazione terapeutica su fattori di rischio, aderenza a DAPT, dieta mediterranea, controllo pressorio e glicemico. Pianificata dimissione per domani in assenza di eventi.",
      "observations": [
        "PA 116/68 mmHg",
        "FC 64 bpm",
        "SpO2 98 %",
        "Glicemia capillare 132 mg/dL",
        "Temperatura 36.4 °C"
      ]
    },
    {
      "id": 35,
      "dateTime": "2026-03-22T08:00:00+01:00",
      "type": "Diario Clinico Degenza",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "Controllo pre-dimissione: paziente in condizioni cliniche stabili, apiretico, eupnoico in aria ambiente, emodinamicamente compensato. Nessuna recidiva anginosa, nessun segno di scompenso o complicanze del sito di accesso. Terapia ben tollerata, funzione renale e potassiemia stabili. Ribadite indicazioni a riabilitazione cardiologica, follow-up cardiologico precoce ed esecuzione di esami ematochimici di controllo entro 5-7 giorni.",
      "observations": [
        "PA 118/70 mmHg",
        "FC 62 bpm",
        "SpO2 98 %",
        "Dolore toracico 0/10",
        "Glicemia capillare 128 mg/dL"
      ]
    },
    {
      "id": 36,
      "dateTime": "2026-03-22T11:00:00+01:00",
      "type": "Lettera di Dimissione Ospedaliera",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "Si dimette il sig. Mario Rossi, 67 anni, ricoverato dal 18/03/2026 al 22/03/2026 per infarto miocardico acuto con sopraslivellamento del tratto ST della parete anteriore. Accesso in rete STEMI tramite 118 con ECG diagnostico pre-ospedaliero, pretrattamento con ASA, ticagrelor ed eparina e trasferimento diretto al centro HUB. In data 18/03/2026 eseguita coronarografia urgente con riscontro di occlusione trombotica acuta dell'IVA prossimale, trattata con PCI primaria e impianto di DES con risultato finale ottimale (TIMI 3). Decorso successivo regolare in UTIC e poi in degenza ordinaria, senza recidive ischemiche né aritmie significative. Ecocardiogramma del 19/03/2026: FEVS 40 %, acinesia antero-setto-apicale, assenza di complicanze meccaniche. Comorbidità rilevante: diabete mellito tipo 2 non ottimamente controllato (HbA1c 8.0 %), rivalutato da diabetologo; metformina sospesa per 48 ore post-contrasto e poi ripresa, gliclazide definitivamente sospesa. Diagnosi alla dimissione: STEMI anteriore rivascolarizzato con PCI primaria su IVA prossimale, disfunzione sistolica ventricolare sinistra moderata, diabete mellito tipo 2, ipertensione arteriosa, dislipidemia. Terapia domiciliare: ASA 100 mg 1 cp/die indefinitamente; ticagrelor 90 mg 1 cp ogni 12 ore per 12 mesi salvo diversa indicazione; atorvastatina 80 mg 1 cp la sera; bisoprololo 1.25 mg 1 cp/die; ramipril 2.5 mg 1 cp ogni 12 ore; eplerenone 25 mg 1 cp/die; pantoprazolo 20 mg/die; metformina 1000 mg 1 cp ogni 12 ore; insulina glargine 14 UI ore 22. Raccomandato automonitoraggio glicemico, dieta ipolipidica e ipoglucidica, astensione dal fumo, graduale ripresa dell'attività fisica. Indicata riabilitazione cardiologica ambulatoriale entro 2 settimane. Controlli: cardiologia entro 7-10 giorni; esami ematochimici con creatinina, elettroliti e emocromo entro 5-7 giorni; profilo lipidico e transaminasi a 6-8 settimane; ecocardiogramma di controllo a 6-8 settimane; diabetologia entro 30 giorni. Il paziente viene dimesso in condizioni cliniche stabili, con consegna di piano terapeutico e istruzioni sui segni/sintomi di allarme per cui ricorrere prontamente a valutazione medica.",
      "observations": [
        "Data dimissione 2026-03-22",
        "FEVS 40 %",
        "Door-to-balloon 53 min",
        "HbA1c 8.0 %",
        "Creatinina pre-dimissione 0.96 mg/dL",
        "Esito dimissione ordinaria"
      ]
    }
  ]
}
$case_CARDIO_STEMI_VANILLA$::jsonb),
        ('CARDIO-STEMI-V01-05-08', $case_CARDIO_STEMI_V01_05_08$
{
  "paziente": {
    "nome": "Mario",
    "cognome": "Rossi",
    "dataDiNascita": "1958-07-12",
    "sesso": "M",
    "codiceFiscale": "RSSMRA58L12H501X",
    "residenza": "Via Appia Nuova 145, 00183 Roma"
  },
  "ricovero": {
    "dataIngresso": "2026-03-18T08:02:00+01:00",
    "dataDimissione": "2026-03-23T10:45:00+01:00",
    "reparto": "UTIC / Cardiologia Degenza",
    "diagnosiPrincipale": "I21.1 - Infarto miocardico acuto con sopraslivellamento del tratto ST della parete inferiore con estensione posteriore, trattato con PCI su coronaria destra dominante",
    "diagnosiSecondarie": [
      "E11.65 - Diabete mellito tipo 2 con iperglicemia",
      "I10 - Ipertensione arteriosa essenziale",
      "E78.5 - Dislipidemia"
    ],
    "esito": "dimissione_ordinaria"
  },
  "healthRecords": [
    {
      "id": 1,
      "dateTime": "2026-03-18T07:48:00+01:00",
      "type": "Referto ECG",
      "humanResource": "Dr.ssa Elisa Gori",
      "role": "Medico 118",
      "narrative": "ECG pre-ospedaliero a 12 derivazioni: ritmo sinusale a 90 bpm; lieve sopraslivellamento del tratto ST in DIII e aVF, inferiore a 1,5 mm, con modesto sottoslivellamento speculare in aVL e V1-V3. Quadro non dirimente per STEMI conclamato, suggestivo per sindrome coronarica acuta infero-posteriore in fase iniziale. Tracciato trasmesso al Pronto Soccorso del centro HUB per rivalutazione all'arrivo.",
      "observations": [
        "Ritmo sinusale 90 bpm",
        "ST elevato 1.0 mm DIII",
        "ST elevato 1.0 mm aVF",
        "ST elevato 0.5 mm DII",
        "ST depresso 1.0 mm V1-V3",
        "QTc 432 ms"
      ]
    },
    {
      "id": 2,
      "dateTime": "2026-03-18T07:50:00+01:00",
      "type": "Verbale Intervento 118",
      "humanResource": "Dr.ssa Elisa Gori",
      "role": "Medico 118",
      "narrative": "Intervento 118 per dolore toracico/epigastrico insorto alle ore 06:55 a riposo, oppressivo, irradiato posteriormente, associato a sudorazione fredda e nausea. Paziente vigile, collaborante, emodinamicamente stabile, SpO2 conservata in aria ambiente. In considerazione del quadro ECG non univoco per STEMI ma compatibile con SCA ad alto rischio, somministrati ASA 300 mg p.o., isosorbide dinitrato sublinguale e morfina 2 mg e.v.; avviato trasporto protetto in codice tempo-dipendente verso HUB cardiologico senza attivazione diretta della sala di emodinamica.",
      "observations": [
        "Esordio sintomi 06:55",
        "FMC 07:44",
        "Dolore toracico NRS 8/10",
        "PA 164/94 mmHg",
        "FC 90 bpm",
        "SpO2 97 % in aria ambiente",
        "FR 20 atti/min",
        "Glicemia capillare 262 mg/dL",
        "Temperatura 36.1 °C"
      ]
    },
    {
      "id": 3,
      "dateTime": "2026-03-18T08:02:00+01:00",
      "type": "Scheda Triage Pronto Soccorso",
      "humanResource": "Paola Conti",
      "role": "Infermiere Triage",
      "narrative": "Accesso in Pronto Soccorso da 118 per dolore toracico persistente in parziale remissione dopo nitrati, con ECG territoriale dubbio per ischemia infero-posteriore. Assegnato codice arancione, instradato in area emergenza ad alta intensità con monitoraggio continuo e prelievi urgenti. Segnalata anamnesi di diabete mellito tipo 2 e ipertensione arteriosa.",
      "observations": [
        "Codice di priorità Arancione",
        "PA 156/90 mmHg",
        "FC 88 bpm",
        "SpO2 97 % in aria ambiente",
        "FR 19 atti/min",
        "Dolore toracico NRS 5/10",
        "Temperatura 36.3 °C"
      ]
    },
    {
      "id": 4,
      "dateTime": "2026-03-18T08:11:00+01:00",
      "type": "Valutazione Medica Pronto Soccorso",
      "humanResource": "Dr. Andrea Bellini",
      "role": "Medico Pronto Soccorso",
      "narrative": "Paziente maschio di 67 anni giunge dal 118 per dolore toracico tipico con alterazioni ECG inferiori non nettamente diagnostiche. All'ingresso vigile, orientato, ancora lievemente algico ma stabile emodinamicamente, Killip I, senza rantoli né segni di basso flusso. Presa visione del tracciato territoriale: in assenza di sopraslivellamento persistente chiaramente diagnostico per STEMI, impostato iter per SCA senza ST con monitoraggio, ECG seriati, dosaggio di hs-cTn e consulenza cardiologica non urgente se comparsa di dinamica clinico-elettrocardiografica.",
      "observations": [
        "Killip class I",
        "PA 154/88 mmHg",
        "FC 86 bpm",
        "SpO2 97 %",
        "Dolore toracico NRS 4/10",
        "Piano iniziale: osservazione breve intensiva"
      ]
    },
    {
      "id": 5,
      "dateTime": "2026-03-18T08:14:00+01:00",
      "type": "Anamnesi",
      "humanResource": "Dr. Andrea Bellini",
      "role": "Medico Pronto Soccorso",
      "narrative": "Anamnesi patologica remota: diabete mellito tipo 2 noto da circa 12 anni, in trattamento domiciliare con metformina 1000 mg x 2/die e gliclazide RM 60 mg al mattino; ultimo valore noto di HbA1c riferito 8.2 % circa due mesi prima. Ipertensione arteriosa in terapia con ramipril 5 mg/die. Dislipidemia in terapia irregolare con atorvastatina 20 mg/die. Ex fumatore, pregresso tabagismo circa 20 pack/years, sospeso nel 2016. Nessuna precedente rivascolarizzazione, nessuna storia di ictus/TIA o sanguinamenti maggiori. Anamnesi familiare positiva per cardiopatia ischemica: padre con infarto miocardico a 62 anni. Nessuna allergia farmacologica nota. Anamnesi patologica prossima: dolore oppressivo epigastrico-retrosternale insorto a riposo alle 06:55 con irradiazione dorsale, nausea e sudorazione.",
      "observations": [
        "Diabete mellito tipo 2 da 12 anni",
        "HbA1c ultimo noto 8.2 %",
        "Metformina 1000 mg BID",
        "Gliclazide RM 60 mg/die",
        "Ramipril 5 mg/die",
        "Atorvastatina 20 mg/die irregolare",
        "Ex fumatore 20 pack-years",
        "BMI 28.8 kg/m²"
      ]
    },
    {
      "id": 6,
      "dateTime": "2026-03-18T08:16:00+01:00",
      "type": "Esame Obiettivo",
      "humanResource": "Dr. Andrea Bellini",
      "role": "Medico Pronto Soccorso",
      "narrative": "Paziente vigile, orientato, collaborante. Cute lievemente sudata, normoperfusa. Torace eupnoico, murmure vescicolare presente bilateralmente, assenza di rantoli. Toni cardiaci validi, ritmici, non soffi francamente patologici. Addome trattabile, modesta dolorabilità epigastrica aspecifica, niente segni di peritonismo. Polsi periferici presenti e simmetrici, assenza di edemi declivi. Quadro generale compatibile con SCA ad alto rischio in classe Killip I.",
      "observations": [
        "PA 152/86 mmHg",
        "FC 84 bpm",
        "SpO2 97 %",
        "FR 18 atti/min",
        "Temperatura 36.4 °C",
        "GCS 15",
        "Segni di scompenso assenti"
      ]
    },
    {
      "id": 7,
      "dateTime": "2026-03-18T08:58:00+01:00",
      "type": "Referto Laboratorio",
      "humanResource": "Dr.ssa Giulia Orsini",
      "role": "Medico Laboratorio",
      "narrative": "Esami urgenti all'ingresso processati in urgenza. Emocromo, coagulazione e funzione renale senza controindicazioni immediate a eventuale strategia invasiva. Dosaggio basale di hs-cTnI lievemente superiore al 99° percentile, reperto da correlare al quadro clinico ed elettrocardiografico; richiesto controllo seriato a distanza.",
      "observations": [
        "Prelievo hs-cTnI basale 08:18",
        "Emoglobina 14.9 g/dL",
        "Leucociti 11.1 x10^9/L",
        "Piastrine 236 x10^9/L",
        "INR 1.01",
        "aPTT 29 s",
        "Creatinina 1.08 mg/dL",
        "eGFR 75 mL/min/1.73m²",
        "Sodio 137 mmol/L",
        "Potassio 4.4 mmol/L",
        "Glucosio 256 mg/dL",
        "hs-cTnI 38 ng/L"
      ]
    },
    {
      "id": 8,
      "dateTime": "2026-03-18T09:36:00+01:00",
      "type": "Referto ECG",
      "humanResource": "Dr. Andrea Bellini",
      "role": "Medico Pronto Soccorso",
      "narrative": "ECG seriato a 12 derivazioni per persistenza di modesta sintomatologia costrittiva toracica. Ritmo sinusale a 82 bpm; persistenza di minime alterazioni del tratto ST in sede inferiore con sottoslivellamento in V1-V3, senza chiara progressione rispetto al tracciato pre-ospedaliero. Quadro ancora non francamente conclusivo per STEMI, prosegue osservazione clinico-strumentale.",
      "observations": [
        "Ritmo sinusale 82 bpm",
        "ST elevato 1.0 mm DIII",
        "ST elevato 0.5-1.0 mm aVF",
        "ST depresso 1.0 mm V1-V3",
        "QTc 428 ms",
        "Dolore toracico NRS 3/10"
      ]
    },
    {
      "id": 9,
      "dateTime": "2026-03-18T11:02:00+01:00",
      "type": "Referto ECG",
      "humanResource": "Dr. Andrea Bellini",
      "role": "Medico Pronto Soccorso",
      "narrative": "Per recrudescenza del dolore toracico con nausea e sudorazione, eseguito nuovo ECG a 12 derivazioni. Ritmo sinusale a 92 bpm; comparsa di netto sopraslivellamento del tratto ST in DII, DIII e aVF con sottoslivellamento reciproco in DI-aVL e persistente sottoslivellamento in V1-V3, quadro compatibile con STEMI inferiore con sospetto interessamento posteriore. Richiesta rivalutazione cardiologica urgente.",
      "observations": [
        "Ritmo sinusale 92 bpm",
        "ST elevato 1.5 mm DII",
        "ST elevato 2.5 mm DIII",
        "ST elevato 2.0 mm aVF",
        "ST depresso 1.5 mm DI-aVL",
        "ST depresso 2.0 mm V1-V3",
        "Dolore toracico NRS 7/10"
      ]
    },
    {
      "id": 10,
      "dateTime": "2026-03-18T11:18:00+01:00",
      "type": "Referto ECG",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "ECG con derivazioni aggiuntive eseguito su richiesta cardiologica dopo rivalutazione clinica per nuova algia. Nelle derivazioni posteriori V7-V9 presente sopraslivellamento del tratto ST fino a 1-1,5 mm; derivazioni destre V3R-V4R senza significativo sopraslivellamento. Reperti compatibili con estensione posteriore dell'infarto inferiore, senza evidenza di importante coinvolgimento del ventricolo destro al momento dell'esame.",
      "observations": [
        "Ritmo sinusale 90 bpm",
        "ST elevato 1.0 mm V7",
        "ST elevato 1.5 mm V8",
        "ST elevato 1.0 mm V9",
        "V4R senza ST significativo",
        "Dolore toracico NRS 6/10"
      ]
    },
    {
      "id": 11,
      "dateTime": "2026-03-18T11:39:00+01:00",
      "type": "Valutazione Medica Pronto Soccorso",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "Valutazione cardiologica urgente in Pronto Soccorso per evoluzione elettrocardiografica e clinica. Alla luce della ricomparsa del dolore toracico, del netto sopraslivellamento inferiore al tracciato delle 11:02 e della conferma di interessamento posteriore alle derivazioni aggiuntive, si pone indicazione a coronarografia urgente con intento di PCI primaria. Emodinamica contattata e attivata alle ore 11:40; somministrati ticagrelor 180 mg p.o. e bolo di eparina sodica 5000 UI e.v., avviato trasferimento non appena disponibile la sala.",
      "observations": [
        "PA 148/84 mmHg",
        "FC 88 bpm",
        "SpO2 97 %",
        "ECG diagnostico STEMI 11:02",
        "Decisione strategia riperfusione 11:39",
        "Attivazione emodinamica 11:40"
      ]
    },
    {
      "id": 12,
      "dateTime": "2026-03-18T11:44:00+01:00",
      "type": "Consenso Informato",
      "humanResource": "Dr. Matteo Ferretti",
      "role": "Cardiologo Emodinamista",
      "narrative": "Il paziente, vigile e pienamente capace di intendere e di volere, viene informato circa indicazione urgente a coronarografia con possibilità di PCI ad hoc per STEMI infero-posteriore in atto. Illustrati finalità, benefici attesi, possibili alternative e principali rischi della procedura e del mezzo di contrasto (sanguinamento, complicanze vascolari, dissezione/perforazione, aritmie, necessità di rivascolarizzazione chirurgica urgente, nefropatia da contrasto, ictus, morte). Spiegata scelta preferenziale di accesso radiale destro e necessità di doppia antiaggregazione protratta dopo eventuale impianto di stent. Il paziente dichiara di aver compreso e sottoscrive il consenso.",
      "observations": [
        "Consenso alla coronarografia acquisito",
        "Consenso alla PCI acquisito",
        "Accesso previsto radiale destro",
        "Stato di coscienza vigile e orientato"
      ]
    },
    {
      "id": 13,
      "dateTime": "2026-03-18T12:06:00+01:00",
      "type": "Referto Laboratorio",
      "humanResource": "Dr.ssa Giulia Orsini",
      "role": "Medico Laboratorio",
      "narrative": "Secondo dosaggio seriato di hs-cTnI eseguito nel contesto del percorso dolore toracico a distanza di circa 3 ore e 40 minuti dal prelievo basale. Marcato incremento dei biomarcatori, coerente con necrosi miocardica in evoluzione. Persistono glicemia elevata e assetto renale sostanzialmente conservato.",
      "observations": [
        "Secondo prelievo hs-cTnI 11:58",
        "Intervallo dal basale 220 min",
        "hs-cTnI 214 ng/L",
        "CK-MB 18.4 ng/mL",
        "Glucosio 238 mg/dL",
        "Creatinina 1.07 mg/dL",
        "Potassio 4.3 mmol/L"
      ]
    },
    {
      "id": 14,
      "dateTime": "2026-03-18T13:05:00+01:00",
      "type": "Referto Emodinamica",
      "humanResource": "Dr. Matteo Ferretti",
      "role": "Cardiologo Emodinamista",
      "narrative": "Coronarografia urgente eseguita per STEMI inferiore con estensione posteriore. Accesso radiale destro 6F. Tronco comune indenne; IVA con ateromasia non critica; circonflessa con stenosi del 40 % nel tratto medio; coronaria destra dominante con occlusione trombotica acuta del tratto medio-prossimale (TIMI 0), lesione colpevole. Eseguita PCI con attraversamento della lesione mediante guida coronarica, predilatazione con pallone 2.5 x 15 mm e impianto di DES 4.0 x 30 mm, seguito da post-dilatazione con pallone non compliante 4.0 x 15 mm. Buon risultato angiografico finale con stenosi residua 0 %, flusso TIMI 3 e blush miocardico 3. Nessuna complicanza immediata; emostasi radiale con dispositivo compressivo.",
      "observations": [
        "Ingresso in emodinamica 12:16",
        "Puntura radiale 12:22",
        "Prima dilatazione 12:29",
        "TIMI pre-PCI 0",
        "Stent DES 4.0 x 30 mm",
        "TIMI post-PCI 3",
        "Myocardial blush 3",
        "ACT 301 s",
        "Door-to-balloon 267 min",
        "FMC-to-balloon 285 min"
      ]
    },
    {
      "id": 15,
      "dateTime": "2026-03-18T14:10:00+01:00",
      "type": "Referto ECG",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "ECG post-PCI: ritmo sinusale a 76 bpm. Marcata riduzione del sopraslivellamento del tratto ST inferiore con residua minima elevazione in DIII-aVF e regressione dei sottoslivellamenti precordiali. Non aritmie, non disturbi maggiori della conduzione. Quadro compatibile con riperfusione efficace dopo PCI su coronaria destra.",
      "observations": [
        "Ritmo sinusale 76 bpm",
        "Riduzione ST >50 %",
        "ST residuo minimo DIII-aVF",
        "QTc 426 ms",
        "Nessuna aritmia ventricolare",
        "Nessun BAV"
      ]
    },
    {
      "id": 16,
      "dateTime": "2026-03-18T14:30:00+01:00",
      "type": "Diario Clinico UTIC",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "Ingresso in UTIC post-PCI su coronaria destra. Paziente vigile, eupnoico, asintomatico per dolore toracico, emodinamicamente stabile, Killip I. Accesso radiale destro in ordine con dispositivo compressivo, assenza di sanguinamento. Impostata terapia con ASA 100 mg/die, ticagrelor 90 mg x 2, atorvastatina 80 mg la sera; pianificato avvio di beta-bloccante a basse dosi in assenza di bradicardia o ipotensione. Metformina sospesa per 48 ore dopo mezzo di contrasto; attivato monitoraggio glicemico preprandiale e notturno con schema insulinico correttivo.",
      "observations": [
        "PA 132/78 mmHg",
        "FC 74 bpm",
        "SpO2 98 %",
        "Dolore toracico 0/10",
        "Diuresi conservata",
        "Glicemia capillare 224 mg/dL"
      ]
    },
    {
      "id": 17,
      "dateTime": "2026-03-18T14:45:00+01:00",
      "type": "Diario Infermieristico UTIC",
      "humanResource": "Sara Vitale",
      "role": "Infermiere UTIC",
      "narrative": "Paziente accolto in UTIC da emodinamica, collegato a monitor multiparametrico e telemetria continua. Posizionato a letto con riposo assoluto iniziale; controllata sede di accesso radiale destro con dispositivo compressivo, asciutta e senza ematoma. Eseguito stick glicemico e somministrata terapia prescritta. Informato a segnalare immediatamente dolore toracico, dispnea, sanguinamento o parestesie alla mano destra.",
      "observations": [
        "PA 130/76 mmHg",
        "FC 74 bpm",
        "SpO2 98 %",
        "Glicemia capillare 224 mg/dL",
        "Sede radiale integra"
      ]
    },
    {
      "id": 18,
      "dateTime": "2026-03-18T18:10:00+01:00",
      "type": "Referto Laboratorio",
      "humanResource": "Dr.ssa Giulia Orsini",
      "role": "Medico Laboratorio",
      "narrative": "Controllo seriato post-rivascolarizzazione. Incremento enzimatico coerente con evoluzione di infarto miocardico acuto in fase subacuta; funzione renale stabile dopo mezzo di contrasto. Nessuna alterazione elettrolitica significativa oltre a iperglicemia ancora presente.",
      "observations": [
        "hs-cTnI 6840 ng/L",
        "CK-MB 112 ng/mL",
        "Creatinina 1.04 mg/dL",
        "eGFR 78 mL/min/1.73m²",
        "Glucosio 218 mg/dL",
        "Potassio 4.1 mmol/L",
        "Magnesio 1.9 mg/dL"
      ]
    },
    {
      "id": 19,
      "dateTime": "2026-03-18T18:40:00+01:00",
      "type": "Diario Clinico UTIC",
      "humanResource": "Dr. Paolo Riva",
      "role": "Cardiologo",
      "narrative": "Decorso regolare nelle prime ore post-riperfusione. Paziente apiretico, senza recidiva algica né dispnea; telemetria con ritmo sinusale stabile, sporadiche extrasistoli ventricolari isolate non ripetitive. Avviato bisoprololo 1.25 mg/die in assenza di segni di basso output; prosegue DAPT e statina ad alta intensità. Gestione glicemica con rapida correzione insulinica sottocutanea secondo schema.",
      "observations": [
        "PA 128/74 mmHg",
        "FC 70 bpm",
        "SpO2 98 %",
        "Temperatura 36.5 °C",
        "Glicemia capillare 210 mg/dL",
        "Extrasistolia ventricolare isolata non sostenuta"
      ]
    },
    {
      "id": 20,
      "dateTime": "2026-03-18T23:00:00+01:00",
      "type": "Diario Infermieristico UTIC",
      "humanResource": "Marco Fabbri",
      "role": "Infermiere UTIC",
      "narrative": "Turno serale/notturno: paziente a riposo, vigile, non algico. Telemetria continua in ritmo sinusale, non episodi ischemici riferiti. Controllata sede radiale: medicazione pulita, asciutta, non segni di sanguinamento; polso radiale presente. Eseguito stick glicemico serale e terapia secondo prescrizione.",
      "observations": [
        "PA 124/72 mmHg",
        "FC 68 bpm",
        "SpO2 97 %",
        "Glicemia capillare 188 mg/dL",
        "Temperatura 36.4 °C"
      ]
    },
    {
      "id": 21,
      "dateTime": "2026-03-19T06:20:00+01:00",
      "type": "Referto Laboratorio",
      "humanResource": "Dr.ssa Giulia Orsini",
      "role": "Medico Laboratorio",
      "narrative": "Controllo ematochimico del primo giorno post-PCI. Picco dei biomarcatori di necrosi miocardica in attesa evolutiva; funzione renale e ionogramma stabili. Eseguiti assetto lipidico e HbA1c per inquadramento del rischio cardiovascolare e della comorbidità diabetica.",
      "observations": [
        "Emoglobina 14.3 g/dL",
        "Leucociti 9.9 x10^9/L",
        "Creatinina 1.00 mg/dL",
        "eGFR 80 mL/min/1.73m²",
        "Sodio 138 mmol/L",
        "Potassio 4.2 mmol/L",
        "Glucosio 178 mg/dL",
        "hs-cTnI 20180 ng/L",
        "CK-MB 162 ng/mL",
        "HbA1c 8.1 %",
        "Colesterolo totale 216 mg/dL",
        "LDL-colesterolo 139 mg/dL",
        "HDL-colesterolo 39 mg/dL",
        "Trigliceridi 176 mg/dL"
      ]
    },
    {
      "id": 22,
      "dateTime": "2026-03-19T07:00:00+01:00",
      "type": "Diario Infermieristico UTIC",
      "humanResource": "Sara Vitale",
      "role": "Infermiere UTIC",
      "narrative": "Notte trascorsa senza eventi. Paziente riferisce sonno discreto, nessun episodio di dolore toracico o dispnea. Igiene al letto eseguita, alzata assistita in poltrona ben tollerata. Prosegue monitoraggio telemetrico continuo e rilevazione parametri; glicemia pre-colazione comunicata al medico di guardia per adeguamento insulinico.",
      "observations": [
        "PA 122/70 mmHg",
        "FC 66 bpm",
        "SpO2 98 %",
        "Glicemia capillare 172 mg/dL",
        "Diuresi notturna 900 mL"
      ]
    },
    {
      "id": 23,
      "dateTime": "2026-03-19T08:00:00+01:00",
      "type": "Diario Clinico UTIC",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "Notte tranquilla, assenza di dolore toracico o dispnea, nessuna aritmia significativa in telemetria. Paziente emodinamicamente stabile, mobilizzazione passiva/attiva in letto ben tollerata. Alla luce della stabilità pressoria avviato ramipril 2.5 mg x 2/die. Richiesto ecocardiogramma di controllo per valutazione della funzione ventricolare e di eventuali complicanze meccaniche post-IMA. Continuano stick glicemici pluriquotidiani e terapia insulinica correttiva.",
      "observations": [
        "PA 122/70 mmHg",
        "FC 66 bpm",
        "SpO2 98 %",
        "Temperatura 36.4 °C",
        "Glicemia capillare 172 mg/dL"
      ]
    },
    {
      "id": 24,
      "dateTime": "2026-03-19T11:20:00+01:00",
      "type": "Referto Ecocardiogramma",
      "humanResource": "Dr.ssa Simona Greco",
      "role": "Cardiologo Ecocardiografista",
      "narrative": "Ecocardiogramma transtoracico: ventricolo sinistro di dimensioni ai limiti superiori, cinesi segmentaria alterata con ipocinesia della parete inferiore medio-basale e infero-posteriore, conservata la cinetica residua. Funzione sistolica globale lievemente ridotta con FEVS biplana stimata 47 %. Ventricolo destro non dilatato, funzione sistolica conservata. Insufficienza mitralica lieve, non stenosi valvolari significative. Assenza di trombi endoventricolari, versamento pericardico assente, nessun segno di complicanze meccaniche post-infartuali.",
      "observations": [
        "FEVS 47 %",
        "TAPSE 21 mm",
        "Insufficienza mitralica lieve",
        "PAPs stimata 30 mmHg",
        "Versamento pericardico assente",
        "Trombi endocavitari assenti"
      ]
    },
    {
      "id": 25,
      "dateTime": "2026-03-19T15:10:00+01:00",
      "type": "Consulenza Diabetologica",
      "humanResource": "Dr.ssa Francesca Leone",
      "role": "Diabetologo",
      "narrative": "Valutazione diabetologica richiesta per diabete mellito tipo 2 noto, scompensato all'ingresso in corso di sindrome coronarica acuta. Paziente riferisce aderenza variabile alla dieta e alla terapia domiciliare con metformina e gliclazide. HbA1c attuale 8.1 %, compatibile con controllo non ottimale. In fase acuta appropriata sospensione di metformina per 48 ore dopo contrasto iodato e sospensione di sulfanilurea. Durante ricovero indicato schema basal-bolus semplificato con insulina glargine 14 UI ore 22 e correzioni con insulina rapida ai pasti. Alla dimissione, in presenza di funzione renale stabile, raccomandata ripresa di metformina 1000 mg due volte/die dopo 48 ore complete dall'esposizione al contrasto; non riprendere gliclazide.",
      "observations": [
        "HbA1c 8.1 %",
        "Schema glargine 14 UI h22",
        "Target glicemico preprandiale 100-180 mg/dL",
        "Ripresa metformina dopo 48 h se creatinina stabile",
        "Sospensione gliclazide"
      ]
    },
    {
      "id": 26,
      "dateTime": "2026-03-19T20:30:00+01:00",
      "type": "Diario Clinico UTIC",
      "humanResource": "Dr. Paolo Riva",
      "role": "Cardiologo",
      "narrative": "Valutazione serale: paziente in buone condizioni generali, vigile, collaborante, autonomo ai passaggi posturali, senza angor né equivalenti ischemici. Telemetria negativa per aritmie significative; non segni di congestione. Terapia ben tollerata, nessuna ipotensione sintomatica dopo introduzione di ACE-inibitore. Educazione iniziale su necessità di aderenza a doppia antiaggregazione, statina ad alta intensità e controllo dei fattori di rischio.",
      "observations": [
        "PA 118/68 mmHg",
        "FC 64 bpm",
        "SpO2 97 %",
        "Temperatura 36.6 °C",
        "Glicemia capillare 154 mg/dL"
      ]
    },
    {
      "id": 27,
      "dateTime": "2026-03-19T23:00:00+01:00",
      "type": "Diario Infermieristico UTIC",
      "humanResource": "Marco Fabbri",
      "role": "Infermiere UTIC",
      "narrative": "Fine turno serale/notturno: paziente in condizioni stabili, orientato, non dolore, non nausea. Monitoraggio cardiaco senza alterazioni rilevanti. Terapia serale assunta regolarmente. Educazione rinforzata su chiamata infermieristica in caso di dolore toracico, palpitazioni o lipotimia.",
      "observations": [
        "PA 118/66 mmHg",
        "FC 64 bpm",
        "SpO2 97 %",
        "Glicemia capillare 150 mg/dL",
        "NRS dolore 0/10"
      ]
    },
    {
      "id": 28,
      "dateTime": "2026-03-20T06:20:00+01:00",
      "type": "Referto Laboratorio",
      "humanResource": "Dr.ssa Giulia Orsini",
      "role": "Medico Laboratorio",
      "narrative": "Controllo seriato in seconda giornata post-infarto: trend decrescente dei biomarcatori, emocromo stabile, funzione renale conservata dopo esposizione a mezzo di contrasto. Dati compatibili con prosecuzione della terapia cardioattiva e con rivalutazione della ripresa della metformina al compimento delle 48 ore.",
      "observations": [
        "Emoglobina 14.0 g/dL",
        "Leucociti 9.0 x10^9/L",
        "Piastrine 228 x10^9/L",
        "Creatinina 0.97 mg/dL",
        "eGFR 83 mL/min/1.73m²",
        "Potassio 4.3 mmol/L",
        "Glucosio 148 mg/dL",
        "hs-cTnI 12940 ng/L",
        "CK-MB 86 ng/mL"
      ]
    },
    {
      "id": 29,
      "dateTime": "2026-03-20T08:10:00+01:00",
      "type": "Diario Clinico UTIC",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "Controllo mattutino: notte tranquilla, nessun evento aritmico o ischemico. Paziente mobilizzato al bordo letto e in poltrona senza sintomi; non dolore, non dispnea, non segni di sanguinamento. Esami ematici in miglioramento, funzione renale stabile dopo mezzo di contrasto. Se confermata stabilità clinica nelle ore successive, programmato trasferimento in degenza cardiologica ordinaria.",
      "observations": [
        "PA 116/68 mmHg",
        "FC 63 bpm",
        "SpO2 98 %",
        "Glicemia capillare 146 mg/dL",
        "Diuresi 1700 mL/24h"
      ]
    },
    {
      "id": 30,
      "dateTime": "2026-03-20T12:00:00+01:00",
      "type": "Diario Clinico Degenza",
      "humanResource": "Dr. Paolo Riva",
      "role": "Cardiologo",
      "narrative": "Trasferito oggi da UTIC a degenza cardiologica ordinaria. Paziente in buone condizioni generali, vigile, orientato, eupnoico, asintomatico per dolore toracico. Deambulazione in corridoio assistita ben tollerata, nessuna aritmia riferita, alvo e diuresi regolari. Prosegue terapia ottimizzata post-STEMI con DAPT, beta-bloccante, ACE-inibitore e statina ad alta intensità. Alla luce della creatinina stabile e del compimento delle 48 ore post-contrasto, programmata ripresa della metformina in serata secondo indicazione diabetologica.",
      "observations": [
        "PA 116/68 mmHg",
        "FC 64 bpm",
        "SpO2 98 %",
        "Peso 84 kg",
        "Glicemia pre-pranzo 142 mg/dL"
      ]
    },
    {
      "id": 31,
      "dateTime": "2026-03-20T16:00:00+01:00",
      "type": "Valutazione Fisioterapica",
      "humanResource": "Alessia Marchetti",
      "role": "Fisioterapista",
      "narrative": "Valutazione fisioterapica in seconda giornata post-PCI. Paziente collaborante, stabile, senza dispnea né angor durante mobilizzazione progressiva. Eseguiti esercizi di respirazione diaframmatica, mobilizzazione attiva degli arti e deambulazione controllata in corridoio con incremento graduale del carico. Tolleranza buona, nessuna desaturazione o sintomatologia. Fornite indicazioni su progressione dell'attività fisica e opportunità di programma di riabilitazione cardiologica strutturata.",
      "observations": [
        "Cammino assistito 120 metri",
        "FC pre-esercizio 66 bpm",
        "FC post-esercizio 80 bpm",
        "SpO2 pre 98 %",
        "SpO2 post 97 %",
        "Scala Borg 11/20"
      ]
    },
    {
      "id": 32,
      "dateTime": "2026-03-21T06:20:00+01:00",
      "type": "Referto Laboratorio",
      "humanResource": "Dr.ssa Giulia Orsini",
      "role": "Medico Laboratorio",
      "narrative": "Esami di controllo in degenza ordinaria: ulteriore stabilizzazione del quadro laboratoristico, funzione renale invariata e glicemie in miglioramento. Parametri compatibili con prosecuzione della terapia prescritta e con mantenimento della metformina ripresa dalla sera precedente.",
      "observations": [
        "Emoglobina 14.1 g/dL",
        "Leucociti 8.3 x10^9/L",
        "Creatinina 0.95 mg/dL",
        "eGFR 85 mL/min/1.73m²",
        "Potassio 4.4 mmol/L",
        "Sodio 139 mmol/L",
        "Glucosio 136 mg/dL"
      ]
    },
    {
      "id": 33,
      "dateTime": "2026-03-21T09:00:00+01:00",
      "type": "Diario Clinico Degenza",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "Decorso in reparto ordinario regolare. Paziente autonomo nella deambulazione in reparto, senza dolore toracico, dispnea o lipotimie. Ripresa metformina dalla serata precedente, ben tollerata; glicemie capillari in progressivo miglioramento. Sede radiale cicatrizzata, senza ematoma né parestesie. Eseguita educazione terapeutica su fattori di rischio, aderenza a DAPT, dieta mediterranea, controllo pressorio e glicemico.",
      "observations": [
        "PA 114/68 mmHg",
        "FC 62 bpm",
        "SpO2 98 %",
        "Glicemia capillare 134 mg/dL",
        "Temperatura 36.4 °C"
      ]
    },
    {
      "id": 34,
      "dateTime": "2026-03-22T08:30:00+01:00",
      "type": "Diario Clinico Degenza",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "Controllo pre-dimissione differita per completamento educazione terapeutica e stabilizzazione glicemica. Paziente in condizioni cliniche stabili, apiretico, eupnoico in aria ambiente, emodinamicamente compensato. Nessuna recidiva anginosa, nessun segno di scompenso o complicanze del sito di accesso. Terapia ben tollerata; ribadite indicazioni a riabilitazione cardiologica, follow-up cardiologico precoce ed esecuzione di esami ematochimici di controllo entro 5-7 giorni.",
      "observations": [
        "PA 116/70 mmHg",
        "FC 61 bpm",
        "SpO2 98 %",
        "Dolore toracico 0/10",
        "Glicemia capillare 128 mg/dL"
      ]
    },
    {
      "id": 35,
      "dateTime": "2026-03-23T08:15:00+01:00",
      "type": "Diario Clinico Degenza",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "Ultimo controllo di reparto: paziente in compenso clinico, deambulante autonomamente, alvo e diuresi regolari, nessuna sintomatologia ischemica riferita. Confermata dimissione in mattinata con consegna di piano terapeutico, lettera di dimissione e appuntamenti di follow-up. Rinforzata educazione a non sospendere autonomamente la doppia antiaggregazione.",
      "observations": [
        "PA 118/70 mmHg",
        "FC 62 bpm",
        "SpO2 98 %",
        "Glicemia capillare 126 mg/dL",
        "Peso 83.5 kg"
      ]
    },
    {
      "id": 36,
      "dateTime": "2026-03-23T10:45:00+01:00",
      "type": "Lettera di Dimissione Ospedaliera",
      "humanResource": "Dr.ssa Laura Neri",
      "role": "Cardiologo",
      "narrative": "Si dimette il sig. Mario Rossi, 67 anni, ricoverato dal 18/03/2026 al 23/03/2026 per sindrome coronarica acuta evoluta in infarto miocardico acuto con sopraslivellamento del tratto ST della parete inferiore con estensione posteriore. Accesso in PS tramite 118 per dolore toracico/epigastrico; iniziale quadro elettrocardiografico non univoco per STEMI con successiva dinamica clinico-elettrocardiografica e comparsa di STEMI inferiore franco, per cui in data 18/03/2026 eseguita coronarografia urgente con riscontro di occlusione trombotica acuta della coronaria destra dominante, trattata con PCI e impianto di DES con risultato finale ottimale (TIMI 3). Decorso successivo regolare in UTIC e poi in degenza ordinaria, senza recidive ischemiche né aritmie significative. Ecocardiogramma del 19/03/2026: FEVS 47 %, ipocinesia infero-posteriore, assenza di complicanze meccaniche. Comorbidità rilevante: diabete mellito tipo 2 non ottimamente controllato (HbA1c 8.1 %), rivalutato da diabetologo; metformina sospesa per 48 ore post-contrasto e poi ripresa, gliclazide definitivamente sospesa. Diagnosi alla dimissione: STEMI infero-posteriore rivascolarizzato con PCI su coronaria destra, disfunzione sistolica ventricolare sinistra lieve, diabete mellito tipo 2, ipertensione arteriosa, dislipidemia. Terapia domiciliare: ASA 100 mg 1 cp/die indefinitamente; ticagrelor 90 mg 1 cp ogni 12 ore per 12 mesi salvo diversa indicazione; atorvastatina 80 mg 1 cp la sera; bisoprololo 1.25 mg 1 cp/die; ramipril 2.5 mg 1 cp ogni 12 ore; pantoprazolo 20 mg/die; metformina 1000 mg 1 cp ogni 12 ore; insulina glargine 14 UI ore 22. Raccomandato automonitoraggio glicemico, dieta ipolipidica e ipoglucidica, astensione dal fumo e graduale ripresa dell'attività fisica. Indicata riabilitazione cardiologica ambulatoriale entro 2 settimane. Controlli: cardiologia entro 7-10 giorni; esami ematochimici con creatinina, elettroliti ed emocromo entro 5-7 giorni; profilo lipidico e transaminasi a 6-8 settimane; ecocardiogramma di controllo a 6-8 settimane; diabetologia entro 30 giorni. Il paziente viene dimesso in condizioni cliniche stabili.",
      "observations": [
        "Data dimissione 2026-03-23",
        "FEVS 47 %",
        "HbA1c 8.1 %",
        "Creatinina pre-dimissione 0.95 mg/dL",
        "Esito dimissione ordinaria"
      ]
    }
  ]
}
$case_CARDIO_STEMI_V01_05_08$::jsonb)
),
upserted_cases AS (
    INSERT INTO clinical_case (clinical_pathway_id, identifier, body)
    SELECT
        1 AS clinical_pathway_id,
        sc.identifier,
        sc.body
    FROM source_cases sc
    ON CONFLICT (clinical_pathway_id, identifier) DO UPDATE
    SET body = EXCLUDED.body
    RETURNING case_id, identifier
),
resolved_cases AS (
    SELECT
        uc.case_id,
        uc.identifier,
        sc.body
    FROM upserted_cases uc
    JOIN source_cases sc USING (identifier)
),
purged_docs AS (
    DELETE FROM document d
    USING resolved_cases rc
    WHERE d.case_id = rc.case_id
    RETURNING d.case_id
)
INSERT INTO document (case_id, document_date, body)
SELECT
    rc.case_id,
    CASE
        WHEN COALESCE(hr ->> 'dateTime', '') <> '' THEN (hr ->> 'dateTime')::timestamptz::date
        ELSE NULL
    END AS document_date,
    hr AS body
FROM resolved_cases rc
CROSS JOIN LATERAL jsonb_array_elements(rc.body -> 'healthRecords') AS hr;

COMMIT;

