# check_rules03 debug log

Creato UTC: 2026-04-06T11:08:03.554424+00:00

Log append-only con confronto progressivo tra output modello e GOLD.

## Debug Entry 1

- timestamp_utc: 2026-04-06T11:08:52.382850+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 137
- rule_id: 1
- rule_name: STEMI-DO-001
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 8/10
- rationale_alignment: 6/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 21.41s
- estimated_cost: $0.001228

### JSON modello

```json
{
  "check_id": "STEMI-DO-001",
  "check_timestamp": "2026-03-22T12:00:00+01:00",
  "confidence": 0.92,
  "outcome": "compliant",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Il paziente ha ricevuto un ECG a 12 derivazioni (id 1) entro 2 minuti dal primo contatto medico documentato (verbale 118, id 2) e la decisione di procedere con PCI primaria è stata documentata immediatamente (id 2). Il timestamp del First Medical Contact è registrato (07:46:00+01:00). Nessuna eccezione è presente. Pertanto la regola è rispettata.",
  "rule_id": "STEMI-DO-001",
  "supporting_documents": [
    {
      "confidence": 0.95,
      "document_id": "1",
      "rationale": "Referto ECG pre-ospedaliero con sopraslivellamento ST, eseguito a 07:44:00+01:00, entro 10 minuti dal FMC."
    },
    {
      "confidence": 0.9,
      "document_id": "2",
      "rationale": "Verbale Intervento 118 con decisione di attivare rete IMA e procedere con PCI primaria, documentato a 07:46:00+01:00."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "compliant",
  "rule_id": "STEMI-DO-001",
  "check_id": "CHK-STEMI-DO-001-RSSMRA58L12H501X-20260318",
  "rationale": "Il paziente soddisfa tutti i criteri di applicabilità della regola: maschio, 67 anni, dolore toracico acuto oppressivo con sopraslivellamento ST in V2-V6, I e aVL all'ECG a 12 derivazioni, compatibile con STEMI antero-laterale. Non sono presenti criteri di esclusione (nessuna DAT, nessuna diagnosi alternativa). Analisi della conformità: (1) ECG a 12 derivazioni eseguito sul territorio alle 07:44, verosimilmente entro pochi minuti dal primo contatto medico (FMC) del team 118, con refertazione immediata compatibile con STEMI (doc 1); il vincolo TC-001 (ECG entro 10 min dal FMC) risulta rispettato. (2) La decisione sulla strategia di riperfusione è stata presa immediatamente: la rete IMA è stata attivata alle 07:47, appena 3 minuti dopo l'ECG diagnostico (doc 2), con preallerta del centro HUB di emodinamica e trasporto diretto; il medico di PS ha confermato l'indicazione a PCI primaria escludendo la fibrinolisi per disponibilità immediata di emodinamica (doc 4). (3) Il timestamp del FMC è ricostruibile dal referto ECG pre-ospedaliero (07:44) e dal verbale 118. (4) Il door-to-balloon è stato di 53 minuti (doc 9); il tempo stimato dal FMC (~07:44) al balloon (~08:55) è circa 71 minuti, ben entro i 120 minuti raccomandati e anche entro i 90 minuti (paziente presentatosi entro 2 ore dai sintomi in centro con PCI). (5) La sequenza ECG → decisione riperfusione → PCI primaria è rispettata. Tutti i criteri di compliance della regola risultano soddisfatti con evidenza documentale forte.",
  "confidence": 0.95,
  "check_timestamp": "2026-03-22T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "Referto ECG pre-ospedaliero alle 07:44 che documenta sopraslivellamento ST in V2-V6, I e aVL, confermando la diagnosi di STEMI antero-laterale e attestando l'esecuzione e interpretazione dell'ECG entro pochi minuti dal primo contatto medico.",
      "confidence": 0.96,
      "document_id": "1"
    },
    {
      "rationale": "Verbale 118 che documenta il primo contatto medico (FMC), la sintomatologia del paziente, l'esecuzione dell'ECG con diagnosi di STEMI, l'attivazione immediata della rete IMA alle 07:47 (3 minuti dopo l'ECG), la somministrazione del pretrattamento farmacologico e il trasporto diretto al centro HUB. Costituisce l'evidenza principale della tempestività della valutazione e della decisione sulla strategia di riperfusione.",
      "confidence": 0.96,
      "document_id": "2"
    },
    {
      "rationale": "Scheda di triage PS che conferma l'arrivo con preallerta STEMI attiva, assegnazione codice rosso e instradamento immediato verso emodinamica, attestando la continuità del percorso STEMI dalla fase pre-ospedaliera a quella intra-ospedaliera.",
      "confidence": 0.9,
      "document_id": "3"
    },
    {
      "rationale": "Valutazione medica di PS alle 08:07 che documenta formalmente la decisione sulla strategia di riperfusione: indicazione a PCI primaria, con esclusione esplicita della fibrinolisi per disponibilità immediata di emodinamica. Soddisfa il criterio di documentazione della decisione di riperfusione.",
      "confidence": 0.95,
      "document_id": "4"
    },
    {
      "rationale": "Referto di emodinamica che documenta l'esecuzione della PCI primaria su IVA prossimale con door-to-balloon di 53 minuti, confermando il rispetto dei vincoli temporali raccomandati (TC-003) e il successo della strategia di riperfusione scelta (TIMI 3 finale).",
      "confidence": 0.94,
      "document_id": "9"
    }
  ]
}
```

## Debug Entry 2

- timestamp_utc: 2026-04-06T11:09:38.906469+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 138
- rule_id: 1
- rule_name: STEMI-DO-001
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: non_compliant
- outcome_gold: probable_non_compliance
- conformity_vs_gold: 6/10
- rationale_alignment: 5/10 (inferenziale)
- outcome_alignment: 8/10
- check_time: 17.25s
- estimated_cost: $0.001197

### JSON modello

```json
{
  "check_id": "STEMI-DO-001",
  "check_timestamp": "2026-04-06T12:00:00+01:00",
  "confidence": 0.85,
  "outcome": "non_compliant",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Il primo contatto medico (FMC) è stato registrato alle 07:44 con il verbale 118, e l’ECG pre-ospedaliero è stato eseguito alle 07:48, entro i 10 minuti richiesti. Tuttavia, la decisione formale sulla strategia di riperfusione è stata documentata solo alle 11:39, 37 minuti dopo la conferma diagnostica di STEMI (ECG alle 11:02). La regola richiede che la decisione sia presa immediatamente dopo la conferma, senza ritardo. Non sono presenti eccezioni valide (arresto cardiaco, rifiuto informato, patologia terminale). Di conseguenza, la procedura non rispetta i vincoli temporali della regola.",
  "rule_id": "STEMI-DO-001",
  "supporting_documents": [
    {
      "confidence": 0.95,
      "document_id": "1",
      "rationale": "Referto ECG pre-ospedaliero con data 07:48, dimostra l’esecuzione entro 10 minuti dal FMC."
    },
    {
      "confidence": 0.9,
      "document_id": "11",
      "rationale": "Valutazione cardiologica con decisione di PCI primaria alle 11:39, evidenziando il ritardo rispetto alla conferma ECG alle 11:02."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "probable_non_compliance",
  "rule_id": "STEMI-DO-001",
  "check_id": "CHK-STEMI-DO-001-RSSMRA58L12H501X-20260318",
  "rationale": "Il paziente presentava al FMC (07:44) un ECG pre-ospedaliero (07:48, 4 minuti dal FMC – conforme a TC-001) con sopraslivellamento ST ≥1 mm in DIII e aVF, tecnicamente soddisfacente i criteri di inclusione INC-002 per sospetto STEMI, sebbene clinicamente interpretato come non dirimente. Nonostante ciò, non è stata attivata una valutazione immediata per strategia di riperfusione d'emergenza: il medico 118 non ha attivato la sala di emodinamica e il medico di PS (08:11) ha optato per un percorso NSTE-ACS. La diagnosi definitiva di STEMI inferiore è stata posta solo alle 11:02 (oltre 3 ore dopo il FMC), con ECG chiaramente diagnostico. Da quel momento, la decisione sulla strategia di riperfusione (PCI primaria) è stata documentata alle 11:39 (37 minuti dopo la conferma diagnostica, con ECG aggiuntivo posteriore alle 11:18), e l'attivazione dell'emodinamica alle 11:40. Il tempo FMC-to-balloon è risultato 285 minuti e il door-to-balloon 267 minuti, ampiamente oltre il target di 120 minuti dal FMC. Sebbene il ritardo sia in parte attribuibile alla presentazione iniziale ambigua ed all'evoluzione progressiva dello STEMI, permangono criticità: (1) i criteri ECG borderline al FMC avrebbero dovuto indurre una valutazione più aggressiva e precoce della strategia riperfusiva; (2) anche dal momento della chiara diagnosi STEMI (11:02), la decisione non è stata propriamente 'immediata' come richiesto da TC-002. L'evidenza suggerisce non conformità, ma la genuina ambiguità del quadro iniziale introduce incertezza, impedendo di affermare una violazione netta.",
  "confidence": 0.72,
  "check_timestamp": "2026-03-23T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "ECG pre-ospedaliero eseguito 4 minuti dopo il FMC (conforme a TC-001), che mostrava ST elevato 1.0 mm in DIII e aVF – tecnicamente compatibile con criteri di inclusione per sospetto STEMI, ma interpretato come non diagnostico. Questo è il documento cardine per valutare se il sospetto STEMI fosse già presente all'esordio.",
      "confidence": 0.8,
      "document_id": "1"
    },
    {
      "rationale": "Verbale 118 che documenta il FMC alle 07:44, la sintomatologia tipica e la decisione esplicita di NON attivare direttamente la sala di emodinamica, optando per trasporto al HUB senza attivazione del percorso STEMI. Questa scelta ha contribuito al ritardo nella valutazione della strategia riperfusiva.",
      "confidence": 0.82,
      "document_id": "2"
    },
    {
      "rationale": "Valutazione medica di PS (08:11) che documenta la decisione di impostare un iter per SCA senza ST, nonostante la presenza di alterazioni ECG inferiori borderline. Non è stata eseguita una valutazione formale per strategia di riperfusione d'emergenza in questa fase.",
      "confidence": 0.75,
      "document_id": "4"
    },
    {
      "rationale": "ECG delle 11:02 chiaramente diagnostico per STEMI inferiore (ST elevato 2.5 mm in DIII, 2.0 mm in aVF, 1.5 mm in DII con reciproci), che rappresenta il momento della diagnosi definitiva di STEMI, oltre 3 ore dopo il FMC. Da questo ECG decorre il vincolo di immediatezza per la decisione riperfusiva (TC-002).",
      "confidence": 0.9,
      "document_id": "9"
    },
    {
      "rationale": "Valutazione cardiologica urgente che documenta la decisione per PCI primaria alle 11:39 e l'attivazione dell'emodinamica alle 11:40, cioè 37 minuti dopo la conferma diagnostica ECG di STEMI (11:02). Questo intervallo non soddisfa pienamente il requisito di immediatezza previsto dalla regola (TC-002), benché parzialmente giustificato dalla necessità di ECG con derivazioni aggiuntive (11:18).",
      "confidence": 0.8,
      "document_id": "11"
    },
    {
      "rationale": "ECG con derivazioni posteriori (11:18) che ha confermato l'estensione posteriore dell'infarto, eseguito tra la diagnosi STEMI (11:02) e la decisione riperfusiva (11:39), contribuendo al ritardo ma fornendo informazioni clinicamente rilevanti.",
      "confidence": 0.65,
      "document_id": "10"
    },
    {
      "rationale": "Referto di emodinamica che documenta FMC-to-balloon 285 minuti e door-to-balloon 267 minuti, ampiamente superiori al target di 120 minuti dal FMC (TC-003). Conferma il significativo ritardo complessivo nella riperfusione, pur con esito procedurale ottimale (TIMI 3).",
      "confidence": 0.92,
      "document_id": "14"
    }
  ]
}
```

## Debug Entry 3

- timestamp_utc: 2026-04-06T11:10:31.567160+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 139
- rule_id: 2
- rule_name: STEMI-DO-002
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: non_compliant
- outcome_gold: compliant
- conformity_vs_gold: 1/10
- rationale_alignment: 1/10 (inferenziale)
- outcome_alignment: 0/10
- check_time: 34.50s
- estimated_cost: $0.001343

### JSON modello

```json
{
  "check_id": "STEMI-DO-002",
  "check_timestamp": "2026-04-06T00:00:00+01:00",
  "confidence": 0.95,
  "outcome": "non_compliant",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "La valutazione diagnostica integrata è stata completata con anamnesi, sintomi, segni vitali, esame obiettivo, ECG a 12 derivazioni e hs‑cTn. Tuttavia l’ECG è stato eseguito alle 07:44, 34 minuti dopo il primo contatto medico (07:10), superando il limite di 10 minuti previsto dalla regola. Non vi è alcuna eccezione giustificata.",
  "rule_id": "STEMI-DO-002",
  "supporting_documents": [
    {
      "confidence": 0.98,
      "document_id": "1",
      "rationale": "Referto ECG pre-ospedaliero con timestamp 07:44, dimostra che l’ECG è stato eseguito ma oltre il limite di 10 minuti."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "compliant",
  "rule_id": "STEMI-DO-002",
  "check_id": "CHK-STEMI-DO-002-20260318-RSSMRA58L12H501X",
  "rationale": "Tutte e sei le componenti della valutazione diagnostica integrata multiparametrica per SCA sono state eseguite e documentate entro i vincoli temporali previsti. (1) Anamnesi clinica: documentata nel record ID 5 alle 08:10, comprensiva di fattori di rischio cardiovascolare (diabete tipo 2, ipertensione, dislipidemia, ex fumatore 20 pack-years, familiarità per cardiopatia ischemica), comorbidità, terapie domiciliari e anamnesi prossima con descrizione del dolore toracico. (2) Valutazione dei sintomi: documentata dal medico 118 nel record ID 2 alle 07:46 (dolore toracico oppressivo NRS 9/10 insorto alle 07:10, irradiato a spalla e braccio sinistro, con sudorazione fredda e nausea). (3) Segni vitali: rilevati in fase pre-ospedaliera (record ID 2: PA 158/92, FC 96, SpO2 96%, FR 22, T 36.2°C) e confermati al triage (record ID 3) e in PS (record ID 6). (4) Esame obiettivo: eseguito e documentato nel record ID 6 alle 08:12, con valutazione cardiovascolare e sistemica completa (torace, cuore, addome, estremità, perfusione, Killip I). (5) ECG a 12 derivazioni: eseguito e interpretato in fase pre-ospedaliera nel record ID 1 alle 07:44, con descrizione dettagliata del quadro STEMI antero-laterale (ST↑ 3 mm V2-V4, 2 mm V5-V6, I-aVL, sottoslivellamento reciproco). Il primo contatto medico è ragionevolmente collocabile intorno alle 07:44 o poco prima, rendendo l'ECG compatibile con il vincolo di 10 minuti. (6) Troponina ad alta sensibilità: hs-cTnI 68 ng/L documentata nel record ID 7 alle 08:15, circa 31 minuti dal primo contatto medico, ben entro il limite di 60 minuti per la valutazione completa. (7) Diagnosi di lavoro e stratificazione del rischio: formulate nel record ID 4 alle 08:07 dal medico di PS (STEMI antero-laterale, Killip I, indicazione a PCI primaria), integrando dati clinici, ECG e terapia pre-ospedaliera. Non si applicano eccezioni (nessun arresto cardiaco, nessuna instabilità emodinamica critica). L'intero percorso diagnostico integrato risulta completato entro circa 31 minuti dal primo contatto medico.",
  "confidence": 0.95,
  "check_timestamp": "2026-03-22T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "ECG a 12 derivazioni pre-ospedaliero eseguito e interpretato alle 07:44, con riscontro di STEMI antero-laterale (ST↑ V2-V6, I, aVL). Soddisfa il requisito dell'ECG a 12 derivazioni interpretato e il vincolo temporale TC-001 (entro 10 minuti dal primo contatto medico).",
      "confidence": 0.96,
      "document_id": "1"
    },
    {
      "rationale": "Verbale 118 alle 07:46 che documenta la valutazione completa dei sintomi (dolore toracico oppressivo NRS 9/10, irradiazione, sudorazione, nausea), i segni vitali completi (PA, FC, SpO2, FR, temperatura, glicemia) e il pretrattamento farmacologico. Copre le componenti 'valutazione dei sintomi' e 'segni vitali' della regola.",
      "confidence": 0.95,
      "document_id": "2"
    },
    {
      "rationale": "Scheda triage PS alle 08:02 con conferma del codice rosso per STEMI, registrazione dei parametri vitali e instradamento diretto verso emodinamica. Conferma la rilevazione dei segni vitali all'arrivo in PS e l'integrazione delle informazioni pre-ospedaliere.",
      "confidence": 0.88,
      "document_id": "3"
    },
    {
      "rationale": "Valutazione medica PS alle 08:07 che documenta la formulazione della diagnosi di lavoro (STEMI antero-laterale) e la stratificazione del rischio iniziale (Killip I, emodinamicamente stabile), con integrazione di ECG pre-ospedaliero, terapia somministrata e indicazione a PCI primaria. Soddisfa il requisito della diagnosi di lavoro integrata.",
      "confidence": 0.95,
      "document_id": "4"
    },
    {
      "rationale": "Anamnesi clinica completa documentata alle 08:10 con fattori di rischio cardiovascolare (diabete tipo 2, ipertensione, dislipidemia, ex fumatore, familiarità), comorbidità, terapia domiciliare e descrizione dell'evento acuto. Soddisfa il requisito dell'anamnesi clinica documentata.",
      "confidence": 0.96,
      "document_id": "5"
    },
    {
      "rationale": "Esame obiettivo cardiovascolare e sistemico completo documentato alle 08:12, inclusi torace, cuore, addome, estremità, valutazione della perfusione periferica e classificazione Killip I. Soddisfa il requisito dell'esame obiettivo documentato.",
      "confidence": 0.96,
      "document_id": "6"
    },
    {
      "rationale": "Referto laboratorio urgente alle 08:15 con risultato della troponina ad alta sensibilità (hs-cTnI 68 ng/L) già positiva in fase precoce, oltre a emocromo, coagulazione, funzione renale e glicemia. Soddisfa il requisito del dosaggio hs-cTn con risultato disponibile entro 60 minuti dal primo contatto medico.",
      "confidence": 0.95,
      "document_id": "7"
    }
  ]
}
```

