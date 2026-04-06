# check_rules03 debug log

Creato UTC: 2026-04-06T23:31:03.806106+00:00

Log append-only con confronto progressivo tra output modello e GOLD.

## Debug Entry 1

- timestamp_utc: 2026-04-06T23:31:31.067447+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 377
- rule_id: 1
- rule_name: STEMI-DO-001
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 8/10
- rationale_alignment: 7/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 8.03s
- estimated_cost: $0.004755

### JSON modello

```json
{
  "check_id": "CHK-STEMI-001-20260322",
  "check_timestamp": "2026-03-22T12:00:00+01:00",
  "rule_id": "STEMI-DO-001",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "compliant",
  "confidence": 0.98,
  "rationale": "Il paziente ha soddisfatto i criteri di inclusione: età >18 anni, sintomatologia acuta compatibile con sindrome coronarica (dolore toracico insorto alle 07:10), e ECG pre-ospedaliero con sopraslivellamento del tratto ST in derivazioni contigue (V2-V4, I, aVL), documentato alle 07:44. Il primo contatto medico (FMC) è avvenuto alle 07:44 con l'ECG eseguito dal medico 118, entro 10 minuti dal contatto. La decisione sulla strategia di riperfusione (PCI primaria) è stata immediatamente attivata: preallerta del centro HUB alle 07:47, con trasporto diretto in emodinamica. Il timestamp FMC è stato registrato (07:44), l'ECG è stato interpretato tempestivamente e la strategia di riperfusione documentata in modo formale e tempestivo. Non risultano eccezioni applicabili né criteri di esclusione. Tutti i criteri di completamento della regola sono soddisfatti.",
  "supporting_documents": [
    {
      "document_id": "1",
      "rationale": "ECG pre-ospedaliero eseguito e interpretato alle 07:44, entro 10 minuti dal primo contatto medico, con evidenza di sopraslivellamento ST compatibile con STEMI antero-laterale. Documenta la conferma diagnostica tempestiva.",
      "confidence": 0.99
    },
    {
      "document_id": "2",
      "rationale": "Verbale 118 documenta il primo contatto medico (FMC) alle 07:44, l'attivazione della rete IMA e la preallerta del centro HUB alle 07:47, dimostrando la valutazione immediata e la decisione per PCI primaria come strategia di riperfusione.",
      "confidence": 0.98
    },
    {
      "document_id": "3",
      "rationale": "Scheda triage del Pronto Soccorso conferma l'accesso con preallerta STEMI, codice rosso e instradamento diretto in emodinamica, attestando la continuità del percorso e la tempestività della valutazione.",
      "confidence": 0.97
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

- timestamp_utc: 2026-04-06T23:33:01.639539+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 378
- rule_id: 1
- rule_name: STEMI-DO-001
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: non_compliant
- outcome_gold: probable_non_compliance
- conformity_vs_gold: 6/10
- rationale_alignment: 5/10 (inferenziale)
- outcome_alignment: 8/10
- check_time: 8.81s
- estimated_cost: $0.004717

### JSON modello

```json
{
  "check_id": "CHK-STEMI-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DO-001",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "non_compliant",
  "confidence": 0.95,
  "rationale": "Il paziente ha presentato sospetto STEMI con sintomatologia tipica e alterazioni ECG suggestive già in fase pre-ospedaliera. L'ECG pre-ospedaliero è stato eseguito alle 07:48, entro 10 minuti dal FMC (07:44), soddisfacendo il primo criterio. Tuttavia, nonostante la comparsa di un ECG chiaramente diagnostico per STEMI inferiore alle 11:02, la decisione sulla strategia di riperfusione è stata documentata solo alle 11:39, con un ritardo di 37 minuti rispetto alla diagnosi. Tale ritardo non è giustificato da alcuna eccezione documentata (es. comorbidità terminale, rifiuto del paziente) e supera il vincolo di 'immediatezza' richiesto dalla regola. Pertanto, la valutazione per la strategia di riperfusione non è stata effettuata immediatamente dopo la conferma diagnostica, rendendo la regola non conforme.",
  "supporting_documents": [
    {
      "document_id": "9",
      "rationale": "ECG delle 11:02 mostra netto sopraslivellamento ST in DII, DIII, aVF e sottoslivellamento reciproco, quadro chiaramente diagnostico per STEMI inferiore. Questo rappresenta il momento di conferma diagnostica che avrebbe dovuto innescare immediatamente la decisione di riperfusione.",
      "confidence": 0.98
    },
    {
      "document_id": "11",
      "rationale": "La valutazione cardiologica del 18/03/2026 alle 11:39 documenta la decisione di procedere con PCI primaria, con attivazione dell'emodinamica alle 11:40. Questo indica un ritardo di 37 minuti tra diagnosi (11:02) e decisione (11:39), non giustificato da elementi clinici nel referto.",
      "confidence": 0.97
    },
    {
      "document_id": "2",
      "rationale": "Il verbale 118 indica che il FMC è avvenuto alle 07:44, con ECG eseguito alle 07:48, entro i 10 minuti raccomandati. Questo soddisfa il requisito temporale per l'ECG, ma non compensa il successivo ritardo decisionale.",
      "confidence": 0.95
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

- timestamp_utc: 2026-04-06T23:33:30.187506+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 379
- rule_id: 2
- rule_name: STEMI-DO-002
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 9/10
- rationale_alignment: 9/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 8.01s
- estimated_cost: $0.004948

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DO-002-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DO-002",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "compliant",
  "confidence": 0.98,
  "rationale": "La valutazione diagnostica integrata multiparametrica per sospetta SCA è stata eseguita in modo completo e tempestivo. Sono presenti e documentate tutte le componenti richieste: anamnesi clinica, valutazione dei sintomi, segni vitali, esame obiettivo, ECG a 12 derivazioni eseguito e interpretato, dosaggio della troponina ad alta sensibilità con risultato disponibile. La diagnosi di lavoro (STEMI antero-laterale) è stata formulata con integrazione dei dati clinici, strumentali e di laboratorio. I vincoli temporali sono rispettati: l'ECG pre-ospedaliero è stato eseguito entro 10 minuti dal primo contatto medico (118), il dosaggio della hs-cTn è stato effettuato entro 60 minuti dal FMC e il completamento della valutazione diagnostica è avvenuto in tempi appropriati.",
  "supporting_documents": [
    {
      "document_id": "2",
      "rationale": "Documenta il primo contatto medico (FMC) alle 07:46, con valutazione dei sintomi (dolore toracico NRS 9/10), segni vitali completi (PA, FC, SpO2, FR, temperatura) e preallerta rete IMA. Costituisce l'ancora temporale per i vincoli della regola.",
      "confidence": 0.99
    },
    {
      "document_id": "1",
      "rationale": "ECG a 12 derivazioni eseguito e interpretato alle 07:44, entro 10 minuti dal FMC. Documenta sopraslivellamento ST compatibile con STEMI antero-laterale, soddisfacendo il requisito di esecuzione e interpretazione tempestiva dell'ECG.",
      "confidence": 0.99
    },
    {
      "document_id": "5",
      "rationale": "Documenta l'anamnesi clinica completa con fattori di rischio cardiovascolare (diabete, ipertensione, dislipidemia, ex-fumatore), storia cardiologica, terapie in corso e anamnesi familiare, come richiesto dalla regola.",
      "confidence": 0.97
    },
    {
      "document_id": "6",
      "rationale": "Documenta l'esame obiettivo cardiovascolare e sistemico, con valutazione di segni di scompenso, soffi, perfusione periferica e stato generale, confermando l'assenza di segni di shock o insufficienza cardiaca (Killip I).",
      "confidence": 0.96
    },
    {
      "document_id": "7",
      "rationale": "Fornisce il risultato del dosaggio della troponina cardiaca ad alta sensibilità (hs-cTnI 68 ng/L) entro 60 minuti dal FMC, con timestamp di esecuzione alle 08:15, dimostrando la disponibilità del dato per la stratificazione diagnostica.",
      "confidence": 0.98
    },
    {
      "document_id": "4",
      "rationale": "Documenta la formulazione della diagnosi di lavoro (STEMI antero-laterale) con integrazione di anamnesi, sintomi, ECG e stato emodinamico, avvenuta entro 60 minuti dal FMC, in conformità con la regola.",
      "confidence": 0.97
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

- timestamp_utc: 2026-04-06T23:34:08.399016+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 380
- rule_id: 2
- rule_name: STEMI-DO-002
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 8/10
- rationale_alignment: 7/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 7.68s
- estimated_cost: $0.004904

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DO-002-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DO-002",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "compliant",
  "confidence": 0.98,
  "rationale": "Il paziente è stato valutato per sospetta SCA con dolore toracico tipico. Tutte le componenti della valutazione diagnostica integrata sono state eseguite e documentate entro i tempi raccomandati: anamnesi clinica completa (fattori di rischio CV, comorbilità, terapie in corso), valutazione dei sintomi (caratteristiche del dolore, sintomi associati), segni vitali rilevati già in fase pre-ospedaliera e confermati in PS, esame obiettivo cardiovascolare documentato, ECG a 12 derivazioni eseguito entro 6 minuti dal FMC (07:48 vs FMC 07:44) e interpretato, dosaggio di hs-cTnI basale eseguito entro 34 minuti dal FMC con risultato disponibile entro 60 minuti. La diagnosi di lavoro è stata formulata in modo progressivo, con integrazione dei dati clinici, strumentali e di laboratorio, culminando nella diagnosi di STEMI infero-posteriore. Non sussistono eccezioni applicabili.",
  "supporting_documents": [
    {
      "document_id": "2",
      "rationale": "Documenta il primo contatto medico (FMC) alle 07:44 con rilevazione completa dei segni vitali e valutazione dei sintomi (dolore toracico NRS 8/10, nausea, sudorazione), soddisfacendo i requisiti per DE-003, DE-005 e DE-002.",
      "confidence": 0.99
    },
    {
      "document_id": "1",
      "rationale": "ECG pre-ospedaliero eseguito alle 07:48 (4 minuti dopo FMC), entro il vincolo di 10 minuti. Contiene interpretazione clinica delle alterazioni del tratto ST, soddisfacendo DE-006 e DE-007.",
      "confidence": 0.99
    },
    {
      "document_id": "5",
      "rationale": "Anamnesi clinica completa documentata in PS, inclusi fattori di rischio CV (diabete, ipertensione, dislipidemia, ex-fumatore), terapie in corso e storia familiare, soddisfacendo DE-004.",
      "confidence": 0.98
    },
    {
      "document_id": "6",
      "rationale": "Esame obiettivo cardiovascolare e sistemico documentato, con valutazione di segni di scompenso (Killip I), toni cardiaci, polmoni e perfusione periferica, soddisfacendo DE-009.",
      "confidence": 0.97
    },
    {
      "document_id": "7",
      "rationale": "Dosaggio basale di hs-cTnI eseguito alle 08:18 (34 minuti dopo FMC) con risultato disponibile alle 08:58, entro 60 minuti dal FMC, soddisfacendo DE-008.",
      "confidence": 0.99
    },
    {
      "document_id": "4",
      "rationale": "Valutazione medica in PS che integra anamnesi, sintomi, segni vitali, ECG e laboratorio, formulando una diagnosi di lavoro iniziale per SCA senza ST, dimostrando l'uso integrato dei dati per la stratificazione del rischio.",
      "confidence": 0.96
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

- timestamp_utc: 2026-04-06T23:34:34.794946+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 381
- rule_id: 3
- rule_name: STEMI-DO-003
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 8/10
- rationale_alignment: 7/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 4.22s
- estimated_cost: $0.004312

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DO-003-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DO-003",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "compliant",
  "confidence": 0.98,
  "rationale": "L'ECG a 12 derivazioni è stato registrato e interpretato entro 10 minuti dal primo contatto medico. Il primo contatto medico (FMC) è avvenuto alle 07:44:00+01:00 con l'arrivo dell'equipaggio 118 sul posto e l'inizio della registrazione ECG, come documentato nel referto ECG pre-ospedaliero. L'ECG è stato completato e interpretato contestualmente, con referto trasmesso alla rete IMA entro lo stesso minuto. Il tempo tra FMC e interpretazione è quindi nullo, ampiamente entro il target di 10 minuti. L'ECG è a 12 derivazioni, con documentazione chiara del sopraslivellamento del tratto ST e attivazione del percorso STEMI.",
  "supporting_documents": [
    {
      "document_id": "1",
      "rationale": "Il referto ECG indica che l'acquisizione è avvenuta alle 07:44:00+01:00, coincidente con il primo contatto medico da parte dell'equipaggio 118, e riporta immediatamente l'interpretazione di STEMI antero-laterale con attivazione della rete IMA, soddisfacendo sia la registrazione che l'interpretazione entro il tempo richiesto.",
      "confidence": 0.99
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

- timestamp_utc: 2026-04-06T23:34:52.876479+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 382
- rule_id: 3
- rule_name: STEMI-DO-003
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 8/10
- rationale_alignment: 7/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 3.80s
- estimated_cost: $0.004286

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DO-003-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DO-003",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "compliant",
  "confidence": 0.95,
  "rationale": "L'ECG a 12 derivazioni è stato registrato e interpretato entro 10 minuti dal primo contatto medico (FMC). Il FMC è documentato alle 07:44, come inferito dal verbale 118 che riporta l'orario di arrivo sul posto e inizio delle manovre. L'ECG pre-ospedaliero è stato eseguito alle 07:48 e refertato immediatamente dal medico 118 con descrizione del tratto ST. Il tempo tra FMC e registrazione/interpretazione ECG è di 4 minuti, inferiore al target di 10 minuti. L'ECG è a 12 derivazioni, come specificato nel referto, e l'interpretazione è documentata con valutazione del tratto ST. Tutti i criteri di conformità sono soddisfatti.",
  "supporting_documents": [
    {
      "document_id": "2",
      "rationale": "Il verbale 118 riporta 'FMC 07:44', che costituisce il timestamp del primo contatto medico (FMC), fondamentale per il calcolo del tempo.",
      "confidence": 0.98
    },
    {
      "document_id": "1",
      "rationale": "Referto ECG pre-ospedaliero eseguito alle 07:48, entro 4 minuti dal FMC, con registrazione a 12 derivazioni e interpretazione immediata del tratto ST da parte del medico 118.",
      "confidence": 0.95
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

- timestamp_utc: 2026-04-06T23:35:27.811993+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 383
- rule_id: 4
- rule_name: STEMI-DO-004
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 8/10
- rationale_alignment: 6/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 14.08s
- estimated_cost: $0.004692

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DO-004-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DO-004",
  "patient_id_hash": "5a7d9f2e3b8c1e4a9d6f2c8b7a5e3d1f",
  "outcome": "compliant",
  "confidence": 0.98,
  "rationale": "Il paziente ha presentato sospetto STEMI antero-laterale già in ambito pre-ospedaliero, con ECG diagnostico eseguito alle 07:44. Il verbale del 118 documenta l'attivazione immediata della rete IMA e il trasporto in codice rosso, contestualmente all'attivazione del percorso STEMI. In ambulanza, il paziente è stato sottoposto a monitoraggio ECG continuo (implicito nel contesto di emergenza per STEMI) e il defibrillatore era disponibile come standard di dotazione. All'ingresso in Pronto Soccorso alle 08:02, il paziente è stato assegnato codice rosso e instradato direttamente verso l'area emergenza con percorso diretto in emodinamica. La scheda triage e la valutazione medica confermano la stabilità emodinamica e la presenza di monitoraggio continuo. In UTIC e in degenza, il monitoraggio ECG continuo è stato mantenuto, come documentato nei diari infermieristici e clinici. La disponibilità del defibrillatore è garantita per protocollo nei setting di emergenza e UTIC. Pertanto, il monitoraggio ECG continuo e la disponibilità del defibrillatore sono stati attivati il prima possibile dal primo contatto medico (07:44), soddisfacendo pienamente la regola.",
  "supporting_documents": [
    {
      "document_id": "2",
      "rationale": "Il verbale del 118 documenta il primo contatto medico con sospetto STEMI alle 07:46, l'esecuzione dell'ECG diagnostico, l'attivazione della rete IMA e il trasporto in codice rosso. In questo contesto, il monitoraggio ECG continuo e la disponibilità del defibrillatore sono standard operativi, garantiti per protocollo.",
      "confidence": 0.99
    },
    {
      "document_id": "3",
      "rationale": "La scheda triage del Pronto Soccorso conferma l'accesso in codice rosso per STEMI, con instradamento immediato in area emergenza. Questo implica l'attivazione immediata del monitoraggio ECG continuo e la disponibilità del defibrillatore, in linea con i protocolli di emergenza.",
      "confidence": 0.98
    },
    {
      "document_id": "12",
      "rationale": "Il diario infermieristico UTIC documenta l'ingresso del paziente post-PCI con collegamento a monitor multiparametrico e telemetria continua, confermando la continuità del monitoraggio ECG. La sede di accesso radiale è controllata, e il paziente è stabile, in un setting dove il defibrillatore è obbligatoriamente disponibile.",
      "confidence": 0.97
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

- timestamp_utc: 2026-04-06T23:36:05.833709+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 384
- rule_id: 4
- rule_name: STEMI-DO-004
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 8/10
- rationale_alignment: 6/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 10.20s
- estimated_cost: $0.004564

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DO-004-001",
  "check_timestamp": "2024-04-05T10:30:00Z",
  "rule_id": "STEMI-DO-004",
  "patient_id_hash": "5a7d9f2e3b8c1e4a9d6f2c8b1a5e7d9f",
  "outcome": "compliant",
  "confidence": 0.98,
  "rationale": "Il paziente ha presentato sospetta SCA con dolore toracico in corso e alterazioni elettrocardiografiche suggestive fin dal primo contatto con il personale 118. Il monitoraggio ECG continuo è stato attivato in ambulanza (documentato nel verbale 118 e confermato all'ingresso in Pronto Soccorso), e un defibrillatore era immediatamente disponibile. La disponibilità del defibrillatore e il monitoraggio continuo sono stati mantenuti in PS, UTIC e degenza fino alla stabilizzazione. L'attivazione è avvenuta entro pochi minuti dal First Medical Contact (FMC alle 07:44), ben prima di qualsiasi trasferimento o procedura invasiva.",
  "supporting_documents": [
    {
      "document_id": "2",
      "rationale": "Il verbale dell'intervento 118 documenta l'accesso del paziente con dolore toracico persistente e alterazioni ECG, e menziona esplicitamente il trasporto protetto in codice tempo-dipendente. Tale contesto implica l'attivazione immediata del monitoraggio ECG continuo e la disponibilità del defibrillatore in ambulanza, conforme alla pratica standard nei casi di sospetta SCA ad alto rischio.",
      "confidence": 0.95
    },
    {
      "document_id": "3",
      "rationale": "La scheda di triage del Pronto Soccorso conferma l'accesso con codice arancione per dolore toracico e alterazioni ECG, con instradamento in area emergenza ad alta intensità. Tale setting prevede monitoraggio continuo e defibrillatore immediatamente disponibile, come standard di cura, e la documentazione infermieristica supporta la continuità del monitoraggio.",
      "confidence": 0.98
    },
    {
      "document_id": "17",
      "rationale": "Il diario infermieristico dell'UTIC documenta esplicitamente il collegamento del paziente al monitor multiparametrico e alla telemetria continua all'ingresso in UTIC post-PCI, confermando la continuità del monitoraggio ECG. La sede di accesso e i parametri vitali sono controllati regolarmente, in un contesto dove il defibrillatore è di routine disponibile.",
      "confidence": 1.0
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

- timestamp_utc: 2026-04-06T23:36:52.995910+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 385
- rule_id: 5
- rule_name: STEMI-DO-005
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: not_applicable
- outcome_gold: not_applicable
- conformity_vs_gold: 9/10
- rationale_alignment: 8/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 32.17s
- estimated_cost: $0.004312

### JSON modello

```json
{
  "check_id": "CHK-STEMI-005-20260322",
  "check_timestamp": "2026-03-22T12:00:00+01:00",
  "rule_id": "STEMI-DO-005",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "not_applicable",
  "confidence": 0.98,
  "rationale": "La regola si applica a STEMI inferiore o a sospetta occlusione coronarica totale con ECG standard non conclusivo. Nel caso in esame, l'ECG pre-ospedaliero e quello di triage mostrano un quadro di STEMI antero-laterale con sopraslivellamento del tratto ST in V2-V6, I e aVL, e sottoslivellamento reciproco in II, III e aVF. Non vi è coinvolgimento della parete inferiore né sospetto di occlusione coronarica totale con ECG non conclusivo. Pertanto, la condizione di applicabilità della regola non sussiste e la raccomandazione sulle derivazioni aggiuntive (V3R, V4R, V7–V9) non è pertinente.",
  "supporting_documents": [
    {
      "document_id": "1",
      "rationale": "L'ECG pre-ospedaliero documenta un STEMI antero-laterale con ST elevato in V2-V4, V5-V6, I e aVL, escludendo un coinvolgimento inferiore come criterio di inclusione per la regola.",
      "confidence": 0.99
    },
    {
      "document_id": "2",
      "rationale": "Il verbale 118 conferma il quadro clinico ed elettrocardiografico di STEMI antero-laterale, con attivazione della rete IMA basata su questo reperto, escludendo l'applicabilità della regola specifica per STEMI inferiore.",
      "confidence": 0.97
    },
    {
      "document_id": "4",
      "rationale": "La valutazione medica in Pronto Soccorso conferma il quadro di STEMI antero-laterale e la decisione di procedere direttamente a PCI primaria senza necessità di ulteriori derivazioni, in quanto la diagnosi è già conclusiva.",
      "confidence": 0.96
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

- timestamp_utc: 2026-04-06T23:37:23.826760+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 386
- rule_id: 5
- rule_name: STEMI-DO-005
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 8/10
- rationale_alignment: 6/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 5.61s
- estimated_cost: $0.004278

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DO-005-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DO-005",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "compliant",
  "confidence": 0.95,
  "rationale": "Il paziente presenta uno STEMI inferiore con ECG standard non inizialmente conclusivo. L'ECG delle 11:02 mostra sopraslivellamento ST ≥1 mm in DII, DIII e aVF, soddisfacendo il criterio di inclusione INCL-005-01. Entro 16 minuti (alle 11:18), è stato eseguito un ECG con derivazioni aggiuntive (V7-V9 e V3R-V4R) su richiesta cardiologica, confermando l'estensione posteriore dell'infarto. Il tracciato è stato interpretato e documentato nel referto. L'esecuzione è avvenuta prima dell'attivazione della sala di emodinamica (11:40) e soddisfa i criteri di completamento della regola. Non risultano eccezioni applicabili.",
  "supporting_documents": [
    {
      "document_id": "9",
      "rationale": "ECG standard a 12 derivazioni delle 11:02 che evidenzia sopraslivellamento ST diagnostico in derivazioni inferiori (DII 1.5 mm, DIII 2.5 mm, aVF 2.0 mm), attivando la regola.",
      "confidence": 0.98
    },
    {
      "document_id": "10",
      "rationale": "ECG con derivazioni aggiuntive (V7-V9 e V3R-V4R) eseguito alle 11:18, entro 10 minuti dall'ECG diagnostico, con documentazione del sopraslivellamento ST in V7-V9 (1-1.5 mm), soddisfacendo l'azione attesa.",
      "confidence": 0.97
    },
    {
      "document_id": "11",
      "rationale": "Valutazione cardiologica delle 11:39 che conferma l'indicazione a PCI primaria sulla base dell'ECG con derivazioni aggiuntive, dimostrando l'uso clinico delle informazioni ottenute.",
      "confidence": 0.95
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

- timestamp_utc: 2026-04-06T23:37:53.220232+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 387
- rule_id: 6
- rule_name: STEMI-DO-006
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: not_applicable
- outcome_gold: not_applicable
- conformity_vs_gold: 9/10
- rationale_alignment: 8/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 12.29s
- estimated_cost: $0.004375

### JSON modello

```json
{
  "check_id": "CHK-STEMI-006-20260322",
  "check_timestamp": "2026-03-22T12:00:00+01:00",
  "rule_id": "STEMI-DO-006",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "not_applicable",
  "confidence": 0.95,
  "rationale": "La regola richiede un ECG a 12 derivazioni aggiuntivo in caso di sintomi ricorrenti o incertezza diagnostica dopo il primo ECG. Nel presente caso, il primo ECG pre-ospedaliero (id: 1) è chiaramente diagnostico per STEMI antero-laterale, con sopraslivellamento del tratto ST in V2-V6, I e aVL e sottoslivellamento reciproco in II, III e aVF. Il referto è stato trasmesso alla rete IMA e condiviso con l'ematologo reperibile, attivando immediatamente il percorso STEMI. Non vi è alcuna documentazione di incertezza diagnostica da parte del personale medico né segni di interpretazione ambigua. Inoltre, non sono documentati sintomi ischemici ricorrenti dopo il primo ECG: il dolore toracico, presente all'insorgenza (07:10), si riduce da NRS 9 a 6 dopo terapia pre-ospedaliera e scompare completamente entro l'arrivo in UTIC. La diagnosi di STEMI è stata confermata clinicamente ed elettrocardiograficamente fin dall'inizio, e la strategia di riperfusione (PCI primaria) è stata attivata immediatamente, con door-to-balloon time di 53 minuti. Pertanto, i criteri di inclusione della regola non si verificano e l'applicabilità è esclusa secondo il criterio di esclusione STEMI-DO-006-EXC-01 (diagnosi confermata e riperfusione attivata).",
  "supporting_documents": [
    {
      "document_id": "1",
      "rationale": "L'ECG pre-ospedaliero mostra chiari segni di STEMI antero-laterale (ST elevato in V2-V6, I, aVL e ST depresso in II, III, aVF), con referto interpretato e trasmesso alla rete IMA, escludendo incertezza diagnostica.",
      "confidence": 0.98
    },
    {
      "document_id": "2",
      "rationale": "Il verbale 118 documenta l'attivazione immediata della rete IMA dopo l'ECG, confermando la diagnosi non ambigua e l'avvio della strategia di riperfusione, rendendo non applicabile la necessità di un ECG aggiuntivo.",
      "confidence": 0.95
    },
    {
      "document_id": "9",
      "rationale": "Il referto emodinamico conferma l'occlusione trombotica dell'IVA prossimale come lesione culprit, in accordo con i reperti ECG, dimostrando che la diagnosi iniziale era corretta e tempestivamente gestita.",
      "confidence": 0.93
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

- timestamp_utc: 2026-04-06T23:38:19.645301+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 388
- rule_id: 6
- rule_name: STEMI-DO-006
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 8/10
- rationale_alignment: 6/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 7.61s
- estimated_cost: $0.004276

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DO-006-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DO-006",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "compliant",
  "confidence": 0.95,
  "rationale": "Il paziente ha presentato sintomi ricorrenti di dolore toracico documentati alle ore 11:02, con aumento del punteggio NRS da 3/10 a 7/10 e comparsa di netto sopraslivellamento del tratto ST all'ECG, quadro compatibile con evoluzione verso STEMI inferiore. In risposta a tale recidiva sintomatologica, è stato eseguito un ECG a 12 derivazioni aggiuntivo alle 11:02, seguito da ECG con derivazioni posteriori (V7-V9) alle 11:18 per confermare l'estensione posteriore. Entrambi i tracciati sono stati interpretati e documentati nel fascicolo clinico. La regola è pertanto rispettata, poiché l'ECG aggiuntivo è stato eseguito in presenza di sintomi ricorrenti e prima della conferma definitiva di STEMI e dell'attivazione della riperfusione (avvenuta alle 11:40).",
  "supporting_documents": [
    {
      "document_id": "9",
      "rationale": "Documento chiave: ECG seriato eseguito alle 11:02 in risposta a recrudescenza del dolore toracico (NRS 7/10), con evidenza di netto sopraslivellamento del tratto ST in DII, DIII, aVF. Questo tracciato rappresenta l'ECG aggiuntivo richiesto dalla regola in caso di sintomi ricorrenti.",
      "confidence": 0.98
    },
    {
      "document_id": "10",
      "rationale": "Documento di supporto: ECG con derivazioni aggiuntive (V7-V9) eseguito alle 11:18 per valutare estensione posteriore, dimostrando ulteriore sopraslivellamento ST. Conferma l'approfondimento elettrocardiografico in corso di incertezza diagnostica evolutiva.",
      "confidence": 0.92
    },
    {
      "document_id": "11",
      "rationale": "Documento di contesto: valutazione cardiologica alle 11:39 che conferma diagnosi di STEMI sulla base dell'ECG delle 11:02 e attiva la riperfusione. Dimostra che l'ECG aggiuntivo è stato eseguito prima della conferma diagnostica e dell'attivazione della strategia di riperfusione.",
      "confidence": 0.9
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

- timestamp_utc: 2026-04-06T23:38:45.114644+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 389
- rule_id: 7
- rule_name: STEMI-DO-007
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 8/10
- rationale_alignment: 7/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 4.85s
- estimated_cost: $0.004445

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DO-007-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DO-007",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "compliant",
  "confidence": 0.98,
  "rationale": "Il paziente è stato presentato al pronto soccorso alle 08:02:00+01:00 con sospetto STEMI antero-laterale, confermato dall'ECG pre-ospedaliero. Il prelievo ematico per la troponina ad alta sensibilità (hs-cTnI) è stato eseguito immediatamente dopo l'ingresso, con referto disponibile alle 08:15:00+01:00. Il tempo tra il prelievo e la refertazione è inferiore a 60 minuti, e il metodo utilizzato è ad alta sensibilità, come dimostrato dal valore di hs-cTnI riportato. Tutti i criteri della regola sono soddisfatti.",
  "supporting_documents": [
    {
      "document_id": "7",
      "rationale": "Referto del laboratorio che documenta il risultato della troponina ad alta sensibilità (hs-cTnI) disponibile entro 13 minuti dal prelievo, confermando il rispetto del vincolo temporale di 60 minuti.",
      "confidence": 0.99
    },
    {
      "document_id": "3",
      "rationale": "Scheda di triage che attesta la presentazione del paziente al pronto soccorso alle 08:02:00+01:00, utilizzata come timestamp di riferimento per il calcolo del tempo di prelievo.",
      "confidence": 0.98
    },
    {
      "document_id": "4",
      "rationale": "Valutazione medica del pronto soccorso che conferma il sospetto clinico di STEMI e l'attivazione del percorso dedicato, supportando l'applicabilità della regola.",
      "confidence": 0.97
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

- timestamp_utc: 2026-04-06T23:39:14.171934+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 390
- rule_id: 7
- rule_name: STEMI-DO-007
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 7/10
- rationale_alignment: 5/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 8.65s
- estimated_cost: $0.004400

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DO-007-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DO-007",
  "patient_id_hash": "5a8b9e2c3d1f4a6b8c7d9e0f1a2b3c4d",
  "outcome": "compliant",
  "confidence": 0.98,
  "rationale": "Il paziente si presenta in pronto soccorso con dolore toracico sospetto per SCA e alterazioni ECG compatibili con STEMI inferiore in evoluzione. Il prelievo ematico per hs-cTnI è eseguito alle 08:18, entro 15 minuti dalla presentazione alle 08:02. Il risultato è refertato alle 08:58, entro 60 minuti dal prelievo (40 minuti). Il metodo utilizzato è ad alta sensibilità (hs-cTnI), come confermato dal referto di laboratorio. Tutti i criteri della regola sono soddisfatti.",
  "supporting_documents": [
    {
      "document_id": "7",
      "rationale": "Documenta il prelievo basale di hs-cTnI alle 08:18, entro 15 minuti dalla presentazione del paziente alle 08:02, soddisfacendo il vincolo temporale di immediatezza.",
      "confidence": 0.99
    },
    {
      "document_id": "3",
      "rationale": "Conferma la presentazione del paziente in pronto soccorso alle 08:02, costituendo l'ancoraggio temporale per il calcolo del tempo di prelievo.",
      "confidence": 0.99
    },
    {
      "document_id": "7",
      "rationale": "Il referto di laboratorio indica la disponibilità del risultato di hs-cTnI alle 08:58, entro 60 minuti dal prelievo effettuato alle 08:18 (intervallo di 40 minuti), rispettando il tempo massimo di refertazione.",
      "confidence": 0.99
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

- timestamp_utc: 2026-04-06T23:39:38.908534+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 391
- rule_id: 8
- rule_name: STEMI-DO-008
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: not_applicable
- outcome_gold: not_applicable
- conformity_vs_gold: 8/10
- rationale_alignment: 7/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 4.33s
- estimated_cost: $0.004785

### JSON modello

```json
{
  "check_id": "CHK-STEMI-008-20260322",
  "check_timestamp": "2026-03-22T12:00:00+01:00",
  "rule_id": "STEMI-DO-008",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "not_applicable",
  "confidence": 1,
  "rationale": "La regola si applica a pazienti con sospetta sindrome coronarica acuta senza sopraslivellamento del tratto ST all'ECG (NSTEMI). Nel caso in esame, il paziente presenta un ECG pre-ospedaliero con sopraslivellamento del tratto ST in V2-V6, I e aVL, classificato come STEMI antero-laterale. Pertanto, il percorso clinico segue il protocollo STEMI diretto con attivazione immediata della rete IMA e PCI primaria, escludendo l'applicabilità dell'algoritmo ESC basato su dosaggi seriati di hs-cTn per NSTEMI.",
  "supporting_documents": [
    {
      "document_id": "1",
      "rationale": "Referto ECG pre-ospedaliero che documenta sopraslivellamento del tratto ST in V2-V4 (3 mm), V5-V6 (2 mm), I e aVL, con sottoslivellamento reciproco in II, III, aVF. Questo reperto è diagnostico per STEMI antero-laterale, escludendo l'applicabilità della regola dedicata a NSTEMI.",
      "confidence": 1
    },
    {
      "document_id": "2",
      "rationale": "Verbale 118 che conferma l'attivazione della rete IMA sulla base dell'ECG diagnostico per STEMI, con preallerta del centro HUB e somministrazione di terapia antiaggregante precoce. Ciò indica l'ingresso nel percorso STEMI diretto, non compatibile con l'uso dell'algoritmo ESC per NSTEMI.",
      "confidence": 1
    },
    {
      "document_id": "4",
      "rationale": "Valutazione medica in Pronto Soccorso che conferma il quadro di STEMI antero-laterale e la decisione di procedere con coronarografia urgente e PCI primaria, escludendo la necessità di algoritmi di stratificazione basati su troponina seriale per NSTEMI.",
      "confidence": 1
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

- timestamp_utc: 2026-04-06T23:40:59.193317+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 392
- rule_id: 8
- rule_name: STEMI-DO-008
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: not_applicable
- outcome_gold: non_compliant
- conformity_vs_gold: 1/10
- rationale_alignment: 2/10 (inferenziale)
- outcome_alignment: 0/10
- check_time: 4.17s
- estimated_cost: $0.004738

### JSON modello

```json
{
  "check_id": "CHK-STEMI-008-20260323",
  "check_timestamp": "2026-03-23T12:00:00+01:00",
  "rule_id": "STEMI-DO-008",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "not_applicable",
  "confidence": 0.98,
  "rationale": "La regola si applica a pazienti con sospetta sindrome coronarica acuta senza sopraslivellamento persistente del tratto ST (NSTEMI), per i quali è indicato l'algoritmo ESC con dosaggi seriati di hs-cTn. Nel caso in esame, il paziente ha evoluto verso una diagnosi di STEMI inferiore con estensione posteriore, confermata da ECG seriato e derivazioni posteriori, con attivazione della sala di emodinamica e PCI primaria eseguita. Pertanto, il percorso clinico ha seguito il protocollo STEMI diretto, escludendo l'applicabilità della regola relativa all'algoritmo ESC per NSTEMI. L'uso di dosaggi seriati di hs-cTn è avvenuto in contesto di monitoraggio post-riperfusione e non per diagnosi differenziale NSTEMI.",
  "supporting_documents": [
    {
      "document_id": "9",
      "rationale": "ECG delle 11:02 mostra netto sopraslivellamento del tratto ST in DII, DIII e aVF con sottoslivellamento reciproco in DI-aVL, quadro diagnostico per STEMI inferiore, escludendo l'applicabilità della regola per NSTEMI.",
      "confidence": 0.99
    },
    {
      "document_id": "10",
      "rationale": "ECG con derivazioni posteriori V7-V9 alle 11:18 conferma estensione posteriore dell'infarto, consolidando la diagnosi di STEMI e giustificando l'attivazione del percorso riperfusivo diretto.",
      "confidence": 0.98
    },
    {
      "document_id": "11",
      "rationale": "Valutazione cardiologica alle 11:39 pone indicazione a PCI primaria per STEMI conclamato, con attivazione della sala di emodinamica, confermando l'uscita dal percorso diagnostico NSTEMI.",
      "confidence": 0.97
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

- timestamp_utc: 2026-04-06T23:41:31.385276+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 393
- rule_id: 9
- rule_name: STEMI-DO-009
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: not_applicable
- outcome_gold: not_applicable
- conformity_vs_gold: 9/10
- rationale_alignment: 8/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 10.03s
- estimated_cost: $0.004824

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DO-009-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DO-009",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "not_applicable",
  "confidence": 0.98,
  "rationale": "La regola non è applicabile poiché il paziente presenta un quadro clinico ed elettrocardiografico di STEMI evidente all'ingresso, con sopraslivellamento del tratto ST in derivazioni V2-V6, I e aVL documentato nell'ECG pre-ospedaliero del 18/03/2026 alle 07:44. In tali casi, secondo le linee guida ESC, il percorso diagnostico-terapeutico prevede attivazione immediata della rete IMA e riperfusione primaria senza necessità di algoritmi seriali di hs-cTn. L'assenza di dosaggio aggiuntivo a 3 ore non costituisce una non conformità, in quanto il paziente è stato correttamente gestito come caso di STEMI franco.",
  "supporting_documents": [
    {
      "document_id": "1",
      "rationale": "L'ECG pre-ospedaliero documenta un chiaro sopraslivellamento del tratto ST in V2-V4 (3 mm), V5-V6 (2 mm), I e aVL, con reciproco sottoslivellamento in II, III e aVF, classico di STEMI antero-laterale. Questo reperto esclude l'applicabilità della regola, che riguarda casi con algoritmo 0h/1h inconcludente.",
      "confidence": 0.99
    },
    {
      "document_id": "2",
      "rationale": "Il verbale 118 conferma l'attivazione della rete IMA alle 07:47 sulla base dell'ECG, con pretrattamento immediato (ASA, ticagrelor, eparina) e trasporto diretto in HUB. Questo indica che il caso è stato classificato come STEMI franco fin dall'ambito preospedaliero, rendendo non necessario alcun ulteriore dosaggio di hs-cTn per conferma diagnostica.",
      "confidence": 0.98
    },
    {
      "document_id": "4",
      "rationale": "La valutazione in Pronto Soccorso conferma il quadro di STEMI e la stabilità emodinamica, con decisione immediata di procedere a coronarografia urgente. Non viene menzionato alcun dubbio diagnostico né richiesta di algoritmo 0h/1h, in quanto la diagnosi è già definita dall'ECG.",
      "confidence": 0.97
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

- timestamp_utc: 2026-04-06T23:41:57.580042+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 394
- rule_id: 9
- rule_name: STEMI-DO-009
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: not_applicable
- outcome_gold: not_evaluable
- conformity_vs_gold: 7/10
- rationale_alignment: 7/10 (inferenziale)
- outcome_alignment: 6/10
- check_time: 5.55s
- estimated_cost: $0.004784

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DO-009-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DO-009",
  "patient_id_hash": "5a7d9f2e3b8c1e4a9d6f2c8b7a4e1d5f",
  "outcome": "not_applicable",
  "confidence": 0.95,
  "rationale": "La regola richiede un dosaggio aggiuntivo di hs-cTn a 3 ore in caso di risultati inconcludenti dell'algoritmo 0 h/1 h. Tuttavia, nel presente caso, il percorso clinico non ha seguito tale algoritmo rapido. Il paziente è stato inizialmente valutato con un ECG pre-ospedaliero e un primo dosaggio di hs-cTn alle 08:18 (tempo 0), ma non è stato eseguito un secondo dosaggio a 1 ora come previsto dall'algoritmo 0 h/1 h. Pertanto, non è possibile determinare se l'esito fosse inconcludente. Inoltre, l'evoluzione clinica ed elettrocardiografica ha portato a una diagnosi di STEMI franco alle 11:02, che configura un'esclusione esplicita della regola (STEMI evidente all'ECG). Il dosaggio di hs-cTn alle 11:58 (circa 3h40m dal primo prelievo) è stato eseguito in un contesto di diagnosi già orientata verso STEMI e non come parte di un algoritmo 0 h/1 h inconcludente. Di conseguenza, la regola non è applicabile.",
  "supporting_documents": [
    {
      "document_id": "7",
      "rationale": "Fornisce il primo valore di hs-cTn (38 ng/L) alle 08:18, utilizzato come tempo 0, ma non esiste un secondo dosaggio a 1 ora per completare l'algoritmo 0 h/1 h.",
      "confidence": 0.98
    },
    {
      "document_id": "9",
      "rationale": "ECG delle 11:02 mostra chiaro sopraslivellamento ST in DII, DIII, aVF, configurando uno STEMI franco, che esclude l'applicabilità della regola secondo il criterio STEMI-DO-009-EXC-03.",
      "confidence": 0.99
    },
    {
      "document_id": "13",
      "rationale": "Il secondo dosaggio di hs-cTn (214 ng/L) è stato eseguito alle 11:58, circa 3h40m dopo il primo, in un contesto di sospetto clinico già elevato e non come parte di un algoritmo 0 h/1 h standard.",
      "confidence": 0.9
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

- timestamp_utc: 2026-04-06T23:42:17.487262+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 395
- rule_id: 10
- rule_name: STEMI-DO-010
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: not_applicable
- outcome_gold: not_applicable
- conformity_vs_gold: 9/10
- rationale_alignment: 8/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 4.66s
- estimated_cost: $0.004728

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DO-010-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DO-010",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "not_applicable",
  "confidence": 0.98,
  "rationale": "La regola richiede l'esecuzione di un ecocardiogramma transtoracico (TTE) d'emergenza in caso di shock cardiogeno o sospette complicanze meccaniche post-infarto. Nel presente episodio, il paziente è stato classificato Killip I, emodinamicamente stabile sin dall'arrivo (PA > 140 mmHg, assenza di ipoperfusione, no vasopressori), senza segni di scompenso acuto né di complicanze meccaniche (nessun soffio di nuova insorgenza, nessun deterioramento emodinamico improvviso, nessun sospetto di tamponamento). L'ecocardiogramma è stato eseguito in regime di urgenza ma non d'emergenza, in quanto non vi erano criteri di instabilità. Pertanto, il trigger della regola non si è mai attivato e la regola non è applicabile.",
  "supporting_documents": [
    {
      "document_id": "4",
      "rationale": "Il referto medico del Pronto Soccorso documenta Killip I e stabilità emodinamica (PA 148/86 mmHg, FC 90 bpm), escludendo shock cardiogeno.",
      "confidence": 0.99
    },
    {
      "document_id": "6",
      "rationale": "L'esame obiettivo conferma assenza di segni di scompenso: cute normoperfusa, torace eupnoico, assenza di rantoli, polsi periferici validi, GCS 15.",
      "confidence": 0.98
    },
    {
      "document_id": "21",
      "rationale": "L'ecocardiogramma è stato eseguito in urgenza programmata (11:30 del 19/03), non in emergenza, per valutazione della funzione ventricolare post-PCI, non per sospetta complicanza meccanica o shock.",
      "confidence": 0.97
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

- timestamp_utc: 2026-04-06T23:42:40.074392+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 396
- rule_id: 10
- rule_name: STEMI-DO-010
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: not_applicable
- outcome_gold: not_applicable
- conformity_vs_gold: 9/10
- rationale_alignment: 8/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 4.92s
- estimated_cost: $0.004710

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DO-010-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DO-010",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "not_applicable",
  "confidence": 0.98,
  "rationale": "La regola richiede l'esecuzione di un ecocardiogramma transtoracico (TTE) d'emergenza nei pazienti con sospetta sindrome coronarica acuta (SCA) che presentano shock cardiogeno o sospette complicanze meccaniche. Nel caso del paziente Mario Rossi, non vi sono evidenze di shock cardiogeno (PAS sempre > 90 mmHg, assenza di vasopressori, segni di ipoperfusione assenti) né di sospette complicanze meccaniche (nessun soffio di nuova insorgenza, nessun deterioramento emodinamico improvviso, nessun sospetto di tamponamento). Il paziente è sempre stato Killip I, emodinamicamente stabile. Pertanto, i criteri di inclusione della regola non sono soddisfatti e la regola non è applicabile.",
  "supporting_documents": [
    {
      "document_id": "4",
      "rationale": "Documenta la stabilità emodinamica del paziente all'ingresso in Pronto Soccorso: Killip I, PA 154/88 mmHg, FC 86 bpm, assenza di segni di ipoperfusione. Esclude shock cardiogeno.",
      "confidence": 0.99
    },
    {
      "document_id": "24",
      "rationale": "Referto ecocardiografico del 19/03/2026: assenza di complicanze meccaniche (nessun trombo, nessun versamento pericardico, nessuna rottura), FEVS 47%. L'esame è stato eseguito in regime di routine, non d'emergenza, confermando l'assenza di condizioni che avrebbero richiesto TTE urgente.",
      "confidence": 0.98
    },
    {
      "document_id": "16",
      "rationale": "Documenta l'ingresso in UTIC post-PCI: paziente emodinamicamente stabile, Killip I, PA 132/78 mmHg, senza necessità di supporto vasopressorio. Nessun segno di ipoperfusione o scompenso acuto.",
      "confidence": 0.97
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

- timestamp_utc: 2026-04-06T23:43:02.948405+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 397
- rule_id: 11
- rule_name: STEMI-DONOT-001
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 9/10
- rationale_alignment: 8/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 7.66s
- estimated_cost: $0.004255

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DONOT-001-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DONOT-001",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "compliant",
  "confidence": 0.98,
  "rationale": "Nel presente episodio, il paziente è stato correttamente gestito secondo il percorso STEMI con attivazione della rete IMA già in ambito pre-ospedaliero, ECG diagnostico per STEMI antero-laterale, pretrattamento farmacologico e trasferimento diretto in emodinamica. Non è stata richiesta né eseguita alcuna angio-TC coronarica in fase precoce. La strategia diagnostica-terapeutica ha seguito le linee guida raccomandate, privilegiando la coronarografia invasiva immediata (door-to-balloon time di 53 minuti), evitando ritardi e esposizioni non necessarie a radiazioni o mezzo di contrasto. La regola è pertanto rispettata.",
  "supporting_documents": [
    {
      "document_id": "1",
      "rationale": "ECG pre-ospedaliero a 12 derivazioni dimostra sopraslivellamento del tratto ST in V2-V4, I e aVL, compatibile con STEMI antero-laterale, attivando il percorso riperfusivo diretto senza necessità di ulteriore imaging non invasivo.",
      "confidence": 0.99
    },
    {
      "document_id": "2",
      "rationale": "Verbale 118 documenta l'attivazione della rete IMA alle 07:47 e il trasporto diretto al centro HUB, escludendo l'esecuzione di esami di imaging alternativi come l'angio-TC coronarica.",
      "confidence": 0.98
    },
    {
      "document_id": "9",
      "rationale": "Referto di emodinamica conferma l'esecuzione di coronarografia urgente con PCI primaria su IVA prossimale, dimostrando l'adozione della strategia invasiva immediata e l'assenza di interventi diagnostici intermedi come l'angio-TC.",
      "confidence": 0.99
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

- timestamp_utc: 2026-04-06T23:43:26.018030+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 398
- rule_id: 11
- rule_name: STEMI-DONOT-001
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 8/10
- rationale_alignment: 7/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 5.39s
- estimated_cost: $0.004297

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DONOT-001-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DONOT-001",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "compliant",
  "confidence": 0.98,
  "rationale": "Nel presente episodio, il paziente si è presentato in Pronto Soccorso con sospetta sindrome coronarica acuta (SCA), inizialmente con ECG non diagnostico per STEMI. È stata correttamente evitata l'esecuzione di angio-TC coronarica precoce e di routine. La gestione ha seguito il percorso standard: monitoraggio clinico-strumentale, ECG seriati e dosaggi seriati di troponina. Alla comparsa di evidenti alterazioni elettrocardiografiche diagnostiche per STEMI inferiore con estensione posteriore, è stata tempestivamente attivata la sala di emodinamica per coronarografia urgente con intento di PCI primaria. Non vi è traccia di richiesta o esecuzione di angio-TC coronarica in fase precoce. L'assenza di tale esame è conforme alla raccomandazione che sconsiglia l'uso routinario e precoce della CCTA nei pazienti con sospetta SCA, al fine di non ritardare la riperfusione. Pertanto, la regola è stata rispettata.",
  "supporting_documents": [
    {
      "document_id": "11",
      "rationale": "Questo documento attesta la valutazione cardiologica urgente in PS e la decisione di attivare la sala di emodinamica per coronarografia con intento di PCI primaria in seguito alla comparsa di ECG diagnostico per STEMI. Dimostra che la strategia diagnostico-terapeutica ha seguito il percorso riperfusivo diretto, escludendo l'uso di angio-TC coronarica.",
      "confidence": 0.99
    },
    {
      "document_id": "14",
      "rationale": "Il referto di emodinamica conferma l'esecuzione della coronarografia invasiva come strategia primaria di riperfusione, con trattamento della lesione colpevole mediante PCI. L'assenza di qualsiasi menzione di angio-TC coronarica prima di questo passaggio supporta la conformità alla regola.",
      "confidence": 0.98
    },
    {
      "document_id": "9",
      "rationale": "L'ECG seriato delle 11:02 mostra la comparsa di alterazioni elettrocardiografiche chiaramente diagnostiche per STEMI inferiore, che ha innescato il percorso riperfusivo. Questo documento dimostra che la diagnosi è stata raggiunta con strumenti standard (ECG e clinica), senza ricorrere a CCTA.",
      "confidence": 0.97
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

- timestamp_utc: 2026-04-06T23:43:59.775910+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 399
- rule_id: 12
- rule_name: STEMI-DO-011
- case_id: 1
- case_identifier: CARDIO-STEMI-VANILLA
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: compliant
- outcome_gold: compliant
- conformity_vs_gold: 8/10
- rationale_alignment: 7/10 (inferenziale)
- outcome_alignment: 10/10
- check_time: 5.47s
- estimated_cost: $0.004477

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DO-011-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DO-011",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "compliant",
  "confidence": 0.95,
  "rationale": "Il paziente è stato gestito in conformità alla regola STEMI-DO-011. L'ECG pre-ospedaliero ha mostrato sopraslivellamento del tratto ST compatibile con STEMI antero-laterale, eseguito entro 10 minuti dal primo contatto medico (FMC alle 07:44). Il tracciato è stato trasmesso alla rete IMA e condiviso con l'emodinamista reperibile. Il laboratorio di emodinamica è stato attivato alle 07:47. Il paziente è stato trasportato direttamente al centro Hub, con arrivo in Pronto Soccorso alle 08:02 e door-to-balloon time di 53 minuti. La strategia di riperfusione è stata PCI primaria, in linea con i protocolli di rete. Tutti i vincoli temporali e sequenziali sono rispettati.",
  "supporting_documents": [
    {
      "document_id": "1",
      "rationale": "Documenta l'esecuzione dell'ECG a 12 derivazioni alle 07:44, entro 10 minuti dal FMC, con evidenza di sopraslivellamento ST compatibile con STEMI.",
      "confidence": 0.98
    },
    {
      "document_id": "2",
      "rationale": "Conferma il primo contatto medico alle 07:46, la trasmissione della preallerta al centro HUB alle 07:47 e l'attivazione della rete IMA, soddisfacendo il requisito di attivazione della rete regionale.",
      "confidence": 0.97
    },
    {
      "document_id": "9",
      "rationale": "Referto di emodinamica che conferma PCI primaria eseguita con successo e door-to-balloon time di 53 minuti, dimostrando l'efficace attivazione del percorso di riperfusione.",
      "confidence": 0.96
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

- timestamp_utc: 2026-04-06T23:44:33.481093+00:00
- run_instance_id: 7
- inference_params_id: 2
- compliance_instance_id: 400
- rule_id: 12
- rule_name: STEMI-DO-011
- case_id: 2
- case_identifier: CARDIO-STEMI-V01-05-08
- model_id: 32
- model_code: Qwen3-235B-A22B-Instruct-2507
- router_code: Nebius
- outcome_modello: non_compliant
- outcome_gold: probable_non_compliance
- conformity_vs_gold: 7/10
- rationale_alignment: 6/10 (inferenziale)
- outcome_alignment: 8/10
- check_time: 10.67s
- estimated_cost: $0.004519

### JSON modello

```json
{
  "check_id": "CHK-STEMI-DO-011-001",
  "check_timestamp": "2024-04-05T10:00:00Z",
  "rule_id": "STEMI-DO-011",
  "patient_id_hash": "RSSMRA58L12H501X",
  "outcome": "non_compliant",
  "confidence": 0.95,
  "rationale": "Il paziente ha presentato sintomi compatibili con STEMI e un ECG pre-ospedaliero (id: 1) con alterazioni suggestive per sindrome coronarica acuta infero-posteriore, trasmesso al centro Hub. Tuttavia, nonostante il quadro clinico-elettrocardiografico ad alto rischio, non è stata attivata la rete regionale STEMI con bypass diretto al centro Hub né è stato eseguito un ECG entro 10 minuti dal FMC. Il FMC è stimato alle 07:44 (dalle osservazioni del verbale 118, id: 2), mentre l'ECG è stato eseguito alle 07:48, rispettando il vincolo temporale. Tuttavia, non vi è evidenza documentata dell'attivazione del laboratorio di emodinamica in fase pre-ospedaliera né del trasporto diretto al centro Hub con bypass del PS. Il paziente è stato trasportato in PS dove è stato valutato solo alle 08:02, con decisione di attivazione dell'emodinamica solo alle 11:40, ben oltre i 120 minuti raccomandati dal FMC. Il tempo FMC-to-balloon è stato di 285 minuti. Non risultano giustificazioni documentate per la mancata attivazione della rete (es. impossibilità di raggiungere il centro PCI entro 120 minuti o controindicazioni alla fibrinolisi). Pertanto, la gestione pre-ospedaliera non è conforme alla regola.",
  "supporting_documents": [
    {
      "document_id": "1",
      "rationale": "ECG pre-ospedaliero con alterazioni ST suggestive per SCA infero-posteriore, trasmesso al PS Hub, ma non documenta attivazione della rete STEMI né bypass diretto.",
      "confidence": 0.98
    },
    {
      "document_id": "2",
      "rationale": "Verbale 118 indica FMC stimato alle 07:44 e ECG eseguito alle 07:48, entro 10 minuti, ma manca evidenza di attivazione del laboratorio di emodinamica o trasporto diretto al centro Hub.",
      "confidence": 0.95
    },
    {
      "document_id": "14",
      "rationale": "Referto emodinamica mostra FMC-to-balloon time di 285 minuti, ampiamente superiore al limite di 120 minuti, senza giustificazione documentata per la deviazione.",
      "confidence": 0.97
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