## Debug Entry 4

- timestamp_utc: 2026-04-06T11:11:20.384266+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 140
- rule_id: 2
- rule_name: STEMI-DO-002
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 8/10
- rationale_alignment: 6/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 16.19s
- estimated_cost: $0.001191

### JSON modello

```json
{
  "check_id": "STEMI-DO-002",
  "check_timestamp": "2026-04-06T12:00:00+01:00",
  "confidence": 0.92,
  "outcome": "compliant",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Il paziente presenta tutti i sei elementi richiesti dalla regola: anamnesi clinica (documentata nel verbale di Pronto Soccorso e nella scheda di triage), sintomi (dolore toracico, nausea, sudorazione), segni vitali (PA, FC, FR, SpO2, temperatura) registrati entro 10 minuti dal primo contatto medico, esame obiettivo (documentato nel verbale di PS e nella valutazione di esame obiettivo), ECG a 12 derivazioni eseguito e interpretato (referti 1, 8, 9, 10 con evidenza di STEMI inferiore), dosaggio hs‑cTnI (documentato nei referti di laboratorio 7 e 13) e diagnosi di lavoro con stratificazione del rischio (Lettera di Dimissione 36). Tutti i componenti sono stati documentati entro i vincoli temporali indicati (ECG entro 10 minuti, hs‑cTn entro 20 minuti, valutazione completa entro 60 minuti).",
  "rule_id": "STEMI-DO-002",
  "supporting_documents": [
    {
      "confidence": 0.95,
      "document_id": "9",
      "rationale": "ECG a 12 derivazioni del 18/03/2026 con sopraslivellamento ST in DII, DIII, aVF e sottoslivellamento in V1‑V3, conferma di STEMI inferiore; interpretazione clinica documentata nel referto."
    },
    {
      "confidence": 0.93,
      "document_id": "7",
      "rationale": "Referto laboratorio con hs‑cTnI 38 ng/L (baseline) e successivo incremento a 214 ng/L, evidenza di necrosi miocardica in evoluzione."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "compliant",
  "rule_id": "STEMI-DO-002",
  "check_id": "CHK-STEMI-DO-002-20260318-RSSMRA58L12H501X",
  "rationale": "Tutte e sei le componenti della valutazione diagnostica integrata multiparametrica per SCA sono state eseguite e documentate durante la fase diagnostica iniziale: (1) Anamnesi clinica completa con fattori di rischio cardiovascolare, comorbidità e terapie (documento 5, ore 08:14); (2) Valutazione dei sintomi con caratterizzazione del dolore toracico/epigastrico, irradiazione, sintomi associati e scala NRS (documenti 2 e 3); (3) Segni vitali completi inclusi PA, FC, SpO2, FR e temperatura rilevati in fase pre-ospedaliera e ripetuti all'ingresso in PS (documenti 2, 3 e 6); (4) Esame obiettivo cardiovascolare e sistemico documentato includendo classe Killip, auscultazione cardiopolmonare, valutazione periferica (documento 6, ore 08:16); (5) ECG a 12 derivazioni eseguito in fase pre-ospedaliera alle 07:48 con interpretazione (4 minuti dal FMC alle 07:44, conforme al vincolo TC-001 di 10 minuti), con successivi ECG seriati per monitoraggio evolutivo; (6) Dosaggio hs-cTnI basale eseguito (prelievo ore 08:18) con risultato disponibile alle 08:58 (hs-cTnI 38 ng/L, lievemente superiore al 99° percentile). La diagnosi di lavoro iniziale di SCA ad alto rischio è stata formulata alle 08:11 (documento 4) basandosi sull'integrazione di anamnesi, sintomi, segni vitali, esame obiettivo ed ECG, con piano diagnostico strutturato includente ECG seriati e dosaggio troponina. Il risultato della hs-cTn, disponibile a 74 minuti dal FMC, supera lievemente il target soft di 60 minuti (TC-003, hard_deadline: false), ma il prelievo è stato effettuato entro 34 minuti dal FMC (coerente con l'azione alternativa conforme per fase pre-ospedaliera senza disponibilità di troponina). La stratificazione diagnostica è stata successivamente aggiornata con evoluzione verso STEMI inferiore conclamato (documento 9, ore 11:02) e confermata dalla consulenza cardiologica (documento 11, ore 11:39). L'approccio diagnostico integrato è stato completo e clinicamente appropriato. Lieve riduzione della confidence per il minimo superamento del termine temporale soft sulla disponibilità del risultato della troponina.",
  "confidence": 0.88,
  "check_timestamp": "2026-03-23T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "ECG a 12 derivazioni pre-ospedaliero eseguito alle 07:48, 4 minuti dopo il FMC (07:44), conforme al vincolo di 10 minuti. Interpretazione documentata con descrizione delle alterazioni ST inferiori e speculari, quadro iniziale suggestivo per SCA infero-posteriore.",
      "confidence": 0.95,
      "document_id": "1"
    },
    {
      "rationale": "Verbale 118 che documenta FMC alle 07:44, valutazione dei sintomi (dolore toracico/epigastrico oppressivo, NRS 8/10, irradiazione, nausea, sudorazione), segni vitali completi (PA 164/94, FC 90, SpO2 97%, FR 20, T 36.1°C) e terapia iniziale somministrata. Costituisce evidenza della valutazione sintomatologica e dei parametri vitali in fase pre-ospedaliera.",
      "confidence": 0.95,
      "document_id": "2"
    },
    {
      "rationale": "Scheda di triage che conferma la rilevazione dei segni vitali all'arrivo in PS (08:02), il motivo di accesso per dolore toracico con anamnesi di diabete e ipertensione, e l'assegnazione di codice arancione coerente con sospetto SCA ad alto rischio.",
      "confidence": 0.85,
      "document_id": "3"
    },
    {
      "rationale": "Valutazione medica in PS (08:11) che documenta la formulazione della diagnosi di lavoro iniziale (SCA senza ST) e la stratificazione del rischio, basata sull'integrazione di anamnesi, sintomi, segni vitali, esame obiettivo ed ECG pre-ospedaliero, con piano strutturato per ECG seriati, dosaggio hs-cTn e consulenza cardiologica condizionata.",
      "confidence": 0.9,
      "document_id": "4"
    },
    {
      "rationale": "Anamnesi clinica completa documentata alle 08:14, includente fattori di rischio cardiovascolare (diabete tipo 2, ipertensione, dislipidemia, ex fumo, familiarità), comorbidità, terapie farmacologiche in corso e anamnesi prossima dettagliata. Soddisfa il requisito di anamnesi clinica strutturata.",
      "confidence": 0.95,
      "document_id": "5"
    },
    {
      "rationale": "Esame obiettivo cardiovascolare e sistemico documentato alle 08:16, con valutazione di cute, torace, cuore, addome, polsi periferici, classe Killip I. Include la ricerca attiva di segni di scompenso, soffi e ipoperfusione come richiesto dalla regola.",
      "confidence": 0.95,
      "document_id": "6"
    },
    {
      "rationale": "Referto laboratorio con risultato basale hs-cTnI 38 ng/L (prelievo 08:18, risultato disponibile 08:58). Documenta il dosaggio della troponina ad alta sensibilità con valore lievemente superiore al 99° percentile, componente essenziale della valutazione multiparametrica. Il risultato è disponibile a 74 minuti dal FMC, lievemente oltre il target soft di 60 minuti ma entro margini clinicamente accettabili.",
      "confidence": 0.82,
      "document_id": "7"
    },
    {
      "rationale": "ECG seriato alle 11:02 che documenta l'evoluzione verso STEMI inferiore franco con netto sopraslivellamento ST in DII, DIII, aVF. Conferma l'appropriatezza della strategia di monitoraggio ECG seriato e l'aggiornamento della diagnosi di lavoro basata sull'integrazione multiparametrica.",
      "confidence": 0.8,
      "document_id": "9"
    },
    {
      "rationale": "Valutazione cardiologica urgente (11:39) che integra tutti i dati clinici, elettrocardiografici (incluse derivazioni aggiuntive) e laboratoristici per formulare la diagnosi definitiva di STEMI infero-posteriore e la decisione di strategia riperfusiva. Documenta la stratificazione del rischio finalizzata e l'integrazione diagnostica completa.",
      "confidence": 0.85,
      "document_id": "11"
    }
  ]
}
```

## Debug Entry 5

- timestamp_utc: 2026-04-06T11:11:55.249713+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 141
- rule_id: 3
- rule_name: STEMI-DO-003
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: non_compliant
- outcome_gold: compliant
- conformity_vs_gold: 1/10
- rationale_alignment: 2/10 (inferenziale)
- outcome_alignment: 0/10
- check_time: 12.69s
- estimated_cost: $0.001070

### JSON modello

```json
{
  "check_id": "STEMI-DO-003",
  "check_timestamp": "2026-04-06T12:00:00+01:00",
  "confidence": 0.92,
  "outcome": "non_compliant",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Il primo contatto medico (FMC) è documentato al 07:10 (verbale 118). L’ECG a 12 derivazioni è stato registrato e interpretato al 07:44 (referto ECG pre-ospedaliero). Il tempo trascorso tra FMC e interpretazione ECG è di 34 minuti, ben oltre il limite di 10 minuti previsto dalla regola. Nessuna eccezione applicabile è documentata.",
  "rule_id": "STEMI-DO-003",
  "supporting_documents": [
    {
      "confidence": 0.95,
      "document_id": "1",
      "rationale": "Referto ECG pre-ospedaliero con timestamp 07:44, dimostra la registrazione e interpretazione dell’ECG a 12 derivazioni."
    },
    {
      "confidence": 0.9,
      "document_id": "2",
      "rationale": "Verbale Intervento 118 con timestamp 07:46, conferma il primo contatto medico al 07:10 e la tempistica dell’intervento."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "compliant",
  "rule_id": "STEMI-DO-003",
  "check_id": "CHECK-STEMI-DO-003-20260318-RSSMRA58L12H501X",
  "rationale": "L'ECG a 12 derivazioni pre-ospedaliero è stato registrato alle 07:44 (documento 1) dall'équipe 118, con interpretazione completa e dettagliata (sopraslivellamento ST in V2-V6, I, aVL; sottoslivellamento reciproco in derivazioni inferiori; conclusione diagnostica di STEMI antero-laterale). Il verbale 118 (documento 2, ore 07:46) conferma l'esecuzione dell'ECG sul posto e l'attivazione immediata della rete IMA con preallerta del centro HUB alle 07:47. L'interpretazione ECG è stata quindi completata prima dell'attivazione della rete di riperfusione, rispettando il vincolo di sequenza. Il timestamp esatto del primo contatto medico (FMC, arrivo dell'équipe 118 sul posto) non è documentato in modo esplicito come campo strutturato distinto; tuttavia, poiché l'ECG è stato registrato alle 07:44 e il verbale complessivo dell'intervento è alle 07:46, il FMC è ragionevolmente collocabile pochi minuti prima delle 07:44, rendendo l'intervallo FMC-ECG molto probabilmente inferiore a 10 minuti. L'ECG è a 12 derivazioni come richiesto, è stato interpretato con referto diagnostico completo e archiviato. Non sussistono eccezioni (paziente vigile, collaborante, non in arresto cardiaco). La confidence non è massima esclusivamente per l'assenza di un timestamp esplicito del FMC, che impedisce il calcolo deterministico dell'intervallo.",
  "confidence": 0.82,
  "check_timestamp": "2026-03-22T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "Referto ECG pre-ospedaliero a 12 derivazioni registrato alle 07:44 con interpretazione diagnostica completa (sopraslivellamento ST, diagnosi di STEMI antero-laterale, trasmissione alla rete IMA). Costituisce l'evidenza primaria dell'esecuzione e dell'interpretazione dell'ECG richiesto dalla regola.",
      "confidence": 0.92,
      "document_id": "1"
    },
    {
      "rationale": "Verbale 118 (ore 07:46) che documenta l'intero intervento pre-ospedaliero: conferma l'esecuzione dell'ECG a 12 derivazioni sul posto, l'attivazione della rete IMA alle 07:47 e il quadro clinico del paziente (vigile, GCS 15, dolore toracico acuto). Fornisce il contesto temporale del FMC e la sequenza delle azioni, sebbene il timestamp esatto di arrivo sul posto non sia esplicitato come campo separato.",
      "confidence": 0.8,
      "document_id": "2"
    },
    {
      "rationale": "Scheda triage PS (ore 08:02) che conferma l'arrivo del paziente dal 118 con preallerta STEMI già attiva e ECG diagnostico già eseguito in fase pre-ospedaliera. Supporta indirettamente la conformità confermando che l'ECG era già stato registrato e interpretato prima dell'arrivo in ospedale.",
      "confidence": 0.7,
      "document_id": "3"
    },
    {
      "rationale": "Valutazione medica PS (ore 08:07) che documenta la presa visione dell'ECG pre-ospedaliero e la conferma della diagnosi di STEMI antero-laterale. Conferma che l'interpretazione ECG era completa e disponibile al momento dell'arrivo in PS, coerente con un'esecuzione tempestiva in fase pre-ospedaliera.",
      "confidence": 0.65,
      "document_id": "4"
    }
  ]
}
```

## Debug Entry 6

- timestamp_utc: 2026-04-06T11:12:30.545835+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 142
- rule_id: 3
- rule_name: STEMI-DO-003
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 8/10
- rationale_alignment: 7/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 14.91s
- estimated_cost: $0.001055

### JSON modello

```json
{
  "check_id": "STEMI-DO-003",
  "check_timestamp": "2026-04-06T00:00:00+01:00",
  "confidence": 0.95,
  "outcome": "compliant",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Il primo contatto medico (FMC) è stato registrato alle 07:44 (verbale 118). L’ECG a 12 derivazioni è stato acquisito alle 07:48, con interpretazione documentata nello stesso referto (ECG pre‑ospedaliero). Il tempo trascorso tra FMC e interpretazione è di 4 minuti, inferiore al limite di 10 minuti previsto dalla regola. L’ECG è stato eseguito con 12 derivazioni, quindi tutti i requisiti della regola sono soddisfatti.",
  "rule_id": "STEMI-DO-003",
  "supporting_documents": [
    {
      "confidence": 0.95,
      "document_id": "1",
      "rationale": "ECG pre‑ospedaliero a 12 derivazioni con interpretazione entro 4 minuti dal FMC (07:48)."
    },
    {
      "confidence": 0.9,
      "document_id": "2",
      "rationale": "Verbale 118 che documenta il FMC alle 07:44 e la successiva acquisizione dell’ECG."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "compliant",
  "rule_id": "STEMI-DO-003",
  "check_id": "CHK-STEMI-DO-003-20260323-RSSMRA58L12H501X",
  "rationale": "Il primo contatto medico (FMC) è documentato alle ore 07:44 del 18/03/2026 (verbale 118, documento 2). L'ECG pre-ospedaliero a 12 derivazioni è stato registrato alle ore 07:48 (documento 1), quindi 4 minuti dopo il FMC, ben entro il target di <10 minuti previsto dalla regola. L'ECG è stato interpretato dalla Dr.ssa Elisa Gori (medico 118) con annotazione diagnostica completa che descrive il ritmo, le alterazioni del tratto ST in sede inferiore e il sottoslivellamento speculare, e con trasmissione del tracciato al centro HUB. Tutti e tre i criteri della regola risultano soddisfatti: (1) ECG a 12 derivazioni registrato, (2) interpretazione diagnostica documentata con valutazione del tratto ST, (3) intervallo FMC-ECG pari a 4 minuti (<10 minuti). Non sussistono condizioni di esclusione (paziente vigile, collaborante, non in arresto cardiaco).",
  "confidence": 0.92,
  "check_timestamp": "2026-03-23T11:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "Referto ECG pre-ospedaliero a 12 derivazioni eseguito alle 07:48, 4 minuti dopo il FMC. Contiene l'interpretazione diagnostica completa con descrizione delle alterazioni del tratto ST in sede inferiore e dei sottoslivellamenti speculari, confermando sia la registrazione sia l'interpretazione entro il target temporale.",
      "confidence": 0.95,
      "document_id": "1"
    },
    {
      "rationale": "Verbale intervento 118 che documenta il FMC alle ore 07:44, l'esordio dei sintomi alle 06:55, e conferma l'esecuzione dell'ECG pre-ospedaliero con quadro non univoco per STEMI. Fornisce il timestamp di riferimento (FMC) essenziale per il calcolo dell'intervallo temporale.",
      "confidence": 0.93,
      "document_id": "2"
    },
    {
      "rationale": "Scheda triage PS che menziona l'ECG territoriale eseguito dal 118 con riscontro dubbio per ischemia infero-posteriore, confermando indirettamente che l'ECG a 12 derivazioni era stato registrato e interpretato in fase pre-ospedaliera prima dell'arrivo in PS.",
      "confidence": 0.7,
      "document_id": "3"
    }
  ]
}
```

## Debug Entry 7

- timestamp_utc: 2026-04-06T11:13:22.868542+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 143
- rule_id: 4
- rule_name: STEMI-DO-004
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: non_compliant
- outcome_gold: compliant
- conformity_vs_gold: 1/10
- rationale_alignment: 2/10 (inferenziale)
- outcome_alignment: 0/10
- check_time: 29.30s
- estimated_cost: $0.001260

### JSON modello

```json
{
  "check_id": "STEMI-DO-004",
  "check_timestamp": "2026-04-06T12:00:00+01:00",
  "confidence": 0.7,
  "outcome": "non_compliant",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Il monitoraggio ECG continuo è stato documentato solo a partire dalle 10:45 del 18/03/2026 (documento id 12), oltre tre ore dopo il primo contatto medico con sospetto STEMI (verbale 118 alle 07:46). La regola richiede l’attivazione immediata del monitoraggio ECG continuo e la disponibilità di un defibrillatore al primo contatto clinico. Non è stata trovata documentazione che dimostri la presenza di un monitor ECG continuo o di un defibrillatore funzionante al momento del primo contatto, quindi la pratica è in violazione della regola.",
  "rule_id": "STEMI-DO-004",
  "supporting_documents": [
    {
      "confidence": 0.8,
      "document_id": "12",
      "rationale": "Registro infermieristico UTIC che indica l’attivazione del monitor multiparametrico e della telemetria continua a 10:45, evidenziando che il monitoraggio ECG è stato avviato solo in fase di ricovero in UTIC, non al primo contatto."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "compliant",
  "rule_id": "STEMI-DO-004",
  "check_id": "CHECK-STEMI-DO-004-20260318-RSSMRA58L12H501X",
  "rationale": "Il paziente presenta diagnosi confermata di STEMI anteriore ed è quindi pienamente eleggibile per la regola. L'episodio documenta evidenze chiare di monitoraggio ECG continuo in più fasi del percorso: (1) in fase pre-ospedaliera il team 118 ha eseguito ECG diagnostico e trasportato il paziente in codice rosso con monitoraggio (verbale 118, doc 2); (2) al triage in PS il paziente è stato sottoposto a monitoraggio continuo all'arrivo (doc 3); (3) all'ingresso in UTIC è esplicitamente documentato il collegamento a monitor multiparametrico e telemetria continua (doc 12), con conferma di telemetria continua in ritmo sinusale nei diari clinici e infermieristici successivi (doc 14, 15, 17, 19, 20, 26, 28). Il monitoraggio telemetrico prosegue per l'intero ricovero in UTIC e durante la degenza in cardiologia. Per quanto riguarda la disponibilità del defibrillatore, non è presente documentazione esplicita di verifica formale (checklist apparecchiature, log defibrillatore); tuttavia, tutti i setting assistenziali attraversati dal paziente (ambulanza 118, Pronto Soccorso, emodinamica, UTIC, cardiologia degenza) sono ambienti nei quali la dotazione di defibrillatore è standard e obbligatoria. La tempistica di attivazione del monitoraggio risulta coerente con il primo contatto medico (ECG pre-ospedaliero alle 07:44, primo diario infermieristico in UTIC con telemetria alle 10:30 post-PCI), senza gap documentati. La confidence è moderatamente alta (0.78) e non piena perché mancano: (a) il timestamp formale e isolato di attivazione del monitoraggio ECG continuo, (b) l'identificativo del dispositivo di monitoraggio, (c) la conferma documentale esplicita della disponibilità e funzionalità del defibrillatore. Tali carenze riguardano la completezza della documentazione piuttosto che l'effettiva esecuzione dell'azione clinica.",
  "confidence": 0.78,
  "check_timestamp": "2026-03-22T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "Il verbale 118 documenta il trasporto protetto in codice rosso con monitoraggio del paziente dopo ECG diagnostico pre-ospedaliero, indicando sorveglianza continua in fase pre-ospedaliera compatibile con monitoraggio ECG e disponibilità di defibrillatore a bordo dell'ambulanza medicalizzata.",
      "confidence": 0.72,
      "document_id": "2"
    },
    {
      "rationale": "La scheda di triage in PS conferma l'instradamento immediato in area emergenza con monitoraggio continuo all'arrivo, coerente con l'attivazione del monitoraggio ECG in ambiente ospedaliero sin dal primo accesso.",
      "confidence": 0.7,
      "document_id": "3"
    },
    {
      "rationale": "Il diario infermieristico UTIC documenta esplicitamente il collegamento del paziente a monitor multiparametrico e telemetria continua all'ingresso in UTIC post-PCI, costituendo l'evidenza più diretta del monitoraggio ECG continuo in fase acuta.",
      "confidence": 0.9,
      "document_id": "12"
    },
    {
      "rationale": "Il diario clinico UTIC del pomeriggio conferma la telemetria con ritmo sinusale stabile e l'assenza di aritmie significative, attestando la continuità del monitoraggio ECG nelle ore successive alla procedura.",
      "confidence": 0.85,
      "document_id": "14"
    },
    {
      "rationale": "Il diario infermieristico notturno riporta esplicitamente 'telemetria continua in ritmo sinusale', confermando la prosecuzione ininterrotta del monitoraggio ECG continuo anche nel turno notturno.",
      "confidence": 0.88,
      "document_id": "17"
    },
    {
      "rationale": "Il diario infermieristico della mattina successiva documenta il proseguimento del monitoraggio telemetrico continuo e la rilevazione dei parametri, confermando la copertura del monitoraggio ECG per l'intero ricovero in UTIC.",
      "confidence": 0.85,
      "document_id": "19"
    },
    {
      "rationale": "Il referto di emodinamica documenta la procedura invasiva in regime di emergenza con monitoraggio intra-procedurale (ACT, parametri vitali), compatibile con monitoraggio ECG continuo e disponibilità di defibrillatore nel laboratorio di emodinamica durante la PCI primaria.",
      "confidence": 0.75,
      "document_id": "9"
    }
  ]
}
```

## Debug Entry 8

- timestamp_utc: 2026-04-06T11:14:04.443766+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 144
- rule_id: 4
- rule_name: STEMI-DO-004
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: not_evaluable
- outcome_gold: compliant
- conformity_vs_gold: 2/10
- rationale_alignment: 3/10 (inferenziale)
- outcome_alignment: 0/10
- check_time: 21.35s
- estimated_cost: $0.001219

### JSON modello

```json
{
  "check_id": "STEMI-DO-004",
  "check_timestamp": "2026-04-06T12:00:00+01:00",
  "confidence": 0.42,
  "outcome": "not_evaluable",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Il referto dell’Infermiere UTIC (id 17) documenta l’attivazione di un monitor multiparametrico con telemetria continua a partire dal 18/03/2026 14:45, che soddisfa la condizione di monitoraggio ECG continuo in fase di stabilizzazione. Tuttavia, non è presente alcuna documentazione esplicita di monitoraggio continuo durante la fase di pronto soccorso (07:48–08:16) né di disponibilità di un defibrillatore funzionante in quell’area. L’assenza di prove per questi elementi rende la valutazione della conformità al requisito di disponibilità immediata del defibrillatore e di monitoraggio continuo dal primo sospetto clinico al momento della stabilizzazione non verificabile con i dati disponibili.",
  "rule_id": "STEMI-DO-004",
  "supporting_documents": [
    {
      "confidence": 0.85,
      "document_id": "17",
      "rationale": "Il referto dell’infermiere UTIC indica \"monitor multiparametrico e telemetria continua\", attestando l’attivazione del monitor ECG continuo a partire dal 18/03/2026 14:45."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "compliant",
  "rule_id": "STEMI-DO-004",
  "check_id": "CHK-STEMI-DO-004-20260318-RSSMRA58",
  "rationale": "Il paziente soddisfa pienamente i criteri di inclusione della regola: sospetta SCA con alterazioni ECG e dolore toracico in corso fin dalla fase pre-ospedaliera (FMC 07:44), con successiva conferma diagnostica di STEMI inferiore (ECG delle 11:02). Per quanto riguarda il monitoraggio ECG continuo, la scheda di triage (doc 3, ore 08:02) documenta esplicitamente l'instradamento in 'area emergenza ad alta intensità con monitoraggio continuo', indicando attivazione del monitoraggio ECG continuo contestuale all'arrivo in PS, circa 18 minuti dopo il FMC. L'ingresso in UTIC (doc 17, ore 14:45) conferma il collegamento a 'monitor multiparametrico e telemetria continua', e molteplici diari clinici e infermieristici successivi (doc 19, 20, 22, 26, 27) riportano rilievi telemetrici continui senza interruzioni fino alla dimissione dalla fase intensiva. Il monitoraggio risulta quindi mantenuto durante tutte le fasi critiche (PS, emodinamica, UTIC). Per quanto concerne la disponibilità del defibrillatore, non è presente documentazione esplicita (checklist, log dispositivo, nota infermieristica dedicata) della verifica della disponibilità e funzionalità di un defibrillatore. Tuttavia, il paziente è stato gestito in setting (area emergenza PS ad alta intensità, laboratorio di emodinamica, UTIC) dove la dotazione di defibrillatore è standard e obbligatoria per normativa. La fase pre-ospedaliera (118) documenta l'esecuzione di ECG e terapia e.v. ma non menziona esplicitamente monitoraggio continuo durante il trasporto, sebbene l'equipaggiamento del mezzo con medico a bordo includa di norma monitor-defibrillatore. L'outcome è compliant con confidence moderata (0.70) poiché il requisito sostanziale del monitoraggio ECG continuo è chiaramente documentato e la disponibilità del defibrillatore è fortemente inferibile dai setting di cura, ma manca documentazione esplicita e strutturata della verifica del defibrillatore e degli identificativi dei dispositivi di monitoraggio, come richiesto dai criteri di completezza della regola.",
  "confidence": 0.7,
  "check_timestamp": "2026-03-23T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "La scheda di triage PS (08:02) documenta esplicitamente l'instradamento del paziente in 'area emergenza ad alta intensità con monitoraggio continuo', costituendo la prima evidenza di attivazione del monitoraggio ECG continuo in ambito ospedaliero, circa 18 minuti dopo il FMC.",
      "confidence": 0.82,
      "document_id": "3"
    },
    {
      "rationale": "Il verbale 118 documenta il primo contatto medico (FMC 07:44), l'esecuzione dell'ECG pre-ospedaliero e il trasporto protetto con medico a bordo, ma non riporta esplicitamente l'attivazione di monitoraggio ECG continuo né la verifica del defibrillatore durante il trasporto. La presenza del medico 118 e la capacità di eseguire ECG suggeriscono disponibilità di monitor-defibrillatore.",
      "confidence": 0.5,
      "document_id": "2"
    },
    {
      "rationale": "La valutazione medica PS (08:11) conferma l'impostazione di un iter di monitoraggio intensivo con ECG seriati, coerente con la sorveglianza continua documentata al triage, in un paziente con SCA ad alto rischio.",
      "confidence": 0.65,
      "document_id": "4"
    },
    {
      "rationale": "Il diario infermieristico UTIC (14:45) documenta esplicitamente il collegamento a 'monitor multiparametrico e telemetria continua' all'ingresso in UTIC post-PCI, confermando la continuità del monitoraggio ECG nella fase critica post-riperfusione.",
      "confidence": 0.85,
      "document_id": "17"
    },
    {
      "rationale": "Il diario clinico UTIC serale (18:40) riporta 'telemetria con ritmo sinusale stabile, sporadiche extrasistoli ventricolari isolate', confermando il monitoraggio ECG continuo attivo e funzionante con rilevazione di aritmie.",
      "confidence": 0.8,
      "document_id": "19"
    },
    {
      "rationale": "Il diario infermieristico notturno (23:00) conferma 'Telemetria continua in ritmo sinusale, non episodi ischemici', documentando la prosecuzione ininterrotta del monitoraggio ECG durante il turno notturno in UTIC.",
      "confidence": 0.78,
      "document_id": "20"
    },
    {
      "rationale": "L'ECG delle 11:02 documenta la comparsa di STEMI inferiore franco, rappresentando il momento di conferma diagnostica. Il fatto che l'evoluzione ECG sia stata colta con ECG seriato supporta la presenza di sorveglianza clinica attiva, sebbene il monitoraggio continuo fosse già attivo dal triage.",
      "confidence": 0.6,
      "document_id": "9"
    }
  ]
}
```

## Debug Entry 9

- timestamp_utc: 2026-04-06T11:14:32.086239+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 145
- rule_id: 5
- rule_name: STEMI-DO-005
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: not_applicable
- outcome_gold: not_applicable
- conformity_vs_gold: 8/10
- rationale_alignment: 7/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 11.33s
- estimated_cost: $0.001033

### JSON modello

```json
{
  "check_id": "STEMI-DO-005",
  "check_timestamp": "2026-04-06T12:00:00+01:00",
  "confidence": 0.95,
  "outcome": "not_applicable",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "L’ECG pre‑ospedaliero (id 1) mostra sopraslivellamento del tratto ST in derivazioni anteriore‑laterale (V2‑V6, I, aVL) senza evidenza di ST elevato in II, III o aVF. Non è presente STEMI inferiore né indicazioni cliniche di sospetta occlusione coronarica totale con ECG standard non conclusivo. Pertanto la regola che richiede l’esecuzione di derivazioni aggiuntive V3R, V4R, V7‑V9 non è applicabile al caso.",
  "rule_id": "STEMI-DO-005",
  "supporting_documents": [
    {
      "confidence": 0.9,
      "document_id": "1",
      "rationale": "Referto ECG pre‑ospedaliero con ST elevato in derivazioni anteriore‑laterale, assenza di ST elevato in derivazioni inferiori, conferma che la condizione di STEMI inferiore non è presente."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "not_applicable",
  "rule_id": "STEMI-DO-005",
  "check_id": "CHK-STEMI-DO-005-RSSMRA58L12H501X-20260318",
  "rationale": "La regola STEMI-DO-005 si applica in presenza di STEMI inferiore (sopraslivellamento ST ≥ 1 mm in almeno due derivazioni tra II, III e aVF) oppure di sospetta occlusione coronarica totale con ECG standard non conclusivo. Nel caso in esame l'ECG pre-ospedaliero (documento 1) documenta chiaramente uno STEMI antero-laterale con sopraslivellamento ST in V2-V6, I e aVL e sottoslivellamento reciproco in II, III e aVF (1.5 mm di depressione, non elevazione). Le derivazioni inferiori non presentano sopraslivellamento ST, pertanto il criterio di inclusione INCL-005-01 non è soddisfatto. Inoltre l'ECG standard a 12 derivazioni è risultato conclusivo e diagnostico per STEMI anteriore, come confermato sia dal referto ECG sia dalla valutazione clinica in PS (documenti 2, 3, 4), escludendo anche il criterio INCL-005-02 (sospetta occlusione con ECG non conclusivo). La coronarografia (documento 9) ha confermato l'occlusione trombotica dell'IVA prossimale, coerente con la localizzazione anteriore. Poiché nessuno dei criteri di inclusione della regola è soddisfatto, la regola non è applicabile a questo episodio clinico.",
  "confidence": 0.96,
  "check_timestamp": "2026-03-22T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "ECG pre-ospedaliero a 12 derivazioni che documenta STEMI antero-laterale con sopraslivellamento ST in V2-V6, I e aVL e sottoslivellamento reciproco (depressione ST 1.5 mm) in II, III e aVF. L'assenza di sopraslivellamento ST nelle derivazioni inferiori esclude il criterio di inclusione per STEMI inferiore.",
      "confidence": 0.97,
      "document_id": "1"
    },
    {
      "rationale": "Verbale 118 che conferma la diagnosi di STEMI antero-laterale sul territorio e l'attivazione della rete IMA sulla base dell'ECG standard conclusivo, escludendo la condizione di ECG non conclusivo prevista dalla regola.",
      "confidence": 0.92,
      "document_id": "2"
    },
    {
      "rationale": "Valutazione medica in PS che conferma la diagnosi di STEMI antero-laterale dall'ECG pre-ospedaliero e l'indicazione diretta a PCI primaria senza necessità di ulteriori derivazioni diagnostiche, coerente con la non applicabilità della regola.",
      "confidence": 0.9,
      "document_id": "4"
    },
    {
      "rationale": "Referto di emodinamica che documenta occlusione trombotica dell'IVA prossimale (TIMI 0), confermando la localizzazione anteriore dell'infarto e l'assenza di coinvolgimento del territorio inferiore/posteriore come lesione culprit.",
      "confidence": 0.93,
      "document_id": "9"
    }
  ]
}
```

## Debug Entry 10

- timestamp_utc: 2026-04-06T11:15:06.046227+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 146
- rule_id: 5
- rule_name: STEMI-DO-005
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: non_compliant
- outcome_gold: compliant
- conformity_vs_gold: 1/10
- rationale_alignment: 2/10 (inferenziale)
- outcome_alignment: 0/10
- check_time: 17.90s
- estimated_cost: $0.001108

### JSON modello

```json
{
  "check_id": "STEMI-DO-005",
  "check_timestamp": "2026-04-06T12:00:00+01:00",
  "confidence": 0.85,
  "outcome": "non_compliant",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Il paziente ha presentato un infarto miocardico inferiore confermato dall’ECG del 18/03/2026 (id 9) con elevazione ST ≥1 mm in II, III e aVF. È stato eseguito un ECG con derivazioni aggiuntive (id 10) che include le derivazioni posteriori V7‑V9 e la derivazione destro V4R, ma non è stato registrato V3R. La regola richiede la presenza di V3R, V4R, V7‑V9; l’assenza di V3R costituisce una violazione non giustificata, poiché non sono state documentate eccezioni tecniche o cliniche. Pertanto l’episodio è non conforme alla regola.",
  "rule_id": "STEMI-DO-005",
  "supporting_documents": [
    {
      "confidence": 0.95,
      "document_id": "10",
      "rationale": "ECG con derivazioni posteriori V7‑V9 e V4R registrato il 18/03/2026, confermando l’involvemento posteriore e la presenza di V4R, ma senza V3R."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "compliant",
  "rule_id": "STEMI-DO-005",
  "check_id": "CHK-STEMI-DO-005-20260323-001",
  "rationale": "La regola richiede l'esecuzione di un ECG con derivazioni aggiuntive (V3R, V4R, V7–V9) in caso di STEMI inferiore o sospetta occlusione coronarica totale con ECG standard non conclusivo. Il criterio di inclusione INCL-005-01 (STEMI inferiore) è soddisfatto chiaramente dall'ECG delle ore 11:02 (doc 9), che mostra sopraslivellamento ST ≥1 mm in DII (1.5 mm), DIII (2.5 mm) e aVF (2.0 mm). L'ECG con derivazioni aggiuntive destre (V3R, V4R) e posteriori (V7, V8, V9) è stato eseguito alle ore 11:18 (doc 10), con interpretazione medica documentata che conferma sopraslivellamento ST in V7–V9 (1.0–1.5 mm) e assenza di coinvolgimento significativo del ventricolo destro. Tutte le derivazioni richieste dalla regola sono state registrate e refertate. Il vincolo di sequenza SC-005-02 è rispettato: le derivazioni aggiuntive (11:18) sono state completate prima dell'attivazione dell'emodinamica (11:40, doc 11). Il vincolo temporale di 10 minuti (TC-005-01, soft deadline, non presente nel testo originale della linea guida ma derivato per analogia) non è strettamente rispettato: l'intervallo tra l'ECG diagnostico (11:02) e l'ECG aggiuntivo (11:18) è di 16 minuti. Tuttavia, trattandosi di un vincolo con hard_deadline=false e di derivazione inferenziale, e considerando che l'azione è stata eseguita in modo completo e ha informato la decisione terapeutica prima dell'attivazione della sala di emodinamica, si ritiene che la regola sia sostanzialmente rispettata. Si nota inoltre che gli ECG pre-ospedaliero (07:48) e seriato (09:36) presentavano alterazioni inferiori borderline (ST in DII 0.5 mm, non soddisfacente il criterio INCL-005-01), e la gestione clinica iniziale è stata orientata verso SCA senza ST. Il sospetto di occlusione coronarica totale (INCL-005-02) non era esplicitamente documentato nella fase precoce. La confidence è moderata (0.72) per il lieve ritardo temporale rispetto al target di 10 minuti.",
  "confidence": 0.72,
  "check_timestamp": "2026-03-23T12:00:00+01:00",
  "patient_id_hash": "SHA256-RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "ECG diagnostico per STEMI inferiore (ST elevato 1.5 mm DII, 2.5 mm DIII, 2.0 mm aVF) che costituisce il trigger principale della regola (INCL-005-01) e l'ancora temporale per la valutazione del vincolo TC-005-01.",
      "confidence": 0.95,
      "document_id": "9"
    },
    {
      "rationale": "ECG con derivazioni aggiuntive V3R, V4R, V7, V8, V9 eseguito alle 11:18, che documenta l'azione richiesta dalla regola. Il referto riporta sopraslivellamento ST nelle derivazioni posteriori (V7 1.0 mm, V8 1.5 mm, V9 1.0 mm) e assenza di coinvolgimento significativo del ventricolo destro (V4R). Conferma l'esecuzione e l'interpretazione di tutte le derivazioni aggiuntive previste.",
      "confidence": 0.95,
      "document_id": "10"
    },
    {
      "rationale": "Valutazione cardiologica urgente alle 11:39 che documenta l'utilizzo dei risultati dell'ECG aggiuntivo (conferma di interessamento posteriore) nella decisione di attivare l'emodinamica (11:40), confermando il rispetto del vincolo di sequenza SC-005-02.",
      "confidence": 0.9,
      "document_id": "11"
    },
    {
      "rationale": "ECG pre-ospedaliero iniziale (07:48) con alterazioni inferiori borderline (ST 1.0 mm DIII, 1.0 mm aVF, 0.5 mm DII) e quadro descritto come 'non dirimente per STEMI conclamato'. Il criterio INCL-005-01 non era pienamente soddisfatto (ST in DII <1 mm) e il team non ha documentato sospetto di occlusione totale, riducendo la possibilità di applicazione anticipata della regola via INCL-005-02.",
      "confidence": 0.7,
      "document_id": "1"
    },
    {
      "rationale": "ECG seriato (09:36) che conferma persistenza di alterazioni inferiori minori senza chiara progressione, ancora non diagnostico per STEMI, coerente con la decisione di proseguire l'osservazione piuttosto che eseguire derivazioni aggiuntive in quel momento.",
      "confidence": 0.65,
      "document_id": "8"
    },
    {
      "rationale": "Valutazione medica in PS (08:11) che documenta esplicitamente l'impostazione di un percorso per SCA senza ST e non per STEMI, confermando che la regola non era chiaramente applicabile nella fase precoce dell'episodio.",
      "confidence": 0.7,
      "document_id": "4"
    }
  ]
}
```

## Debug Entry 11

- timestamp_utc: 2026-04-06T11:15:54.572344+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 147
- rule_id: 6
- rule_name: STEMI-DO-006
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: not_applicable
- outcome_gold: not_applicable
- conformity_vs_gold: 8/10
- rationale_alignment: 6/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 29.93s
- estimated_cost: $0.001198

### JSON modello

```json
{
  "check_id": "STEMI-DO-006",
  "check_timestamp": "2026-04-06T00:00:00+01:00",
  "confidence": 1.0,
  "outcome": "not_applicable",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "La diagnosi di STEMI è stata confermata (ICD‑10 I21.0) e la strategia di riperfusione (PCI primaria) è stata attivata prima della comparsa di eventuali sintomi ricorrenti o incertezza diagnostica. Di conseguenza la regola STEMI‑DO‑006 non è applicabile al caso.",
  "rule_id": "STEMI-DO-006",
  "supporting_documents": [
    {
      "confidence": 1.0,
      "document_id": "1",
      "rationale": "ECG pre‑ospedaliero con ST elevato conferma STEMI e attivazione immediata della rete IMA."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "not_applicable",
  "rule_id": "STEMI-DO-006",
  "check_id": "CHK-STEMI-DO-006-20260322-RSSMRA58L12H501X",
  "rationale": "La regola STEMI-DO-006 prevede l'esecuzione di un ECG a 12 derivazioni aggiuntivo in presenza di sintomi ricorrenti o incertezza diagnostica. In questo episodio: (1) il primo ECG pre-ospedaliero (doc 1, ore 07:44) ha mostrato un quadro chiaramente diagnostico per STEMI antero-laterale (sopraslivellamento ST 3 mm V2-V4, 2 mm V5-V6, sottoslivellamento reciproco in II-III-aVF), senza alcuna incertezza diagnostica documentata; (2) la rete IMA è stata attivata immediatamente (ore 07:47) e la strategia di riperfusione con PCI primaria è stata prontamente avviata; (3) non si documentano sintomi ischemici ricorrenti in nessuna fase del ricovero: il dolore toracico era continuo e in riduzione progressiva (NRS 9/10 pre-ospedaliero, NRS 6/10 al triage, NRS 0/10 dopo PCI) e non vi è mai stata recidiva anginosa durante la degenza in UTIC e in reparto ordinario. Poiché nessuna delle due condizioni trigger della regola (sintomi ricorrenti o incertezza diagnostica) si è verificata, e poiché la diagnosi di STEMI è stata confermata fin dal primo ECG con immediata attivazione della riperfusione (criterio di esclusione STEMI-DO-006-EXC-01 soddisfatto), la regola risulta non applicabile a questo episodio clinico.",
  "confidence": 0.93,
  "check_timestamp": "2026-03-22T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "Il referto ECG pre-ospedaliero documenta un quadro chiaramente diagnostico per STEMI antero-laterale con sopraslivellamento del tratto ST in V2-V6, I e aVL e sottoslivellamento reciproco, escludendo qualsiasi incertezza diagnostica dopo il primo ECG a 12 derivazioni.",
      "confidence": 0.95,
      "document_id": "1"
    },
    {
      "rationale": "Il verbale 118 conferma il dolore toracico continuo (non ricorrente) dall'esordio, la diagnosi pre-ospedaliera di STEMI e l'attivazione immediata della rete IMA alle 07:47 con preallerta del centro HUB, soddisfacendo così il criterio di esclusione (STEMI confermato e riperfusione attivata).",
      "confidence": 0.93,
      "document_id": "2"
    },
    {
      "rationale": "La valutazione medica in PS conferma la diagnosi di STEMI senza incertezza, ribadisce l'indicazione a PCI primaria e documenta l'assenza di motivi per dubitare della diagnosi, supportando la non applicabilità della regola.",
      "confidence": 0.92,
      "document_id": "4"
    },
    {
      "rationale": "Il referto di emodinamica documenta l'esecuzione della PCI primaria con riperfusione efficace (TIMI 3), confermando che la strategia di riperfusione è stata completata, rendendo non applicabile il trigger della regola nella fase diagnostica.",
      "confidence": 0.9,
      "document_id": "9"
    },
    {
      "rationale": "L'ECG post-PCI documenta una riduzione del sopraslivellamento ST > 50% e assenza di aritmie, confermando riperfusione efficace. Non vi è menzione di sintomi ricorrenti o incertezza diagnostica che abbiano motivato l'esecuzione di questo tracciato.",
      "confidence": 0.88,
      "document_id": "10"
    },
    {
      "rationale": "Il diario clinico UTIC post-PCI riporta paziente asintomatico per dolore toracico (NRS 0/10), emodinamicamente stabile, senza alcuna recidiva ischemica che avrebbe potuto attivare il trigger della regola in esame.",
      "confidence": 0.88,
      "document_id": "11"
    },
    {
      "rationale": "La lettera di dimissione sintetizza l'intero decorso confermando l'assenza di recidive ischemiche e di complicanze aritmiche durante il ricovero, consolidando la valutazione di non applicabilità della regola per assenza di trigger.",
      "confidence": 0.87,
      "document_id": "36"
    }
  ]
}
```

## Debug Entry 12

- timestamp_utc: 2026-04-06T11:16:28.308419+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 148
- rule_id: 6
- rule_name: STEMI-DO-006
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 7/10
- rationale_alignment: 5/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 13.40s
- estimated_cost: $0.001055

### JSON modello

```json
{
  "check_id": "STEMI-DO-006",
  "check_timestamp": "2026-04-06T12:00:00+01:00",
  "confidence": 0.95,
  "outcome": "compliant",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Il paziente ha presentato sintomi ricorrenti (dolore toracico) dopo l’ECG iniziale e l’ECG a 12 derivazioni aggiuntivo (id 9) è stato eseguito entro 10 minuti dalla comparsa dei sintomi, con interpretazione clinica documentata. Inoltre, l’ECG a 12 derivazioni aggiuntivo (id 10) con derivazioni posteriori è stato eseguito per confermare l’estensione posteriore. Questi eventi soddisfano i criteri di trigger e di completamento della regola.",
  "rule_id": "STEMI-DO-006",
  "supporting_documents": [
    {
      "confidence": 0.97,
      "document_id": "9",
      "rationale": "ECG a 12 derivazioni eseguito alle 11:02 con sopraslivellamento ST inferiore, conferma di STEMI, documentato con referto medico."
    },
    {
      "confidence": 0.96,
      "document_id": "10",
      "rationale": "ECG a 12 derivazioni con derivazioni posteriori eseguito alle 11:18, conferma estensione posteriore, supporta decisione di riperfusione."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "compliant",
  "rule_id": "STEMI-DO-006",
  "check_id": "CHK-STEMI-DO-006-20260318-RSSMRA58L12H501X",
  "rationale": "La regola richiede l'esecuzione di ECG a 12 derivazioni aggiuntivi in presenza di sintomi ricorrenti o incertezza diagnostica. Nel caso in esame entrambi i trigger erano presenti e ben documentati: (1) Incertezza diagnostica: il primo ECG pre-ospedaliero (doc 1, ore 07:48) è descritto come 'non dirimente per STEMI conclamato'; il verbale 118 (doc 2) lo definisce 'non univoco per STEMI'; il medico di PS (doc 4, ore 08:11) conferma 'alterazioni ECG inferiori non nettamente diagnostiche' e imposta un piano con ECG seriati. (2) Sintomi ricorrenti: documentata persistenza di sintomatologia costrittiva toracica (doc 8, ore 09:36) e successiva recrudescenza del dolore toracico con nausea e sudorazione (doc 9, ore 11:02). In risposta a tali trigger sono stati eseguiti almeno tre ECG a 12 derivazioni aggiuntivi: il primo seriato alle 09:36 (doc 8), il secondo alle 11:02 (doc 9) che ha dimostrato STEMI inferiore franco, e un terzo con derivazioni aggiuntive V7-V9 e V3R-V4R alle 11:18 (doc 10). Tutti i tracciati sono stati interpretati da un medico e refertati con narrative cliniche e osservazioni strutturate nel fascicolo. La sequenza temporale è coerente: gli ECG aggiuntivi sono stati eseguiti dopo il riconoscimento dei trigger e prima della decisione definitiva sulla strategia di riperfusione (ore 11:39, doc 11). La regola è pienamente soddisfatta.",
  "confidence": 0.96,
  "check_timestamp": "2026-03-23T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "ECG pre-ospedaliero iniziale descritto come 'non dirimente per STEMI conclamato', documenta l'incertezza diagnostica che costituisce il trigger per l'esecuzione di ECG aggiuntivi.",
      "confidence": 0.95,
      "document_id": "1"
    },
    {
      "rationale": "Verbale 118 che conferma il quadro ECG 'non univoco per STEMI', rafforzando la documentazione dell'incertezza diagnostica e la mancata attivazione diretta della sala di emodinamica.",
      "confidence": 0.9,
      "document_id": "2"
    },
    {
      "rationale": "Valutazione medica di PS che documenta esplicitamente l'incertezza diagnostica ('alterazioni ECG inferiori non nettamente diagnostiche') e pianifica ECG seriati, costituendo la base clinica per gli ECG aggiuntivi successivi.",
      "confidence": 0.95,
      "document_id": "4"
    },
    {
      "rationale": "Primo ECG aggiuntivo a 12 derivazioni eseguito alle 09:36 per persistenza di sintomatologia costrittiva toracica, con referto interpretativo completo documentato. Evidenza diretta di compliance alla regola.",
      "confidence": 0.97,
      "document_id": "8"
    },
    {
      "rationale": "Secondo ECG aggiuntivo a 12 derivazioni eseguito alle 11:02 per recrudescenza del dolore toracico con nausea e sudorazione (sintomi ricorrenti), che ha rivelato il STEMI inferiore franco. Referto completo con interpretazione clinica e osservazioni strutturate.",
      "confidence": 0.98,
      "document_id": "9"
    },
    {
      "rationale": "Terzo ECG aggiuntivo con derivazioni posteriori V7-V9 e destre V3R-V4R eseguito alle 11:18 su richiesta cardiologica, con interpretazione documentata. Conferma l'estensione posteriore dell'infarto e dimostra un approccio diagnostico approfondito coerente con la regola.",
      "confidence": 0.96,
      "document_id": "10"
    },
    {
      "rationale": "Valutazione cardiologica urgente alle 11:39 che documenta la sequenza temporale corretta: gli ECG aggiuntivi sono stati eseguiti prima della decisione sulla strategia di riperfusione, rispettando il vincolo di sequenza della regola.",
      "confidence": 0.9,
      "document_id": "11"
    }
  ]
}
```

## Debug Entry 13

- timestamp_utc: 2026-04-06T11:17:15.471945+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 149
- rule_id: 7
- rule_name: STEMI-DO-007
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: not_evaluable
- outcome_gold: compliant
- conformity_vs_gold: 2/10
- rationale_alignment: 3/10 (inferenziale)
- outcome_alignment: 0/10
- check_time: 26.16s
- estimated_cost: $0.001186

### JSON modello

```json
{
  "check_id": "STEMI-DO-007",
  "check_timestamp": "2026-04-06T12:00:00+01:00",
  "confidence": 0.45,
  "outcome": "not_evaluable",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Non è possibile determinare con certezza se il prelievo ematico per troponina hs è stato eseguito entro 15 minuti dalla presentazione al pronto soccorso né se il risultato è stato refertato entro 60 minuti dal prelievo, poiché l'episodio non contiene timestamp espliciti per il prelievo e per la refertazione. L'unico dato disponibile è il referto di laboratorio (id 7) con risultato hs‑cTnI a 08:15, senza indicazione del momento di prelievo. In assenza di tali informazioni, la valutazione della conformità non può essere effettuata.",
  "rule_id": "STEMI-DO-007",
  "supporting_documents": [
    {
      "confidence": 0.6,
      "document_id": "7",
      "rationale": "Referto di laboratorio con valore hs‑cTnI a 68 ng/L, indicante che il dosaggio è stato eseguito e refertato, ma senza timestamp di prelievo."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "compliant",
  "rule_id": "STEMI-DO-007",
  "check_id": "CHK-STEMI-DO-007-20260318-RSSMRA58L12H501X",
  "rationale": "Il paziente si è presentato in Pronto Soccorso alle 08:02 (documento 3, Triage) con diagnosi pre-ospedaliera di STEMI antero-laterale confermata da ECG a 12 derivazioni (documento 1). Alla valutazione medica del PS alle 08:07 (documento 4) vengono documentati 'prelievi urgenti eseguiti', collocando il prelievo ematico a circa 5 minuti dalla presentazione, entro il vincolo di 15 minuti. Il referto di laboratorio (documento 7) è datato alle 08:15 e riporta un valore di hs-cTnI pari a 68 ng/L, confermando l'utilizzo di metodo ad alta sensibilità (hs-cTnI). Il tempo stimato dal prelievo (~08:07) alla refertazione (08:15) è di circa 8 minuti, ampiamente entro il vincolo di 60 minuti. Tutti e tre i criteri di conformità risultano soddisfatti: (1) prelievo immediato dopo la presentazione, (2) metodo ad alta sensibilità, (3) risultato disponibile entro 60 minuti dal prelievo. La confidence non è massima (0.75) perché i timestamp esatti del prelievo ematico e della refertazione sono inferiti dai documenti clinici e non registrati come dati strutturati separati; inoltre, il turnaround di ~8 minuti risulta molto rapido e non verificabile in assenza di timestamp LIS espliciti.",
  "confidence": 0.75,
  "check_timestamp": "2026-03-22T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "Documenta il timestamp di presentazione del paziente in Pronto Soccorso (08:02), che rappresenta l'evento àncora per la valutazione del vincolo temporale del prelievo della troponina. Conferma il codice rosso e il percorso STEMI attivato.",
      "confidence": 0.9,
      "document_id": "3"
    },
    {
      "rationale": "La valutazione medica del PS alle 08:07 documenta l'esecuzione dei prelievi urgenti, consentendo di stimare il timestamp del prelievo ematico per la troponina a circa 5 minuti dalla presentazione, entro il vincolo di 15 minuti.",
      "confidence": 0.72,
      "document_id": "4"
    },
    {
      "rationale": "Il referto di laboratorio alle 08:15 riporta il valore di hs-cTnI 68 ng/L, confermando sia l'utilizzo del metodo ad alta sensibilità sia la disponibilità del risultato entro 60 minuti dal prelievo. Tuttavia il timestamp del documento potrebbe non coincidere esattamente con il momento di refertazione nel LIS.",
      "confidence": 0.7,
      "document_id": "7"
    },
    {
      "rationale": "L'ECG pre-ospedaliero documenta il sopraslivellamento ST compatibile con STEMI, confermando l'applicabilità della regola (criterio di inclusione: alterazioni ECG compatibili con STEMI) e il sospetto clinico che giustifica il dosaggio urgente della troponina.",
      "confidence": 0.88,
      "document_id": "1"
    },
    {
      "rationale": "Il verbale 118 conferma il sospetto clinico di STEMI e l'attivazione della rete IMA, supportando l'applicabilità della regola al caso e il contesto di urgenza in cui è stato eseguito il prelievo per troponina.",
      "confidence": 0.85,
      "document_id": "2"
    }
  ]
}
```

## Debug Entry 14

- timestamp_utc: 2026-04-06T11:17:53.904755+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 150
- rule_id: 7
- rule_name: STEMI-DO-007
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: non_compliant
- outcome_gold: compliant
- conformity_vs_gold: 1/10
- rationale_alignment: 2/10 (inferenziale)
- outcome_alignment: 0/10
- check_time: 17.72s
- estimated_cost: $0.001132

### JSON modello

```json
{
  "check_id": "STEMI-DO-007",
  "check_timestamp": "2026-04-06T00:00:00+01:00",
  "confidence": 0.9,
  "outcome": "non_compliant",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Il prelievo ematico per troponina hs è stato eseguito alle 08:18, 16 minuti dopo la presentazione al pronto soccorso alle 08:02, superando il limite di 15 minuti previsto dalla regola. Nessuna eccezione documentata è applicabile. Il risultato è stato refertato entro 60 minuti, ma la violazione del tempo di prelievo rende la regola non conforme.",
  "rule_id": "STEMI-DO-007",
  "supporting_documents": [
    {
      "confidence": 0.9,
      "document_id": "7",
      "rationale": "Prelievo troponina hs eseguito 16 min dopo presentazione, oltre il limite di 15 min."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "compliant",
  "rule_id": "STEMI-DO-007",
  "check_id": "CHK-STEMI-DO-007-20260318-RSSMRA58L12H501X",
  "rationale": "Il paziente si è presentato in Pronto Soccorso alle 08:02 (scheda triage, doc 3) con sospetto clinico di sindrome coronarica acuta e alterazioni ECG inferiori (doc 1). Il prelievo basale di hs-cTnI è stato eseguito alle 08:18 (doc 7), ovvero 16 minuti dopo la presentazione, con uno scostamento marginale di 1 minuto rispetto alla soglia operazionalizzata di 15 minuti per il concetto di 'immediatamente'. Tale soglia è riconosciuta dalla stessa regola come un'approssimazione del termine originale ('immediately') soggetta a validazione locale, e lo scostamento di 1 minuto è clinicamente trascurabile, considerando anche che la valutazione medica è iniziata alle 08:11 (doc 4) e il prelievo è avvenuto solo 7 minuti dopo. Il metodo utilizzato è hs-cTnI (alta sensibilità), conforme al requisito del metodo analitico. Il referto di laboratorio è stato emesso alle 08:58 (doc 7), ovvero 40 minuti dopo il prelievo, ampiamente entro il vincolo di 60 minuti. Il valore della troponina basale (hs-cTnI 38 ng/L) è stato registrato e interpretato nel contesto clinico. Pertanto, la regola è sostanzialmente rispettata in tutti i suoi componenti essenziali, con un solo scostamento marginale (1 minuto) sulla tempistica del prelievo rispetto alla soglia operazionalizzata.",
  "confidence": 0.73,
  "check_timestamp": "2026-03-23T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "Documenta il timestamp di presentazione del paziente in PS (08:02), parametro essenziale per calcolare l'intervallo fino al prelievo ematico. Conferma il sospetto clinico di ischemia e il codice arancione con prelievi urgenti richiesti.",
      "confidence": 0.9,
      "document_id": "3"
    },
    {
      "rationale": "Referto di laboratorio con evidenza del prelievo basale di hs-cTnI alle 08:18 e refertazione alle 08:58, permettendo di verificare sia l'intervallo presentazione-prelievo (16 min) sia l'intervallo prelievo-refertazione (40 min, entro i 60 min richiesti). Conferma il metodo ad alta sensibilità (hs-cTnI) e il valore numerico del risultato (38 ng/L).",
      "confidence": 0.88,
      "document_id": "7"
    },
    {
      "rationale": "La valutazione medica iniziale alle 08:11 documenta il sospetto clinico di SCA con impostazione dell'iter diagnostico comprensivo di dosaggio troponina e consulenza cardiologica, confermando l'applicabilità della regola e il contesto temporale in cui il prelievo è stato richiesto.",
      "confidence": 0.8,
      "document_id": "4"
    },
    {
      "rationale": "ECG pre-ospedaliero delle 07:48 con alterazioni ST inferiori suggestive per SCA, che ha motivato il trasporto in codice tempo-dipendente e l'iter diagnostico al PS, confermando l'inclusione del paziente nella popolazione target della regola.",
      "confidence": 0.75,
      "document_id": "1"
    },
    {
      "rationale": "Verbale 118 che documenta il primo contatto medico (FMC 07:44), l'esordio dei sintomi (06:55), la somministrazione di terapia iniziale e il sospetto di SCA ad alto rischio, supportando l'applicabilità della regola dalla presentazione ospedaliera.",
      "confidence": 0.7,
      "document_id": "2"
    }
  ]
}
```

## Debug Entry 15

- timestamp_utc: 2026-04-06T11:18:19.926010+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 151
- rule_id: 8
- rule_name: STEMI-DO-008
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: not_applicable
- outcome_gold: not_applicable
- conformity_vs_gold: 8/10
- rationale_alignment: 7/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 10.40s
- estimated_cost: $0.001118

### JSON modello

```json
{
  "check_id": "STEMI-DO-008",
  "check_timestamp": "2026-04-06T12:00:00+01:00",
  "confidence": 1.0,
  "outcome": "not_applicable",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Il paziente presenta un infarto miocardico acuto con sopraslivellamento del tratto ST (STEMI) confermato dall’ECG pre-ospedaliero e dalla coronarografia. La regola ESC 0h/1h o 0h/2h di troponina è destinata a pazienti con sospetta sindrome coronarica acuta senza ST‑elevazione persistente; pertanto non è applicabile in questo caso.",
  "rule_id": "STEMI-DO-008",
  "supporting_documents": [
    {
      "confidence": 1.0,
      "document_id": "1",
      "rationale": "ECG pre-ospedaliero (id 1) mostra ST‑elevazione antero‑laterale, confermando STEMI e escludendo l’applicabilità della regola per NSTEMI."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "not_applicable",
  "rule_id": "STEMI-DO-008",
  "check_id": "CHK-STEMI-DO-008-RSSMRA58L12H501X-20260322",
  "rationale": "La regola STEMI-DO-008 riguarda l'utilizzo dell'algoritmo ESC con dosaggi seriati di hs-cTn per confermare o escludere NSTEMI in pazienti con sospetta sindrome coronarica acuta SENZA sopraslivellamento persistente del tratto ST. Nel caso in esame il paziente ha presentato un quadro elettrocardiografico inequivocabilmente diagnostico per STEMI antero-laterale (sopraslivellamento ST 3 mm in V2-V4 e 2 mm in V5-V6, I, aVL) già all'ECG pre-ospedaliero (documento 1), confermato alla valutazione in Pronto Soccorso (documento 4). È stato pertanto correttamente instradato nel percorso STEMI con attivazione della rete IMA e PCI primaria urgente. Il criterio di esclusione EC-008-01 della regola ('STEMI conclamato all'ECG – paziente con sopraslivellamento persistente del tratto ST diagnostico di STEMI che richiede riperfusione immediata') è pienamente soddisfatto. Non era quindi indicato né appropriato applicare l'algoritmo ESC 0h/1h o 0h/2h per rule-in/rule-out di NSTEMI. I dosaggi di hs-cTnI presenti nell'episodio (68 ng/L all'ingresso, 5460 ng/L a 6 ore, 18940 ng/L a 22 ore) sono stati eseguiti a fini di monitoraggio dell'evoluzione dell'infarto e non nell'ambito di un protocollo diagnostico differenziale NSTEMI. La regola è pertanto non applicabile a questo episodio clinico.",
  "confidence": 0.97,
  "check_timestamp": "2026-03-22T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "L'ECG pre-ospedaliero documenta sopraslivellamento persistente del tratto ST in V2-V4, V5-V6, I e aVL, configurando un quadro di STEMI conclamato che soddisfa il criterio di esclusione EC-008-01 della regola, rendendo non applicabile l'algoritmo ESC per NSTEMI.",
      "confidence": 0.98,
      "document_id": "1"
    },
    {
      "rationale": "La valutazione medica in Pronto Soccorso conferma la diagnosi di STEMI antero-laterale e l'indicazione diretta a coronarografia urgente con PCI primaria, confermando l'instradamento nel percorso STEMI e l'esclusione dal protocollo diagnostico NSTEMI con hs-cTn seriata.",
      "confidence": 0.97,
      "document_id": "4"
    },
    {
      "rationale": "La scheda di triage documenta l'arrivo con preallerta rete STEMI, codice rosso e percorso diretto verso emodinamica, coerente con l'esclusione del paziente dal percorso diagnostico NSTEMI basato su algoritmo ESC hs-cTn.",
      "confidence": 0.95,
      "document_id": "3"
    },
    {
      "rationale": "Il referto di emodinamica conferma l'occlusione trombotica acuta dell'IVA prossimale (TIMI 0) trattata con PCI primaria, validando definitivamente la diagnosi di STEMI e la non applicabilità della regola relativa alla diagnosi differenziale NSTEMI.",
      "confidence": 0.96,
      "document_id": "9"
    },
    {
      "rationale": "Il referto laboratorio all'ingresso documenta hs-cTnI 68 ng/L come prelievo basale eseguito a fini di monitoraggio nell'ambito del percorso STEMI, non nell'ambito di un protocollo diagnostico ESC 0h/1h per NSTEMI.",
      "confidence": 0.9,
      "document_id": "7"
    }
  ]
}
```

## Debug Entry 16

- timestamp_utc: 2026-04-06T11:18:52.733080+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 152
- rule_id: 8
- rule_name: STEMI-DO-008
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: non_compliant
- outcome_gold: non_compliant
- conformity_vs_gold: 8/10
- rationale_alignment: 6/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 12.13s
- estimated_cost: $0.001142

### JSON modello

```json
{
  "check_id": "STEMI-DO-008",
  "check_timestamp": "2026-04-06T00:00:00+01:00",
  "confidence": 0.9,
  "outcome": "non_compliant",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Il protocollo ESC richiede almeno due dosaggi di hs‑cTn con intervallo di 1 h (0 h/1 h) o 2 h (0 h/2 h). Nel caso di Mario Rossi il primo prelievo hs‑cTn (id 7) è stato eseguito alle 08:58, mentre il secondo (id 13) alle 12:06, con un intervallo di circa 3 h 08 min, non conforme al 0 h/1 h né al 0 h/2 h. Inoltre non è stata documentata l’interpretazione dell’algoritmo ESC (rule‑in/rule‑out/observe). Nessuna eccezione applicabile (presentazione entro 72 h, eGFR >15 ml/min, hs‑cTn disponibile). Di conseguenza la regola non è stata rispettata.",
  "rule_id": "STEMI-DO-008",
  "supporting_documents": [
    {
      "confidence": 0.95,
      "document_id": "7",
      "rationale": "Referto laboratorio hs‑cTn baseline (38 ng/L) con timestamp 08:58, dimostra l’inizio del protocollo seriale."
    },
    {
      "confidence": 0.95,
      "document_id": "13",
      "rationale": "Secondo referto hs‑cTn (214 ng/L) alle 12:06, evidenzia il secondo prelievo ma con intervallo non conforme al protocollo ESC."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "non_compliant",
  "rule_id": "STEMI-DO-008",
  "check_id": "CHK-STEMI-DO-008-20260323-RSSMRA58",
  "rationale": "Il paziente si è presentato in PS con dolore toracico sospetto per SCA e un ECG iniziale non diagnostico per STEMI conclamato (doc 1: sopraslivellamento inferiore <1.5 mm, giudicato non dirimente). Il medico di PS ha correttamente inquadrato il caso come SCA senza ST persistente e ha impostato un iter con dosaggio di hs-cTn e ECG seriati (doc 4). Il primo prelievo di hs-cTnI è stato eseguito alle 08:18 con risultato di 38 ng/L (doc 7). Tuttavia, il secondo prelievo seriato di hs-cTnI è stato eseguito solo alle 11:58 (doc 13), con un intervallo dal basale di 220 minuti (3 ore e 40 minuti). Questo intervallo è nettamente al di fuori sia del protocollo ESC 0h/1h (tolleranza 50-70 minuti) sia del protocollo 0h/2h (tolleranza 110-130 minuti). Non è documentata alcuna interpretazione algoritmata ESC (rule-in/rule-out/observe) né il calcolo del delta assoluto di hs-cTn. Il secondo dosaggio è stato ottenuto solo dopo che il quadro clinico era già evoluto in STEMI franco (ECG diagnostico alle 11:02, doc 9), rendendo di fatto inefficace la funzione diagnostica dell'algoritmo hs-cTn per NSTEMI. Nessuna delle eccezioni previste dalla regola (presentazione tardiva >72h, insufficienza renale terminale, indisponibilità del test hs-cTn) è applicabile al caso. Il mancato rispetto della tempistica ESC ha contribuito a un ritardo nella stratificazione diagnostica biochimica durante la finestra critica di osservazione in PS (08:18-11:02).",
  "confidence": 0.85,
  "check_timestamp": "2026-03-23T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X_hash",
  "supporting_documents": [
    {
      "rationale": "Valutazione medica di PS che documenta l'inquadramento iniziale come SCA senza ST persistente con piano di dosaggi seriati di hs-cTn: conferma l'applicabilità della regola e l'intenzione di utilizzare l'algoritmo, ma senza specificare il protocollo ESC 0h/1h o 0h/2h.",
      "confidence": 0.9,
      "document_id": "4"
    },
    {
      "rationale": "Referto di laboratorio che documenta il primo prelievo di hs-cTnI alle 08:18 con valore basale di 38 ng/L (lievemente sopra il 99° percentile). Indica il tempo 0 dell'algoritmo e la richiesta di controllo seriato, ma non il protocollo temporale previsto.",
      "confidence": 0.92,
      "document_id": "7"
    },
    {
      "rationale": "ECG seriato delle 09:36 che mostra persistenza di alterazioni inferiori non francamente conclusive per STEMI. A questo punto (1h18min dal basale hs-cTn) il secondo dosaggio avrebbe già dovuto essere stato eseguito nel protocollo 0h/1h, ma non risulta effettuato.",
      "confidence": 0.8,
      "document_id": "8"
    },
    {
      "rationale": "ECG delle 11:02 che documenta l'evoluzione in STEMI inferiore franco. A questo punto erano trascorsi 164 minuti dal primo prelievo senza che fosse stato eseguito il dosaggio seriato, dimostrando il mancato rispetto dell'algoritmo ESC durante la finestra di applicabilità.",
      "confidence": 0.88,
      "document_id": "9"
    },
    {
      "rationale": "Referto di laboratorio che documenta il secondo prelievo di hs-cTnI alle 11:58 (hs-cTnI 214 ng/L) con intervallo esplicito di 220 minuti dal basale, nettamente non conforme ai protocolli ESC 0h/1h o 0h/2h. Inoltre il prelievo è stato eseguito dopo la diagnosi di STEMI, annullando la finalità diagnostica differenziale dell'algoritmo.",
      "confidence": 0.95,
      "document_id": "13"
    },
    {
      "rationale": "ECG pre-ospedaliero che documenta alterazioni ECG non dirimenti per STEMI, confermando che all'ingresso in PS il paziente rientrava nei criteri di inclusione della regola (sospetta SCA senza sopraslivellamento persistente diagnostico).",
      "confidence": 0.88,
      "document_id": "1"
    }
  ]
}
```

## Debug Entry 17

- timestamp_utc: 2026-04-06T11:19:34.166815+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 153
- rule_id: 9
- rule_name: STEMI-DO-009
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: not_evaluable
- outcome_gold: not_applicable
- conformity_vs_gold: 4/10
- rationale_alignment: 3/10 (inferenziale)
- outcome_alignment: 6/10
- check_time: 19.37s
- estimated_cost: $0.001221

### JSON modello

```json
{
  "check_id": "STEMI-DO-009",
  "check_timestamp": "2026-04-06T12:00:00+01:00",
  "confidence": 0.32,
  "outcome": "not_evaluable",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Nessun risultato di hs‑cTn disponibile nei primi 0 h e 1 h dall’arrivo in pronto soccorso; l’unico dosaggio di troponina cardiaca ad alta sensibilità registrato (hs‑cTnI 68 ng/L) è stato eseguito post‑PCI (08:15). Pertanto non è possibile verificare se l’algoritmo 0 h/1 h sia risultato inconcludente né se sia stato eseguito un terzo dosaggio a 3 h entro la tolleranza di ±30 min. La mancanza di dati strutturati rende la valutazione non affidabile.",
  "rule_id": "STEMI-DO-009",
  "supporting_documents": [
    {
      "confidence": 0.42,
      "document_id": "7",
      "rationale": "Referto laboratorio con valore hs‑cTnI 68 ng/L a 08:15, dimostra che è stato eseguito un dosaggio di troponina, ma non ai tempi richiesti (0 h/1 h)."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "not_applicable",
  "rule_id": "STEMI-DO-009",
  "check_id": "CHK-STEMI-DO-009-20260322-RSSMRA58L12H501X",
  "rationale": "La regola STEMI-DO-009 si applica a pazienti con sospetta SCA il cui algoritmo 0 h/1 h di hs-cTn risulta inconcludente. Nel caso in esame, il paziente presentava un quadro ECG pre-ospedaliero chiaramente diagnostico per STEMI antero-laterale (sopraslivellamento ST 3 mm in V2-V4, 2 mm in V5-V6, I-aVL con sottoslivellamento reciproco in derivazioni inferiori), che ha determinato l'attivazione immediata della rete IMA con percorso diretto verso emodinamica per PCI primaria. Si configura pertanto il criterio di esclusione STEMI-DO-009-EXC-03 (STEMI evidente all'ECG): la diagnosi era già chiara al primo ECG e non vi era alcuna necessità di applicare l'algoritmo 0 h/1 h di hs-cTn né il dosaggio aggiuntivo a 3 ore. La troponina all'ingresso (hs-cTnI 68 ng/L) è stata dosata come parte della routine laboratoristica di inquadramento e non nell'ambito di un algoritmo diagnostico di rule-in/rule-out. La regola non è applicabile a questo contesto clinico.",
  "confidence": 0.97,
  "check_timestamp": "2026-03-22T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "Referto ECG pre-ospedaliero che documenta un quadro inequivocabilmente diagnostico per STEMI antero-laterale (ST elevato 3 mm V2-V4, 2 mm V5-V6, I-aVL), configurando il criterio di esclusione EXC-03 della regola.",
      "confidence": 0.98,
      "document_id": "1"
    },
    {
      "rationale": "Verbale 118 che conferma l'attivazione immediata della rete IMA con preallerta del centro HUB di emodinamica sulla base dell'ECG diagnostico per STEMI, dimostrando che il percorso clinico seguito era quello della riperfusione urgente e non quello dell'algoritmo diagnostico 0 h/1 h.",
      "confidence": 0.96,
      "document_id": "2"
    },
    {
      "rationale": "Valutazione medica di Pronto Soccorso che conferma la diagnosi di STEMI antero-laterale con indicazione a coronarografia urgente e PCI primaria, escludendo esplicitamente l'indicazione a fibrinolisi per disponibilità immediata di emodinamica. Non vi era alcun dubbio diagnostico che giustificasse l'applicazione dell'algoritmo 0 h/1 h.",
      "confidence": 0.95,
      "document_id": "4"
    },
    {
      "rationale": "Referto di emodinamica che documenta l'esecuzione della PCI primaria con door-to-balloon di 53 minuti, confermando il percorso di riperfusione urgente per STEMI conclamato, incompatibile con la necessità di un algoritmo diagnostico seriato della troponina.",
      "confidence": 0.93,
      "document_id": "9"
    },
    {
      "rationale": "Referto di laboratorio all'ingresso con hs-cTnI 68 ng/L, eseguito come routine laboratoristica urgente e non nell'ambito di un algoritmo 0 h/1 h strutturato. Non risulta alcun secondo dosaggio a 1 ora né classificazione dell'esito come inconcludente, a conferma della non applicabilità della regola.",
      "confidence": 0.9,
      "document_id": "7"
    }
  ]
}
```

## Debug Entry 18

- timestamp_utc: 2026-04-06T11:20:16.949873+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 154
- rule_id: 9
- rule_name: STEMI-DO-009
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: not_evaluable
- outcome_gold: not_evaluable
- conformity_vs_gold: 6/10
- rationale_alignment: 4/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 22.80s
- estimated_cost: $0.001252

### JSON modello

```json
{
  "check_id": "STEMI-DO-009",
  "check_timestamp": "2026-04-06T12:00:00+01:00",
  "confidence": 0.45,
  "outcome": "not_evaluable",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Nel dossier non è presente un campione di hs‑cTn a 1 h, quindi non è possibile determinare se l’algoritmo 0 h/1 h sia risultato inconcludente. L’unico prelievo a 3 h (id 13) è stato eseguito a 3 h 40 min dopo il campione di 0 h (id 7), ma senza la prova dell’esito dell’algoritmo. Di conseguenza la regola non può essere valutata come applicabile o non‑compliant.",
  "rule_id": "STEMI-DO-009",
  "supporting_documents": [
    {
      "confidence": 0.6,
      "document_id": ",",
      "rationale": "Prelievo hs‑cTn a 0 h (08:18) con valore 38 ng/L, indicativo di un livello di troponina non elevato al momento dell’arrivo."
    },
    {
      "confidence": 0.6,
      "document_id": ",",
      "rationale": "Prelievo hs‑cTn a 3 h 40 min (11:58) con valore 214 ng/L, che mostra un incremento ma non è accompagnato da un esito dell’algoritmo 0 h/1 h."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "not_evaluable",
  "rule_id": "STEMI-DO-009",
  "check_id": "CHK-STEMI-DO-009-RSSMRA58L12H501X-20260318",
  "rationale": "La regola STEMI-DO-009 si applica quando l'algoritmo 0 h/1 h di hs-cTn produce un esito inconcludente. Nel caso in esame, il paziente si è presentato in PS alle 08:02 con sospetta SCA (dolore toracico tipico, ECG pre-ospedaliero non diagnostico per STEMI, alterazioni inferiori non conclusive). Il primo dosaggio di hs-cTnI è stato eseguito alle 08:18 con valore di 38 ng/L (lievemente sopra il 99° percentile). Tuttavia, NON è documentato alcun secondo dosaggio di hs-cTnI a 1 ora (atteso intorno alle 09:02-09:18). Il successivo dosaggio di hs-cTnI risulta essere stato effettuato solo alle 11:58 (documento 13, valore 214 ng/L), circa 3 ore e 40 minuti dopo il primo prelievo. L'algoritmo rapido 0 h/1 h non è stato formalmente applicato (manca la misurazione a 1 ora), pertanto il suo esito non può essere classificato come 'inconcludente'. Il criterio di inclusione INC-01 richiede che entrambe le prime due misurazioni siano state eseguite e classificate come inconcludenti, e il campo inference_allowed per questo criterio è 'false', impedendo l'inferenza. Inoltre, alle 11:02 il quadro clinico ed elettrocardiografico è evoluto in STEMI inferiore franco (documento 9), configurando il criterio di esclusione EXC-03 a partire da quel momento. In sintesi: la precondizione per l'applicazione della regola (esito inconcludente dell'algoritmo 0 h/1 h) non è verificabile perché l'algoritmo non è stato completato con la misurazione a 1 ora. I dati sono insufficienti per determinare se la regola fosse applicabile e se sia stata rispettata.",
  "confidence": 0.75,
  "check_timestamp": "2026-03-23T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "Documenta il primo dosaggio di hs-cTnI basale (38 ng/L alle 08:18), unica misurazione del tempo 0 dell'algoritmo 0 h/1 h. Non vi è evidenza di un secondo dosaggio a 1 ora, impedendo il completamento dell'algoritmo e la classificazione del suo esito.",
      "confidence": 0.85,
      "document_id": "7"
    },
    {
      "rationale": "La valutazione medica di PS alle 08:11 descrive un iter per SCA senza ST con ECG seriati e dosaggio hs-cTn, ma non menziona esplicitamente l'applicazione dell'algoritmo rapido 0 h/1 h né la richiesta di un prelievo a 1 ora. Conferma l'approccio osservazionale adottato dal medico.",
      "confidence": 0.8,
      "document_id": "4"
    },
    {
      "rationale": "ECG seriato delle 09:36 (circa 1,5 h dalla presentazione) ancora non conclusivo per STEMI. In questo intervallo temporale sarebbe dovuto essere disponibile il dosaggio a 1 ora per completare l'algoritmo, ma non risulta effettuato.",
      "confidence": 0.65,
      "document_id": "8"
    },
    {
      "rationale": "Secondo dosaggio di hs-cTnI (214 ng/L) eseguito alle 11:58, circa 3 h e 40 min dopo il primo prelievo. Sebbene temporalmente prossimo a un ipotetico dosaggio a 3 h dalla presentazione, non si configura come terzo dosaggio dell'algoritmo 0 h/1 h/3 h poiché l'algoritmo 0 h/1 h non è stato completato. Inoltre il timestamp eccede la tolleranza di ±30 min dal target di 3 h dalla presentazione (11:02).",
      "confidence": 0.7,
      "document_id": "13"
    },
    {
      "rationale": "ECG delle 11:02 documenta la comparsa di STEMI inferiore franco con sopraslivellamento ST netto in DII, DIII e aVF, configurando il criterio di esclusione EXC-03 (STEMI evidente all'ECG). Da questo momento il percorso clinico si è orientato verso la riperfusione urgente, rendendo superfluo il proseguimento dell'algoritmo diagnostico di hs-cTn.",
      "confidence": 0.85,
      "document_id": "9"
    }
  ]
}
```

## Debug Entry 19

- timestamp_utc: 2026-04-06T11:20:44.499607+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 155
- rule_id: 10
- rule_name: STEMI-DO-010
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: not_applicable
- outcome_gold: not_applicable
- conformity_vs_gold: 8/10
- rationale_alignment: 6/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 8.02s
- estimated_cost: $0.001083

### JSON modello

```json
{
  "check_id": "STEMI-DO-010",
  "check_timestamp": "2026-04-06T12:00:00+01:00",
  "confidence": 0.95,
  "outcome": "not_applicable",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Il paziente non presenta segni clinici di shock cardiogeno (PA > 90 mmHg, nessun vasopressore, nessun segno di ipoperfusione) né sospetti di complicanze meccaniche post-infarto (nessun nuovo soffio, nessun deterioramento emodinamico improvviso, nessun sospetto tamponamento). Di conseguenza la condizione di trigger della regola (shock cardiogeno o complicanze meccaniche) non è stata soddisfatta, rendendo la regola non applicabile all’episodio.",
  "rule_id": "STEMI-DO-010",
  "supporting_documents": [
    {
      "confidence": 0.9,
      "document_id": "1",
      "rationale": "ECG pre-ospedaliero mostra sopraslivellamento ST ma vitale stabile, nessun segno di shock; conferma che il paziente è in stato di Killip I e non presenta complicanze meccaniche."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "not_applicable",
  "rule_id": "STEMI-DO-010",
  "check_id": "CHK-STEMI-DO-010-RSSMRA58L12H501X-20260318",
  "rationale": "La regola STEMI-DO-010 richiede l'esecuzione di una TTE d'emergenza nei pazienti con sospetta SCA che presentano shock cardiogeno o sospette complicanze meccaniche. Il paziente presenta STEMI anteriore confermato, tuttavia durante l'intero episodio non ha mai soddisfatto i criteri di inclusione specifici della regola: (1) Shock cardiogeno assente – la pressione arteriosa sistolica è sempre stata ampiamente superiore a 90 mmHg (range 118-158 mmHg), non è stato mai utilizzato supporto con vasopressori/inotropi, il paziente è rimasto vigile, orientato, con estremità calde, polsi periferici validi, diuresi conservata, classe Killip I per tutta la degenza; (2) Complicanze meccaniche sospette assenti – l'esame obiettivo in PS (doc 6) esclude esplicitamente soffi di nuova insorgenza, non si è verificato alcun deterioramento emodinamico improvviso, non vi è stato sospetto clinico di tamponamento cardiaco, rottura del setto interventricolare o della parete libera. Il TTE eseguito il 19/03/2026 (doc 21) è stato un ecocardiogramma di routine post-PCI per valutazione della funzione ventricolare e non una TTE d'emergenza per shock o complicanza meccanica. Pertanto il trigger della regola non è stato attivato e la regola risulta non applicabile a questo episodio.",
  "confidence": 0.95,
  "check_timestamp": "2026-03-22T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "La valutazione medica in PS documenta esplicitamente classe Killip I, stabilità emodinamica, assenza di segni di scompenso acuto e shock, confermando l'assenza del trigger 'shock cardiogeno'.",
      "confidence": 0.96,
      "document_id": "4"
    },
    {
      "rationale": "L'esame obiettivo riporta esplicitamente 'non soffi di nuova insorgenza apprezzabili', estremità calde, polsi periferici validi e simmetrici, toni cardiaci ritmici con pause libere, escludendo segni clinici di complicanze meccaniche e di ipoperfusione periferica.",
      "confidence": 0.95,
      "document_id": "6"
    },
    {
      "rationale": "Il verbale 118 documenta parametri vitali stabili (PA 158/92, SpO2 96%, GCS 15) e assenza di cute marezzata, contribuendo ad escludere lo shock cardiogeno già in fase pre-ospedaliera.",
      "confidence": 0.9,
      "document_id": "2"
    },
    {
      "rationale": "La scheda di triage conferma stabilità emodinamica all'arrivo in PS (PA 150/88, FC 92, SpO2 97%), senza elementi suggestivi di shock o complicanze meccaniche.",
      "confidence": 0.88,
      "document_id": "3"
    },
    {
      "rationale": "Il TTE eseguito il 19/03/2026 è un ecocardiogramma transtoracico di routine post-PCI (non d'emergenza), che documenta FEVS 40%, assenza di trombi, assenza di versamento pericardico e assenza di complicanze meccaniche, confermando retrospettivamente che non vi erano complicanze meccaniche durante il ricovero.",
      "confidence": 0.85,
      "document_id": "21"
    },
    {
      "rationale": "Il diario UTIC post-PCI documenta paziente emodinamicamente stabile, Killip I, asintomatico, senza segni di shock o deterioramento emodinamico, confermando la non applicabilità del trigger anche nella fase post-procedurale.",
      "confidence": 0.88,
      "document_id": "11"
    }
  ]
}
```

## Debug Entry 20

- timestamp_utc: 2026-04-06T11:21:22.840857+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 156
- rule_id: 10
- rule_name: STEMI-DO-010
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: not_applicable
- outcome_gold: not_applicable
- conformity_vs_gold: 8/10
- rationale_alignment: 6/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 18.74s
- estimated_cost: $0.001174

### JSON modello

```json
{
  "check_id": "STEMI-DO-010",
  "check_timestamp": "2026-04-06T00:00:00+01:00",
  "confidence": 0.95,
  "outcome": "not_applicable",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Il paziente presentava una sospetta SCA (STEMI) ma non si sono verificati segni clinici di shock cardiogeno né sospette complicanze meccaniche post-infarto. Di conseguenza il trigger della regola non è stato attivato e la TTE d'emergenza non è stata indicata. Un TTE è stato eseguito (id 24) ma in contesto di follow-up, non di emergenza.",
  "rule_id": "STEMI-DO-010",
  "supporting_documents": [
    {
      "confidence": 0.9,
      "document_id": "document_id",
      "rationale": "Ecocardiogramma transtoracico eseguito il 19/03/2026, riportando funzione ventricolare e assenza di complicanze meccaniche; non indicato come emergenza."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "not_applicable",
  "rule_id": "STEMI-DO-010",
  "check_id": "CHK-STEMI-DO-010-20260323-RSSMRA58L12H501X",
  "rationale": "La regola STEMI-DO-010 si applica a pazienti con sospetta SCA che presentano shock cardiogeno o sospette complicanze meccaniche. In questo episodio il paziente ha presentato STEMI infero-posteriore confermato, ma non ha mai sviluppato shock cardiogeno né sospette complicanze meccaniche. In tutte le rilevazioni documentate la pressione arteriosa sistolica è sempre rimasta ben al di sopra di 90 mmHg (range 114-164 mmHg); non sono stati mai somministrati vasopressori né inotropi; non sono stati descritti segni di ipoperfusione periferica (GCS sempre 15, SpO2 97-98%, diuresi conservata, assenza di estremità fredde o lattati elevati); la classe Killip è rimasta I per tutto il ricovero. All'esame obiettivo non è stato rilevato alcun soffio cardiaco di nuova insorgenza né deterioramento emodinamico improvviso; non vi è stato sospetto clinico di tamponamento cardiaco, rottura del setto interventricolare o rottura della parete libera. Il trigger della regola (riconoscimento di shock cardiogeno o complicanza meccanica sospetta) non si è mai verificato. L'ecocardiogramma transtoracico eseguito in data 19/03/2026 (documento 24) è stato un esame di controllo post-infartuale programmato e non una TTE d'emergenza in risposta a shock o complicanza meccanica. Pertanto la regola risulta non applicabile al contesto clinico di questo paziente.",
  "confidence": 0.93,
  "check_timestamp": "2026-03-23T11:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "La valutazione medica di Pronto Soccorso documenta Killip classe I, stabilità emodinamica, assenza di segni di basso flusso o congestione, confermando l'assenza di shock cardiogeno all'ingresso.",
      "confidence": 0.95,
      "document_id": "4"
    },
    {
      "rationale": "L'esame obiettivo documenta toni cardiaci validi e ritmici senza soffi francamente patologici, assenza di rantoli e buona perfusione periferica, escludendo sospetti di complicanze meccaniche e shock.",
      "confidence": 0.93,
      "document_id": "6"
    },
    {
      "rationale": "La valutazione cardiologica urgente che ha portato all'attivazione dell'emodinamica descrive il paziente come emodinamicamente stabile (PA 148/84, SpO2 97%) senza menzione di shock cardiogeno o complicanze meccaniche sospette.",
      "confidence": 0.92,
      "document_id": "11"
    },
    {
      "rationale": "Il diario clinico UTIC post-PCI conferma Killip I, stabilità emodinamica, assenza di segni di congestione o ipoperfusione, escludendo lo sviluppo di shock cardiogeno nella fase post-procedurale.",
      "confidence": 0.92,
      "document_id": "16"
    },
    {
      "rationale": "L'ecocardiogramma transtoracico del 19/03/2026 è stato eseguito come controllo programmato (non d'emergenza) e ha confermato l'assenza di complicanze meccaniche post-infartuali (no trombi, no versamento pericardico, no rotture), avvalorando che tali complicanze non erano sospettate clinicamente.",
      "confidence": 0.94,
      "document_id": "24"
    },
    {
      "rationale": "Il referto di emodinamica non riporta necessità di supporto con vasopressori/inotropi né instabilità emodinamica durante la procedura, confermando l'assenza di shock cardiogeno anche in fase periprocedurale.",
      "confidence": 0.9,
      "document_id": "14"
    }
  ]
}
```

## Debug Entry 21

- timestamp_utc: 2026-04-06T11:21:47.352614+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 157
- rule_id: 11
- rule_name: STEMI-DONOT-001
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 8/10
- rationale_alignment: 7/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 12.94s
- estimated_cost: $0.001028

### JSON modello

```json
{
  "check_id": "STEMI-DONOT-001",
  "check_timestamp": "2026-04-06T00:00:00+01:00",
  "confidence": 0.95,
  "outcome": "compliant",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Nessuna richiesta o esecuzione di angio‑TC coronarica è riportata nei documenti clinici. Il paziente è stato valutato con ECG pre‑ospedaliero, ECG in pronto soccorso e coronarografia invasiva primaria entro 53 minuti. Non esiste documentazione di override o eccezione. Pertanto la regola è rispettata.",
  "rule_id": "STEMI-DONOT-001",
  "supporting_documents": [
    {
      "confidence": 1.0,
      "document_id": "1",
      "rationale": "Referto ECG pre‑ospedaliero indica sospetta STEMI e non menziona angio‑TC"
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "compliant",
  "rule_id": "STEMI-DONOT-001",
  "check_id": "CHK-STEMI-DONOT-001-RSSMRA58L12H501X-20260322",
  "rationale": "Il paziente si è presentato con STEMI antero-laterale confermato da ECG pre-ospedaliero (documento 1) ed è stato gestito secondo il percorso standard della rete IMA: ECG diagnostico sul territorio, attivazione della rete STEMI, trasferimento diretto al centro HUB, coronarografia invasiva urgente con PCI primaria su IVA prossimale (documento 9). Non vi è alcuna evidenza nell'intero episodio clinico (36 documenti esaminati) di richiesta, prescrizione o esecuzione di angio-TC coronarica (CCTA) in nessuna fase del ricovero. La strategia diagnostica si è basata esclusivamente su ECG a 12 derivazioni, biomarcatori cardiaci seriati e coronarografia invasiva, coerentemente con la raccomandazione ESC di Classe III che sconsiglia l'uso routinario della CCTA precoce nella sospetta SCA. La regola è pertanto pienamente rispettata.",
  "confidence": 0.95,
  "check_timestamp": "2026-03-22T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "ECG pre-ospedaliero diagnostico per STEMI antero-laterale: ha avviato il percorso diagnostico standard (ECG + rete IMA) senza necessità di angio-TC coronarica.",
      "confidence": 0.95,
      "document_id": "1"
    },
    {
      "rationale": "Verbale 118 che documenta l'attivazione immediata della rete IMA e il trasferimento diretto al centro HUB per coronarografia urgente, confermando l'assenza di richiesta di CCTA nella fase pre-ospedaliera.",
      "confidence": 0.93,
      "document_id": "2"
    },
    {
      "rationale": "Valutazione medica in PS che conferma l'indicazione diretta a coronarografia invasiva urgente con PCI primaria, senza alcuna menzione di angio-TC coronarica e con esplicita esclusione della fibrinolisi per disponibilità di emodinamica.",
      "confidence": 0.95,
      "document_id": "4"
    },
    {
      "rationale": "Referto di emodinamica che documenta l'esecuzione della coronarografia invasiva urgente con PCI primaria: la strategia diagnostico-interventistica standard è stata seguita correttamente, rendendo non necessaria e non richiesta alcuna CCTA.",
      "confidence": 0.96,
      "document_id": "9"
    },
    {
      "rationale": "Lettera di dimissione che riepiloga l'intero percorso diagnostico-terapeutico senza alcun riferimento a richiesta o esecuzione di angio-TC coronarica, confermando la compliance alla regola lungo tutto l'episodio.",
      "confidence": 0.94,
      "document_id": "36"
    }
  ]
}
```

## Debug Entry 22

- timestamp_utc: 2026-04-06T11:22:15.801126+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 158
- rule_id: 11
- rule_name: STEMI-DONOT-001
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 8/10
- rationale_alignment: 6/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 13.38s
- estimated_cost: $0.001024

### JSON modello

```json
{
  "check_id": "STEMI-DONOT-001",
  "check_timestamp": "2026-04-06T12:00:00+01:00",
  "confidence": 0.95,
  "outcome": "compliant",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Nessuna evidenza di richiesta o esecuzione di angio‑TC coronarica nei primi 24 h dall’arrivo in pronto soccorso. L’episodio mostra ECG, biomarcatori e coronarografia invasiva, ma non è riportata alcuna ordinazione o referto di CCTA. Pertanto la regola è rispettata.",
  "rule_id": "STEMI-DONOT-001",
  "supporting_documents": [
    {
      "confidence": 1.0,
      "document_id": "36",
      "rationale": "Verbale di dimissione non menziona alcuna angio‑TC coronarica; indica solo coronarografia invasiva e PCI."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "compliant",
  "rule_id": "STEMI-DONOT-001",
  "check_id": "CHK-STEMI-DONOT-001-RSSMRA58L12H501X-20260318",
  "rationale": "Il paziente si è presentato con sospetta sindrome coronarica acuta (dolore toracico tipico, alterazioni ECG inferiori, troponina elevata) configurando un quadro di SCA a cui la regola è applicabile. Dall'analisi completa dei 36 documenti clinici dell'episodio non risulta alcuna richiesta né esecuzione di angio-TC coronarica (CCTA) in nessuna fase del ricovero. L'iter diagnostico ha seguito il percorso standard raccomandato: ECG seriati (pre-ospedaliero, in PS e successivi), dosaggio seriato di hs-cTnI, consulenza cardiologica e coronarografia invasiva con PCI primaria. L'unico esame di imaging cardiaco non invasivo eseguito è stato l'ecocardiogramma transtoracico post-procedurale (doc 24), che non rientra nella proibizione. La regola DO_NOT è pertanto pienamente rispettata: nessuna angio-TC coronarica è stata richiesta o eseguita di routine in fase precoce.",
  "confidence": 0.95,
  "check_timestamp": "2026-03-23T12:00:00+01:00",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "ECG pre-ospedaliero che documenta l'avvio del percorso diagnostico standard per sospetta SCA (alterazioni ST inferiori) senza ricorso ad angio-TC coronarica.",
      "confidence": 0.9,
      "document_id": "1"
    },
    {
      "rationale": "Valutazione medica in PS che definisce l'iter diagnostico con ECG seriati, biomarcatori e consulenza cardiologica, senza richiesta di CCTA nonostante il quadro ECG inizialmente non dirimente.",
      "confidence": 0.95,
      "document_id": "4"
    },
    {
      "rationale": "ECG seriato delle 11:02 che documenta l'evoluzione in STEMI inferiore franco, confermando la strategia diagnostica basata su ECG seriati e troponina anziché su angio-TC coronarica.",
      "confidence": 0.93,
      "document_id": "9"
    },
    {
      "rationale": "Consulenza cardiologica urgente che pone indicazione a coronarografia invasiva con PCI primaria, senza alcuna menzione di angio-TC coronarica come indagine alternativa o complementare.",
      "confidence": 0.96,
      "document_id": "11"
    },
    {
      "rationale": "Referto di coronarografia invasiva urgente con PCI su coronaria destra, documentando che il percorso diagnostico-terapeutico ha seguito l'approccio invasivo standard senza uso di CCTA.",
      "confidence": 0.97,
      "document_id": "14"
    },
    {
      "rationale": "Lettera di dimissione che riassume l'intero percorso diagnostico-terapeutico senza alcun riferimento a richiesta o esecuzione di angio-TC coronarica durante l'episodio.",
      "confidence": 0.94,
      "document_id": "36"
    }
  ]
}
```

## Debug Entry 23

- timestamp_utc: 2026-04-06T11:23:02.821952+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 159
- rule_id: 12
- rule_name: STEMI-DO-011
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: non_compliant
- outcome_gold: compliant
- conformity_vs_gold: 1/10
- rationale_alignment: 1/10 (inferenziale)
- outcome_alignment: 0/10
- check_time: 30.29s
- estimated_cost: $0.001276

### JSON modello

```json
{
  "check_id": "STEMI-DO-011",
  "check_timestamp": "2026-04-06T00:00:00+01:00",
  "confidence": 0.9,
  "outcome": "non_compliant",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Il primo contatto medico (FMC) è avvenuto alle 07:10. L’ECG a 12 derivazioni è stato eseguito alle 07:44, 34 minuti dopo il FMC, superando il limite di 10 minuti previsto dalla regola. La trasmissione dell’ECG, l’attivazione del laboratorio di emodinamica e il trasferimento al centro hub sono stati eseguiti, ma la tempistica dell’ECG non rispetta il requisito temporale, quindi la gestione non è conforme.",
  "rule_id": "STEMI-DO-011",
  "supporting_documents": [
    {
      "confidence": 0.95,
      "document_id": "1",
      "rationale": "Referto ECG pre-ospedaliero con data 07:44, dimostra il tempo di esecuzione dell’ECG."
    },
    {
      "confidence": 0.9,
      "document_id": "2",
      "rationale": "Verbale 118 con data 07:46, conferma il primo contatto medico alle 07:10 e la trasmissione dell’ECG."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "compliant",
  "rule_id": "STEMI-DO-011",
  "check_id": "CHK-STEMI-DO-011-RSSMRA58L12H501X-20260318",
  "rationale": "Il paziente presenta diagnosi operativa di STEMI antero-laterale formulata in fase pre-ospedaliera dal medico 118, soddisfacendo tutti i criteri di inclusione (ECG con ST elevato + sintomatologia ischemica entro 12 ore + primo contatto medico pre-ospedaliero). Non ricorrono criteri di esclusione né eccezioni. Verificati i requisiti della regola: (1) ECG a 12 derivazioni eseguito alle 07:44, coerente con un FMC stimato intorno alle 07:42-07:44, quindi entro il vincolo di 10 minuti; (2) trasmissione telematica dell'ECG alla rete IMA e condivisione con emodinamista reperibile documentata nel referto ECG pre-ospedaliero; (3) rete IMA attivata e preallerta del centro HUB di emodinamica documentata alle 07:47 nel verbale 118; (4) trasporto diretto al centro HUB con arrivo (door-in) alle 08:02; (5) PCI primaria eseguita su IVA prossimale con door-to-balloon di 53 minuti; il tempo FMC-to-balloon stimato è di circa 71 minuti, ben entro il limite di 120 minuti e inferiore anche alla soglia ideale di 90 minuti. La strategia di riperfusione adottata è la PCI primaria, come raccomandato. Tutti gli elementi di compliance documentale sono presenti, sebbene alcuni timestamp (FMC esatto, orario preciso trasmissione ECG) siano ricavati da testo narrativo e non da campi strutturati, il che comporta una lieve riduzione della confidence ma non inficia la valutazione complessiva di piena conformità.",
  "confidence": 0.92,
  "check_timestamp": "2025-01-24T12:00:00Z",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "Documenta l'esecuzione dell'ECG a 12 derivazioni pre-ospedaliero alle 07:44 con riscontro di sopraslivellamento ST compatibile con STEMI antero-laterale e la trasmissione del referto alla rete IMA e all'emodinamista reperibile, soddisfacendo i requisiti di esecuzione ECG entro 10 minuti dal FMC e di trasmissione telematica al centro HUB.",
      "confidence": 0.93,
      "document_id": "1"
    },
    {
      "rationale": "Documenta l'intervento 118 con orario di esordio sintomi (07:10), parametri vitali, attivazione immediata della rete IMA con preallerta del centro HUB di emodinamica alle ore 07:47, somministrazione del pretrattamento farmacologico (ASA, ticagrelor, eparina) e trasporto diretto in codice rosso. Conferma il FMC pre-ospedaliero e la sequenza temporale di attivazione della rete.",
      "confidence": 0.95,
      "document_id": "2"
    },
    {
      "rationale": "Conferma l'arrivo del paziente in Pronto Soccorso alle 08:02 tramite 118 con preallerta rete STEMI attiva, codice rosso, e instradamento immediato verso emodinamica. Documenta il timestamp di door-in e la continuità del percorso di rete.",
      "confidence": 0.9,
      "document_id": "3"
    },
    {
      "rationale": "Conferma la valutazione medica in PS con presa visione dell'ECG pre-ospedaliero, indicazione a coronarografia urgente con PCI primaria, tempo door-in alle 08:02 e trasferimento in emodinamica alle 08:20. Documenta la destinazione diretta al centro HUB e l'assenza di ritardi evitabili.",
      "confidence": 0.9,
      "document_id": "4"
    },
    {
      "rationale": "Documenta l'esecuzione della PCI primaria su IVA prossimale con accesso radiale, risultato ottimale (TIMI 3, blush 3, stenosi residua 0%) e door-to-balloon di 53 minuti. Conferma la strategia di riperfusione adottata (PCI primaria) e il rispetto del vincolo temporale FMC-to-wire stimato in circa 71 minuti, ampiamente entro i 120 minuti.",
      "confidence": 0.95,
      "document_id": "9"
    },
    {
      "rationale": "Lettera di dimissione che riassume l'intero percorso di rete STEMI: accesso tramite 118 con ECG diagnostico pre-ospedaliero, pretrattamento, trasferimento diretto al centro HUB, PCI primaria con door-to-balloon 53 minuti. Conferma globalmente tutti gli elementi di compliance della regola.",
      "confidence": 0.93,
      "document_id": "36"
    }
  ]
}
```

## Debug Entry 24

- timestamp_utc: 2026-04-06T11:23:51.368849+00:00
- run_instance_id: 6
- inference_params_id: 1
- compliance_instance_id: 160
- rule_id: 12
- rule_name: STEMI-DO-011
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 30
- model_code: gpt-oss-20b
- router_code: OVHCloud
- outcome_modello: non_compliant
- outcome_gold: probable_non_compliance
- conformity_vs_gold: 7/10
- rationale_alignment: 6/10 (inferenziale)
- outcome_alignment: 8/10
- check_time: 18.77s
- estimated_cost: $0.001149

### JSON modello

```json
{
  "check_id": "STEMI-DO-011",
  "check_timestamp": "2026-04-06T12:00:00+01:00",
  "confidence": 0.9,
  "outcome": "non_compliant",
  "patient_id_hash": "RSSMRA58L12H501X",
  "rationale": "Il paziente ha presentato un ECG pre-ospedaliero (07:48) che non evidenziava un sopraslivellamento diagnostico di STEMI; la diagnosi di STEMI è stata confermata solo a 11:02, dopo l’arrivo in pronto soccorso. Non è stato trasmesso un ECG a 12 derivazioni con STEMI al centro hub prima dell’arrivo, né è stato attivato il laboratorio di emodinamica entro 120 min dal primo contatto medico (FMC 07:44). La PCI è stata eseguita a 12:16, oltre il limite di 120 min, senza somministrazione di fibrinolisi giustificata. Pertanto la regola non è rispettata.",
  "rule_id": "STEMI-DO-011",
  "supporting_documents": [
    {
      "confidence": 0.95,
      "document_id": "1",
      "rationale": "ECG pre-ospedaliero a 12 derivazioni eseguito 07:48, 4 min dopo FMC 07:44, ma senza ST‑elevazione diagnostica di STEMI."
    },
    {
      "confidence": 0.9,
      "document_id": "9",
      "rationale": "ECG a 12 derivazioni a 11:02 mostra ST‑elevazione inferiore, conferma STEMI, ma è stato eseguito solo dopo l’arrivo in PS, non pre-ospedaliero."
    }
  ]
}
```

### JSON gold

```json
{
  "outcome": "probable_non_compliance",
  "rule_id": "STEMI-DO-011",
  "check_id": "CHK-STEMI-DO-011-RSSMRA58L12H501X-20260318",
  "rationale": "L'ECG pre-ospedaliero (doc 1, ore 07:48, 4 minuti dopo il FMC delle 07:44) ha documentato sopraslivellamento del tratto ST di 1.0 mm in DIII e aVF con sottoslivellamento reciproco in V1-V3, in un paziente con dolore toracico tipico insorto alle 06:55. Sebbene la medico 118 abbia giudicato il quadro 'non dirimente per STEMI conclamato', le alterazioni elettrocardiografiche (ST elevato ≥1 mm in due derivazioni inferiori contigue con modifiche reciproche) erano retrospettivamente compatibili con uno STEMI inferiore in fase iniziale, entro le 12 ore dall'esordio dei sintomi. Il tracciato è stato trasmesso al PS del centro Hub e il paziente è stato trasportato al centro Hub, ma senza attivazione diretta della sala di emodinamica (esplicitamente dichiarato nel doc 2: 'senza attivazione diretta della sala di emodinamica'). La diagnosi di STEMI franco è stata posta solo in sede intraospedaliera alle 11:02 (doc 9), con attivazione dell'emodinamica alle 11:40 (doc 11). Il tempo FMC-to-balloon risulta di 285 minuti (FMC 07:44, prima dilatazione 12:29), ampiamente superiore sia al target di 90 minuti sia al limite massimo di 120 minuti. Non è stata somministrata fibrinolisi e non risulta documentata una giustificazione formale per la mancata attivazione della rete STEMI pre-ospedaliera. Il caso configura indizi significativi di non conformità alla regola, temperati dal fatto che il quadro ECG pre-ospedaliero era effettivamente borderline e la diagnosi operativa di STEMI non è stata formulata in fase pre-ospedaliera dal medico 118, rendendo l'applicabilità della regola non del tutto certa. L'outcome è pertanto classificato come probabile non conformità con confidenza moderata.",
  "confidence": 0.62,
  "check_timestamp": "2025-07-14T12:00:00Z",
  "patient_id_hash": "RSSMRA58L12H501X",
  "supporting_documents": [
    {
      "rationale": "ECG pre-ospedaliero eseguito 4 minuti dopo il FMC che mostra ST elevato 1.0 mm in DIII e aVF con reciproci in V1-V3, interpretato come non dirimente ma retrospettivamente compatibile con STEMI inferiore iniziale. Documenta il trigger diagnostico pre-ospedaliero e la trasmissione del tracciato al centro Hub.",
      "confidence": 0.65,
      "document_id": "1"
    },
    {
      "rationale": "Verbale 118 che documenta il FMC alle 07:44, la somministrazione di ASA e farmaci, e soprattutto la decisione esplicita di non attivare la sala di emodinamica ('senza attivazione diretta della sala di emodinamica'), elemento chiave della probabile non conformità rispetto alla regola di attivazione della rete STEMI.",
      "confidence": 0.75,
      "document_id": "2"
    },
    {
      "rationale": "ECG delle 11:02 che documenta la comparsa di STEMI inferiore franco (ST elevato 2.5 mm DIII, 2.0 mm aVF) confermando retrospettivamente la natura ischemica delle alterazioni già presenti al tracciato pre-ospedaliero e il ritardo diagnostico.",
      "confidence": 0.7,
      "document_id": "9"
    },
    {
      "rationale": "Valutazione cardiologica urgente che documenta l'attivazione dell'emodinamica alle 11:40, quasi 4 ore dopo il FMC, evidenziando il ritardo nell'attivazione della rete rispetto al limite dei 120 minuti previsto dalla regola.",
      "confidence": 0.75,
      "document_id": "11"
    },
    {
      "rationale": "Referto di emodinamica che documenta i tempi procedurali: ingresso in sala 12:16, puntura radiale 12:22, prima dilatazione 12:29, con FMC-to-balloon di 285 minuti e door-to-balloon di 267 minuti, entrambi ampiamente fuori dai limiti raccomandati.",
      "confidence": 0.85,
      "document_id": "14"
    },
    {
      "rationale": "Valutazione medica in PS (ore 08:11) che conferma la decisione di non trattare come STEMI ma come SCA senza ST, documentando la mancata attivazione della rete anche in fase ospedaliera precoce nonostante alterazioni ECG suggestive.",
      "confidence": 0.55,
      "document_id": "4"
    },
    {
      "rationale": "Lettera di dimissione che riassume l'intero percorso clinico, confermando la diagnosi finale di STEMI infero-posteriore e la dinamica temporale con iniziale quadro non univoco e successiva evoluzione, fornendo contesto globale sulla gestione del caso.",
      "confidence": 0.6,
      "document_id": "36"
    }
  ]
}
```

