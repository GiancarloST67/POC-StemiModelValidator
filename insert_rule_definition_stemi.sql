BEGIN;
SET search_path TO riskm_manager_model_evaluation, public;

INSERT INTO riskm_manager_model_evaluation.rule_definition (clinical_pathway_id, name, body)
VALUES (1, 'STEMI-DO-001', $json_STEMI_DO_001$
{
  "schema_version": "1.0.0",
  "rule_id": "STEMI-DO-001",
  "rule_type": "do",
  "title": "Valutazione immediata per strategia di riperfusione d'emergenza nei pazienti con sospetto STEMI",
  "short_label": "Valutazione riperfusione STEMI",
  "clinical_pathway_id": "PDTA-STEMI-001",
  "clinical_pathway_name": "Percorso Diagnostico Terapeutico Assistenziale per Infarto Miocardico con Sopraslivellamento del tratto ST (STEMI)",
  "clinical_phase": "triage e valutazione iniziale",
  "care_settings": [
    "Pronto Soccorso",
    "Sistema di Emergenza Territoriale 118",
    "Unità di Terapia Intensiva Cardiologica"
  ],
  "responsible_actors": [
    {
      "role_name": "Medico d'emergenza-urgenza",
      "responsibility_type": "primary",
      "organization_unit": "Pronto Soccorso / Dipartimento di Emergenza e Accettazione (DEA)",
      "notes": "Responsabile della valutazione clinica iniziale e dell'attivazione della strategia di riperfusione."
    },
    {
      "role_name": "Cardiologo interventista",
      "responsibility_type": "consulted",
      "organization_unit": "Laboratorio di Emodinamica / Cardiologia Interventistica",
      "notes": "Consulente per la definizione della strategia di riperfusione più appropriata (PCI primaria vs fibrinolisi)."
    },
    {
      "role_name": "Infermiere di triage",
      "responsibility_type": "supporting",
      "organization_unit": "Pronto Soccorso",
      "notes": "Supporto nell'identificazione precoce dei pazienti con sospetto STEMI e nell'esecuzione dell'ECG a 12 derivazioni."
    },
    {
      "role_name": "Medico del Sistema di Emergenza Territoriale 118",
      "responsibility_type": "primary",
      "organization_unit": "Centrale Operativa 118 / Ambulanza medicalizzata",
      "notes": "Responsabile della valutazione pre-ospedaliera e dell'attivazione del percorso STEMI in fase pre-ospedaliera."
    },
    {
      "role_name": "Coordinatore della rete STEMI",
      "responsibility_type": "monitoring",
      "organization_unit": "Rete cardiologica regionale",
      "notes": "Supervisione del rispetto dei tempi e delle procedure della rete per lo STEMI."
    }
  ],
  "deontic_strength": "recommended",
  "recommendation_strength": "Classe I (fortemente raccomandato)",
  "evidence_level": "Livello di evidenza B",
  "original_statement": "Si raccomanda che i pazienti con sospetto STEMI siano immediatamente valutati per una emergency reperfusion strategy.",
  "normalized_statement": "Ogni paziente con sospetto clinico ed elettrocardiografico di STEMI deve essere immediatamente valutato per determinare la strategia di riperfusione d'emergenza più appropriata.",
  "intent": "Garantire che ogni paziente con sospetto STEMI riceva una valutazione tempestiva finalizzata alla selezione e attivazione della strategia di riperfusione d'emergenza più appropriata, riducendo il tempo totale di ischemia miocardica.",
  "rationale": "La tempestività della riperfusione miocardica è il principale determinante della prognosi nei pazienti con STEMI. La valutazione immediata per la strategia di riperfusione consente di ridurre il ritardo tra il primo contatto medico e l'apertura del vaso coronarico occluso, migliorando la sopravvivenza e riducendo l'estensione dell'infarto.",
  "source_references": [
    {
      "source_id": "SRC-ESC-STEMI-2023",
      "source_level": "international",
      "issuer": "European Society of Cardiology (ESC)",
      "document_title": "2023 ESC Guidelines for the management of acute coronary syndromes",
      "document_version": "2023",
      "publication_date": "2023-08-25",
      "section_reference": "Sezione 5 - Strategia di riperfusione",
      "page_reference": "p. 28-35",
      "statement_quote": "Si raccomanda che i pazienti con sospetto STEMI siano immediatamente valutati per una emergency reperfusion strategy.",
      "citation_uri": "https://doi.org/10.1093/eurheartj/ehad191",
      "license_note": "Contenuto soggetto a copyright ESC. Utilizzo consentito per finalità cliniche e di ricerca secondo le condizioni d'uso dell'editore."
    }
  ],
  "applicability": {
    "population_description": "Pazienti adulti (età ≥ 18 anni) con sospetto clinico di infarto miocardico con sopraslivellamento del tratto ST (STEMI), inclusi pazienti con dolore toracico acuto e alterazioni ECG compatibili con STEMI.",
    "clinical_context": "Sospetto clinico ed elettrocardiografico di STEMI in fase acuta, indipendentemente dal tempo di insorgenza dei sintomi.",
    "care_context": "Fase pre-ospedaliera (ambulanza 118) e fase di accesso al Pronto Soccorso / DEA, fino alla decisione sulla strategia di riperfusione.",
    "inclusion_criteria": [
      {
        "criterion_id": "INC-001",
        "label": "Dolore toracico acuto suggestivo di sindrome coronarica acuta",
        "description": "Paziente che presenta dolore toracico acuto, oppressivo, retrosternale, eventualmente irradiato, o equivalente anginoso, suggestivo di ischemia miocardica acuta.",
        "logic_expression": "sintomo_dolore_toracico_acuto == true OR equivalente_anginoso == true",
        "data_elements": [
          "DE-001",
          "DE-002"
        ],
        "inference_allowed": true
      },
      {
        "criterion_id": "INC-002",
        "label": "Sopraslivellamento del tratto ST all'ECG a 12 derivazioni",
        "description": "ECG a 12 derivazioni che mostra sopraslivellamento del tratto ST in almeno due derivazioni contigue, oppure blocco di branca sinistra di nuova insorgenza, compatibile con diagnosi di STEMI.",
        "logic_expression": "ecg_st_elevation >= 1mm IN >=2 derivazioni_contigue OR nuovo_BBS == true",
        "data_elements": [
          "DE-003",
          "DE-004"
        ],
        "inference_allowed": true
      },
      {
        "criterion_id": "INC-003",
        "label": "Età adulta",
        "description": "Paziente di età maggiore o uguale a 18 anni.",
        "logic_expression": "età_paziente >= 18",
        "data_elements": [
          "DE-005"
        ],
        "inference_allowed": false
      }
    ],
    "exclusion_criteria": [
      {
        "criterion_id": "EXC-001",
        "label": "Direttive anticipate di trattamento che escludono interventi invasivi",
        "description": "Paziente con direttive anticipate di trattamento (DAT) valide che escludono esplicitamente interventi cardiologici invasivi o manovre di riperfusione.",
        "logic_expression": "DAT_presente == true AND DAT_esclude_riperfusione == true",
        "data_elements": [
          "DE-006"
        ],
        "inference_allowed": false
      },
      {
        "criterion_id": "EXC-002",
        "label": "Diagnosi alternativa confermata",
        "description": "Paziente per il quale è stata confermata una diagnosi alternativa che esclude lo STEMI, come pericardite acuta, sindrome di Takotsubo confermata, o artefatto ECG.",
        "logic_expression": "diagnosi_alternativa_confermata == true AND diagnosi_stemi_esclusa == true",
        "data_elements": [
          "DE-007"
        ],
        "inference_allowed": true
      }
    ]
  },
  "trigger": {
    "trigger_type": "diagnostic_finding",
    "trigger_description": "Riscontro di sopraslivellamento del tratto ST su ECG a 12 derivazioni in un paziente con sintomatologia clinica compatibile con sindrome coronarica acuta, oppure sospetto clinico fondato di STEMI comunicato dal personale del 118 o dal medico di triage.",
    "anchor_event": "Primo contatto medico con riscontro di sospetto STEMI (First Medical Contact - FMC)",
    "start_of_applicability": "Dal momento del primo contatto medico (FMC) con riscontro di sospetto STEMI, sia in fase pre-ospedaliera che in Pronto Soccorso.",
    "end_of_applicability": "Fino alla documentazione formale della decisione sulla strategia di riperfusione (PCI primaria, fibrinolisi, o esclusione motivata della riperfusione).",
    "trigger_data_elements": [
      "DE-001",
      "DE-002",
      "DE-003",
      "DE-008"
    ],
    "inference_allowed": true
  },
  "exceptions": [
    {
      "exception_id": "EXP-001",
      "label": "Arresto cardiaco refrattario con prognosi infausta",
      "description": "Paziente in arresto cardiaco refrattario a manovre di rianimazione cardiopolmonare avanzata prolungate, con segni di prognosi infausta, per il quale il team medico ritiene non indicato proseguire con la strategia di riperfusione.",
      "condition_logic": "arresto_cardiaco == true AND RCP_prolungata > 30min AND segni_prognosi_infausta == true",
      "required_justification": true,
      "required_evidence": [
        "Documentazione del tempo di arresto cardiaco e delle manovre rianimatorie eseguite",
        "Valutazione prognostica documentata dal medico responsabile"
      ]
    },
    {
      "exception_id": "EXP-002",
      "label": "Rifiuto informato del paziente",
      "description": "Il paziente, adeguatamente informato, rifiuta espressamente la valutazione o il trattamento di riperfusione.",
      "condition_logic": "rifiuto_informato_paziente == true AND documentazione_rifiuto == true",
      "required_justification": true,
      "required_evidence": [
        "Modulo di rifiuto informato firmato dal paziente",
        "Nota clinica attestante l'informazione fornita al paziente"
      ]
    },
    {
      "exception_id": "EXP-003",
      "label": "Comorbidità terminali con aspettativa di vita molto limitata",
      "description": "Paziente con patologie terminali preesistenti note (es. neoplasia in fase terminale) con aspettativa di vita molto limitata, per il quale il team medico concorda che la riperfusione non è nel miglior interesse del paziente.",
      "condition_logic": "patologia_terminale == true AND aspettativa_vita_limitata == true",
      "required_justification": true,
      "required_evidence": [
        "Documentazione clinica della patologia terminale",
        "Discussione multidisciplinare documentata",
        "Eventuale parere palliativista"
      ]
    }
  ],
  "expected_action": {
    "action_verb": "valutare",
    "action_description": "Valutare immediatamente il paziente con sospetto STEMI per determinare la strategia di riperfusione d'emergenza più appropriata, considerando: il tempo dall'insorgenza dei sintomi, la disponibilità di un laboratorio di emodinamica per PCI primaria entro i tempi raccomandati, le controindicazioni alla fibrinolisi, le condizioni cliniche del paziente e la logistica di trasporto.",
    "action_target": "Strategia di riperfusione d'emergenza (PCI primaria, fibrinolisi sistemica, o strategia farmaco-invasiva)",
    "action_parameters": [
      {
        "parameter_name": "Tempistica della valutazione",
        "parameter_description": "La valutazione per la strategia di riperfusione deve essere effettuata immediatamente al momento del riconoscimento del sospetto STEMI.",
        "expected_value": "immediata",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "Esecuzione ECG a 12 derivazioni",
        "parameter_description": "Un ECG a 12 derivazioni deve essere eseguito e interpretato entro 10 minuti dal primo contatto medico per confermare il sospetto STEMI.",
        "expected_value": "10",
        "comparison_operator": "less_than",
        "unit": "minuti",
        "mandatory": true
      },
      {
        "parameter_name": "Valutazione disponibilità PCI primaria",
        "parameter_description": "Deve essere verificata la possibilità di eseguire una PCI primaria entro 120 minuti dal primo contatto medico (o 90 minuti se il paziente si presenta precocemente).",
        "expected_value": "120",
        "comparison_operator": "less_than",
        "unit": "minuti",
        "mandatory": true
      }
    ],
    "alternative_compliant_actions": [
      "Se la PCI primaria non è disponibile entro i tempi raccomandati, considerare la fibrinolisi sistemica entro 10 minuti dalla diagnosi di STEMI, seguita da eventuale strategia farmaco-invasiva.",
      "In caso di presentazione pre-ospedaliera, attivazione diretta del laboratorio di emodinamica con trasporto diretto del paziente, bypassando il Pronto Soccorso."
    ]
  },
  "completion_criteria": {
    "description": "La regola si considera soddisfatta quando è stata documentata formalmente la decisione sulla strategia di riperfusione d'emergenza più appropriata per il paziente con sospetto STEMI, con le relative motivazioni cliniche e la tempistica prevista.",
    "minimum_occurrences": 1,
    "required_event_types": [
      "Interpretazione ECG a 12 derivazioni documentata",
      "Decisione sulla strategia di riperfusione documentata"
    ],
    "required_documentation_elements": [
      "Referto ECG con interpretazione e ora di esecuzione",
      "Nota clinica con indicazione della strategia di riperfusione scelta",
      "Ora del primo contatto medico (FMC)",
      "Ora della diagnosi di STEMI"
    ],
    "success_condition": "ECG interpretato E strategia di riperfusione documentata E timestamp FMC registrato E decisione riperfusione avvenuta immediatamente dopo il riconoscimento del sospetto STEMI"
  },
  "time_constraints": [
    {
      "constraint_id": "TC-001",
      "description": "L'ECG a 12 derivazioni deve essere eseguito e interpretato entro 10 minuti dal primo contatto medico (FMC).",
      "relation_to_anchor": "within",
      "anchor_event": "Primo contatto medico (FMC)",
      "duration_value": 10,
      "duration_unit": "minuti",
      "hard_deadline": true,
      "alert_threshold_value": 7,
      "alert_threshold_unit": "minuti"
    },
    {
      "constraint_id": "TC-002",
      "description": "La decisione sulla strategia di riperfusione deve essere presa immediatamente dopo la conferma diagnostica del sospetto STEMI all'ECG.",
      "relation_to_anchor": "immediate",
      "anchor_event": "Diagnosi di STEMI confermata all'ECG",
      "duration_value": null,
      "duration_unit": null,
      "hard_deadline": true,
      "alert_threshold_value": null,
      "alert_threshold_unit": null
    },
    {
      "constraint_id": "TC-003",
      "description": "Se la strategia scelta è la PCI primaria, il tempo wire-crossing (apertura del vaso) deve avvenire entro 120 minuti dal FMC (o entro 90 minuti se il paziente si presenta entro 2 ore dall'insorgenza dei sintomi e in un centro con PCI).",
      "relation_to_anchor": "no_later_than",
      "anchor_event": "Primo contatto medico (FMC)",
      "duration_value": 120,
      "duration_unit": "minuti",
      "hard_deadline": true,
      "alert_threshold_value": 90,
      "alert_threshold_unit": "minuti"
    }
  ],
  "sequence_constraints": [
    {
      "constraint_id": "SC-001",
      "description": "L'ECG a 12 derivazioni deve essere eseguito e interpretato prima della decisione formale sulla strategia di riperfusione.",
      "predecessor_event": "Esecuzione e interpretazione ECG a 12 derivazioni",
      "successor_event": "Decisione sulla strategia di riperfusione d'emergenza",
      "allowed_order": "predecessor_first",
      "violation_condition": "La decisione sulla strategia di riperfusione è stata documentata senza evidenza di un ECG a 12 derivazioni interpretato precedentemente."
    },
    {
      "constraint_id": "SC-002",
      "description": "Il primo contatto medico deve precedere la valutazione per la strategia di riperfusione.",
      "predecessor_event": "Primo contatto medico (FMC)",
      "successor_event": "Valutazione per strategia di riperfusione",
      "allowed_order": "predecessor_first",
      "violation_condition": "La valutazione per la strategia di riperfusione risulta temporalmente antecedente al primo contatto medico registrato."
    }
  ],
  "required_data_elements": [
    {
      "data_element_id": "DE-001",
      "name": "Sintomatologia di presentazione",
      "description": "Descrizione della sintomatologia riferita dal paziente al momento del primo contatto, in particolare dolore toracico acuto o equivalente anginoso.",
      "source_location": "ehr_structured",
      "data_type": "text",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Cercare nel campo motivo di accesso, triage narrative, valutazione clinica iniziale."
    },
    {
      "data_element_id": "DE-002",
      "name": "Equivalente anginoso",
      "description": "Presenza di sintomi atipici compatibili con ischemia miocardica (dispnea, sudorazione, nausea, sincope) in assenza di dolore toracico tipico.",
      "source_location": "ehr_unstructured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": false,
      "extraction_method": "inferential",
      "query_hint": "Estrarre da note cliniche di triage e valutazione medica iniziale."
    },
    {
      "data_element_id": "DE-003",
      "name": "Referto ECG a 12 derivazioni",
      "description": "Risultato dell'ECG a 12 derivazioni con indicazione della presenza o assenza di sopraslivellamento del tratto ST e localizzazione delle derivazioni coinvolte.",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": "Codifica locale referto ECG / ICD-10 I21.x",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Verificare il campo referto ECG nel sistema di refertazione cardiologica o nel verbale di Pronto Soccorso."
    },
    {
      "data_element_id": "DE-004",
      "name": "Blocco di branca sinistra di nuova insorgenza",
      "description": "Presenza di blocco di branca sinistra (BBS) di nuova insorgenza all'ECG, compatibile con STEMI.",
      "source_location": "ehr_structured",
      "data_type": "boolean",
      "coding_system": "ICD-10 I44.7",
      "required_for_evaluation": false,
      "extraction_method": "hybrid",
      "query_hint": "Verificare nel referto ECG e confrontare con ECG precedenti se disponibili."
    },
    {
      "data_element_id": "DE-005",
      "name": "Età del paziente",
      "description": "Età anagrafica del paziente in anni compiuti al momento dell'accesso.",
      "source_location": "ehr_structured",
      "data_type": "numeric",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Calcolare dalla data di nascita nel sistema anagrafico."
    },
    {
      "data_element_id": "DE-006",
      "name": "Direttive anticipate di trattamento (DAT)",
      "description": "Presenza e contenuto delle direttive anticipate di trattamento registrate per il paziente.",
      "source_location": "ehr_structured",
      "data_type": "text",
      "coding_system": null,
      "required_for_evaluation": false,
      "extraction_method": "deterministic",
      "query_hint": "Verificare nel registro DAT nazionale o nella cartella clinica del paziente."
    },
    {
      "data_element_id": "DE-007",
      "name": "Diagnosi alternativa confermata",
      "description": "Eventuale diagnosi alternativa allo STEMI confermata dal team clinico.",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": "ICD-10",
      "required_for_evaluation": false,
      "extraction_method": "deterministic",
      "query_hint": "Verificare il campo diagnosi nel verbale di Pronto Soccorso o nella lettera di dimissione."
    },
    {
      "data_element_id": "DE-008",
      "name": "Timestamp del primo contatto medico (FMC)",
      "description": "Data e ora esatte del primo contatto del paziente con un operatore sanitario in grado di eseguire e interpretare un ECG (medico o infermiere formato).",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare nel campo orario di triage, orario di arrivo ambulanza, o orario di primo contatto nel flusso STEMI."
    },
    {
      "data_element_id": "DE-009",
      "name": "Timestamp esecuzione ECG",
      "description": "Data e ora di esecuzione dell'ECG a 12 derivazioni.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare nel sistema di refertazione ECG o nel verbale di Pronto Soccorso."
    },
    {
      "data_element_id": "DE-010",
      "name": "Decisione strategia di riperfusione",
      "description": "Documentazione della strategia di riperfusione scelta (PCI primaria, fibrinolisi, strategia farmaco-invasiva, nessuna riperfusione con motivazione).",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": "Codifica locale percorso STEMI",
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Verificare nel modulo STEMI, nota clinica del medico d'emergenza, o scheda di attivazione emodinamica."
    },
    {
      "data_element_id": "DE-011",
      "name": "Timestamp decisione strategia di riperfusione",
      "description": "Data e ora della documentazione della decisione sulla strategia di riperfusione.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare nel modulo STEMI o nella nota clinica relativa alla decisione di riperfusione."
    }
  ],
  "evidence_of_compliance": [
    {
      "evidence_id": "EC-001",
      "description": "Presenza di un ECG a 12 derivazioni eseguito e interpretato entro 10 minuti dal primo contatto medico, con risultato documentato compatibile con sospetto STEMI.",
      "evidence_type": "result",
      "minimum_occurrences": 1,
      "time_reference": "Entro 10 minuti dal primo contatto medico (FMC)",
      "derived_from_data_elements": [
        "DE-003",
        "DE-008",
        "DE-009"
      ]
    },
    {
      "evidence_id": "EC-002",
      "description": "Documentazione della decisione sulla strategia di riperfusione d'emergenza immediatamente successiva alla conferma diagnostica di sospetto STEMI.",
      "evidence_type": "documentation",
      "minimum_occurrences": 1,
      "time_reference": "Immediatamente dopo la conferma diagnostica di STEMI",
      "derived_from_data_elements": [
        "DE-010",
        "DE-011"
      ]
    },
    {
      "evidence_id": "EC-003",
      "description": "Registrazione del timestamp del primo contatto medico (FMC) nel sistema informativo.",
      "evidence_type": "timestamp",
      "minimum_occurrences": 1,
      "time_reference": "Al momento del primo contatto medico",
      "derived_from_data_elements": [
        "DE-008"
      ]
    }
  ],
  "evidence_of_non_compliance": [
    {
      "evidence_id": "ENC-001",
      "description": "Assenza di documentazione di un ECG a 12 derivazioni eseguito entro 10 minuti dal primo contatto medico in un paziente con sospetto STEMI.",
      "evidence_type": "absence_of_event",
      "minimum_occurrences": 1,
      "time_reference": "Entro 10 minuti dal FMC non risulta alcun ECG documentato",
      "derived_from_data_elements": [
        "DE-003",
        "DE-008",
        "DE-009"
      ]
    },
    {
      "evidence_id": "ENC-002",
      "description": "Assenza di documentazione della decisione sulla strategia di riperfusione d'emergenza dopo la conferma diagnostica di sospetto STEMI.",
      "evidence_type": "absence_of_event",
      "minimum_occurrences": 1,
      "time_reference": "Dopo la conferma diagnostica di STEMI, nessuna decisione di riperfusione documentata",
      "derived_from_data_elements": [
        "DE-010",
        "DE-011"
      ]
    },
    {
      "evidence_id": "ENC-003",
      "description": "Ritardo significativo tra il primo contatto medico e la decisione sulla strategia di riperfusione, senza giustificazione clinica documentata.",
      "evidence_type": "timestamp",
      "minimum_occurrences": 1,
      "time_reference": "Intervallo FMC → decisione riperfusione superiore ai tempi raccomandati",
      "derived_from_data_elements": [
        "DE-008",
        "DE-009",
        "DE-011"
      ]
    },
    {
      "evidence_id": "ENC-004",
      "description": "Mancata registrazione del timestamp del primo contatto medico (FMC), che impedisce la verifica dei tempi del percorso STEMI.",
      "evidence_type": "documentation_gap",
      "minimum_occurrences": 1,
      "time_reference": null,
      "derived_from_data_elements": [
        "DE-008"
      ]
    }
  ],
  "evaluation_logic": {
    "natural_language_test": "Per ogni paziente con sospetto STEMI (dolore toracico acuto o equivalente anginoso + sopraslivellamento ST o BBS di nuova insorgenza all'ECG), verificare che: (1) sia stato eseguito un ECG a 12 derivazioni entro 10 minuti dal primo contatto medico; (2) sia stata documentata immediatamente la decisione sulla strategia di riperfusione d'emergenza; (3) il timestamp del FMC sia stato registrato. Se tutti e tre i criteri sono soddisfatti, la regola è conforme. Se manca la decisione sulla strategia di riperfusione o l'ECG non è stato eseguito/interpretato, la regola è non conforme. Se il paziente rientra in un'eccezione documentata, si classifica come deviazione giustificata.",
    "formal_expression_language": "pseudocode",
    "formal_expression": "IF (sospetto_STEMI == true) THEN { IF (ECG_eseguito_entro_10min == true AND decisione_riperfusione_documentata == true AND FMC_timestamp_registrato == true) THEN outcome = 'compliant'; ELSE IF (eccezione_documentata == true AND giustificazione_presente == true) THEN outcome = 'justified_deviation'; ELSE IF (dati_mancanti_critici == true) THEN outcome = 'not_evaluable'; ELSE outcome = 'non_compliant'; } ELSE outcome = 'not_applicable';",
    "missing_data_policy": "not_evaluable",
    "ambiguity_policy": "review_required",
    "conflict_resolution_policy": "human_review",
    "notes": "In caso di discordanza tra il timestamp FMC registrato nel sistema 118 e quello registrato nel sistema di Pronto Soccorso, utilizzare il timestamp più precoce. La valutazione retrospettiva può richiedere revisione manuale delle note cliniche per i casi in cui la documentazione strutturata è incompleta."
  },
  "evaluation_method": {
    "primary_method": "hybrid",
    "allowed_inference_sources": [
      "Note cliniche di triage",
      "Verbale di Pronto Soccorso",
      "Scheda intervento 118",
      "Referto ECG",
      "Scheda di attivazione emodinamica",
      "Note del cardiologo di guardia"
    ],
    "human_review_required": true,
    "minimum_confidence": 0.85,
    "notes": "La valutazione deterministica è possibile per i casi con documentazione strutturata completa (timestamp, referto ECG codificato, decisione di riperfusione nel modulo STEMI). L'inferenza è necessaria quando la decisione di riperfusione è documentata solo in testo libero o quando i timestamp non sono registrati in campi strutturati."
  },
  "possible_outcomes": [
    "compliant",
    "non_compliant",
    "justified_deviation",
    "not_applicable",
    "not_evaluable",
    "probable_non_compliance"
  ],
  "risk_classification": {
    "clinical_risk_severity": "critical",
    "process_risk_severity": "critical",
    "likelihood_if_violated": "likely",
    "detectability": "moderate",
    "priority_score": 9.5,
    "rationale": "La mancata valutazione immediata per la strategia di riperfusione in un paziente con STEMI comporta un prolungamento del tempo di ischemia miocardica, con aumento diretto della mortalità, dell'estensione dell'infarto e del rischio di complicanze gravi (scompenso cardiaco, shock cardiogeno, aritmie fatali). La rilevanza critica è confermata da tutte le linee guida internazionali."
  },
  "documentation_requirements": {
    "mandatory_fields": [
      "Timestamp del primo contatto medico (FMC)",
      "Timestamp di esecuzione dell'ECG a 12 derivazioni",
      "Referto ECG con interpretazione",
      "Strategia di riperfusione scelta",
      "Timestamp della decisione sulla strategia di riperfusione",
      "Identificativo del medico responsabile della decisione"
    ],
    "acceptable_evidence_sources": [
      "Cartella clinica elettronica di Pronto Soccorso",
      "Sistema di refertazione ECG",
      "Scheda intervento 118",
      "Modulo percorso STEMI",
      "Scheda di attivazione laboratorio di emodinamica",
      "Registro regionale STEMI"
    ],
    "justification_required_when_deviating": true,
    "justification_fields": [
      "Campo motivazione nel modulo STEMI",
      "Nota clinica nel verbale di Pronto Soccorso",
      "Campo note della scheda di attivazione emodinamica"
    ],
    "free_text_allowed": true
  },
  "associated_weak_signal_ids": [
    "WS-STEMI-001",
    "WS-STEMI-002",
    "WS-STEMI-003"
  ],
  "extraction_metadata": {
    "generation_mode": "llm_inference",
    "source_interpretation_notes": "Il testo sorgente utilizza il termine 'emergency reperfusion strategy' che è stato normalizzato in italiano come 'strategia di riperfusione d'emergenza'. Il verbo 'si raccomanda' è stato interpretato come forza deontica 'recommended' (Classe I ESC). L'avverbio 'immediatamente' è stato interpretato come vincolo temporale che richiede azione senza ritardo evitabile dopo il riconoscimento del sospetto STEMI. La valutazione include sia la componente diagnostica (ECG) sia la componente decisionale (scelta della strategia di riperfusione).",
    "extraction_confidence": 0.92,
    "ambiguity_flags": [
      "Il termine 'immediatamente' non specifica un tempo massimo numerico esatto per la decisione sulla strategia; è stato operazionalizzato tramite i vincoli temporali ESC esistenti (ECG entro 10 min, PCI entro 120 min).",
      "Il termine 'sospetto STEMI' non definisce criteri diagnostici precisi nel testo sorgente; sono stati adottati i criteri ECG standard delle linee guida ESC."
    ],
    "human_validation_status": "not_reviewed",
    "validated_by": null,
    "validated_at": null
  },
  "governance_metadata": {
    "lifecycle_status": "draft",
    "version": "1.0.0",
    "authoring_body": "Team Clinical Pathway STEMI",
    "rule_owner": "Direttore Dipartimento Emergenza e Accettazione",
    "effective_from": null,
    "effective_to": null,
    "review_cycle": "Ogni 12 mesi o in occasione di aggiornamento delle linee guida ESC/ANMCO",
    "last_reviewed_at": null,
    "approved_by": null
  }
}
$json_STEMI_DO_001$::jsonb)
ON CONFLICT (clinical_pathway_id, name) DO UPDATE
SET body = EXCLUDED.body;

INSERT INTO riskm_manager_model_evaluation.rule_definition (clinical_pathway_id, name, body)
VALUES (1, 'STEMI-DO-002', $json_STEMI_DO_002$
{
  "schema_version": "1.0.0",
  "rule_id": "STEMI-DO-002",
  "rule_type": "do",
  "title": "Diagnosi e stratificazione del rischio a breve termine della SCA basata su anamnesi, sintomi, segni vitali, esame obiettivo, ECG e troponina ad alta sensibilità",
  "short_label": "Diagnosi SCA multiparametrica",
  "clinical_pathway_id": "PDTA-STEMI-001",
  "clinical_pathway_name": "Percorso Diagnostico Terapeutico Assistenziale per STEMI",
  "clinical_phase": "diagnosi",
  "care_settings": [
    "Pronto Soccorso",
    "Servizio di Emergenza Territoriale (118)",
    "Unità di Terapia Intensiva Cardiologica"
  ],
  "responsible_actors": [
    {
      "role_name": "Medico di Pronto Soccorso",
      "responsibility_type": "primary",
      "organization_unit": "Pronto Soccorso / Dipartimento di Emergenza-Urgenza",
      "notes": "Responsabile principale della valutazione diagnostica iniziale integrata del paziente con sospetta SCA."
    },
    {
      "role_name": "Cardiologo di guardia",
      "responsibility_type": "consulted",
      "organization_unit": "Unità di Terapia Intensiva Cardiologica (UTIC)",
      "notes": "Consulente per la conferma diagnostica e la stratificazione del rischio nei casi complessi."
    },
    {
      "role_name": "Infermiere di Triage",
      "responsibility_type": "supporting",
      "organization_unit": "Pronto Soccorso",
      "notes": "Supporta la raccolta dei parametri vitali, l'esecuzione dell'ECG e il prelievo ematico per troponina."
    },
    {
      "role_name": "Medico del Servizio di Emergenza Territoriale",
      "responsibility_type": "primary",
      "organization_unit": "Servizio 118",
      "notes": "In fase pre-ospedaliera è responsabile della valutazione clinica iniziale, dell'ECG e della trasmissione dei dati."
    }
  ],
  "deontic_strength": "mandatory",
  "recommendation_strength": "Classe I",
  "evidence_level": "Livello di evidenza B",
  "original_statement": "It is recommended to base the diagnosis and initial short-term risk stratification of ACS on a combination of clinical history, symptoms, vital signs, other physical findings, ECG, and hs-cTn.",
  "normalized_statement": "La diagnosi e la stratificazione iniziale del rischio a breve termine della sindrome coronarica acuta devono essere basate sulla combinazione di anamnesi clinica, sintomi, segni vitali, altri reperti dell'esame obiettivo, elettrocardiogramma e troponina cardiaca ad alta sensibilità.",
  "intent": "Garantire una diagnosi accurata e una stratificazione del rischio a breve termine della SCA mediante un approccio diagnostico multiparametrico integrato che combini dati clinici, strumentali e di laboratorio.",
  "rationale": "L'utilizzo combinato di anamnesi, sintomi, parametri vitali, esame obiettivo, ECG e troponina ad alta sensibilità consente di aumentare la sensibilità e la specificità diagnostica della SCA, riducendo il rischio di mancata diagnosi e permettendo una stratificazione prognostica precoce che orienta il trattamento tempestivo.",
  "source_references": [
    {
      "source_id": "ESC-ACS-2023",
      "source_level": "international",
      "issuer": "European Society of Cardiology (ESC)",
      "document_title": "2023 ESC Guidelines for the management of acute coronary syndromes",
      "document_version": "2023",
      "publication_date": "2023-08-25",
      "section_reference": "Sezione 3 - Diagnosi",
      "page_reference": null,
      "statement_quote": "It is recommended to base the diagnosis and initial short-term risk stratification of ACS on a combination of clinical history, symptoms, vital signs, other physical findings, ECG, and hs-cTn.",
      "citation_uri": "https://doi.org/10.1093/eurheartj/ehad191",
      "license_note": "Contenuto protetto da copyright ESC. Uso a fini clinici e di ricerca conforme alle condizioni di utilizzo dell'editore."
    }
  ],
  "applicability": {
    "population_description": "Pazienti adulti (età ≥ 18 anni) che si presentano con sospetta sindrome coronarica acuta, incluso STEMI, NSTEMI e angina instabile.",
    "clinical_context": "Sospetto clinico di sindrome coronarica acuta (SCA) in fase acuta, inclusa la presentazione con dolore toracico, dispnea, sintomi equivalenti anginosi o alterazioni emodinamiche suggestive.",
    "care_context": "Fase diagnostica iniziale in ambito pre-ospedaliero (118) e in Pronto Soccorso, fino alla conferma o esclusione della diagnosi di SCA.",
    "inclusion_criteria": [
      {
        "criterion_id": "IC-001",
        "label": "Sospetta SCA",
        "description": "Paziente adulto che si presenta con sintomi compatibili con sindrome coronarica acuta, come dolore toracico, dispnea acuta, sincope o equivalenti anginosi.",
        "logic_expression": "age >= 18 AND (chief_complaint IN ['dolore_toracico', 'dispnea_acuta', 'sincope', 'equivalente_anginoso'] OR clinical_suspicion == 'SCA')",
        "data_elements": [
          "DE-001",
          "DE-002"
        ],
        "inference_allowed": true
      }
    ],
    "exclusion_criteria": [
      {
        "criterion_id": "EC-001",
        "label": "Causa non cardiaca chiaramente identificata",
        "description": "Paziente in cui una causa non cardiaca dei sintomi è stata chiaramente identificata e documentata prima della valutazione multiparametrica (ad es. trauma toracico diretto, pneumotorace evidente alla radiografia).",
        "logic_expression": "confirmed_non_cardiac_etiology == true AND alternative_diagnosis IS NOT NULL",
        "data_elements": [
          "DE-010"
        ],
        "inference_allowed": false
      }
    ]
  },
  "trigger": {
    "trigger_type": "documented_symptom",
    "trigger_description": "Il paziente si presenta al Pronto Soccorso o viene valutato dal Servizio di Emergenza Territoriale con sintomi suggestivi di sindrome coronarica acuta (dolore toracico acuto, dispnea, sudorazione, nausea, sincope o equivalenti anginosi).",
    "anchor_event": "primo_contatto_medico",
    "start_of_applicability": "Dal momento del primo contatto medico con il paziente che presenta sospetta SCA.",
    "end_of_applicability": "Fino al completamento della valutazione diagnostica iniziale integrata e alla formulazione della diagnosi di lavoro.",
    "trigger_data_elements": [
      "DE-001",
      "DE-002",
      "DE-003"
    ],
    "inference_allowed": true
  },
  "exceptions": [
    {
      "exception_id": "EX-001",
      "label": "Arresto cardiaco in corso con necessità di rianimazione immediata",
      "description": "Nel paziente in arresto cardiaco, le manovre rianimatorie hanno priorità assoluta. La valutazione diagnostica multiparametrica completa può essere posticipata fino al ripristino della circolazione spontanea (ROSC).",
      "condition_logic": "patient_status == 'arresto_cardiaco' AND rosc == false",
      "required_justification": true,
      "required_evidence": [
        "Documentazione dello stato di arresto cardiaco",
        "Registrazione dei tempi di rianimazione cardiopolmonare",
        "Nota clinica che giustifica il differimento della valutazione diagnostica completa"
      ]
    },
    {
      "exception_id": "EX-002",
      "label": "Instabilità emodinamica critica che richiede intervento immediato",
      "description": "In presenza di shock cardiogeno o instabilità emodinamica grave con necessità di supporto circolatorio immediato, alcune componenti della valutazione diagnostica possono essere differite o eseguite in parallelo con le manovre di stabilizzazione.",
      "condition_logic": "hemodynamic_status == 'shock_cardiogeno' OR systolic_bp < 90",
      "required_justification": true,
      "required_evidence": [
        "Documentazione dei parametri emodinamici critici",
        "Nota clinica sulla prioritizzazione delle manovre di stabilizzazione"
      ]
    }
  ],
  "expected_action": {
    "action_verb": "eseguire",
    "action_description": "Eseguire una valutazione diagnostica integrata e una stratificazione iniziale del rischio a breve termine della SCA basata sulla combinazione sistematica di: anamnesi clinica (inclusa storia cardiologica, fattori di rischio cardiovascolare, terapie in corso), valutazione dei sintomi (caratteristiche del dolore toracico, sintomi associati), rilevazione dei segni vitali (pressione arteriosa, frequenza cardiaca, frequenza respiratoria, saturazione di ossigeno), esame obiettivo (inclusi segni di scompenso cardiaco, soffi, segni di ipoperfusione), registrazione e interpretazione dell'ECG a 12 derivazioni, e dosaggio della troponina cardiaca ad alta sensibilità (hs-cTn).",
    "action_target": "Valutazione diagnostica integrata multiparametrica per SCA",
    "action_parameters": [
      {
        "parameter_name": "Anamnesi clinica",
        "parameter_description": "Raccolta dell'anamnesi completa inclusi fattori di rischio cardiovascolare, storia cardiologica, comorbilità, terapie farmacologiche in corso e anamnesi familiare per cardiopatia ischemica.",
        "expected_value": "completata",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "Valutazione dei sintomi",
        "parameter_description": "Caratterizzazione dei sintomi di presentazione: tipo, localizzazione, irradiazione, durata, intensità del dolore toracico; presenza di sintomi associati quali dispnea, nausea, sudorazione, sincope.",
        "expected_value": "completata",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "Segni vitali",
        "parameter_description": "Rilevazione di pressione arteriosa sistolica e diastolica, frequenza cardiaca, frequenza respiratoria, saturazione periferica di ossigeno e temperatura corporea.",
        "expected_value": "completata",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "Esame obiettivo",
        "parameter_description": "Esame obiettivo cardiovascolare e sistemico con ricerca di segni di scompenso cardiaco, soffi cardiaci, segni di ipoperfusione periferica, turgore giugulare e rantoli polmonari.",
        "expected_value": "completato",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "ECG a 12 derivazioni",
        "parameter_description": "Registrazione e interpretazione di un elettrocardiogramma a 12 derivazioni standard per identificare sopraslivellamento del tratto ST, sottoslivellamento, inversione dell'onda T o altre anomalie suggestive di ischemia acuta.",
        "expected_value": "eseguito e interpretato",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "Troponina cardiaca ad alta sensibilità (hs-cTn)",
        "parameter_description": "Dosaggio della troponina cardiaca ad alta sensibilità (hs-cTnI o hs-cTnT) su prelievo ematico per identificare danno miocardico acuto.",
        "expected_value": "dosata",
        "comparison_operator": "equals",
        "unit": "ng/L",
        "mandatory": true
      }
    ],
    "alternative_compliant_actions": [
      "In fase pre-ospedaliera, se il dosaggio della hs-cTn non è disponibile, eseguire tutte le altre componenti della valutazione e assicurare il prelievo ematico più precoce possibile all'arrivo in Pronto Soccorso."
    ]
  },
  "completion_criteria": {
    "description": "La regola è soddisfatta quando tutte e sei le componenti della valutazione diagnostica integrata sono state eseguite e documentate: anamnesi clinica, valutazione dei sintomi, rilevazione dei segni vitali, esame obiettivo, ECG a 12 derivazioni interpretato e dosaggio della hs-cTn con risultato disponibile. La diagnosi di lavoro e la stratificazione iniziale del rischio devono essere documentate.",
    "minimum_occurrences": 1,
    "required_event_types": [
      "raccolta_anamnesi",
      "valutazione_sintomi",
      "rilevazione_segni_vitali",
      "esame_obiettivo",
      "registrazione_ECG_12_derivazioni",
      "dosaggio_hs_cTn",
      "formulazione_diagnosi_di_lavoro"
    ],
    "required_documentation_elements": [
      "Referto anamnesi clinica nel verbale di Pronto Soccorso",
      "Descrizione dei sintomi di presentazione",
      "Parametri vitali registrati",
      "Referto dell'esame obiettivo",
      "Tracciato ECG a 12 derivazioni con interpretazione",
      "Risultato del dosaggio della troponina ad alta sensibilità",
      "Diagnosi di lavoro e stratificazione del rischio iniziale"
    ],
    "success_condition": "anamnesi_completata == true AND sintomi_valutati == true AND segni_vitali_rilevati == true AND esame_obiettivo_completato == true AND ECG_12_derivazioni_eseguito == true AND ECG_interpretato == true AND hs_cTn_dosata == true AND diagnosi_di_lavoro_formulata == true"
  },
  "time_constraints": [
    {
      "constraint_id": "TC-001",
      "description": "L'ECG a 12 derivazioni deve essere eseguito e interpretato entro 10 minuti dal primo contatto medico.",
      "relation_to_anchor": "within",
      "anchor_event": "primo_contatto_medico",
      "duration_value": 10,
      "duration_unit": "minuti",
      "hard_deadline": true,
      "alert_threshold_value": 7,
      "alert_threshold_unit": "minuti"
    },
    {
      "constraint_id": "TC-002",
      "description": "Il prelievo ematico per il dosaggio della troponina ad alta sensibilità deve essere effettuato il prima possibile e comunque contestualmente al primo accesso venoso.",
      "relation_to_anchor": "within",
      "anchor_event": "primo_contatto_medico",
      "duration_value": 20,
      "duration_unit": "minuti",
      "hard_deadline": false,
      "alert_threshold_value": 15,
      "alert_threshold_unit": "minuti"
    },
    {
      "constraint_id": "TC-003",
      "description": "La valutazione diagnostica integrata completa (inclusi anamnesi, sintomi, segni vitali, esame obiettivo, ECG interpretato e risultato hs-cTn) deve essere completata entro 60 minuti dal primo contatto medico.",
      "relation_to_anchor": "within",
      "anchor_event": "primo_contatto_medico",
      "duration_value": 60,
      "duration_unit": "minuti",
      "hard_deadline": false,
      "alert_threshold_value": 45,
      "alert_threshold_unit": "minuti"
    }
  ],
  "sequence_constraints": [
    {
      "constraint_id": "SC-001",
      "description": "L'ECG a 12 derivazioni deve essere eseguito prima o contestualmente alla formulazione della diagnosi di lavoro e della stratificazione del rischio.",
      "predecessor_event": "registrazione_ECG_12_derivazioni",
      "successor_event": "formulazione_diagnosi_di_lavoro",
      "allowed_order": "predecessor_first",
      "violation_condition": "La diagnosi di lavoro viene formulata senza che sia stato eseguito e interpretato un ECG a 12 derivazioni."
    },
    {
      "constraint_id": "SC-002",
      "description": "Il dosaggio della troponina ad alta sensibilità deve essere richiesto prima o in parallelo con il completamento dell'esame obiettivo.",
      "predecessor_event": "richiesta_dosaggio_hs_cTn",
      "successor_event": "completamento_esame_obiettivo",
      "allowed_order": "any_order",
      "violation_condition": "Il dosaggio della hs-cTn non viene richiesto durante l'intero corso della valutazione diagnostica iniziale."
    }
  ],
  "required_data_elements": [
    {
      "data_element_id": "DE-001",
      "name": "Età del paziente",
      "description": "Età anagrafica del paziente al momento della presentazione.",
      "source_location": "ehr_structured",
      "data_type": "numeric",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Estrarre dalla scheda anagrafica del paziente nel sistema di Pronto Soccorso."
    },
    {
      "data_element_id": "DE-002",
      "name": "Motivo di accesso / sintomo principale",
      "description": "Sintomo o motivo principale di presentazione del paziente (es. dolore toracico, dispnea, sincope).",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": "ICD-10",
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Campi di triage o motivo di accesso nel sistema di PS. Se non codificato, inferire dal testo libero di triage."
    },
    {
      "data_element_id": "DE-003",
      "name": "Timestamp primo contatto medico",
      "description": "Data e ora del primo contatto medico (First Medical Contact - FMC) con il paziente.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Orario di presa in carico medica o primo contatto 118 nel sistema informatico del PS o del 118."
    },
    {
      "data_element_id": "DE-004",
      "name": "Anamnesi clinica documentata",
      "description": "Documentazione dell'anamnesi clinica inclusi fattori di rischio cardiovascolare, storia cardiologica pregressa, comorbilità e terapie in corso.",
      "source_location": "ehr_unstructured",
      "data_type": "text",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "inferential",
      "query_hint": "Sezione anamnesi del verbale di Pronto Soccorso. Verificare la presenza di menzioni di fattori di rischio CV e storia cardiologica."
    },
    {
      "data_element_id": "DE-005",
      "name": "Segni vitali rilevati",
      "description": "Set completo dei parametri vitali: pressione arteriosa sistolica e diastolica (mmHg), frequenza cardiaca (bpm), frequenza respiratoria (atti/min), saturazione O2 (%), temperatura corporea (°C).",
      "source_location": "ehr_structured",
      "data_type": "numeric",
      "coding_system": "LOINC",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Tabella dei parametri vitali nel sistema di monitoraggio o nel modulo di triage/PS."
    },
    {
      "data_element_id": "DE-006",
      "name": "ECG a 12 derivazioni - timestamp esecuzione",
      "description": "Data e ora di esecuzione dell'elettrocardiogramma a 12 derivazioni.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Timestamp di acquisizione dal sistema ECG o dall'ordine/risultato nel sistema informatico di PS."
    },
    {
      "data_element_id": "DE-007",
      "name": "ECG a 12 derivazioni - referto interpretativo",
      "description": "Interpretazione clinica dell'ECG a 12 derivazioni con identificazione di eventuali segni di ischemia, sopraslivellamento ST, sottoslivellamento ST, inversione onde T, aritmie.",
      "source_location": "ehr_unstructured",
      "data_type": "text",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "inferential",
      "query_hint": "Referto ECG nel sistema di refertazione o nel verbale di PS. Cercare menzioni di STEMI, sopraslivellamento ST, ischemia."
    },
    {
      "data_element_id": "DE-008",
      "name": "Risultato troponina ad alta sensibilità (hs-cTn)",
      "description": "Valore numerico del dosaggio della troponina cardiaca ad alta sensibilità (hs-cTnI o hs-cTnT) con timestamp del prelievo e del risultato.",
      "source_location": "ehr_structured",
      "data_type": "numeric",
      "coding_system": "LOINC",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Risultato di laboratorio con codice LOINC 89579-7 (hs-cTnI) o 67151-1 (hs-cTnT). Verificare unità di misura (ng/L o pg/mL)."
    },
    {
      "data_element_id": "DE-009",
      "name": "Esame obiettivo documentato",
      "description": "Documentazione dell'esame obiettivo cardiovascolare e sistemico, con menzione di eventuali segni di scompenso cardiaco, soffi, rantoli, turgore giugulare, segni di ipoperfusione.",
      "source_location": "ehr_unstructured",
      "data_type": "text",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "inferential",
      "query_hint": "Sezione esame obiettivo del verbale di Pronto Soccorso."
    },
    {
      "data_element_id": "DE-010",
      "name": "Diagnosi alternativa non cardiaca confermata",
      "description": "Eventuale diagnosi alternativa non cardiaca confermata che escluda il paziente dal sospetto di SCA.",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": "ICD-10",
      "required_for_evaluation": false,
      "extraction_method": "hybrid",
      "query_hint": "Campo diagnosi nel sistema di PS. Se assente, verificare note cliniche per esclusione SCA documentata."
    }
  ],
  "evidence_of_compliance": [
    {
      "evidence_id": "EOC-001",
      "description": "Presenza di documentazione dell'anamnesi clinica nel verbale di Pronto Soccorso con menzione di fattori di rischio cardiovascolare e storia cardiologica.",
      "evidence_type": "documentation",
      "minimum_occurrences": 1,
      "time_reference": "Entro 60 minuti dal primo contatto medico.",
      "derived_from_data_elements": [
        "DE-004"
      ]
    },
    {
      "evidence_id": "EOC-002",
      "description": "Registrazione completa dei segni vitali (PA, FC, FR, SpO2) nel sistema informatico.",
      "evidence_type": "result",
      "minimum_occurrences": 1,
      "time_reference": "Entro 10 minuti dal primo contatto medico.",
      "derived_from_data_elements": [
        "DE-005"
      ]
    },
    {
      "evidence_id": "EOC-003",
      "description": "Presenza di un ECG a 12 derivazioni eseguito e interpretato con timestamp coerente con i vincoli temporali.",
      "evidence_type": "result",
      "minimum_occurrences": 1,
      "time_reference": "Entro 10 minuti dal primo contatto medico.",
      "derived_from_data_elements": [
        "DE-006",
        "DE-007"
      ]
    },
    {
      "evidence_id": "EOC-004",
      "description": "Risultato numerico disponibile del dosaggio della troponina cardiaca ad alta sensibilità (hs-cTn).",
      "evidence_type": "result",
      "minimum_occurrences": 1,
      "time_reference": "Entro 60 minuti dal primo contatto medico.",
      "derived_from_data_elements": [
        "DE-008"
      ]
    },
    {
      "evidence_id": "EOC-005",
      "description": "Documentazione dell'esame obiettivo cardiovascolare nel verbale di Pronto Soccorso.",
      "evidence_type": "documentation",
      "minimum_occurrences": 1,
      "time_reference": "Entro 60 minuti dal primo contatto medico.",
      "derived_from_data_elements": [
        "DE-009"
      ]
    },
    {
      "evidence_id": "EOC-006",
      "description": "Diagnosi di lavoro e stratificazione del rischio iniziale documentate nel verbale di PS, con menzione esplicita dell'integrazione dei dati clinici, strumentali e di laboratorio.",
      "evidence_type": "documentation",
      "minimum_occurrences": 1,
      "time_reference": "Entro 60 minuti dal primo contatto medico.",
      "derived_from_data_elements": [
        "DE-004",
        "DE-005",
        "DE-007",
        "DE-008",
        "DE-009"
      ]
    }
  ],
  "evidence_of_non_compliance": [
    {
      "evidence_id": "EONC-001",
      "description": "Assenza di ECG a 12 derivazioni eseguito o assenza di interpretazione documentata entro i tempi previsti.",
      "evidence_type": "absence_of_event",
      "minimum_occurrences": 1,
      "time_reference": "Oltre 10 minuti dal primo contatto medico senza evidenza di ECG.",
      "derived_from_data_elements": [
        "DE-006",
        "DE-007"
      ]
    },
    {
      "evidence_id": "EONC-002",
      "description": "Assenza di dosaggio della troponina ad alta sensibilità o risultato non disponibile durante la fase diagnostica iniziale.",
      "evidence_type": "absence_of_event",
      "minimum_occurrences": 1,
      "time_reference": "Entro 60 minuti dal primo contatto medico senza risultato hs-cTn.",
      "derived_from_data_elements": [
        "DE-008"
      ]
    },
    {
      "evidence_id": "EONC-003",
      "description": "Assenza di documentazione dell'anamnesi clinica o dell'esame obiettivo nel verbale di Pronto Soccorso.",
      "evidence_type": "documentation_gap",
      "minimum_occurrences": 1,
      "time_reference": "Al momento della chiusura del percorso diagnostico iniziale.",
      "derived_from_data_elements": [
        "DE-004",
        "DE-009"
      ]
    },
    {
      "evidence_id": "EONC-004",
      "description": "Diagnosi di lavoro formulata senza integrazione documentata di tutte le componenti previste (anamnesi, sintomi, segni vitali, esame obiettivo, ECG, hs-cTn).",
      "evidence_type": "documentation_gap",
      "minimum_occurrences": 1,
      "time_reference": "Al momento della formulazione della diagnosi di lavoro.",
      "derived_from_data_elements": [
        "DE-004",
        "DE-005",
        "DE-007",
        "DE-008",
        "DE-009"
      ]
    }
  ],
  "evaluation_logic": {
    "natural_language_test": "Verificare che per il paziente con sospetta SCA siano presenti e documentate tutte e sei le componenti della valutazione diagnostica integrata: (1) anamnesi clinica, (2) valutazione dei sintomi, (3) segni vitali, (4) esame obiettivo, (5) ECG a 12 derivazioni eseguito e interpretato, (6) dosaggio della troponina ad alta sensibilità con risultato disponibile. Inoltre, verificare che sia stata formulata e documentata una diagnosi di lavoro con stratificazione del rischio iniziale basata sull'integrazione di tali elementi.",
    "formal_expression_language": "pseudocode",
    "formal_expression": "IF (anamnesi_documentata == true AND sintomi_valutati == true AND segni_vitali_completi == true AND esame_obiettivo_documentato == true AND ECG_12_derivazioni_eseguito == true AND ECG_interpretato == true AND hs_cTn_risultato_disponibile == true AND diagnosi_di_lavoro_formulata == true) THEN status = 'compliant' ELIF (exception_documented == true AND required_justification_present == true) THEN status = 'justified_deviation' ELIF (any_component_missing == true AND no_justification == true) THEN status = 'non_compliant' ELSE status = 'not_evaluable'",
    "missing_data_policy": "review_required",
    "ambiguity_policy": "review_required",
    "conflict_resolution_policy": "human_review",
    "notes": "Alcune componenti (anamnesi, esame obiettivo, valutazione dei sintomi) sono tipicamente documentate in formato narrativo non strutturato e possono richiedere estrazione inferenziale tramite NLP. La completezza della documentazione è l'indicatore primario di compliance."
  },
  "evaluation_method": {
    "primary_method": "hybrid",
    "allowed_inference_sources": [
      "Verbale di Pronto Soccorso",
      "Note cliniche di triage",
      "Note cliniche del medico di PS",
      "Referto ECG",
      "Risultati di laboratorio",
      "Scheda 118 pre-ospedaliera"
    ],
    "human_review_required": true,
    "minimum_confidence": 0.85,
    "notes": "L'estrazione deterministica è possibile per segni vitali, timestamp ECG e risultato hs-cTn. Per anamnesi, esame obiettivo e valutazione dei sintomi è necessaria l'analisi del testo libero con verifica umana. La revisione manuale è raccomandata per la conferma della completezza dell'integrazione diagnostica."
  },
  "possible_outcomes": [
    "compliant",
    "non_compliant",
    "justified_deviation",
    "not_applicable",
    "not_evaluable",
    "probable_non_compliance"
  ],
  "risk_classification": {
    "clinical_risk_severity": "critical",
    "process_risk_severity": "high",
    "likelihood_if_violated": "likely",
    "detectability": "moderate",
    "priority_score": 95,
    "rationale": "La mancata esecuzione di una valutazione diagnostica integrata completa per la SCA può portare a diagnosi mancate o ritardate, con conseguenze potenzialmente fatali (infarto miocardico non riconosciuto, ritardo nella riperfusione). L'omissione di singole componenti (es. ECG o troponina) riduce significativamente la sensibilità diagnostica e compromette la stratificazione del rischio."
  },
  "documentation_requirements": {
    "mandatory_fields": [
      "Anamnesi clinica con fattori di rischio cardiovascolare",
      "Descrizione dei sintomi di presentazione",
      "Parametri vitali completi (PA, FC, FR, SpO2)",
      "Esame obiettivo cardiovascolare e generale",
      "Tracciato ECG a 12 derivazioni con interpretazione",
      "Risultato dosaggio hs-cTn con timestamp",
      "Diagnosi di lavoro e stratificazione del rischio"
    ],
    "acceptable_evidence_sources": [
      "Verbale di Pronto Soccorso",
      "Scheda di triage",
      "Sistema di refertazione ECG",
      "Sistema informativo di laboratorio (LIS)",
      "Scheda del Servizio 118",
      "Cartella clinica elettronica",
      "Sistema di monitoraggio parametri vitali"
    ],
    "justification_required_when_deviating": true,
    "justification_fields": [
      "Nota clinica nel verbale di Pronto Soccorso con motivazione della deviazione",
      "Campo note di eccezione nel sistema informativo di PS"
    ],
    "free_text_allowed": true
  },
  "associated_weak_signal_ids": [
    "STEMI-WS-003",
    "STEMI-WS-004"
  ],
  "extraction_metadata": {
    "generation_mode": "llm_inference",
    "source_interpretation_notes": "La raccomandazione originale ESC è stata tradotta e contestualizzata al sistema sanitario italiano. Il termine 'hs-cTn' è stato mantenuto come sigla internazionale con traduzione esplicita 'troponina cardiaca ad alta sensibilità'. La forza della raccomandazione ('It is recommended') è stata mappata a Classe I ESC e forza deontica 'mandatory'. I vincoli temporali (10 minuti per ECG, 60 minuti per valutazione completa) sono stati derivati da altre raccomandazioni delle stesse linee guida ESC e dal contesto STEMI.",
    "extraction_confidence": 0.92,
    "ambiguity_flags": [
      "Il testo originale non specifica vincoli temporali espliciti per ciascuna componente; i tempi sono stati integrati da altre sezioni delle linee guida ESC 2023.",
      "La raccomandazione si riferisce genericamente ad 'ACS' e non specificamente a STEMI; è stata contestualizzata al pathway STEMI ma si applica anche a NSTEMI e angina instabile.",
      "Il livello di evidenza non è esplicitamente indicato nel frammento di testo fornito; è stato assegnato 'Livello B' sulla base della raccomandazione completa nel documento ESC."
    ],
    "human_validation_status": "not_reviewed",
    "validated_by": null,
    "validated_at": null
  },
  "governance_metadata": {
    "lifecycle_status": "draft",
    "version": "1.0.0",
    "authoring_body": "Gruppo di Lavoro PDTA STEMI - Rete Cardiologica",
    "rule_owner": "Direttore Clinico del Dipartimento di Emergenza-Urgenza",
    "effective_from": "2024-01-01",
    "effective_to": null,
    "review_cycle": "Ogni 12 mesi o in caso di aggiornamento delle linee guida ESC",
    "last_reviewed_at": null,
    "approved_by": null
  }
}
$json_STEMI_DO_002$::jsonb)
ON CONFLICT (clinical_pathway_id, name) DO UPDATE
SET body = EXCLUDED.body;

INSERT INTO riskm_manager_model_evaluation.rule_definition (clinical_pathway_id, name, body)
VALUES (1, 'STEMI-DO-003', $json_STEMI_DO_003$
{
  "schema_version": "1.0.0",
  "rule_id": "STEMI-DO-003",
  "rule_type": "do",
  "title": "Esecuzione e interpretazione dell'ECG a 12 derivazioni entro 10 minuti dal primo contatto medico",
  "short_label": "ECG 12 derivazioni ≤10 min da FMC",
  "clinical_pathway_id": "PDTA-STEMI-001",
  "clinical_pathway_name": "Percorso Diagnostico Terapeutico Assistenziale per STEMI",
  "clinical_phase": "primo contatto medico / triage",
  "care_settings": [
    "pre-ospedaliero (118/ambulanza)",
    "pronto soccorso",
    "punto di primo contatto medico"
  ],
  "responsible_actors": [
    {
      "role_name": "Medico di emergenza territoriale (118)",
      "responsibility_type": "primary",
      "organization_unit": "Servizio di Emergenza Territoriale 118",
      "notes": "Responsabile principale dell'esecuzione e interpretazione dell'ECG a 12 derivazioni in ambito pre-ospedaliero."
    },
    {
      "role_name": "Medico di pronto soccorso",
      "responsibility_type": "primary",
      "organization_unit": "Pronto Soccorso / DEA",
      "notes": "Responsabile principale dell'esecuzione e interpretazione dell'ECG a 12 derivazioni se il primo contatto medico avviene in pronto soccorso."
    },
    {
      "role_name": "Infermiere di triage",
      "responsibility_type": "supporting",
      "organization_unit": "Pronto Soccorso / DEA",
      "notes": "Supporto nell'esecuzione dell'ECG a 12 derivazioni; può avviare la registrazione ECG prima della valutazione medica secondo protocollo locale."
    },
    {
      "role_name": "Equipaggio ambulanza (infermiere/tecnico)",
      "responsibility_type": "supporting",
      "organization_unit": "Servizio di Emergenza Territoriale 118",
      "notes": "Supporto tecnico per l'esecuzione dell'ECG nella fase pre-ospedaliera."
    }
  ],
  "deontic_strength": "recommended",
  "recommendation_strength": "Classe I (Raccomandato)",
  "evidence_level": "B",
  "original_statement": "Twelve-lead ECG recording and interpretation is recommended as soon as possible at the point of first medical contact, with a target of <10 min.",
  "normalized_statement": "La registrazione e l'interpretazione dell'ECG a 12 derivazioni devono essere eseguite il prima possibile al punto di primo contatto medico, con un obiettivo temporale inferiore a 10 minuti.",
  "intent": "Garantire una diagnosi ECG rapida di STEMI per consentire l'attivazione tempestiva del percorso di riperfusione e ridurre il tempo totale di ischemia miocardica.",
  "rationale": "La diagnosi precoce mediante ECG a 12 derivazioni è fondamentale per l'identificazione dello STEMI e l'attivazione immediata della strategia di riperfusione. Il ritardo nella registrazione e interpretazione dell'ECG comporta un prolungamento del tempo di ischemia, con conseguente aumento dell'area di necrosi miocardica e peggioramento degli esiti clinici.",
  "source_references": [
    {
      "source_id": "ESC-STEMI-2023",
      "source_level": "international",
      "issuer": "European Society of Cardiology (ESC)",
      "document_title": "2023 ESC Guidelines for the management of acute coronary syndromes",
      "document_version": "2023",
      "publication_date": "2023-08-25",
      "section_reference": "Sezione Diagnosi – Raccomandazione ECG al primo contatto medico",
      "page_reference": null,
      "statement_quote": "Twelve-lead ECG recording and interpretation is recommended as soon as possible at the point of first medical contact, with a target of <10 min.",
      "citation_uri": "https://doi.org/10.1093/eurheartj/ehad191",
      "license_note": "Contenuto soggetto a copyright ESC. Utilizzo ai fini di codifica interna del PDTA."
    }
  ],
  "applicability": {
    "population_description": "Pazienti adulti con sospetto clinico di sindrome coronarica acuta, in particolare con dolore toracico suggestivo di infarto miocardico acuto con sopraslivellamento del tratto ST (STEMI).",
    "clinical_context": "Sospetto clinico di sindrome coronarica acuta / STEMI al primo contatto medico.",
    "care_context": "Fase pre-ospedaliera (primo contatto medico con equipaggio 118) o fase di arrivo in pronto soccorso, qualunque sia il punto di primo contatto medico.",
    "inclusion_criteria": [
      {
        "criterion_id": "STEMI-DO-003-INC-01",
        "label": "Dolore toracico acuto sospetto ischemico",
        "description": "Paziente adulto che presenta dolore toracico acuto o equivalente ischemico (dispnea, sudorazione algida, dolore epigastrico) suggestivo di sindrome coronarica acuta.",
        "logic_expression": "sintomo_presentazione IN ('dolore_toracico_acuto', 'equivalente_ischemico') AND età >= 18",
        "data_elements": [
          "DE-sintomo-presentazione",
          "DE-eta-paziente"
        ],
        "inference_allowed": true
      },
      {
        "criterion_id": "STEMI-DO-003-INC-02",
        "label": "Primo contatto medico avvenuto",
        "description": "Il paziente ha raggiunto il punto di primo contatto medico (first medical contact), sia in ambito pre-ospedaliero sia in pronto soccorso.",
        "logic_expression": "evento_primo_contatto_medico IS NOT NULL",
        "data_elements": [
          "DE-timestamp-primo-contatto-medico"
        ],
        "inference_allowed": false
      }
    ],
    "exclusion_criteria": [
      {
        "criterion_id": "STEMI-DO-003-EXC-01",
        "label": "Arresto cardiaco in corso con rianimazione attiva",
        "description": "Paziente in arresto cardiaco con manovre di rianimazione cardiopolmonare in corso, per il quale l'ECG a 12 derivazioni non è tecnicamente eseguibile in modo affidabile.",
        "logic_expression": "stato_clinico == 'arresto_cardiaco' AND RCP_in_corso == true",
        "data_elements": [
          "DE-stato-clinico",
          "DE-RCP-in-corso"
        ],
        "inference_allowed": true
      }
    ]
  },
  "trigger": {
    "trigger_type": "event",
    "trigger_description": "Il primo contatto medico (First Medical Contact, FMC) con un paziente che presenta sintomi suggestivi di sindrome coronarica acuta / sospetto STEMI.",
    "anchor_event": "primo_contatto_medico",
    "start_of_applicability": "Dal momento esatto del primo contatto medico con il paziente sintomatico.",
    "end_of_applicability": "Fino al completamento della registrazione e interpretazione dell'ECG a 12 derivazioni, oppure fino alla decisione clinica di non procedere con l'ECG per motivazione documentata.",
    "trigger_data_elements": [
      "DE-timestamp-primo-contatto-medico",
      "DE-sintomo-presentazione"
    ],
    "inference_allowed": true
  },
  "exceptions": [
    {
      "exception_id": "STEMI-DO-003-EXP-01",
      "label": "Arresto cardiaco con RCP in corso",
      "description": "L'ECG a 12 derivazioni non può essere eseguito in modo attendibile durante le manovre di rianimazione cardiopolmonare attiva. L'esecuzione viene differita fino al ripristino della circolazione spontanea (ROSC).",
      "condition_logic": "stato_clinico == 'arresto_cardiaco' AND RCP_in_corso == true",
      "required_justification": true,
      "required_evidence": [
        "Documentazione dello stato di arresto cardiaco",
        "Timestamp di inizio e fine RCP",
        "Timestamp del ROSC se ottenuto"
      ]
    },
    {
      "exception_id": "STEMI-DO-003-EXP-02",
      "label": "Indisponibilità temporanea dell'elettrocardiografo",
      "description": "L'apparecchio ECG non è disponibile o malfunzionante al punto di primo contatto medico. In tal caso il paziente deve essere trasferito al più presto verso una sede dotata di ECG.",
      "condition_logic": "disponibilita_ECG == false",
      "required_justification": true,
      "required_evidence": [
        "Documentazione dell'indisponibilità dell'apparecchio ECG",
        "Timestamp della segnalazione del malfunzionamento",
        "Azioni correttive intraprese (es. trasferimento rapido)"
      ]
    },
    {
      "exception_id": "STEMI-DO-003-EXP-03",
      "label": "Condizioni cliniche che impediscono l'esecuzione tecnica dell'ECG",
      "description": "Condizioni del paziente (es. agitazione psicomotoria estrema, ustioni toraciche estese) che rendono tecnicamente impossibile il posizionamento degli elettrodi e la registrazione dell'ECG.",
      "condition_logic": "impedimento_tecnico_ECG == true",
      "required_justification": true,
      "required_evidence": [
        "Descrizione clinica dell'impedimento tecnico",
        "Documentazione delle azioni alternative intraprese"
      ]
    }
  ],
  "expected_action": {
    "action_verb": "eseguire",
    "action_description": "Registrare e interpretare un ECG a 12 derivazioni il prima possibile al punto di primo contatto medico, con un obiettivo temporale inferiore a 10 minuti dal primo contatto medico.",
    "action_target": "ECG a 12 derivazioni",
    "action_parameters": [
      {
        "parameter_name": "numero_derivazioni",
        "parameter_description": "Numero minimo di derivazioni dell'ECG da registrare.",
        "expected_value": "12",
        "comparison_operator": "equals",
        "unit": "derivazioni",
        "mandatory": true
      },
      {
        "parameter_name": "tempo_massimo_da_FMC",
        "parameter_description": "Tempo massimo target dalla registrazione del primo contatto medico all'acquisizione e interpretazione dell'ECG.",
        "expected_value": "10",
        "comparison_operator": "less_than",
        "unit": "minuti",
        "mandatory": true
      },
      {
        "parameter_name": "interpretazione_ECG",
        "parameter_description": "L'ECG deve essere non solo registrato ma anche interpretato da personale qualificato per identificare un eventuale sopraslivellamento del tratto ST.",
        "expected_value": "completata",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      }
    ],
    "alternative_compliant_actions": [
      "Trasmissione telematica dell'ECG a 12 derivazioni a un centro hub per tele-interpretazione da parte di un cardiologo esperto, entro il medesimo limite temporale"
    ]
  },
  "completion_criteria": {
    "description": "La regola è soddisfatta quando un ECG a 12 derivazioni è stato registrato e interpretato (con refertazione o annotazione diagnostica documentata) entro 10 minuti dal momento del primo contatto medico.",
    "minimum_occurrences": 1,
    "required_event_types": [
      "registrazione_ECG_12_derivazioni",
      "interpretazione_ECG"
    ],
    "required_documentation_elements": [
      "Tracciato ECG a 12 derivazioni memorizzato",
      "Timestamp di acquisizione dell'ECG",
      "Referto o annotazione diagnostica dell'interpretazione ECG"
    ],
    "success_condition": "ECG_12_derivazioni_registrato == true AND ECG_interpretato == true AND (timestamp_ECG_interpretato - timestamp_primo_contatto_medico) < 10 minuti"
  },
  "time_constraints": [
    {
      "constraint_id": "STEMI-DO-003-TC-01",
      "description": "L'ECG a 12 derivazioni deve essere registrato e interpretato entro un obiettivo inferiore a 10 minuti dal primo contatto medico (FMC).",
      "relation_to_anchor": "within",
      "anchor_event": "primo_contatto_medico",
      "duration_value": 10,
      "duration_unit": "minuti",
      "hard_deadline": true,
      "alert_threshold_value": 7,
      "alert_threshold_unit": "minuti"
    }
  ],
  "sequence_constraints": [
    {
      "constraint_id": "STEMI-DO-003-SC-01",
      "description": "L'ECG a 12 derivazioni deve essere eseguito e interpretato prima dell'attivazione del laboratorio di emodinamica, poiché la decisione di attivare il percorso di riperfusione dipende dall'interpretazione ECG.",
      "predecessor_event": "interpretazione_ECG_12_derivazioni",
      "successor_event": "attivazione_laboratorio_emodinamica",
      "allowed_order": "predecessor_first",
      "violation_condition": "timestamp_attivazione_emodinamica < timestamp_interpretazione_ECG OR interpretazione_ECG IS NULL al momento dell'attivazione emodinamica"
    },
    {
      "constraint_id": "STEMI-DO-003-SC-02",
      "description": "Il primo contatto medico deve precedere la registrazione dell'ECG a 12 derivazioni.",
      "predecessor_event": "primo_contatto_medico",
      "successor_event": "registrazione_ECG_12_derivazioni",
      "allowed_order": "predecessor_first",
      "violation_condition": "timestamp_registrazione_ECG < timestamp_primo_contatto_medico"
    }
  ],
  "required_data_elements": [
    {
      "data_element_id": "DE-timestamp-primo-contatto-medico",
      "name": "Timestamp del primo contatto medico (FMC)",
      "description": "Data e ora esatta del primo contatto tra il paziente con sospetta SCA e un operatore sanitario qualificato (medico o infermiere) in grado di acquisire e interpretare un ECG.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare il timestamp nell'accettazione del 118 (orario arrivo sul posto) o nell'accettazione di triage in pronto soccorso, a seconda del punto di primo contatto."
    },
    {
      "data_element_id": "DE-timestamp-registrazione-ECG",
      "name": "Timestamp di registrazione dell'ECG a 12 derivazioni",
      "description": "Data e ora di acquisizione del tracciato ECG a 12 derivazioni.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Estrarre il timestamp dall'header dell'ECG digitale o dal sistema di archiviazione ECG (MUSE, sistema di gestione ECG)."
    },
    {
      "data_element_id": "DE-timestamp-interpretazione-ECG",
      "name": "Timestamp di interpretazione dell'ECG",
      "description": "Data e ora in cui l'ECG a 12 derivazioni è stato interpretato e refertato (anche sotto forma di annotazione clinica).",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Può coincidere con il timestamp della registrazione se l'interpretazione è immediata. Verificare la presenza di un referto ECG o annotazione diagnostica nel sistema."
    },
    {
      "data_element_id": "DE-sintomo-presentazione",
      "name": "Sintomo di presentazione",
      "description": "Sintomo principale riferito dal paziente o rilevato all'esame obiettivo al primo contatto medico (es. dolore toracico, dispnea, sincope).",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": "ICD-10 / codifica locale triage",
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Cercare nel campo 'motivo di accesso' del triage o nel campo 'sintomo principale' della scheda 118."
    },
    {
      "data_element_id": "DE-eta-paziente",
      "name": "Età del paziente",
      "description": "Età del paziente in anni al momento del primo contatto medico.",
      "source_location": "ehr_structured",
      "data_type": "numeric",
      "coding_system": null,
      "required_for_evaluation": false,
      "extraction_method": "deterministic",
      "query_hint": "Calcolare dalla data di nascita nel sistema anagrafico."
    },
    {
      "data_element_id": "DE-referto-ECG",
      "name": "Referto/interpretazione ECG",
      "description": "Contenuto testuale o codificato dell'interpretazione dell'ECG a 12 derivazioni, inclusa la valutazione del tratto ST.",
      "source_location": "ehr_structured",
      "data_type": "text",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Cercare nel sistema di archiviazione ECG il referto associato al tracciato. Può essere presente anche in nota clinica di pronto soccorso."
    },
    {
      "data_element_id": "DE-stato-clinico",
      "name": "Stato clinico del paziente al primo contatto",
      "description": "Stato clinico complessivo del paziente (cosciente, incosciente, arresto cardiaco) al momento del primo contatto medico.",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": "Codifica locale",
      "required_for_evaluation": false,
      "extraction_method": "hybrid",
      "query_hint": "Verificare lo stato clinico nella scheda 118 o nella valutazione iniziale di triage."
    },
    {
      "data_element_id": "DE-numero-derivazioni-ECG",
      "name": "Numero di derivazioni dell'ECG",
      "description": "Numero di derivazioni registrate nell'ECG acquisito.",
      "source_location": "ehr_structured",
      "data_type": "numeric",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Verificare dall'header del file ECG digitale o dalla descrizione del dispositivo utilizzato."
    }
  ],
  "evidence_of_compliance": [
    {
      "evidence_id": "STEMI-DO-003-EOC-01",
      "description": "Tracciato ECG a 12 derivazioni registrato e archiviato nel sistema, con timestamp di acquisizione entro 10 minuti dal primo contatto medico.",
      "evidence_type": "execution",
      "minimum_occurrences": 1,
      "time_reference": "Entro 10 minuti dal primo contatto medico",
      "derived_from_data_elements": [
        "DE-timestamp-primo-contatto-medico",
        "DE-timestamp-registrazione-ECG",
        "DE-numero-derivazioni-ECG"
      ]
    },
    {
      "evidence_id": "STEMI-DO-003-EOC-02",
      "description": "Referto o annotazione diagnostica dell'interpretazione dell'ECG presente nel sistema, con valutazione del tratto ST documentata.",
      "evidence_type": "documentation",
      "minimum_occurrences": 1,
      "time_reference": "Entro 10 minuti dal primo contatto medico",
      "derived_from_data_elements": [
        "DE-referto-ECG",
        "DE-timestamp-interpretazione-ECG"
      ]
    },
    {
      "evidence_id": "STEMI-DO-003-EOC-03",
      "description": "Timestamp documentato attestante che la differenza tra il momento dell'interpretazione ECG e il momento del primo contatto medico è inferiore a 10 minuti.",
      "evidence_type": "timestamp",
      "minimum_occurrences": 1,
      "time_reference": "Differenza temporale < 10 minuti",
      "derived_from_data_elements": [
        "DE-timestamp-primo-contatto-medico",
        "DE-timestamp-interpretazione-ECG"
      ]
    }
  ],
  "evidence_of_non_compliance": [
    {
      "evidence_id": "STEMI-DO-003-EONC-01",
      "description": "Assenza di tracciato ECG a 12 derivazioni registrato nel sistema per il paziente con sospetta SCA dopo il primo contatto medico.",
      "evidence_type": "absence_of_event",
      "minimum_occurrences": 1,
      "time_reference": "Oltre 10 minuti dal primo contatto medico senza ECG registrato",
      "derived_from_data_elements": [
        "DE-timestamp-primo-contatto-medico",
        "DE-timestamp-registrazione-ECG"
      ]
    },
    {
      "evidence_id": "STEMI-DO-003-EONC-02",
      "description": "ECG registrato ma con intervallo temporale dal primo contatto medico superiore o uguale a 10 minuti.",
      "evidence_type": "timestamp",
      "minimum_occurrences": 1,
      "time_reference": "Differenza temporale >= 10 minuti tra FMC e registrazione/interpretazione ECG",
      "derived_from_data_elements": [
        "DE-timestamp-primo-contatto-medico",
        "DE-timestamp-registrazione-ECG",
        "DE-timestamp-interpretazione-ECG"
      ]
    },
    {
      "evidence_id": "STEMI-DO-003-EONC-03",
      "description": "ECG registrato ma senza interpretazione o referto documentato.",
      "evidence_type": "documentation",
      "minimum_occurrences": 1,
      "time_reference": "Dopo la registrazione dell'ECG",
      "derived_from_data_elements": [
        "DE-referto-ECG",
        "DE-timestamp-interpretazione-ECG"
      ]
    },
    {
      "evidence_id": "STEMI-DO-003-EONC-04",
      "description": "ECG registrato con numero di derivazioni inferiore a 12 senza giustificazione clinica documentata.",
      "evidence_type": "result",
      "minimum_occurrences": 1,
      "time_reference": null,
      "derived_from_data_elements": [
        "DE-numero-derivazioni-ECG"
      ]
    }
  ],
  "evaluation_logic": {
    "natural_language_test": "Verificare che: (1) esista un ECG a 12 derivazioni registrato per il paziente dopo il primo contatto medico; (2) l'ECG sia stato interpretato con referto o annotazione diagnostica documentata; (3) il tempo trascorso tra il primo contatto medico e il completamento dell'interpretazione ECG sia inferiore a 10 minuti. Se tutte e tre le condizioni sono soddisfatte, la regola è conforme. Se manca l'ECG o l'interpretazione, o se il tempo è ≥ 10 minuti, la regola è non conforme, salvo eccezione giustificata documentata.",
    "formal_expression_language": "pseudocode",
    "formal_expression": "IF DE-timestamp-registrazione-ECG IS NOT NULL AND DE-referto-ECG IS NOT NULL AND DE-numero-derivazioni-ECG == 12 AND (DE-timestamp-interpretazione-ECG - DE-timestamp-primo-contatto-medico) < 10 min THEN 'compliant' ELIF exception_documented == true THEN 'justified_deviation' ELIF DE-timestamp-primo-contatto-medico IS NULL OR DE-timestamp-registrazione-ECG IS NULL THEN 'not_evaluable' ELSE 'non_compliant'",
    "missing_data_policy": "not_evaluable",
    "ambiguity_policy": "review_required",
    "conflict_resolution_policy": "most_recent_source",
    "notes": "Il timestamp del primo contatto medico può provenire da fonti differenti (scheda 118, triage PS). In caso di discrepanza, utilizzare il timestamp più precoce documentato. L'interpretazione dell'ECG può essere effettuata anche mediante tele-refertazione."
  },
  "evaluation_method": {
    "primary_method": "hybrid",
    "allowed_inference_sources": [
      "Note cliniche di pronto soccorso",
      "Scheda intervento 118",
      "Sistema di archiviazione ECG",
      "Verbale di triage"
    ],
    "human_review_required": false,
    "minimum_confidence": 0.85,
    "notes": "La valutazione deterministica è possibile quando i timestamp strutturati sono disponibili nel sistema. L'inferenza è necessaria quando il timestamp del FMC o dell'interpretazione ECG devono essere estratti da documentazione non strutturata."
  },
  "possible_outcomes": [
    "compliant",
    "non_compliant",
    "justified_deviation",
    "not_applicable",
    "not_evaluable",
    "probable_non_compliance"
  ],
  "risk_classification": {
    "clinical_risk_severity": "critical",
    "process_risk_severity": "high",
    "likelihood_if_violated": "likely",
    "detectability": "easy",
    "priority_score": 95,
    "rationale": "Il ritardo nella registrazione e interpretazione dell'ECG a 12 derivazioni è direttamente correlato al ritardo nella diagnosi di STEMI e nell'attivazione del percorso di riperfusione. Ogni minuto di ritardo aumenta l'area di necrosi miocardica e peggiora la prognosi del paziente. La rilevabilità è elevata grazie alla disponibilità di timestamp strutturati nei sistemi ECG."
  },
  "documentation_requirements": {
    "mandatory_fields": [
      "Timestamp del primo contatto medico (FMC)",
      "Timestamp di registrazione dell'ECG a 12 derivazioni",
      "Tracciato ECG a 12 derivazioni archiviato",
      "Referto o annotazione diagnostica dell'interpretazione ECG",
      "Identificativo dell'operatore che ha interpretato l'ECG"
    ],
    "acceptable_evidence_sources": [
      "Sistema di archiviazione ECG digitale (es. MUSE, Mortara)",
      "Cartella clinica elettronica di pronto soccorso",
      "Scheda intervento 118",
      "Verbale di triage",
      "Sistema di tele-ECG"
    ],
    "justification_required_when_deviating": true,
    "justification_fields": [
      "Motivo del ritardo o della mancata esecuzione dell'ECG",
      "Condizioni cliniche del paziente che hanno impedito l'esecuzione",
      "Azioni alternative intraprese",
      "Timestamp delle azioni correttive"
    ],
    "free_text_allowed": true
  },
  "associated_weak_signal_ids": [
    "STEMI-WS-003-A",
    "STEMI-WS-003-B",
    "STEMI-WS-003-C"
  ],
  "extraction_metadata": {
    "generation_mode": "llm_inference",
    "source_interpretation_notes": "Il testo originale utilizza il termine 'recommended' che nella classificazione ESC corrisponde a Classe I. Il target temporale '<10 min' è stato codificato come vincolo temporale rigido (hard deadline). L'azione comprende sia la registrazione sia l'interpretazione dell'ECG, come esplicitamente indicato nella raccomandazione originale. Il concetto di 'point of first medical contact' è stato tradotto con il termine italiano 'primo contatto medico (FMC)' secondo la terminologia standard PDTA STEMI.",
    "extraction_confidence": 0.93,
    "ambiguity_flags": [
      "Il timestamp esatto dell'interpretazione ECG potrebbe non essere sempre registrato separatamente dal timestamp di acquisizione",
      "La definizione operativa di 'primo contatto medico' può variare tra contesti pre-ospedalieri e ospedalieri"
    ],
    "human_validation_status": "not_reviewed",
    "validated_by": null,
    "validated_at": null
  },
  "governance_metadata": {
    "lifecycle_status": "draft",
    "version": "1.0.0",
    "authoring_body": "Gruppo di lavoro PDTA STEMI – Rete Cardiologica",
    "rule_owner": "Responsabile Clinico PDTA STEMI",
    "effective_from": null,
    "effective_to": null,
    "review_cycle": "12 mesi",
    "last_reviewed_at": null,
    "approved_by": null
  }
}
$json_STEMI_DO_003$::jsonb)
ON CONFLICT (clinical_pathway_id, name) DO UPDATE
SET body = EXCLUDED.body;

INSERT INTO riskm_manager_model_evaluation.rule_definition (clinical_pathway_id, name, body)
VALUES (1, 'STEMI-DO-004', $json_STEMI_DO_004$
{
  "schema_version": "1.0.0",
  "rule_id": "STEMI-DO-004",
  "rule_type": "do",
  "title": "Monitoraggio ECG continuo e disponibilità di defibrillatore nei pazienti con sospetto STEMI o SCA",
  "short_label": "ECG continuo + defibrillatore",
  "clinical_pathway_id": "PDTA-STEMI-001",
  "clinical_pathway_name": "Percorso Diagnostico Terapeutico Assistenziale per STEMI",
  "clinical_phase": "monitoraggio precoce",
  "care_settings": [
    "pronto soccorso",
    "ambulanza 118",
    "unità di terapia intensiva cardiologica",
    "laboratorio di emodinamica",
    "reparto di cardiologia"
  ],
  "responsible_actors": [
    {
      "role_name": "Medico d'emergenza",
      "responsibility_type": "primary",
      "organization_unit": "Pronto Soccorso / DEA",
      "notes": "Responsabile dell'attivazione tempestiva del monitoraggio ECG continuo e della verifica della disponibilità del defibrillatore al primo contatto con il paziente."
    },
    {
      "role_name": "Infermiere di triage",
      "responsibility_type": "supporting",
      "organization_unit": "Pronto Soccorso / DEA",
      "notes": "Supporto nell'applicazione immediata del monitoraggio ECG e nella verifica della funzionalità del defibrillatore."
    },
    {
      "role_name": "Personale del 118",
      "responsibility_type": "primary",
      "organization_unit": "Servizio di Emergenza Territoriale 118",
      "notes": "Responsabile dell'avvio del monitoraggio ECG continuo e della disponibilità del defibrillatore in fase pre-ospedaliera."
    },
    {
      "role_name": "Cardiologo di guardia",
      "responsibility_type": "consulted",
      "organization_unit": "Unità di Terapia Intensiva Cardiologica (UTIC)",
      "notes": "Consultato per la gestione avanzata del monitoraggio e per eventuali aritmie rilevate."
    },
    {
      "role_name": "Infermiere UTIC",
      "responsibility_type": "supporting",
      "organization_unit": "Unità di Terapia Intensiva Cardiologica (UTIC)",
      "notes": "Responsabile della continuità del monitoraggio ECG durante il ricovero in UTIC."
    }
  ],
  "deontic_strength": "mandatory",
  "recommendation_strength": "Classe I",
  "evidence_level": "Livello di evidenza B",
  "original_statement": "Continuous ECG monitoring and the availability of defibrillator capacity is recommended as soon as possible in all patients with suspected STEMI, in suspected ACS with other ECG changes or ongoing chest pain, and once the diagnosis of MI is made.",
  "normalized_statement": "Il monitoraggio ECG continuo e la disponibilità di un defibrillatore devono essere garantiti il prima possibile in tutti i pazienti con sospetto STEMI, con sospetta SCA con alterazioni ECG o dolore toracico in corso, e una volta che la diagnosi di infarto miocardico sia stata posta.",
  "intent": "Garantire la sorveglianza elettrocardiografica continua e la capacità di defibrillazione immediata per la rilevazione e il trattamento tempestivo di aritmie potenzialmente fatali nei pazienti con sindrome coronarica acuta sospetta o confermata.",
  "rationale": "I pazienti con STEMI o SCA sono a elevato rischio di aritmie ventricolari maligne, inclusa la fibrillazione ventricolare, specialmente nelle prime ore dall'esordio dei sintomi. Il monitoraggio ECG continuo consente la rilevazione precoce di aritmie, mentre la disponibilità immediata di un defibrillatore permette la defibrillazione tempestiva, riducendo significativamente la mortalità per arresto cardiaco.",
  "source_references": [
    {
      "source_id": "ESC-STEMI-2023",
      "source_level": "international",
      "issuer": "European Society of Cardiology (ESC)",
      "document_title": "2023 ESC Guidelines for the management of acute coronary syndromes",
      "document_version": "2023",
      "publication_date": "2023-08-25",
      "section_reference": "Sezione Monitoraggio e gestione delle aritmie nella fase acuta",
      "page_reference": null,
      "statement_quote": "Continuous ECG monitoring and the availability of defibrillator capacity is recommended as soon as possible in all patients with suspected STEMI, in suspected ACS with other ECG changes or ongoing chest pain, and once the diagnosis of MI is made.",
      "citation_uri": "https://doi.org/10.1093/eurheartj/ehad191",
      "license_note": "Contenuto derivato dalle linee guida ESC; utilizzato a scopo clinico-assistenziale e di ricerca sotto fair use accademico."
    }
  ],
  "applicability": {
    "population_description": "Tutti i pazienti adulti con sospetto STEMI, sospetta sindrome coronarica acuta (SCA) con alterazioni ECG o dolore toracico in corso, oppure con diagnosi confermata di infarto miocardico.",
    "clinical_context": "Sindrome coronarica acuta sospetta o confermata, inclusi STEMI, NSTEMI e angina instabile con alterazioni elettrocardiografiche o sintomatologia toracica persistente.",
    "care_context": "Fase pre-ospedaliera (118/ambulanza), pronto soccorso, triage, laboratorio di emodinamica, UTIC e qualsiasi setting in cui il paziente sia in fase acuta.",
    "inclusion_criteria": [
      {
        "criterion_id": "STEMI-DO-004-INC-01",
        "label": "Sospetto STEMI",
        "description": "Paziente con presentazione clinica e/o elettrocardiografica compatibile con sospetto infarto miocardico con sopraslivellamento del tratto ST.",
        "logic_expression": "ECG.ST_elevation = true OR clinical_suspicion.STEMI = true",
        "data_elements": [
          "DE-ECG-001",
          "DE-CLINICAL-SUSPICION-001"
        ],
        "inference_allowed": true
      },
      {
        "criterion_id": "STEMI-DO-004-INC-02",
        "label": "Sospetta SCA con alterazioni ECG",
        "description": "Paziente con sospetta sindrome coronarica acuta che presenta alterazioni elettrocardiografiche diverse dal sopraslivellamento ST (es. sottoslivellamento ST, inversione onda T, blocco di branca di nuova insorgenza).",
        "logic_expression": "clinical_suspicion.ACS = true AND ECG.abnormal_changes = true",
        "data_elements": [
          "DE-ECG-001",
          "DE-CLINICAL-SUSPICION-002"
        ],
        "inference_allowed": true
      },
      {
        "criterion_id": "STEMI-DO-004-INC-03",
        "label": "Sospetta SCA con dolore toracico in corso",
        "description": "Paziente con sospetta sindrome coronarica acuta e dolore toracico persistente al momento della valutazione.",
        "logic_expression": "clinical_suspicion.ACS = true AND chest_pain.ongoing = true",
        "data_elements": [
          "DE-CHEST-PAIN-001",
          "DE-CLINICAL-SUSPICION-002"
        ],
        "inference_allowed": true
      },
      {
        "criterion_id": "STEMI-DO-004-INC-04",
        "label": "Diagnosi confermata di infarto miocardico",
        "description": "Paziente con diagnosi confermata di infarto miocardico acuto (STEMI o NSTEMI) sulla base di criteri clinici, elettrocardiografici e bioumorali.",
        "logic_expression": "diagnosis.MI_confirmed = true",
        "data_elements": [
          "DE-DIAGNOSIS-MI-001"
        ],
        "inference_allowed": true
      }
    ],
    "exclusion_criteria": [
      {
        "criterion_id": "STEMI-DO-004-EXC-01",
        "label": "Paziente deceduto prima dell'applicazione",
        "description": "La regola non si applica se il paziente è deceduto prima del primo contatto medico o se si è deciso di non procedere a rianimazione.",
        "logic_expression": "patient.status = 'deceased' OR DNR_order = true",
        "data_elements": [
          "DE-PATIENT-STATUS-001",
          "DE-DNR-001"
        ],
        "inference_allowed": false
      },
      {
        "criterion_id": "STEMI-DO-004-EXC-02",
        "label": "Diagnosi alternativa definitivamente confermata",
        "description": "La regola non si applica se una diagnosi alternativa non cardiaca è stata definitivamente confermata e la SCA è stata esclusa con certezza.",
        "logic_expression": "ACS_excluded = true AND alternative_diagnosis_confirmed = true",
        "data_elements": [
          "DE-ACS-EXCLUSION-001"
        ],
        "inference_allowed": false
      }
    ]
  },
  "trigger": {
    "trigger_type": "documented_symptom",
    "trigger_description": "Il trigger si attiva al momento del primo sospetto clinico di STEMI o SCA (basato su sintomi, ECG o anamnesi), oppure al momento della conferma diagnostica di infarto miocardico acuto.",
    "anchor_event": "primo_contatto_medico_con_sospetto_SCA",
    "start_of_applicability": "Dal momento del primo sospetto clinico di STEMI, SCA con alterazioni ECG, SCA con dolore toracico persistente, o dalla diagnosi confermata di infarto miocardico.",
    "end_of_applicability": "Fino alla stabilizzazione clinica del paziente e alla dimissione dalla fase di monitoraggio intensivo, o fino al trasferimento in reparto senza indicazione a monitoraggio continuo.",
    "trigger_data_elements": [
      "DE-ECG-001",
      "DE-CHEST-PAIN-001",
      "DE-CLINICAL-SUSPICION-001",
      "DE-CLINICAL-SUSPICION-002",
      "DE-DIAGNOSIS-MI-001"
    ],
    "inference_allowed": true
  },
  "exceptions": [
    {
      "exception_id": "STEMI-DO-004-EXP-01",
      "label": "Indisponibilità tecnica temporanea del monitor ECG",
      "description": "In caso di indisponibilità tecnica temporanea del dispositivo di monitoraggio ECG (es. guasto, mancanza di apparecchiatura), è necessario documentare il motivo e attivare immediatamente procedure alternative di sorveglianza clinica ravvicinata.",
      "condition_logic": "ECG_monitor.available = false AND equipment_failure.documented = true",
      "required_justification": true,
      "required_evidence": [
        "Documentazione del guasto o indisponibilità dell'apparecchio",
        "Registrazione della sorveglianza clinica alternativa adottata",
        "Orario di ripristino del monitoraggio ECG"
      ]
    },
    {
      "exception_id": "STEMI-DO-004-EXP-02",
      "label": "Rifiuto del paziente",
      "description": "Il paziente, adeguatamente informato, rifiuta esplicitamente il monitoraggio ECG continuo. Il rifiuto deve essere documentato formalmente.",
      "condition_logic": "patient.informed_refusal.ECG_monitoring = true",
      "required_justification": true,
      "required_evidence": [
        "Consenso informato con documentazione del rifiuto",
        "Nota medica attestante l'informazione fornita sui rischi"
      ]
    }
  ],
  "expected_action": {
    "action_verb": "attivare",
    "action_description": "Attivare il monitoraggio ECG continuo e garantire la disponibilità immediata di un defibrillatore funzionante il prima possibile in tutti i pazienti con sospetto STEMI, sospetta SCA con alterazioni ECG o dolore toracico in corso, e in tutti i pazienti con diagnosi confermata di infarto miocardico.",
    "action_target": "monitoraggio ECG continuo e defibrillatore",
    "action_parameters": [
      {
        "parameter_name": "modalità_monitoraggio_ECG",
        "parameter_description": "Il monitoraggio ECG deve essere continuo (non intermittente) per consentire la rilevazione in tempo reale di aritmie.",
        "expected_value": "continuo",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "disponibilità_defibrillatore",
        "parameter_description": "Un defibrillatore funzionante deve essere immediatamente disponibile nella stessa area in cui si trova il paziente.",
        "expected_value": "immediatamente disponibile",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "tempistica_attivazione",
        "parameter_description": "L'attivazione del monitoraggio e la verifica della disponibilità del defibrillatore devono avvenire il prima possibile dal sospetto clinico.",
        "expected_value": "il prima possibile",
        "comparison_operator": null,
        "unit": null,
        "mandatory": true
      }
    ],
    "alternative_compliant_actions": [
      "Utilizzo di telemetria portatile con allarmi aritmici in caso di indisponibilità di monitor ECG fisso",
      "Utilizzo di defibrillatore automatico esterno (DAE) in sostituzione del defibrillatore manuale se quest'ultimo non è disponibile"
    ]
  },
  "completion_criteria": {
    "description": "La regola è considerata soddisfatta quando il monitoraggio ECG continuo è stato attivato e un defibrillatore funzionante è stato reso disponibile nella prossimità del paziente, con documentazione dell'ora di attivazione.",
    "minimum_occurrences": 1,
    "required_event_types": [
      "attivazione_monitoraggio_ECG_continuo",
      "verifica_disponibilità_defibrillatore"
    ],
    "required_documentation_elements": [
      "Orario di inizio del monitoraggio ECG continuo",
      "Conferma della disponibilità del defibrillatore",
      "Identificativo del dispositivo di monitoraggio utilizzato"
    ],
    "success_condition": "ECG_monitoring.continuous = true AND defibrillator.available = true AND documentation.timestamp IS NOT NULL"
  },
  "time_constraints": [
    {
      "constraint_id": "STEMI-DO-004-TC-01",
      "description": "Il monitoraggio ECG continuo e la disponibilità del defibrillatore devono essere garantiti il prima possibile dal momento del sospetto clinico di STEMI/SCA o dalla conferma diagnostica di infarto miocardico.",
      "relation_to_anchor": "immediate",
      "anchor_event": "primo_contatto_medico_con_sospetto_SCA",
      "duration_value": null,
      "duration_unit": null,
      "hard_deadline": true,
      "alert_threshold_value": 5,
      "alert_threshold_unit": "minuti"
    }
  ],
  "sequence_constraints": [
    {
      "constraint_id": "STEMI-DO-004-SC-01",
      "description": "Il monitoraggio ECG continuo e la disponibilità del defibrillatore devono essere attivati prima di qualsiasi procedura interventistica o trasferimento intra-ospedaliero.",
      "predecessor_event": "attivazione_monitoraggio_ECG_e_defibrillatore",
      "successor_event": "trasferimento_laboratorio_emodinamica",
      "allowed_order": "predecessor_first",
      "violation_condition": "Il paziente viene trasferito al laboratorio di emodinamica o sottoposto a intervento senza monitoraggio ECG continuo attivo e senza defibrillatore disponibile."
    },
    {
      "constraint_id": "STEMI-DO-004-SC-02",
      "description": "Il monitoraggio ECG continuo deve essere attivato contestualmente o immediatamente dopo il primo ECG diagnostico.",
      "predecessor_event": "esecuzione_ECG_diagnostico",
      "successor_event": "attivazione_monitoraggio_ECG_continuo",
      "allowed_order": "same_encounter",
      "violation_condition": "Il monitoraggio ECG continuo non viene attivato durante lo stesso contatto clinico in cui viene eseguito l'ECG diagnostico."
    }
  ],
  "required_data_elements": [
    {
      "data_element_id": "DE-ECG-001",
      "name": "Risultato ECG a 12 derivazioni",
      "description": "Tracciato e referto dell'elettrocardiogramma a 12 derivazioni eseguito al primo contatto, inclusa la presenza di sopraslivellamento ST o altre alterazioni.",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": "LOINC",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare risultati ECG con codici LOINC pertinenti (es. 11524-6) e referto interpretativo."
    },
    {
      "data_element_id": "DE-CHEST-PAIN-001",
      "name": "Dolore toracico in corso",
      "description": "Presenza di dolore toracico persistente al momento della valutazione clinica.",
      "source_location": "ehr_unstructured",
      "data_type": "boolean",
      "coding_system": "ICD-10 R07.9",
      "required_for_evaluation": true,
      "extraction_method": "inferential",
      "query_hint": "Cercare menzione di dolore toracico in corso, persistente o acuto nelle note di triage o di pronto soccorso."
    },
    {
      "data_element_id": "DE-CLINICAL-SUSPICION-001",
      "name": "Sospetto clinico di STEMI",
      "description": "Documentazione del sospetto clinico di STEMI basato su presentazione clinica e/o ECG.",
      "source_location": "ehr_structured",
      "data_type": "boolean",
      "coding_system": "ICD-10 I21",
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Cercare codice di attivazione percorso STEMI, diagnosi provvisoria I21.x o nota clinica con sospetto STEMI."
    },
    {
      "data_element_id": "DE-CLINICAL-SUSPICION-002",
      "name": "Sospetto clinico di SCA",
      "description": "Documentazione del sospetto clinico di sindrome coronarica acuta (SCA) non-STEMI.",
      "source_location": "ehr_structured",
      "data_type": "boolean",
      "coding_system": "ICD-10 I20-I21",
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Cercare diagnosi provvisoria di SCA, NSTEMI o angina instabile nelle note cliniche o nel sistema di triage."
    },
    {
      "data_element_id": "DE-DIAGNOSIS-MI-001",
      "name": "Diagnosi confermata di infarto miocardico",
      "description": "Diagnosi confermata di infarto miocardico acuto (STEMI o NSTEMI) basata su criteri clinici, ECG e biomarcatori.",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": "ICD-10 I21",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare diagnosi definitiva codificata I21.x nel sistema di cartella clinica."
    },
    {
      "data_element_id": "DE-ECG-MONITOR-001",
      "name": "Stato monitoraggio ECG continuo",
      "description": "Registrazione dell'attivazione del monitoraggio ECG continuo, incluso orario di inizio e identificativo del dispositivo.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare registrazioni di inizio monitoraggio ECG continuo nel sistema di monitoraggio o nella cartella infermieristica."
    },
    {
      "data_element_id": "DE-DEFIB-001",
      "name": "Disponibilità defibrillatore",
      "description": "Conferma della disponibilità e funzionalità di un defibrillatore nell'area del paziente.",
      "source_location": "ehr_structured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Cercare checklist di verifica apparecchiature, log del defibrillatore o note infermieristiche che confermino la disponibilità."
    },
    {
      "data_element_id": "DE-PATIENT-STATUS-001",
      "name": "Stato vitale del paziente",
      "description": "Stato vitale corrente del paziente (vivo, deceduto).",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": null,
      "required_for_evaluation": false,
      "extraction_method": "deterministic",
      "query_hint": "Verificare lo stato del paziente nel sistema ADT."
    },
    {
      "data_element_id": "DE-DNR-001",
      "name": "Ordine di non rianimazione (DNR)",
      "description": "Presenza di un ordine documentato di non rianimazione cardio-polmonare.",
      "source_location": "ehr_structured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": false,
      "extraction_method": "deterministic",
      "query_hint": "Cercare ordini DNR o disposizioni anticipate di trattamento nel fascicolo del paziente."
    },
    {
      "data_element_id": "DE-ACS-EXCLUSION-001",
      "name": "Esclusione di SCA",
      "description": "Documentazione dell'esclusione definitiva di sindrome coronarica acuta con diagnosi alternativa confermata.",
      "source_location": "ehr_structured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": false,
      "extraction_method": "hybrid",
      "query_hint": "Cercare nota clinica di esclusione di SCA con diagnosi alternativa confermata."
    }
  ],
  "evidence_of_compliance": [
    {
      "evidence_id": "STEMI-DO-004-EOC-01",
      "description": "Registrazione documentata dell'attivazione del monitoraggio ECG continuo con orario di inizio.",
      "evidence_type": "timestamp",
      "minimum_occurrences": 1,
      "time_reference": "Entro i primi minuti dal sospetto clinico di STEMI/SCA o dalla diagnosi di infarto miocardico.",
      "derived_from_data_elements": [
        "DE-ECG-MONITOR-001"
      ]
    },
    {
      "evidence_id": "STEMI-DO-004-EOC-02",
      "description": "Documentazione della disponibilità e funzionalità del defibrillatore nell'area del paziente.",
      "evidence_type": "documentation",
      "minimum_occurrences": 1,
      "time_reference": "Contestualmente all'attivazione del monitoraggio ECG continuo.",
      "derived_from_data_elements": [
        "DE-DEFIB-001"
      ]
    },
    {
      "evidence_id": "STEMI-DO-004-EOC-03",
      "description": "Presenza di tracciati ECG continui nel sistema di monitoraggio a partire dalla fase acuta.",
      "evidence_type": "execution",
      "minimum_occurrences": 1,
      "time_reference": "Dalla fase acuta del sospetto/diagnosi fino alla stabilizzazione clinica.",
      "derived_from_data_elements": [
        "DE-ECG-MONITOR-001"
      ]
    }
  ],
  "evidence_of_non_compliance": [
    {
      "evidence_id": "STEMI-DO-004-EONC-01",
      "description": "Assenza di documentazione di attivazione del monitoraggio ECG continuo durante la fase acuta del sospetto o della diagnosi di STEMI/SCA/IM.",
      "evidence_type": "absence_of_event",
      "minimum_occurrences": 1,
      "time_reference": "Dall'esordio del sospetto clinico fino al ricovero in UTIC o al trasferimento in emodinamica.",
      "derived_from_data_elements": [
        "DE-ECG-MONITOR-001"
      ]
    },
    {
      "evidence_id": "STEMI-DO-004-EONC-02",
      "description": "Assenza di documentazione della disponibilità del defibrillatore nell'area del paziente.",
      "evidence_type": "absence_of_event",
      "minimum_occurrences": 1,
      "time_reference": "Dall'esordio del sospetto clinico fino al ricovero in UTIC.",
      "derived_from_data_elements": [
        "DE-DEFIB-001"
      ]
    },
    {
      "evidence_id": "STEMI-DO-004-EONC-03",
      "description": "Ritardo significativo nell'attivazione del monitoraggio ECG continuo rispetto al primo contatto medico con sospetto clinico.",
      "evidence_type": "timestamp",
      "minimum_occurrences": 1,
      "time_reference": "Più di 10 minuti dal primo contatto medico con sospetto di SCA/STEMI.",
      "derived_from_data_elements": [
        "DE-ECG-MONITOR-001",
        "DE-CLINICAL-SUSPICION-001",
        "DE-CLINICAL-SUSPICION-002"
      ]
    }
  ],
  "evaluation_logic": {
    "natural_language_test": "Verificare che per ogni paziente con sospetto STEMI, sospetta SCA con alterazioni ECG o dolore toracico in corso, o con diagnosi confermata di infarto miocardico, esista documentazione dell'attivazione del monitoraggio ECG continuo E della disponibilità di un defibrillatore funzionante, il prima possibile dal momento del sospetto o della conferma diagnostica.",
    "formal_expression_language": "pseudocode",
    "formal_expression": "IF (clinical_suspicion.STEMI = true OR (clinical_suspicion.ACS = true AND (ECG.abnormal_changes = true OR chest_pain.ongoing = true)) OR diagnosis.MI_confirmed = true) THEN REQUIRE (ECG_monitoring.continuous.start_timestamp IS NOT NULL AND defibrillator.available = true AND ECG_monitoring.continuous.start_timestamp <= first_medical_contact_timestamp + INTERVAL_ASAP)",
    "missing_data_policy": "review_required",
    "ambiguity_policy": "review_required",
    "conflict_resolution_policy": "highest_risk_interpretation",
    "notes": "La definizione di 'il prima possibile' (as soon as possible) è soggetta a interpretazione operativa. Si raccomanda che venga considerata una tempistica entro pochi minuti dal primo contatto medico. In caso di dati mancanti sulla tempistica esatta, è richiesta revisione manuale."
  },
  "evaluation_method": {
    "primary_method": "hybrid",
    "allowed_inference_sources": [
      "note cliniche di pronto soccorso",
      "schede infermieristiche",
      "log dei dispositivi di monitoraggio",
      "verbale del 118",
      "cartella clinica elettronica",
      "checklist apparecchiature di reparto"
    ],
    "human_review_required": true,
    "minimum_confidence": 0.8,
    "notes": "La verifica della disponibilità del defibrillatore potrebbe richiedere inferenza da documentazione non strutturata. Il monitoraggio ECG continuo può essere verificato tramite log dei dispositivi o registrazioni infermieristiche. Si consiglia revisione umana per confermare la tempistica di attivazione."
  },
  "possible_outcomes": [
    "compliant",
    "non_compliant",
    "justified_deviation",
    "not_applicable",
    "not_evaluable",
    "probable_non_compliance"
  ],
  "risk_classification": {
    "clinical_risk_severity": "critical",
    "process_risk_severity": "high",
    "likelihood_if_violated": "likely",
    "detectability": "moderate",
    "priority_score": 95,
    "rationale": "L'assenza di monitoraggio ECG continuo e/o di defibrillatore disponibile in pazienti con STEMI/SCA espone il paziente a rischio di morte improvvisa per fibrillazione ventricolare non rilevata o non trattata tempestivamente. La mortalità per aritmie ventricolari maligne non trattate è estremamente elevata. La rilevabilità della violazione è moderata perché la documentazione del monitoraggio potrebbe non essere sempre completa."
  },
  "documentation_requirements": {
    "mandatory_fields": [
      "Orario di attivazione del monitoraggio ECG continuo",
      "Conferma della disponibilità del defibrillatore",
      "Identificativo del dispositivo di monitoraggio ECG",
      "Nome dell'operatore che ha attivato il monitoraggio",
      "Setting in cui è stato attivato il monitoraggio (ambulanza, PS, UTIC)"
    ],
    "acceptable_evidence_sources": [
      "Cartella clinica elettronica",
      "Scheda infermieristica",
      "Log dei dispositivi di monitoraggio",
      "Verbale del 118",
      "Checklist apparecchiature",
      "Report sistema di telemetria"
    ],
    "justification_required_when_deviating": true,
    "justification_fields": [
      "Motivo della deviazione dalla regola",
      "Misure alternative adottate",
      "Orario previsto di ripristino del monitoraggio",
      "Firma del medico responsabile"
    ],
    "free_text_allowed": true
  },
  "associated_weak_signal_ids": [
    "STEMI-WS-004-01",
    "STEMI-WS-004-02",
    "STEMI-WS-004-03"
  ],
  "extraction_metadata": {
    "generation_mode": "llm_inference",
    "source_interpretation_notes": "Il testo sorgente utilizza il termine 'recommended' che, nel contesto delle linee guida ESC con classe di raccomandazione I, è stato interpretato come 'mandatory' (obbligatorio). L'espressione 'as soon as possible' è stata tradotta come 'il prima possibile' e interpretata operativamente come tempistica immediata dall'insorgenza del sospetto clinico. La regola copre tre popolazioni distinte (sospetto STEMI, sospetta SCA con alterazioni ECG o dolore toracico persistente, diagnosi confermata di IM) che sono state tutte incluse come criteri di inclusione separati.",
    "extraction_confidence": 0.92,
    "ambiguity_flags": [
      "La definizione esatta di 'as soon as possible' non è quantificata in minuti nel testo sorgente",
      "Non è specificato il tipo di defibrillatore richiesto (manuale vs automatico)",
      "Non è esplicitata la durata minima del monitoraggio ECG continuo"
    ],
    "human_validation_status": "not_reviewed",
    "validated_by": null,
    "validated_at": null
  },
  "governance_metadata": {
    "lifecycle_status": "draft",
    "version": "1.0.0",
    "authoring_body": "Gruppo di Lavoro PDTA STEMI",
    "rule_owner": "Direttore UOC Cardiologia / Responsabile Rete STEMI",
    "effective_from": "2024-01-01",
    "effective_to": null,
    "review_cycle": "ogni 12 mesi",
    "last_reviewed_at": null,
    "approved_by": null
  }
}
$json_STEMI_DO_004$::jsonb)
ON CONFLICT (clinical_pathway_id, name) DO UPDATE
SET body = EXCLUDED.body;

INSERT INTO riskm_manager_model_evaluation.rule_definition (clinical_pathway_id, name, body)
VALUES (1, 'STEMI-DO-005', $json_STEMI_DO_005$
{
  "schema_version": "1.0.0",
  "rule_id": "STEMI-DO-005",
  "rule_type": "do",
  "title": "Utilizzo di derivazioni ECG aggiuntive (V3R, V4R e V7–V9) in caso di STEMI inferiore o sospetta occlusione coronarica totale con derivazioni standard non conclusive",
  "short_label": "ECG derivazioni aggiuntive STEMI inferiore",
  "clinical_pathway_id": "PDTA-STEMI-001",
  "clinical_pathway_name": "Percorso Diagnostico-Terapeutico Assistenziale per STEMI",
  "clinical_phase": "diagnosi",
  "care_settings": [
    "pronto soccorso",
    "unità di terapia intensiva cardiologica",
    "pre-ospedaliero (ambulanza medicalizzata)"
  ],
  "responsible_actors": [
    {
      "role_name": "Medico d'emergenza",
      "responsibility_type": "primary",
      "organization_unit": "Pronto Soccorso",
      "notes": "Responsabile dell'esecuzione e dell'interpretazione dell'ECG a 12 derivazioni e delle derivazioni aggiuntive."
    },
    {
      "role_name": "Infermiere di triage/emergenza",
      "responsibility_type": "supporting",
      "organization_unit": "Pronto Soccorso",
      "notes": "Esegue materialmente la registrazione ECG con le derivazioni aggiuntive su indicazione medica."
    },
    {
      "role_name": "Cardiologo interventista",
      "responsibility_type": "consulted",
      "organization_unit": "Emodinamica / UTIC",
      "notes": "Può essere consultato per l'interpretazione delle derivazioni aggiuntive e per la pianificazione dell'eventuale coronarografia."
    }
  ],
  "deontic_strength": "recommended",
  "recommendation_strength": "Classe I",
  "evidence_level": "Livello di evidenza C",
  "original_statement": "The use of additional ECG leads (V3R, V4R, and V7–V9) is recommended in cases of inferior STEMI or if total vessel occlusion is suspected and standard leads are inconclusive.",
  "normalized_statement": "In presenza di STEMI inferiore o di sospetta occlusione coronarica totale con derivazioni ECG standard non conclusive, si raccomanda l'esecuzione di un ECG con derivazioni aggiuntive V3R, V4R e V7–V9.",
  "intent": "Migliorare la sensibilità diagnostica dell'ECG per identificare l'estensione dell'infarto al ventricolo destro e alla parete posteriore, nonché per confermare un'occlusione coronarica totale quando le derivazioni standard sono non conclusive.",
  "rationale": "Le derivazioni standard a 12 canali possono non evidenziare il sopraslivellamento del tratto ST nel coinvolgimento del ventricolo destro o della parete posteriore. Le derivazioni destre (V3R, V4R) rilevano l'infarto del ventricolo destro, mentre le derivazioni posteriori (V7–V9) rilevano l'infarto posteriore. La mancata identificazione di tali territori può comportare una sottovalutazione dell'estensione dell'infarto e un trattamento inadeguato.",
  "source_references": [
    {
      "source_id": "ESC-STEMI-GL-2023",
      "source_level": "international",
      "issuer": "European Society of Cardiology (ESC)",
      "document_title": "2023 ESC Guidelines for the management of acute coronary syndromes",
      "document_version": "2023",
      "publication_date": "2023-08-25",
      "section_reference": "Sezione Diagnosi – Raccomandazioni ECG",
      "page_reference": null,
      "statement_quote": "The use of additional ECG leads (V3R, V4R, and V7–V9) is recommended in cases of inferior STEMI or if total vessel occlusion is suspected and standard leads are inconclusive.",
      "citation_uri": "https://doi.org/10.1093/eurheartj/ehad191",
      "license_note": "Contenuto soggetto a copyright ESC. Utilizzato a scopo di sintesi clinica non commerciale."
    }
  ],
  "applicability": {
    "population_description": "Pazienti adulti con sospetto clinico o diagnosi elettrocardiografica di STEMI inferiore oppure con sospetta occlusione coronarica totale e derivazioni ECG standard non conclusive.",
    "clinical_context": "Infarto miocardico acuto con sopraslivellamento del tratto ST in sede inferiore (derivazioni II, III, aVF) oppure quadro clinico suggestivo di occlusione coronarica acuta con ECG standard non diagnostico.",
    "care_context": "Fase diagnostica in pronto soccorso, in ambiente pre-ospedaliero o in UTIC.",
    "inclusion_criteria": [
      {
        "criterion_id": "INCL-005-01",
        "label": "STEMI inferiore all'ECG standard",
        "description": "Sopraslivellamento del tratto ST ≥ 1 mm in almeno due derivazioni contigue tra II, III e aVF all'ECG a 12 derivazioni.",
        "logic_expression": "ST_elevation(II) >= 1mm AND (ST_elevation(III) >= 1mm OR ST_elevation(aVF) >= 1mm)",
        "data_elements": [
          "DE-005-01",
          "DE-005-02"
        ],
        "inference_allowed": true
      },
      {
        "criterion_id": "INCL-005-02",
        "label": "Sospetta occlusione coronarica totale con ECG standard non conclusivo",
        "description": "Quadro clinico altamente suggestivo di sindrome coronarica acuta con occlusione totale (dolore toracico tipico, instabilità emodinamica) ma ECG a 12 derivazioni non diagnostico per sopraslivellamento ST.",
        "logic_expression": "clinical_suspicion_total_occlusion == true AND standard_ECG_inconclusive == true",
        "data_elements": [
          "DE-005-03",
          "DE-005-04"
        ],
        "inference_allowed": true
      }
    ],
    "exclusion_criteria": [
      {
        "criterion_id": "EXCL-005-01",
        "label": "Impossibilità tecnica di posizionamento elettrodi aggiuntivi",
        "description": "Condizioni cliniche o anatomiche che impediscono fisicamente il posizionamento degli elettrodi nelle sedi V3R, V4R, V7–V9 (ad es. estese lesioni cutanee toraciche, ustioni).",
        "logic_expression": "electrode_placement_impossible == true",
        "data_elements": [
          "DE-005-05"
        ],
        "inference_allowed": true
      }
    ]
  },
  "trigger": {
    "trigger_type": "diagnostic_finding",
    "trigger_description": "Riscontro di sopraslivellamento del tratto ST in sede inferiore all'ECG standard a 12 derivazioni oppure elevato sospetto clinico di occlusione coronarica totale con ECG standard non conclusivo.",
    "anchor_event": "Registrazione ECG a 12 derivazioni standard",
    "start_of_applicability": "Immediatamente dopo l'identificazione di STEMI inferiore o del sospetto di occlusione coronarica totale con ECG non conclusivo.",
    "end_of_applicability": "Fino al completamento della registrazione ECG con derivazioni aggiuntive o fino alla decisione definitiva sulla strategia di riperfusione.",
    "trigger_data_elements": [
      "DE-005-01",
      "DE-005-02",
      "DE-005-03",
      "DE-005-04"
    ],
    "inference_allowed": true
  },
  "exceptions": [
    {
      "exception_id": "EXC-005-01",
      "label": "Impossibilità tecnica di posizionamento degli elettrodi aggiuntivi",
      "description": "Lesioni cutanee estese, ustioni o altre condizioni anatomiche che rendono impossibile il posizionamento degli elettrodi nelle posizioni V3R, V4R, V7–V9.",
      "condition_logic": "electrode_placement_impossible == true",
      "required_justification": true,
      "required_evidence": [
        "Documentazione clinica della condizione che impedisce il posizionamento",
        "Nota infermieristica o medica nel verbale di pronto soccorso"
      ]
    },
    {
      "exception_id": "EXC-005-02",
      "label": "Priorità di intervento immediato per instabilità emodinamica critica",
      "description": "Il paziente presenta arresto cardiaco, shock cardiogeno grave o altra emergenza che richiede interventi salvavita immediati, rendendo la registrazione delle derivazioni aggiuntive non prioritaria in quel momento.",
      "condition_logic": "hemodynamic_instability_critical == true AND life_saving_intervention_priority == true",
      "required_justification": true,
      "required_evidence": [
        "Documentazione dell'instabilità emodinamica critica",
        "Registrazione delle manovre di rianimazione o stabilizzazione eseguite"
      ]
    }
  ],
  "expected_action": {
    "action_verb": "eseguire",
    "action_description": "Eseguire la registrazione di un ECG con derivazioni aggiuntive destre (V3R, V4R) e posteriori (V7, V8, V9) per valutare il coinvolgimento del ventricolo destro e della parete posteriore.",
    "action_target": "ECG a derivazioni aggiuntive (V3R, V4R, V7–V9)",
    "action_parameters": [
      {
        "parameter_name": "Derivazioni destre",
        "parameter_description": "Derivazioni precordiali destre da registrare per identificare l'infarto del ventricolo destro.",
        "expected_value": "V3R, V4R",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "Derivazioni posteriori",
        "parameter_description": "Derivazioni posteriori da registrare per identificare l'infarto della parete posteriore.",
        "expected_value": "V7, V8, V9",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "Soglia sopraslivellamento ST derivazioni posteriori",
        "parameter_description": "Soglia di sopraslivellamento del tratto ST nelle derivazioni posteriori considerata significativa.",
        "expected_value": "0.5",
        "comparison_operator": "greater_than",
        "unit": "mm",
        "mandatory": false
      }
    ],
    "alternative_compliant_actions": [
      "Esecuzione di ECG a 15 derivazioni (12 standard + V3R, V4R, V7–V9) in unica registrazione",
      "Esecuzione di ECG a 18 derivazioni se disponibile apparecchiatura idonea"
    ]
  },
  "completion_criteria": {
    "description": "La regola si considera soddisfatta quando è stata registrata e documentata in cartella clinica almeno una traccia ECG che includa le derivazioni aggiuntive V3R, V4R e V7–V9, con relativa interpretazione medica.",
    "minimum_occurrences": 1,
    "required_event_types": [
      "Registrazione ECG con derivazioni aggiuntive",
      "Interpretazione medica del tracciato ECG aggiuntivo"
    ],
    "required_documentation_elements": [
      "Tracciato ECG con derivazioni aggiuntive allegato in cartella",
      "Referto interpretativo delle derivazioni aggiuntive"
    ],
    "success_condition": "ECG_additional_leads_recorded == true AND ECG_additional_leads_interpreted == true AND leads_set CONTAINS {'V3R','V4R','V7','V8','V9'}"
  },
  "time_constraints": [
    {
      "constraint_id": "TC-005-01",
      "description": "L'ECG con derivazioni aggiuntive deve essere eseguito il prima possibile e comunque entro 10 minuti dalla registrazione dell'ECG standard che ha evidenziato lo STEMI inferiore o il sospetto di occlusione coronarica totale.",
      "relation_to_anchor": "within",
      "anchor_event": "Registrazione ECG standard a 12 derivazioni con riscontro diagnostico",
      "duration_value": 10,
      "duration_unit": "minuti",
      "hard_deadline": false,
      "alert_threshold_value": 5,
      "alert_threshold_unit": "minuti"
    }
  ],
  "sequence_constraints": [
    {
      "constraint_id": "SC-005-01",
      "description": "L'ECG a 12 derivazioni standard deve essere stato eseguito e interpretato prima della registrazione delle derivazioni aggiuntive, in quanto il riscontro di STEMI inferiore o la non conclusività dell'ECG standard è il presupposto per l'indicazione alle derivazioni aggiuntive.",
      "predecessor_event": "Registrazione e interpretazione ECG standard a 12 derivazioni",
      "successor_event": "Registrazione ECG con derivazioni aggiuntive V3R, V4R, V7–V9",
      "allowed_order": "predecessor_first",
      "violation_condition": "Le derivazioni aggiuntive vengono registrate senza che sia stato prima completato e interpretato l'ECG standard a 12 derivazioni."
    },
    {
      "constraint_id": "SC-005-02",
      "description": "L'ECG con derivazioni aggiuntive deve essere completato prima dell'attivazione del laboratorio di emodinamica, così da fornire informazioni diagnostiche complete per la pianificazione dell'intervento.",
      "predecessor_event": "Registrazione ECG con derivazioni aggiuntive V3R, V4R, V7–V9",
      "successor_event": "Attivazione laboratorio di emodinamica",
      "allowed_order": "predecessor_first",
      "violation_condition": "Il laboratorio di emodinamica viene attivato senza aver prima registrato le derivazioni aggiuntive nei casi indicati, salvo giustificazione clinica documentata."
    }
  ],
  "required_data_elements": [
    {
      "data_element_id": "DE-005-01",
      "name": "Tracciato ECG a 12 derivazioni standard",
      "description": "Registrazione elettrocardiografica completa a 12 derivazioni standard con timestamp e valori di sopraslivellamento ST.",
      "source_location": "ehr_structured",
      "data_type": "documento/tracciato",
      "coding_system": "LOINC 11524-6",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare l'ultimo ECG registrato con timestamp nel contesto dell'episodio acuto."
    },
    {
      "data_element_id": "DE-005-02",
      "name": "Sopraslivellamento ST in derivazioni inferiori",
      "description": "Presenza e misura del sopraslivellamento del tratto ST nelle derivazioni II, III e aVF.",
      "source_location": "ehr_structured",
      "data_type": "numeric (mm)",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Estrarre i valori di ST elevation dalle derivazioni II, III, aVF dal referto ECG automatico o dal referto medico."
    },
    {
      "data_element_id": "DE-005-03",
      "name": "Sospetto clinico di occlusione coronarica totale",
      "description": "Indicazione documentata del sospetto clinico di occlusione coronarica totale basata su sintomi, segni clinici ed eventuale imaging.",
      "source_location": "ehr_unstructured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "inferential",
      "query_hint": "Cercare nelle note cliniche espressioni come 'sospetta occlusione totale', 'STEMI equivalente', 'occlusione acuta coronarica'."
    },
    {
      "data_element_id": "DE-005-04",
      "name": "ECG standard non conclusivo",
      "description": "Indicazione che l'ECG a 12 derivazioni standard non è conclusivo per la diagnosi di STEMI o occlusione coronarica.",
      "source_location": "ehr_unstructured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "inferential",
      "query_hint": "Cercare nel referto ECG o nelle note cliniche espressioni come 'non conclusivo', 'non diagnostico', 'dubbio', 'da completare con derivazioni aggiuntive'."
    },
    {
      "data_element_id": "DE-005-05",
      "name": "Impossibilità posizionamento elettrodi aggiuntivi",
      "description": "Documentazione di condizioni cliniche o anatomiche che impediscono il posizionamento degli elettrodi nelle posizioni aggiuntive.",
      "source_location": "ehr_unstructured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": false,
      "extraction_method": "inferential",
      "query_hint": "Cercare nelle note cliniche o infermieristiche espressioni relative a impossibilità di posizionamento elettrodi."
    },
    {
      "data_element_id": "DE-005-06",
      "name": "Tracciato ECG con derivazioni aggiuntive",
      "description": "Registrazione ECG che include le derivazioni V3R, V4R, V7, V8, V9 con relativo timestamp.",
      "source_location": "ehr_structured",
      "data_type": "documento/tracciato",
      "coding_system": "LOINC 11524-6",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare tracciato ECG con indicazione di derivazioni aggiuntive (15 o 18 derivazioni) registrato dopo l'ECG standard nel contesto dell'episodio acuto."
    },
    {
      "data_element_id": "DE-005-07",
      "name": "Timestamp registrazione ECG aggiuntivo",
      "description": "Data e ora di esecuzione dell'ECG con derivazioni aggiuntive.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Estrarre il timestamp dal tracciato ECG aggiuntivo o dal sistema di refertazione."
    }
  ],
  "evidence_of_compliance": [
    {
      "evidence_id": "EC-005-01",
      "description": "Presenza in cartella clinica di un tracciato ECG con derivazioni aggiuntive V3R, V4R, V7–V9 registrato dopo l'identificazione dello STEMI inferiore o del sospetto di occlusione coronarica totale.",
      "evidence_type": "execution",
      "minimum_occurrences": 1,
      "time_reference": "Entro 10 minuti dall'ECG standard diagnostico",
      "derived_from_data_elements": [
        "DE-005-06",
        "DE-005-07"
      ]
    },
    {
      "evidence_id": "EC-005-02",
      "description": "Referto medico che documenta l'interpretazione delle derivazioni aggiuntive con indicazione della presenza o assenza di sopraslivellamento ST nelle derivazioni destre e posteriori.",
      "evidence_type": "documentation",
      "minimum_occurrences": 1,
      "time_reference": "Contestualmente o subito dopo la registrazione dell'ECG aggiuntivo",
      "derived_from_data_elements": [
        "DE-005-06"
      ]
    }
  ],
  "evidence_of_non_compliance": [
    {
      "evidence_id": "ENC-005-01",
      "description": "Assenza di tracciato ECG con derivazioni aggiuntive in cartella clinica nonostante la presenza di STEMI inferiore o sospetta occlusione coronarica totale con ECG standard non conclusivo, senza documentazione di eccezione o giustificazione clinica.",
      "evidence_type": "absence_of_event",
      "minimum_occurrences": 1,
      "time_reference": "Nell'intero episodio di cura acuto",
      "derived_from_data_elements": [
        "DE-005-01",
        "DE-005-02",
        "DE-005-03",
        "DE-005-04",
        "DE-005-06"
      ]
    },
    {
      "evidence_id": "ENC-005-02",
      "description": "Ritardo significativo (oltre 10 minuti) nell'esecuzione dell'ECG con derivazioni aggiuntive rispetto all'ECG standard diagnostico.",
      "evidence_type": "timestamp",
      "minimum_occurrences": 1,
      "time_reference": "Differenza tra timestamp ECG aggiuntivo e timestamp ECG standard > 10 minuti",
      "derived_from_data_elements": [
        "DE-005-07",
        "DE-005-01"
      ]
    }
  ],
  "evaluation_logic": {
    "natural_language_test": "Verificare se, in presenza di STEMI inferiore (sopraslivellamento ST ≥ 1 mm in almeno due derivazioni tra II, III, aVF) oppure di sospetta occlusione coronarica totale con ECG standard non conclusivo, sia stato registrato e interpretato un ECG con derivazioni aggiuntive V3R, V4R, V7–V9 entro 10 minuti dall'ECG standard. Nel caso di eccezione documentata e giustificata, la deviazione è considerata giustificata.",
    "formal_expression_language": "pseudocode",
    "formal_expression": "IF (ST_elevation_inferior == true OR (clinical_suspicion_total_occlusion == true AND standard_ECG_inconclusive == true)) THEN IF (ECG_additional_leads_recorded == true AND leads_include(V3R, V4R, V7, V8, V9) AND time_diff(ECG_additional_timestamp, ECG_standard_timestamp) <= 10 min) THEN 'compliant' ELSE IF (exception_documented == true AND justification_present == true) THEN 'justified_deviation' ELSE 'non_compliant' ELSE 'not_applicable'",
    "missing_data_policy": "review_required",
    "ambiguity_policy": "review_required",
    "conflict_resolution_policy": "human_review",
    "notes": "La valutazione può richiedere l'analisi del testo libero del referto ECG per determinare se le derivazioni aggiuntive sono state effettivamente registrate, in particolare quando il sistema non struttura automaticamente il tipo di derivazioni."
  },
  "evaluation_method": {
    "primary_method": "hybrid",
    "allowed_inference_sources": [
      "Referti ECG in testo libero",
      "Note cliniche del medico d'emergenza",
      "Note infermieristiche",
      "Tracciati ECG allegati in formato digitale"
    ],
    "human_review_required": true,
    "minimum_confidence": 0.85,
    "notes": "In molti sistemi informativi ospedalieri il tipo di derivazioni ECG non è codificato strutturalmente; potrebbe essere necessario analizzare il tracciato PDF o il referto testuale per verificare la presenza delle derivazioni aggiuntive."
  },
  "possible_outcomes": [
    "compliant",
    "non_compliant",
    "justified_deviation",
    "not_applicable",
    "not_evaluable"
  ],
  "risk_classification": {
    "clinical_risk_severity": "high",
    "process_risk_severity": "moderate",
    "likelihood_if_violated": "possible",
    "detectability": "moderate",
    "priority_score": 7.5,
    "rationale": "La mancata esecuzione delle derivazioni aggiuntive può comportare il mancato riconoscimento dell'estensione dell'infarto al ventricolo destro o alla parete posteriore, con conseguente sottostima della gravità clinica e potenziale inadeguatezza del trattamento (ad es. mancata somministrazione di fluidi nello shock del ventricolo destro, ritardo nella strategia di riperfusione)."
  },
  "documentation_requirements": {
    "mandatory_fields": [
      "Tracciato ECG con derivazioni aggiuntive V3R, V4R, V7–V9",
      "Data e ora di esecuzione dell'ECG aggiuntivo",
      "Referto interpretativo delle derivazioni aggiuntive",
      "Indicazione clinica per l'esecuzione delle derivazioni aggiuntive"
    ],
    "acceptable_evidence_sources": [
      "Tracciato ECG digitale in cartella clinica elettronica",
      "Referto ECG firmato dal medico",
      "Nota clinica del medico d'emergenza",
      "Stampa cartacea del tracciato ECG allegata alla documentazione"
    ],
    "justification_required_when_deviating": true,
    "justification_fields": [
      "Nota clinica che documenta il motivo della mancata esecuzione delle derivazioni aggiuntive",
      "Descrizione della condizione di emergenza che ha impedito l'esecuzione"
    ],
    "free_text_allowed": true
  },
  "associated_weak_signal_ids": [
    "STEMI-WS-005-01",
    "STEMI-WS-005-02"
  ],
  "extraction_metadata": {
    "generation_mode": "llm_inference",
    "source_interpretation_notes": "Il testo originale in lingua inglese utilizza il termine 'recommended', interpretato come raccomandazione forte (Classe I). Le condizioni di applicabilità sono state suddivise in due criteri di inclusione distinti: STEMI inferiore e sospetta occlusione coronarica totale con ECG non conclusivo. Il vincolo temporale di 10 minuti è stato aggiunto come buona pratica clinica in analogia con le raccomandazioni ESC sull'ECG iniziale, poiché non è esplicitato nel testo originale.",
    "extraction_confidence": 0.88,
    "ambiguity_flags": [
      "Il testo originale non specifica un limite temporale esplicito per l'esecuzione delle derivazioni aggiuntive; il vincolo di 10 minuti è stato derivato per analogia clinica.",
      "Il termine 'inconclusive' per le derivazioni standard richiede interpretazione clinica contestuale e potrebbe avere soglie variabili in diversi contesti."
    ],
    "human_validation_status": "not_reviewed",
    "validated_by": null,
    "validated_at": null
  },
  "governance_metadata": {
    "lifecycle_status": "draft",
    "version": "1.0.0",
    "authoring_body": "Comitato PDTA Cardiovascolare",
    "rule_owner": "Direttore UOC Cardiologia d'Urgenza",
    "effective_from": null,
    "effective_to": null,
    "review_cycle": "12 mesi",
    "last_reviewed_at": null,
    "approved_by": null
  }
}
$json_STEMI_DO_005$::jsonb)
ON CONFLICT (clinical_pathway_id, name) DO UPDATE
SET body = EXCLUDED.body;

INSERT INTO riskm_manager_model_evaluation.rule_definition (clinical_pathway_id, name, body)
VALUES (1, 'STEMI-DO-006', $json_STEMI_DO_006$
{
  "schema_version": "1.0.0",
  "rule_id": "STEMI-DO-006",
  "rule_type": "do",
  "title": "Esecuzione di un ECG a 12 derivazioni aggiuntivo in caso di sintomi ricorrenti o incertezza diagnostica",
  "short_label": "ECG aggiuntivo per sintomi ricorrenti/incertezza",
  "clinical_pathway_id": "PDTA-STEMI-001",
  "clinical_pathway_name": "Percorso Diagnostico Terapeutico Assistenziale per STEMI",
  "clinical_phase": "diagnosi",
  "care_settings": [
    "pronto soccorso",
    "unità di terapia intensiva coronarica",
    "pre-ospedaliero",
    "reparto di cardiologia"
  ],
  "responsible_actors": [
    {
      "role_name": "Medico d'emergenza",
      "responsibility_type": "primary",
      "organization_unit": "Pronto Soccorso",
      "notes": "Responsabile della decisione clinica di eseguire un ECG aggiuntivo e dell'interpretazione del tracciato."
    },
    {
      "role_name": "Infermiere di pronto soccorso",
      "responsibility_type": "supporting",
      "organization_unit": "Pronto Soccorso",
      "notes": "Responsabile dell'esecuzione tecnica dell'ECG a 12 derivazioni su indicazione medica."
    },
    {
      "role_name": "Cardiologo di guardia",
      "responsibility_type": "consulted",
      "organization_unit": "Cardiologia / UTIC",
      "notes": "Consultato in caso di persistenza dell'incertezza diagnostica dopo l'ECG aggiuntivo."
    }
  ],
  "deontic_strength": "recommended",
  "recommendation_strength": "Classe I",
  "evidence_level": "Livello di evidenza C",
  "original_statement": "An additional 12-lead ECG is recommended in cases with recurrent symptoms or diagnostic uncertainty.",
  "normalized_statement": "In presenza di sintomi ricorrenti o incertezza diagnostica, è raccomandata l'esecuzione di un ECG a 12 derivazioni aggiuntivo.",
  "intent": "Garantire una rivalutazione elettrocardiografica tempestiva nei pazienti con sospetto STEMI che presentano sintomi ricorrenti o in cui persiste incertezza diagnostica, al fine di identificare variazioni ischemiche evolutive e supportare decisioni terapeutiche appropriate.",
  "rationale": "Un ECG a 12 derivazioni aggiuntivo consente di identificare alterazioni del segmento ST di nuova insorgenza o in evoluzione, migliorando l'accuratezza diagnostica nei casi di incertezza e nei pazienti con sintomi ricorrenti suggestivi di ischemia in corso. L'omissione di tale controllo potrebbe ritardare il riconoscimento di uno STEMI e la conseguente rivascolarizzazione.",
  "source_references": [
    {
      "source_id": "ESC-STEMI-2023",
      "source_level": "international",
      "issuer": "European Society of Cardiology (ESC)",
      "document_title": "2023 ESC Guidelines for the management of acute coronary syndromes",
      "document_version": "2023",
      "publication_date": "2023-08-25",
      "section_reference": "Sezione Diagnosi – Elettrocardiogramma",
      "page_reference": null,
      "statement_quote": "An additional 12-lead ECG is recommended in cases with recurrent symptoms or diagnostic uncertainty.",
      "citation_uri": "https://doi.org/10.1093/eurheartj/ehad191",
      "license_note": "Contenuto soggetto a copyright ESC. Uso a fini clinici e di ricerca secondo i termini dell'editore."
    }
  ],
  "applicability": {
    "population_description": "Pazienti adulti con sospetto clinico di infarto miocardico con sopraslivellamento del tratto ST (STEMI) che presentano sintomi ricorrenti o in cui persiste incertezza diagnostica dopo l'ECG iniziale.",
    "clinical_context": "Sospetto STEMI con sintomatologia ricorrente (es. dolore toracico recidivante) o tracciato ECG iniziale non conclusivo per la diagnosi.",
    "care_context": "Fase diagnostica del percorso STEMI, applicabile in ambito pre-ospedaliero, pronto soccorso e unità di terapia intensiva coronarica.",
    "inclusion_criteria": [
      {
        "criterion_id": "STEMI-DO-006-INC-01",
        "label": "Sintomi ricorrenti suggestivi di ischemia",
        "description": "Il paziente presenta recidiva di dolore toracico o sintomi equivalenti ischemici dopo l'esecuzione del primo ECG a 12 derivazioni.",
        "logic_expression": "recurrent_ischemic_symptoms == true",
        "data_elements": [
          "DE-STEMI-006-01",
          "DE-STEMI-006-02"
        ],
        "inference_allowed": true
      },
      {
        "criterion_id": "STEMI-DO-006-INC-02",
        "label": "Incertezza diagnostica persistente",
        "description": "Il tracciato ECG iniziale non è conclusivo per la diagnosi di STEMI (es. blocco di branca sinistra preesistente, ritmo da pacemaker, alterazioni aspecifiche del tratto ST) oppure il quadro clinico è discordante rispetto ai reperti elettrocardiografici.",
        "logic_expression": "diagnostic_uncertainty == true",
        "data_elements": [
          "DE-STEMI-006-03",
          "DE-STEMI-006-04"
        ],
        "inference_allowed": true
      }
    ],
    "exclusion_criteria": [
      {
        "criterion_id": "STEMI-DO-006-EXC-01",
        "label": "Diagnosi STEMI già confermata e trattamento avviato",
        "description": "Il paziente ha già una diagnosi STEMI confermata e la strategia di riperfusione è già stata attivata. In questo caso l'ECG aggiuntivo non modifica la gestione immediata.",
        "logic_expression": "stemi_confirmed == true AND reperfusion_activated == true",
        "data_elements": [
          "DE-STEMI-006-05",
          "DE-STEMI-006-06"
        ],
        "inference_allowed": false
      }
    ]
  },
  "trigger": {
    "trigger_type": "documented_symptom",
    "trigger_description": "Il trigger si attiva quando il paziente con sospetto STEMI presenta una recidiva di sintomi ischemici (es. dolore toracico, dispnea, sudorazione) dopo l'ECG iniziale, oppure quando il clinico documenta un'incertezza diagnostica relativa all'interpretazione dell'ECG iniziale.",
    "anchor_event": "Esecuzione del primo ECG a 12 derivazioni",
    "start_of_applicability": "Dal momento della comparsa di sintomi ricorrenti o della documentazione di incertezza diagnostica dopo il primo ECG.",
    "end_of_applicability": "Fino alla conferma o all'esclusione della diagnosi di STEMI, oppure fino all'attivazione della strategia di riperfusione.",
    "trigger_data_elements": [
      "DE-STEMI-006-01",
      "DE-STEMI-006-02",
      "DE-STEMI-006-03"
    ],
    "inference_allowed": true
  },
  "exceptions": [
    {
      "exception_id": "STEMI-DO-006-EXP-01",
      "label": "Paziente in arresto cardiaco non recuperato",
      "description": "Il paziente è in arresto cardiaco refrattario e l'esecuzione di un ECG aggiuntivo non è tecnicamente praticabile o clinicamente prioritaria rispetto alle manovre rianimatorie in corso.",
      "condition_logic": "cardiac_arrest_ongoing == true AND ROSC == false",
      "required_justification": true,
      "required_evidence": [
        "Documentazione dello stato di arresto cardiaco",
        "Registrazione delle manovre rianimatorie in corso"
      ]
    },
    {
      "exception_id": "STEMI-DO-006-EXP-02",
      "label": "Trasferimento emergente in atto verso sala di emodinamica",
      "description": "Il paziente è già in trasferimento emergente verso il laboratorio di emodinamica e la sosta per un ECG aggiuntivo comporterebbe un ritardo clinicamente inaccettabile nella riperfusione.",
      "condition_logic": "emergent_transfer_to_cath_lab == true AND delay_unacceptable == true",
      "required_justification": true,
      "required_evidence": [
        "Documentazione del trasferimento emergente in corso",
        "Motivazione clinica del mancato ECG aggiuntivo"
      ]
    }
  ],
  "expected_action": {
    "action_verb": "eseguire",
    "action_description": "Eseguire un ECG a 12 derivazioni aggiuntivo con acquisizione completa di tutte le derivazioni standard, provvedendo a un'interpretazione rapida del tracciato con ricerca di alterazioni del tratto ST, nuove onde Q, o altri segni indicativi di ischemia acuta.",
    "action_target": "ECG a 12 derivazioni",
    "action_parameters": [
      {
        "parameter_name": "Numero di derivazioni",
        "parameter_description": "L'ECG deve includere almeno tutte le 12 derivazioni standard.",
        "expected_value": "12",
        "comparison_operator": "equals",
        "unit": "derivazioni",
        "mandatory": true
      },
      {
        "parameter_name": "Interpretazione clinica documentata",
        "parameter_description": "Il tracciato deve essere interpretato da un medico e l'esito documentato nel fascicolo clinico.",
        "expected_value": "presente",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "Derivazioni aggiuntive opzionali",
        "parameter_description": "In caso di sospetto infarto posteriore o del ventricolo destro, possono essere aggiunte derivazioni V7-V9 e V3R-V4R.",
        "expected_value": null,
        "comparison_operator": null,
        "unit": null,
        "mandatory": false
      }
    ],
    "alternative_compliant_actions": [
      "Monitoraggio ECG continuo con registrazione periodica del tracciato a 12 derivazioni se l'ECG aggiuntivo non è immediatamente disponibile"
    ]
  },
  "completion_criteria": {
    "description": "L'azione è considerata completata quando un ECG a 12 derivazioni aggiuntivo è stato acquisito, interpretato da un medico e il risultato è stato documentato nel fascicolo clinico del paziente.",
    "minimum_occurrences": 1,
    "required_event_types": [
      "acquisizione_ecg_12_derivazioni",
      "interpretazione_ecg",
      "documentazione_referto_ecg"
    ],
    "required_documentation_elements": [
      "Tracciato ECG a 12 derivazioni acquisito",
      "Referto di interpretazione con indicazione della presenza o assenza di alterazioni ischemiche",
      "Timestamp di acquisizione dell'ECG aggiuntivo"
    ],
    "success_condition": "ECG a 12 derivazioni aggiuntivo acquisito AND interpretazione documentata nel fascicolo clinico AND timestamp registrato"
  },
  "time_constraints": [
    {
      "constraint_id": "STEMI-DO-006-TC-01",
      "description": "L'ECG aggiuntivo a 12 derivazioni deve essere eseguito entro 10 minuti dalla comparsa dei sintomi ricorrenti o dal riconoscimento dell'incertezza diagnostica.",
      "relation_to_anchor": "within",
      "anchor_event": "Comparsa di sintomi ricorrenti o riconoscimento di incertezza diagnostica",
      "duration_value": 10,
      "duration_unit": "minuti",
      "hard_deadline": false,
      "alert_threshold_value": 5,
      "alert_threshold_unit": "minuti"
    }
  ],
  "sequence_constraints": [
    {
      "constraint_id": "STEMI-DO-006-SC-01",
      "description": "L'ECG aggiuntivo deve essere eseguito dopo la comparsa dei sintomi ricorrenti o della documentazione di incertezza diagnostica, e prima della decisione definitiva sulla strategia di riperfusione.",
      "predecessor_event": "Comparsa di sintomi ricorrenti o incertezza diagnostica documentata",
      "successor_event": "Esecuzione ECG a 12 derivazioni aggiuntivo",
      "allowed_order": "predecessor_first",
      "violation_condition": "L'ECG aggiuntivo non è stato eseguito nonostante la documentazione di sintomi ricorrenti o incertezza diagnostica."
    }
  ],
  "required_data_elements": [
    {
      "data_element_id": "DE-STEMI-006-01",
      "name": "Presenza di sintomi ricorrenti",
      "description": "Indicazione della recidiva di sintomi ischemici (dolore toracico, dispnea, sudorazione) dopo l'ECG iniziale.",
      "source_location": "ehr_structured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Cercare documentazione di recidiva di dolore toracico o sintomi equivalenti ischemici nelle note cliniche o nel sistema di monitoraggio."
    },
    {
      "data_element_id": "DE-STEMI-006-02",
      "name": "Timestamp comparsa sintomi ricorrenti",
      "description": "Data e ora della comparsa dei sintomi ischemici ricorrenti.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Verificare la registrazione temporale degli eventi clinici nel sistema di gestione del pronto soccorso."
    },
    {
      "data_element_id": "DE-STEMI-006-03",
      "name": "Incertezza diagnostica documentata",
      "description": "Documentazione da parte del clinico di un'incertezza nell'interpretazione dell'ECG iniziale o nel quadro clinico complessivo.",
      "source_location": "ehr_unstructured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "inferential",
      "query_hint": "Analizzare le note cliniche per espressioni di dubbio diagnostico, ECG non conclusivo, alterazioni aspecifiche del tratto ST."
    },
    {
      "data_element_id": "DE-STEMI-006-04",
      "name": "Referto ECG iniziale",
      "description": "Referto dell'ECG a 12 derivazioni iniziale con interpretazione clinica.",
      "source_location": "ehr_structured",
      "data_type": "text",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Recuperare il referto del primo ECG eseguito nel percorso STEMI dal sistema di cardiologia o dal fascicolo di PS."
    },
    {
      "data_element_id": "DE-STEMI-006-05",
      "name": "Diagnosi STEMI confermata",
      "description": "Indicazione se la diagnosi di STEMI è stata confermata definitivamente.",
      "source_location": "ehr_structured",
      "data_type": "boolean",
      "coding_system": "ICD-10",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Verificare la presenza di codice ICD-10 I21.x confermato o diagnosi clinica di STEMI."
    },
    {
      "data_element_id": "DE-STEMI-006-06",
      "name": "Attivazione strategia di riperfusione",
      "description": "Indicazione se la strategia di riperfusione (PCI primaria o fibrinolisi) è già stata attivata.",
      "source_location": "ehr_structured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Verificare l'attivazione del percorso emodinamica o la somministrazione di fibrinolitico nel sistema ordini."
    },
    {
      "data_element_id": "DE-STEMI-006-07",
      "name": "Timestamp ECG aggiuntivo",
      "description": "Data e ora di acquisizione dell'ECG a 12 derivazioni aggiuntivo.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Recuperare il timestamp del secondo o successivo ECG a 12 derivazioni dal sistema ECG o dal fascicolo clinico."
    },
    {
      "data_element_id": "DE-STEMI-006-08",
      "name": "Referto ECG aggiuntivo",
      "description": "Referto dell'ECG a 12 derivazioni aggiuntivo con interpretazione clinica documentata.",
      "source_location": "ehr_structured",
      "data_type": "text",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Recuperare il referto dell'ECG aggiuntivo dal sistema di cardiologia o dal fascicolo di PS."
    }
  ],
  "evidence_of_compliance": [
    {
      "evidence_id": "STEMI-DO-006-EOC-01",
      "description": "Presenza di un tracciato ECG a 12 derivazioni aggiuntivo acquisito e documentato nel fascicolo clinico del paziente dopo la comparsa di sintomi ricorrenti o incertezza diagnostica.",
      "evidence_type": "execution",
      "minimum_occurrences": 1,
      "time_reference": "Dopo la comparsa dei sintomi ricorrenti o la documentazione di incertezza diagnostica",
      "derived_from_data_elements": [
        "DE-STEMI-006-07",
        "DE-STEMI-006-08"
      ]
    },
    {
      "evidence_id": "STEMI-DO-006-EOC-02",
      "description": "Documentazione dell'interpretazione clinica del tracciato ECG aggiuntivo con valutazione delle alterazioni ischemiche.",
      "evidence_type": "documentation",
      "minimum_occurrences": 1,
      "time_reference": "Contestualmente o immediatamente dopo l'acquisizione dell'ECG aggiuntivo",
      "derived_from_data_elements": [
        "DE-STEMI-006-08"
      ]
    }
  ],
  "evidence_of_non_compliance": [
    {
      "evidence_id": "STEMI-DO-006-EONC-01",
      "description": "Assenza di un ECG a 12 derivazioni aggiuntivo nel fascicolo clinico nonostante la documentazione di sintomi ricorrenti o di incertezza diagnostica.",
      "evidence_type": "absence_of_event",
      "minimum_occurrences": 1,
      "time_reference": "Dall'insorgenza dei sintomi ricorrenti o dell'incertezza diagnostica fino alla chiusura dell'episodio diagnostico",
      "derived_from_data_elements": [
        "DE-STEMI-006-01",
        "DE-STEMI-006-03",
        "DE-STEMI-006-07"
      ]
    },
    {
      "evidence_id": "STEMI-DO-006-EONC-02",
      "description": "ECG aggiuntivo eseguito ma privo di referto o interpretazione clinica documentata.",
      "evidence_type": "documentation",
      "minimum_occurrences": 1,
      "time_reference": "Dopo l'acquisizione dell'ECG aggiuntivo",
      "derived_from_data_elements": [
        "DE-STEMI-006-07",
        "DE-STEMI-006-08"
      ]
    }
  ],
  "evaluation_logic": {
    "natural_language_test": "Verificare se, in presenza di sintomi ricorrenti documentati OPPURE incertezza diagnostica documentata dopo il primo ECG, è stato eseguito almeno un ECG a 12 derivazioni aggiuntivo con relativa interpretazione clinica registrata nel fascicolo del paziente. La regola è soddisfatta se il tracciato ECG aggiuntivo e il referto sono presenti; è non conforme se mancano nonostante la presenza dei trigger.",
    "formal_expression_language": "pseudocode",
    "formal_expression": "IF (recurrent_symptoms == TRUE OR diagnostic_uncertainty == TRUE) AND NOT (stemi_confirmed == TRUE AND reperfusion_activated == TRUE) THEN IF additional_ecg_performed == TRUE AND ecg_interpretation_documented == TRUE THEN status = 'compliant' ELSE IF exception_documented == TRUE THEN status = 'justified_deviation' ELSE status = 'non_compliant' ELSE status = 'not_applicable'",
    "missing_data_policy": "review_required",
    "ambiguity_policy": "review_required",
    "conflict_resolution_policy": "human_review",
    "notes": "L'incertezza diagnostica è spesso documentata in formato narrativo e richiede estrazione inferenziale dalle note cliniche. In caso di dubbio sulla presenza del trigger, è necessaria la revisione umana."
  },
  "evaluation_method": {
    "primary_method": "hybrid",
    "allowed_inference_sources": [
      "note cliniche di pronto soccorso",
      "referti ECG",
      "lettere di dimissione",
      "registrazioni infermieristiche",
      "sistema di gestione emergenze"
    ],
    "human_review_required": true,
    "minimum_confidence": 0.8,
    "notes": "L'identificazione dell'incertezza diagnostica richiede analisi testuale inferenziale. La verifica dell'avvenuta esecuzione dell'ECG aggiuntivo può essere deterministica se il timestamp è disponibile nel sistema ECG. La revisione umana è consigliata per confermare la corretta identificazione del trigger."
  },
  "possible_outcomes": [
    "compliant",
    "non_compliant",
    "justified_deviation",
    "not_applicable",
    "not_evaluable"
  ],
  "risk_classification": {
    "clinical_risk_severity": "high",
    "process_risk_severity": "moderate",
    "likelihood_if_violated": "possible",
    "detectability": "moderate",
    "priority_score": 7.5,
    "rationale": "La mancata esecuzione di un ECG aggiuntivo in caso di sintomi ricorrenti o incertezza diagnostica può portare al mancato riconoscimento di uno STEMI in evoluzione, con conseguente ritardo nella riperfusione e aumento del rischio di danno miocardico irreversibile e mortalità."
  },
  "documentation_requirements": {
    "mandatory_fields": [
      "Tracciato ECG a 12 derivazioni aggiuntivo",
      "Referto di interpretazione dell'ECG aggiuntivo",
      "Timestamp di acquisizione dell'ECG aggiuntivo",
      "Indicazione clinica per l'esecuzione dell'ECG aggiuntivo (sintomi ricorrenti o incertezza diagnostica)"
    ],
    "acceptable_evidence_sources": [
      "Sistema ECG digitale",
      "Fascicolo clinico elettronico",
      "Note mediche di pronto soccorso",
      "Registrazioni infermieristiche",
      "Sistema di gestione emergenze"
    ],
    "justification_required_when_deviating": true,
    "justification_fields": [
      "Motivazione clinica per la mancata esecuzione dell'ECG aggiuntivo",
      "Condizione clinica del paziente al momento della decisione"
    ],
    "free_text_allowed": true
  },
  "associated_weak_signal_ids": [
    "STEMI-WS-006-01",
    "STEMI-WS-006-02"
  ],
  "extraction_metadata": {
    "generation_mode": "llm_inference",
    "source_interpretation_notes": "La raccomandazione originale utilizza il termine 'recommended', interpretato come forza deontica 'raccomandato' (non obbligatorio). I trigger 'recurrent symptoms' e 'diagnostic uncertainty' sono stati tradotti e operazionalizzati rispettivamente come sintomi ischemici ricorrenti e incertezza diagnostica documentata. L'incertezza diagnostica è un concetto soggettivo che richiede estrazione inferenziale dalle note cliniche.",
    "extraction_confidence": 0.88,
    "ambiguity_flags": [
      "Il concetto di 'incertezza diagnostica' non è definito in modo univoco nella linea guida; la sua operazionalizzazione dipende dall'interpretazione clinica locale.",
      "Non è specificato un vincolo temporale esplicito nella raccomandazione originale; il limite di 10 minuti è stato derivato dalla pratica clinica standard per ECG in contesto emergenziale."
    ],
    "human_validation_status": "not_reviewed",
    "validated_by": null,
    "validated_at": null
  },
  "governance_metadata": {
    "lifecycle_status": "draft",
    "version": "1.0.0",
    "authoring_body": "Gruppo di lavoro PDTA STEMI",
    "rule_owner": "Dipartimento di Cardiologia d'Urgenza",
    "effective_from": "2024-01-01",
    "effective_to": null,
    "review_cycle": "ogni 12 mesi",
    "last_reviewed_at": null,
    "approved_by": null
  }
}
$json_STEMI_DO_006$::jsonb)
ON CONFLICT (clinical_pathway_id, name) DO UPDATE
SET body = EXCLUDED.body;

INSERT INTO riskm_manager_model_evaluation.rule_definition (clinical_pathway_id, name, body)
VALUES (1, 'STEMI-DO-007', $json_STEMI_DO_007$
{
  "schema_version": "1.0.0",
  "rule_id": "STEMI-DO-007",
  "rule_type": "do",
  "title": "Dosaggio delle troponine cardiache con metodo ad alta sensibilità immediatamente dopo la presentazione e ottenimento dei risultati entro 60 minuti dal prelievo ematico",
  "short_label": "Troponina hs entro 60 min",
  "clinical_pathway_id": "PDTA-STEMI-001",
  "clinical_pathway_name": "Percorso Diagnostico Terapeutico Assistenziale per STEMI",
  "clinical_phase": "diagnosi",
  "care_settings": [
    "pronto soccorso",
    "dipartimento di emergenza-urgenza",
    "unità di terapia intensiva cardiologica"
  ],
  "responsible_actors": [
    {
      "role_name": "medico di pronto soccorso",
      "responsibility_type": "primary",
      "organization_unit": "pronto soccorso",
      "notes": "Responsabile della prescrizione del dosaggio della troponina ad alta sensibilità al momento della presentazione del paziente."
    },
    {
      "role_name": "infermiere di triage",
      "responsibility_type": "supporting",
      "organization_unit": "pronto soccorso",
      "notes": "Responsabile dell'esecuzione del prelievo ematico e dell'invio del campione al laboratorio secondo protocollo fast-track."
    },
    {
      "role_name": "tecnico di laboratorio biomedico",
      "responsibility_type": "primary",
      "organization_unit": "laboratorio analisi d'urgenza",
      "notes": "Responsabile dell'elaborazione del campione e della refertazione della troponina hs nel tempo stabilito."
    },
    {
      "role_name": "cardiologo di guardia",
      "responsibility_type": "consulted",
      "organization_unit": "unità di terapia intensiva coronarica",
      "notes": "Consultato per l'interpretazione clinica del risultato della troponina nel contesto del sospetto STEMI."
    }
  ],
  "deontic_strength": "mandatory",
  "recommendation_strength": "Classe I",
  "evidence_level": "Livello B",
  "original_statement": "It is recommended to measure cardiac troponins with high-sensitivity assays immediately after presentation and to obtain the results within 60 min of blood sampling.",
  "normalized_statement": "Si raccomanda di dosare le troponine cardiache con metodo ad alta sensibilità immediatamente dopo la presentazione del paziente e di ottenere i risultati entro 60 minuti dal prelievo ematico.",
  "intent": "Garantire una diagnosi biochimica tempestiva di necrosi miocardica mediante il dosaggio rapido delle troponine cardiache ad alta sensibilità per supportare la diagnosi differenziale e la stratificazione del rischio nei pazienti con sospetto STEMI.",
  "rationale": "Il dosaggio precoce delle troponine cardiache con metodo ad alta sensibilità consente di confermare o escludere rapidamente la necrosi miocardica, supportando le decisioni terapeutiche urgenti come l'attivazione del laboratorio di emodinamica. Un tempo di refertazione entro 60 minuti dal prelievo è essenziale per non ritardare la strategia di riperfusione e migliorare gli outcome clinici.",
  "source_references": [
    {
      "source_id": "ESC-STEMI-GL-2023",
      "source_level": "international",
      "issuer": "European Society of Cardiology (ESC)",
      "document_title": "2023 ESC Guidelines for the management of acute coronary syndromes",
      "document_version": "2023",
      "publication_date": "2023-08-25",
      "section_reference": "Sezione 4 - Diagnosi",
      "page_reference": null,
      "statement_quote": "It is recommended to measure cardiac troponins with high-sensitivity assays immediately after presentation and to obtain the results within 60 min of blood sampling.",
      "citation_uri": "https://doi.org/10.1093/eurheartj/ehad191",
      "license_note": "Contenuto utilizzato a scopo di derivazione di regole cliniche in conformità con le linee guida ESC. Copyright European Society of Cardiology."
    }
  ],
  "applicability": {
    "population_description": "Pazienti adulti che si presentano al pronto soccorso con sospetta sindrome coronarica acuta con sopraslivellamento del tratto ST (STEMI).",
    "clinical_context": "Sospetto clinico di infarto miocardico acuto con sopraslivellamento del tratto ST, fase diagnostica iniziale.",
    "care_context": "Pronto soccorso o dipartimento di emergenza-urgenza, fase di valutazione diagnostica iniziale.",
    "inclusion_criteria": [
      {
        "criterion_id": "STEMI-DO-007-INC-01",
        "label": "Presentazione con dolore toracico sospetto per SCA",
        "description": "Il paziente si presenta con dolore toracico o sintomi equivalenti suggestivi di sindrome coronarica acuta.",
        "logic_expression": "symptom.chief_complaint IN ('dolore_toracico', 'dispnea_acuta', 'sincope', 'dolore_epigastrico_sospetto') OR clinical_suspicion.acs == true",
        "data_elements": [
          "DE-STEMI-007-01",
          "DE-STEMI-007-02"
        ],
        "inference_allowed": true
      },
      {
        "criterion_id": "STEMI-DO-007-INC-02",
        "label": "Alterazioni ECG compatibili con STEMI",
        "description": "L'elettrocardiogramma mostra un sopraslivellamento del tratto ST o equivalenti elettrocardiografici suggestivi di STEMI.",
        "logic_expression": "ecg.st_elevation == true OR ecg.lbbb_new_onset == true OR ecg.stemi_equivalent == true",
        "data_elements": [
          "DE-STEMI-007-03"
        ],
        "inference_allowed": true
      }
    ],
    "exclusion_criteria": [
      {
        "criterion_id": "STEMI-DO-007-EXC-01",
        "label": "Diagnosi alternativa certa all'arrivo",
        "description": "È stata già identificata con certezza una diagnosi alternativa non cardiaca che spiega completamente il quadro clinico, rendendo non necessario il dosaggio delle troponine.",
        "logic_expression": "diagnosis.alternative_confirmed == true AND diagnosis.cardiac_excluded == true",
        "data_elements": [
          "DE-STEMI-007-08"
        ],
        "inference_allowed": false
      }
    ]
  },
  "trigger": {
    "trigger_type": "event",
    "trigger_description": "Presentazione del paziente al pronto soccorso con sospetto clinico di STEMI o sindrome coronarica acuta con sopraslivellamento del tratto ST.",
    "anchor_event": "presentazione_paziente_ps",
    "start_of_applicability": "Immediatamente al momento della presentazione del paziente al pronto soccorso con sospetto di STEMI.",
    "end_of_applicability": "Alla ricezione del risultato della troponina hs o alla conferma diagnostica attraverso altro percorso.",
    "trigger_data_elements": [
      "DE-STEMI-007-01",
      "DE-STEMI-007-02",
      "DE-STEMI-007-03"
    ],
    "inference_allowed": true
  },
  "exceptions": [
    {
      "exception_id": "STEMI-DO-007-EXC-COND-01",
      "label": "Diagnosi STEMI evidente con trasferimento immediato in sala di emodinamica",
      "description": "Nei casi in cui la diagnosi di STEMI è chiaramente evidente dall'ECG e il paziente viene immediatamente trasferito al laboratorio di emodinamica per angioplastica primaria, il prelievo per la troponina può essere eseguito ma il risultato potrebbe non essere disponibile prima dell'inizio della procedura. L'assenza del risultato prima della procedura non costituisce una non conformità se il prelievo è stato effettuato.",
      "condition_logic": "ecg.stemi_clear == true AND cath_lab.activation_immediate == true AND blood_sample.troponin_ordered == true",
      "required_justification": true,
      "required_evidence": [
        "ECG con chiaro sopraslivellamento ST",
        "Ordine di attivazione immediata della sala di emodinamica",
        "Documentazione dell'avvenuto prelievo ematico per troponina"
      ]
    },
    {
      "exception_id": "STEMI-DO-007-EXC-COND-02",
      "label": "Indisponibilità temporanea del metodo ad alta sensibilità",
      "description": "Il metodo ad alta sensibilità non è temporaneamente disponibile per guasto strumentale o indisponibilità del reagente. In tal caso è accettabile l'uso di un metodo convenzionale come misura temporanea, con documentazione della causa.",
      "condition_logic": "lab.hs_troponin_assay_available == false AND lab.instrument_failure == true",
      "required_justification": true,
      "required_evidence": [
        "Documentazione del guasto strumentale o della mancata disponibilità del reagente",
        "Risultato con metodo convenzionale come alternativa"
      ]
    }
  ],
  "expected_action": {
    "action_verb": "dosare",
    "action_description": "Eseguire il prelievo ematico per il dosaggio delle troponine cardiache con metodo ad alta sensibilità (hs-cTn) immediatamente dopo la presentazione del paziente e garantire che i risultati siano disponibili entro 60 minuti dal momento del prelievo.",
    "action_target": "troponina cardiaca ad alta sensibilità (hs-cTnI o hs-cTnT)",
    "action_parameters": [
      {
        "parameter_name": "metodo_analitico",
        "parameter_description": "Tipo di metodo analitico utilizzato per il dosaggio della troponina cardiaca.",
        "expected_value": "alta sensibilità (hs)",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "tempistica_prelievo",
        "parameter_description": "Momento in cui deve essere effettuato il prelievo ematico rispetto alla presentazione del paziente.",
        "expected_value": "immediato",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "tempo_massimo_refertazione",
        "parameter_description": "Tempo massimo entro il quale il risultato del dosaggio della troponina deve essere disponibile dal momento del prelievo ematico.",
        "expected_value": "60",
        "comparison_operator": "less_than",
        "unit": "minuti",
        "mandatory": true
      }
    ],
    "alternative_compliant_actions": [
      "Utilizzo di dosaggio della troponina con metodo point-of-care ad alta sensibilità se disponibile e validato, con refertazione entro 60 minuti dal prelievo"
    ]
  },
  "completion_criteria": {
    "description": "La regola è considerata soddisfatta quando il prelievo ematico per la troponina hs è stato eseguito immediatamente dopo la presentazione e il risultato è stato ricevuto e registrato nel sistema informativo clinico entro 60 minuti dal momento del prelievo.",
    "minimum_occurrences": 1,
    "required_event_types": [
      "ordine_dosaggio_troponina_hs",
      "prelievo_ematico",
      "refertazione_troponina_hs"
    ],
    "required_documentation_elements": [
      "timestamp_ordine_troponina",
      "timestamp_prelievo_ematico",
      "timestamp_refertazione_risultato",
      "valore_troponina_hs",
      "metodo_analitico_utilizzato"
    ],
    "success_condition": "(timestamp_prelievo - timestamp_presentazione <= 15 minuti) AND (timestamp_refertazione - timestamp_prelievo <= 60 minuti) AND metodo == 'alta_sensibilità'"
  },
  "time_constraints": [
    {
      "constraint_id": "STEMI-DO-007-TC-01",
      "description": "Il prelievo ematico per il dosaggio della troponina ad alta sensibilità deve essere eseguito immediatamente dopo la presentazione del paziente.",
      "relation_to_anchor": "immediate",
      "anchor_event": "presentazione_paziente_ps",
      "duration_value": 15,
      "duration_unit": "minuti",
      "hard_deadline": true,
      "alert_threshold_value": 10,
      "alert_threshold_unit": "minuti"
    },
    {
      "constraint_id": "STEMI-DO-007-TC-02",
      "description": "I risultati del dosaggio della troponina cardiaca ad alta sensibilità devono essere disponibili entro 60 minuti dal prelievo ematico.",
      "relation_to_anchor": "within",
      "anchor_event": "prelievo_ematico_troponina",
      "duration_value": 60,
      "duration_unit": "minuti",
      "hard_deadline": true,
      "alert_threshold_value": 45,
      "alert_threshold_unit": "minuti"
    }
  ],
  "sequence_constraints": [
    {
      "constraint_id": "STEMI-DO-007-SC-01",
      "description": "Il prelievo ematico per la troponina deve avvenire prima della refertazione del risultato.",
      "predecessor_event": "prelievo_ematico_troponina",
      "successor_event": "refertazione_troponina_hs",
      "allowed_order": "predecessor_first",
      "violation_condition": "timestamp_refertazione <= timestamp_prelievo OR prelievo_ematico non documentato"
    },
    {
      "constraint_id": "STEMI-DO-007-SC-02",
      "description": "La presentazione del paziente deve precedere l'ordine e il prelievo per la troponina.",
      "predecessor_event": "presentazione_paziente_ps",
      "successor_event": "prelievo_ematico_troponina",
      "allowed_order": "predecessor_first",
      "violation_condition": "timestamp_prelievo < timestamp_presentazione"
    }
  ],
  "required_data_elements": [
    {
      "data_element_id": "DE-STEMI-007-01",
      "name": "Motivo di accesso al pronto soccorso",
      "description": "Motivo principale di presentazione del paziente, incluso il sintomo guida (es. dolore toracico).",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": "ICD-10-CM",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Ricercare nei campi di triage il motivo di accesso con codici correlati a dolore toracico (R07.x) o infarto miocardico (I21.x)."
    },
    {
      "data_element_id": "DE-STEMI-007-02",
      "name": "Sospetto clinico di sindrome coronarica acuta",
      "description": "Valutazione clinica iniziale che documenta il sospetto di SCA o STEMI.",
      "source_location": "ehr_unstructured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "inferential",
      "query_hint": "Ricercare nelle note di triage e nella valutazione medica iniziale riferimenti a sospetto SCA, STEMI, infarto miocardico."
    },
    {
      "data_element_id": "DE-STEMI-007-03",
      "name": "Risultato ECG a 12 derivazioni",
      "description": "Referto dell'ECG con indicazione di sopraslivellamento del tratto ST o equivalenti STEMI.",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": "SNOMED CT",
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Ricercare nel referto ECG la presenza di sopraslivellamento ST, blocco di branca sinistra di nuova insorgenza, o equivalenti STEMI."
    },
    {
      "data_element_id": "DE-STEMI-007-04",
      "name": "Timestamp di presentazione del paziente",
      "description": "Data e ora di registrazione del paziente al triage o al pronto soccorso.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Campo datetime del sistema di triage o del registro accessi di pronto soccorso."
    },
    {
      "data_element_id": "DE-STEMI-007-05",
      "name": "Timestamp del prelievo ematico per troponina",
      "description": "Data e ora di esecuzione del prelievo ematico per il dosaggio della troponina cardiaca.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Ricercare il timestamp di raccolta campione associato all'ordine di troponina nel sistema di laboratorio (LIS) o nell'ordine infermieristico."
    },
    {
      "data_element_id": "DE-STEMI-007-06",
      "name": "Timestamp di refertazione del risultato della troponina",
      "description": "Data e ora in cui il risultato del dosaggio della troponina hs è stato reso disponibile nel sistema informativo clinico.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Ricercare il timestamp di validazione/refertazione del risultato nel LIS o il timestamp di ricezione nel sistema di cartella clinica elettronica."
    },
    {
      "data_element_id": "DE-STEMI-007-07",
      "name": "Valore della troponina cardiaca ad alta sensibilità",
      "description": "Valore numerico del risultato del dosaggio della troponina cardiaca (hs-cTnI o hs-cTnT).",
      "source_location": "ehr_structured",
      "data_type": "numeric",
      "coding_system": "LOINC",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Ricercare i codici LOINC per hs-cTnI (89579-7) o hs-cTnT (67151-1) nel risultato di laboratorio."
    },
    {
      "data_element_id": "DE-STEMI-007-08",
      "name": "Diagnosi alternativa confermata",
      "description": "Eventuale diagnosi alternativa non cardiaca confermata che esclude la necessità del dosaggio della troponina nel contesto STEMI.",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": "ICD-10-CM",
      "required_for_evaluation": false,
      "extraction_method": "hybrid",
      "query_hint": "Ricercare diagnosi confermate non cardiache registrate nel sistema al momento del triage o della prima valutazione."
    }
  ],
  "evidence_of_compliance": [
    {
      "evidence_id": "STEMI-DO-007-EOC-01",
      "description": "Ordine di dosaggio della troponina cardiaca con metodo ad alta sensibilità registrato nel sistema informativo clinico.",
      "evidence_type": "order",
      "minimum_occurrences": 1,
      "time_reference": "Entro i primi minuti dalla presentazione del paziente al pronto soccorso.",
      "derived_from_data_elements": [
        "DE-STEMI-007-04",
        "DE-STEMI-007-05"
      ]
    },
    {
      "evidence_id": "STEMI-DO-007-EOC-02",
      "description": "Prelievo ematico per troponina hs eseguito immediatamente dopo la presentazione del paziente.",
      "evidence_type": "execution",
      "minimum_occurrences": 1,
      "time_reference": "Immediatamente dopo la presentazione (entro 15 minuti).",
      "derived_from_data_elements": [
        "DE-STEMI-007-04",
        "DE-STEMI-007-05"
      ]
    },
    {
      "evidence_id": "STEMI-DO-007-EOC-03",
      "description": "Risultato della troponina hs disponibile e registrato entro 60 minuti dal prelievo ematico.",
      "evidence_type": "result",
      "minimum_occurrences": 1,
      "time_reference": "Entro 60 minuti dal prelievo ematico.",
      "derived_from_data_elements": [
        "DE-STEMI-007-05",
        "DE-STEMI-007-06",
        "DE-STEMI-007-07"
      ]
    },
    {
      "evidence_id": "STEMI-DO-007-EOC-04",
      "description": "Presenza del timestamp di refertazione che conferma il rispetto del vincolo temporale di 60 minuti dal prelievo.",
      "evidence_type": "timestamp",
      "minimum_occurrences": 1,
      "time_reference": "Differenza tra timestamp refertazione e timestamp prelievo ≤ 60 minuti.",
      "derived_from_data_elements": [
        "DE-STEMI-007-05",
        "DE-STEMI-007-06"
      ]
    }
  ],
  "evidence_of_non_compliance": [
    {
      "evidence_id": "STEMI-DO-007-EONC-01",
      "description": "Assenza di ordine per dosaggio della troponina cardiaca ad alta sensibilità in un paziente con sospetto STEMI.",
      "evidence_type": "absence_of_event",
      "minimum_occurrences": 1,
      "time_reference": "Nessun ordine registrato entro 30 minuti dalla presentazione.",
      "derived_from_data_elements": [
        "DE-STEMI-007-04",
        "DE-STEMI-007-05"
      ]
    },
    {
      "evidence_id": "STEMI-DO-007-EONC-02",
      "description": "Risultato della troponina non disponibile entro 60 minuti dal prelievo ematico, indicando un ritardo nel processo di refertazione.",
      "evidence_type": "timestamp",
      "minimum_occurrences": 1,
      "time_reference": "Differenza tra timestamp refertazione e timestamp prelievo > 60 minuti.",
      "derived_from_data_elements": [
        "DE-STEMI-007-05",
        "DE-STEMI-007-06"
      ]
    },
    {
      "evidence_id": "STEMI-DO-007-EONC-03",
      "description": "Utilizzo di un metodo non ad alta sensibilità per il dosaggio della troponina senza documentazione di giustificazione.",
      "evidence_type": "derived_fact",
      "minimum_occurrences": 1,
      "time_reference": "Al momento della refertazione del risultato.",
      "derived_from_data_elements": [
        "DE-STEMI-007-07"
      ]
    },
    {
      "evidence_id": "STEMI-DO-007-EONC-04",
      "description": "Ritardo significativo tra la presentazione del paziente e l'esecuzione del prelievo ematico (superiore a 15 minuti).",
      "evidence_type": "timestamp",
      "minimum_occurrences": 1,
      "time_reference": "Differenza tra timestamp prelievo e timestamp presentazione > 15 minuti.",
      "derived_from_data_elements": [
        "DE-STEMI-007-04",
        "DE-STEMI-007-05"
      ]
    }
  ],
  "evaluation_logic": {
    "natural_language_test": "Verificare che: (1) il paziente con sospetto STEMI abbia avuto un prelievo ematico per troponina hs eseguito immediatamente dopo la presentazione (entro 15 minuti); (2) il metodo analitico utilizzato sia ad alta sensibilità; (3) il risultato sia stato refertato e reso disponibile nel sistema informativo entro 60 minuti dal momento del prelievo ematico. Se tutti e tre i criteri sono soddisfatti, la regola è conforme. Se uno qualsiasi dei criteri non è soddisfatto, la regola è non conforme a meno che non sia presente una deviazione giustificata documentata.",
    "formal_expression_language": "pseudocode",
    "formal_expression": "IF (patient.suspected_stemi == true) THEN { LET t_pres = timestamp_presentazione; LET t_prel = timestamp_prelievo_troponina; LET t_ref = timestamp_refertazione_troponina; LET method = metodo_analitico; IF (t_prel IS NOT NULL AND t_ref IS NOT NULL AND method == 'hs') THEN { IF ((t_prel - t_pres) <= 15 min AND (t_ref - t_prel) <= 60 min) THEN RETURN 'compliant'; ELSE IF (exception_documented == true) THEN RETURN 'justified_deviation'; ELSE RETURN 'non_compliant'; } ELSE IF (t_prel IS NULL OR t_ref IS NULL) THEN { IF (exception_documented == true) THEN RETURN 'justified_deviation'; ELSE RETURN 'non_compliant'; } } ELSE RETURN 'not_applicable';",
    "missing_data_policy": "review_required",
    "ambiguity_policy": "review_required",
    "conflict_resolution_policy": "human_review",
    "notes": "Il vincolo di 15 minuti per il prelievo è un'operazionalizzazione del termine 'immediatamente' presente nella raccomandazione originale. Il vincolo di 60 minuti dal prelievo alla refertazione è esplicito nel testo della linea guida. In caso di dati mancanti relativi ai timestamp, è necessaria una revisione manuale per determinare la conformità."
  },
  "evaluation_method": {
    "primary_method": "hybrid",
    "allowed_inference_sources": [
      "note cliniche di pronto soccorso",
      "registro di triage",
      "sistema informativo di laboratorio (LIS)",
      "cartella clinica elettronica"
    ],
    "human_review_required": false,
    "minimum_confidence": 0.85,
    "notes": "La valutazione primaria è deterministica basata sui timestamp strutturati. Il metodo inferenziale è necessario solo quando i timestamp strutturati non sono disponibili e occorre estrarre le informazioni temporali dalle note cliniche."
  },
  "possible_outcomes": [
    "compliant",
    "non_compliant",
    "justified_deviation",
    "not_applicable",
    "not_evaluable",
    "probable_non_compliance"
  ],
  "risk_classification": {
    "clinical_risk_severity": "high",
    "process_risk_severity": "high",
    "likelihood_if_violated": "possible",
    "detectability": "easy",
    "priority_score": 8.5,
    "rationale": "Il ritardo nel dosaggio e nella refertazione della troponina hs può determinare un ritardo diagnostico significativo nei pazienti con STEMI, con conseguente ritardo nella strategia di riperfusione e peggioramento dell'outcome clinico. Il rischio clinico è elevato perché il mancato rispetto di questa regola può contribuire a un ritardo complessivo del door-to-balloon time. La violazione è facilmente rilevabile attraverso i timestamp registrati nei sistemi informativi."
  },
  "documentation_requirements": {
    "mandatory_fields": [
      "timestamp_presentazione_paziente",
      "timestamp_prelievo_ematico_troponina",
      "timestamp_refertazione_troponina",
      "valore_troponina_hs",
      "metodo_analitico_troponina",
      "unità_di_misura_troponina"
    ],
    "acceptable_evidence_sources": [
      "sistema informativo di laboratorio (LIS)",
      "cartella clinica elettronica",
      "sistema di gestione ordini",
      "registro infermieristico di pronto soccorso",
      "sistema di triage"
    ],
    "justification_required_when_deviating": true,
    "justification_fields": [
      "nota_clinica_di_deviazione",
      "motivo_di_ritardo_refertazione",
      "motivo_di_utilizzo_metodo_non_hs"
    ],
    "free_text_allowed": true
  },
  "associated_weak_signal_ids": [
    "STEMI-WS-007-01",
    "STEMI-WS-007-02",
    "STEMI-WS-007-03"
  ],
  "extraction_metadata": {
    "generation_mode": "llm_inference",
    "source_interpretation_notes": "Il testo originale specifica 'immediately after presentation' che è stato operazionalizzato come entro 15 minuti dalla presentazione, un valore soglia comunemente adottato nella pratica clinica per definire l'immediatezza in contesto di emergenza. Il vincolo di 60 minuti dal prelievo alla disponibilità dei risultati è esplicito nel testo. Il termine 'high-sensitivity assays' è stato tradotto come 'metodo ad alta sensibilità (hs)' in conformità con la terminologia clinica italiana.",
    "extraction_confidence": 0.93,
    "ambiguity_flags": [
      "Il termine 'immediately' è stato interpretato come 'entro 15 minuti' - soglia da validare con il comitato clinico locale",
      "Non è specificato se il vincolo di 60 minuti si applica anche ai dosaggi point-of-care"
    ],
    "human_validation_status": "not_reviewed",
    "validated_by": null,
    "validated_at": null
  },
  "governance_metadata": {
    "lifecycle_status": "draft",
    "version": "1.0.0",
    "authoring_body": "Gruppo di lavoro PDTA STEMI",
    "rule_owner": "Direttore del Dipartimento di Emergenza-Urgenza",
    "effective_from": null,
    "effective_to": null,
    "review_cycle": "12 mesi",
    "last_reviewed_at": null,
    "approved_by": null
  }
}
$json_STEMI_DO_007$::jsonb)
ON CONFLICT (clinical_pathway_id, name) DO UPDATE
SET body = EXCLUDED.body;

INSERT INTO riskm_manager_model_evaluation.rule_definition (clinical_pathway_id, name, body)
VALUES (1, 'STEMI-DO-008', $json_STEMI_DO_008$
{
  "schema_version": "1.0.0",
  "rule_id": "STEMI-DO-008",
  "rule_type": "do",
  "title": "Utilizzo dell'approccio algoritmico ESC con dosaggi seriati di troponina cardiaca ad alta sensibilità (hs-cTn) per confermare o escludere NSTEMI",
  "short_label": "Algoritmo ESC hs-cTn 0h/1h o 0h/2h",
  "clinical_pathway_id": "PDTA-STEMI-001",
  "clinical_pathway_name": "Percorso Diagnostico Terapeutico Assistenziale per STEMI",
  "clinical_phase": "diagnosi",
  "care_settings": [
    "pronto soccorso",
    "dipartimento di emergenza-urgenza",
    "unità di dolore toracico"
  ],
  "responsible_actors": [
    {
      "role_name": "Medico d'urgenza",
      "responsibility_type": "primary",
      "organization_unit": "Pronto Soccorso / Dipartimento di Emergenza-Urgenza",
      "notes": "Responsabile della richiesta e interpretazione dei dosaggi seriati di hs-cTn secondo l'algoritmo ESC."
    },
    {
      "role_name": "Cardiologo",
      "responsibility_type": "consulted",
      "organization_unit": "Cardiologia / Unità di Terapia Intensiva Coronarica",
      "notes": "Consulente per interpretazione di risultati ambigui o per conferma diagnostica di NSTEMI."
    },
    {
      "role_name": "Infermiere di triage",
      "responsibility_type": "supporting",
      "organization_unit": "Pronto Soccorso",
      "notes": "Supporta il prelievo ematico al tempo 0 e garantisce il prelievo seriato nei tempi previsti dall'algoritmo."
    },
    {
      "role_name": "Laboratorio analisi",
      "responsibility_type": "supporting",
      "organization_unit": "Laboratorio centralizzato / Point-of-care",
      "notes": "Responsabile dell'esecuzione del dosaggio hs-cTn con tempi di refertazione rapidi (turn-around time ≤ 60 minuti)."
    }
  ],
  "deontic_strength": "recommended",
  "recommendation_strength": "Classe I",
  "evidence_level": "Livello di evidenza B",
  "original_statement": "It is recommended to use an ESC algorithmic approach with serial hs-cTn measurements (0 h/1 h or 0 h/2 h) to rule in and rule out NSTEMI.",
  "normalized_statement": "Si raccomanda di utilizzare l'approccio algoritmico ESC con dosaggi seriati di troponina cardiaca ad alta sensibilità (hs-cTn) a 0h/1h oppure 0h/2h per confermare o escludere la diagnosi di NSTEMI.",
  "intent": "Garantire una stratificazione diagnostica rapida e accurata dei pazienti con sospetta sindrome coronarica acuta senza sopraslivellamento del tratto ST, utilizzando un algoritmo validato basato su dosaggi seriati di hs-cTn per confermare o escludere NSTEMI.",
  "rationale": "L'algoritmo ESC basato su dosaggi seriati di hs-cTn a 0h/1h o 0h/2h consente un rapido rule-in e rule-out dell'NSTEMI con elevata accuratezza diagnostica (VPN >99%), riducendo i tempi di permanenza in pronto soccorso, migliorando l'allocazione delle risorse e garantendo un trattamento tempestivo nei pazienti con infarto miocardico confermato.",
  "source_references": [
    {
      "source_id": "ESC-ACS-2023",
      "source_level": "international",
      "issuer": "European Society of Cardiology (ESC)",
      "document_title": "2023 ESC Guidelines for the management of acute coronary syndromes",
      "document_version": "2023",
      "publication_date": "2023-08-25",
      "section_reference": "Sezione 3.3 – Diagnosi biochimica: troponina cardiaca ad alta sensibilità",
      "page_reference": null,
      "statement_quote": "It is recommended to use an ESC algorithmic approach with serial hs-cTn measurements (0 h/1 h or 0 h/2 h) to rule in and rule out NSTEMI.",
      "citation_uri": "https://doi.org/10.1093/eurheartj/ehad191",
      "license_note": "Contenuto soggetto a copyright ESC. Uso a fini clinici e di qualità interna."
    }
  ],
  "applicability": {
    "population_description": "Pazienti adulti che si presentano in pronto soccorso con sospetta sindrome coronarica acuta, in particolare quelli senza sopraslivellamento persistente del tratto ST all'ECG, in cui è necessario confermare o escludere un NSTEMI.",
    "clinical_context": "Sospetta sindrome coronarica acuta (SCA) senza sopraslivellamento persistente del tratto ST, nell'ambito del percorso diagnostico differenziale STEMI/NSTEMI.",
    "care_context": "Fase diagnostica iniziale presso il pronto soccorso o l'unità di dolore toracico.",
    "inclusion_criteria": [
      {
        "criterion_id": "IC-008-01",
        "label": "Dolore toracico suggestivo di SCA",
        "description": "Paziente con dolore toracico acuto o equivalente ischemico sospetto per sindrome coronarica acuta.",
        "logic_expression": "presenting_complaint IN ('dolore toracico', 'dispnea acuta', 'sincope', 'equivalente ischemico')",
        "data_elements": [
          "DE-008-01"
        ],
        "inference_allowed": true
      },
      {
        "criterion_id": "IC-008-02",
        "label": "ECG senza sopraslivellamento persistente ST",
        "description": "ECG al primo contatto che non mostra un sopraslivellamento persistente del tratto ST (esclusione di STEMI evidente).",
        "logic_expression": "ecg_finding != 'STEMI_persistente'",
        "data_elements": [
          "DE-008-02"
        ],
        "inference_allowed": true
      },
      {
        "criterion_id": "IC-008-03",
        "label": "Disponibilità del dosaggio hs-cTn",
        "description": "Il laboratorio o il sistema point-of-care deve disporre di un test di troponina cardiaca ad alta sensibilità validato.",
        "logic_expression": "hs_cTn_assay_available == true",
        "data_elements": [
          "DE-008-03"
        ],
        "inference_allowed": false
      }
    ],
    "exclusion_criteria": [
      {
        "criterion_id": "EC-008-01",
        "label": "STEMI conclamato all'ECG",
        "description": "Paziente con sopraslivellamento persistente del tratto ST diagnostico di STEMI che richiede riperfusione immediata (percorso STEMI diretto).",
        "logic_expression": "ecg_finding == 'STEMI_persistente'",
        "data_elements": [
          "DE-008-02"
        ],
        "inference_allowed": false
      },
      {
        "criterion_id": "EC-008-02",
        "label": "Arresto cardiaco in corso con instabilità emodinamica severa",
        "description": "Pazienti in arresto cardiaco refrattario o con instabilità emodinamica critica che preclude l'attesa dei risultati seriati di troponina.",
        "logic_expression": "hemodynamic_status == 'arresto_cardiaco_refrattario' OR hemodynamic_status == 'shock_cardiogeno_severo'",
        "data_elements": [
          "DE-008-04"
        ],
        "inference_allowed": true
      }
    ]
  },
  "trigger": {
    "trigger_type": "documented_symptom",
    "trigger_description": "Presentazione in pronto soccorso di un paziente con sintomatologia suggestiva di sindrome coronarica acuta e assenza di sopraslivellamento persistente del tratto ST all'ECG iniziale, con necessità di differenziazione diagnostica NSTEMI vs altre cause.",
    "anchor_event": "primo_contatto_medico_PS",
    "start_of_applicability": "Dal momento della presentazione in pronto soccorso con sospetto clinico di SCA e ECG non diagnostico per STEMI.",
    "end_of_applicability": "Fino al completamento dell'algoritmo diagnostico hs-cTn con conferma o esclusione di NSTEMI, oppure fino a eventuale riclassificazione come STEMI.",
    "trigger_data_elements": [
      "DE-008-01",
      "DE-008-02"
    ],
    "inference_allowed": true
  },
  "exceptions": [
    {
      "exception_id": "EX-008-01",
      "label": "Presentazione molto tardiva (>72 ore dall'esordio dei sintomi)",
      "description": "In caso di presentazione molto tardiva con esordio dei sintomi oltre 72 ore prima, la troponina potrebbe essere in fase discendente e l'algoritmo 0h/1h-2h potrebbe non essere affidabile; in tal caso si richiede valutazione clinica individuale.",
      "condition_logic": "symptom_onset_to_presentation > 72 hours",
      "required_justification": true,
      "required_evidence": [
        "Documentazione del tempo stimato dall'esordio dei sintomi",
        "Nota clinica con giustificazione della variazione dell'approccio diagnostico"
      ]
    },
    {
      "exception_id": "EX-008-02",
      "label": "Insufficienza renale terminale con troponina cronicamente elevata",
      "description": "Nei pazienti con insufficienza renale cronica terminale (eGFR <15 ml/min o in dialisi), i livelli basali di hs-cTn possono essere cronicamente elevati, richiedendo soglie e interpretazioni differenti o l'uso di delta assoluti specifici.",
      "condition_logic": "eGFR < 15 OR dialysis_status == true",
      "required_justification": true,
      "required_evidence": [
        "Valore di eGFR o stato di dialisi documentato",
        "Valori basali noti di hs-cTn se disponibili",
        "Nota clinica con motivazione dell'approccio diagnostico alternativo"
      ]
    },
    {
      "exception_id": "EX-008-03",
      "label": "Test hs-cTn non disponibile",
      "description": "In caso di indisponibilità temporanea del dosaggio ad alta sensibilità della troponina, si può ricorrere ad un dosaggio convenzionale con protocollo standard (0h/3h-6h) o trasferimento del paziente verso struttura dotata di hs-cTn.",
      "condition_logic": "hs_cTn_assay_available == false",
      "required_justification": true,
      "required_evidence": [
        "Documentazione dell'indisponibilità del test hs-cTn",
        "Nota clinica indicante il protocollo alternativo adottato"
      ]
    }
  ],
  "expected_action": {
    "action_verb": "eseguire",
    "action_description": "Eseguire dosaggi seriati di troponina cardiaca ad alta sensibilità (hs-cTn) secondo l'approccio algoritmico ESC con protocollo 0h/1h o, in alternativa, 0h/2h, al fine di confermare (rule-in) o escludere (rule-out) la diagnosi di NSTEMI nei pazienti con sospetta sindrome coronarica acuta.",
    "action_target": "Dosaggio seriato di troponina cardiaca ad alta sensibilità (hs-cTn)",
    "action_parameters": [
      {
        "parameter_name": "Protocollo temporale primario",
        "parameter_description": "Intervallo temporale tra il primo e il secondo dosaggio di hs-cTn secondo il protocollo ESC raccomandato.",
        "expected_value": "1",
        "comparison_operator": "equals",
        "unit": "ora",
        "mandatory": true
      },
      {
        "parameter_name": "Protocollo temporale alternativo",
        "parameter_description": "Intervallo temporale alternativo tra il primo e il secondo dosaggio di hs-cTn quando il protocollo a 1 ora non è utilizzabile.",
        "expected_value": "2",
        "comparison_operator": "equals",
        "unit": "ore",
        "mandatory": false
      },
      {
        "parameter_name": "Tipo di dosaggio",
        "parameter_description": "Il dosaggio della troponina deve essere eseguito con un test ad alta sensibilità (hs-cTn, troponina T o I ad alta sensibilità) validato.",
        "expected_value": "alta sensibilità (hs-cTn)",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "Numero minimo di prelievi",
        "parameter_description": "Numero minimo di prelievi seriati richiesti per l'applicazione dell'algoritmo ESC (tempo 0 + almeno un prelievo successivo).",
        "expected_value": "2",
        "comparison_operator": "greater_than",
        "unit": "prelievi",
        "mandatory": true
      },
      {
        "parameter_name": "Applicazione algoritmo ESC di rule-in/rule-out",
        "parameter_description": "I risultati dei dosaggi seriati devono essere interpretati secondo le soglie e i delta previsti dall'algoritmo ESC specifico per il test hs-cTn utilizzato (rule-in, rule-out, zona grigia/osservazione).",
        "expected_value": "Algoritmo ESC 0h/1h o 0h/2h applicato",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      }
    ],
    "alternative_compliant_actions": [
      "Utilizzo del protocollo ESC 0h/2h in alternativa al protocollo 0h/1h quando quest'ultimo non è disponibile per il test hs-cTn utilizzato",
      "In caso di zona grigia (observe zone), esecuzione di un ulteriore dosaggio di hs-cTn a 3 ore dal primo prelievo con rivalutazione clinica"
    ]
  },
  "completion_criteria": {
    "description": "L'azione è considerata completata quando sono stati eseguiti almeno due dosaggi seriati di hs-cTn secondo i tempi previsti dall'algoritmo ESC (0h e 1h o 0h e 2h), i risultati sono stati interpretati secondo le soglie algoritmiche ESC e la decisione clinica di rule-in, rule-out o osservazione è stata documentata.",
    "minimum_occurrences": 1,
    "required_event_types": [
      "prelievo_hs_cTn_tempo_0",
      "prelievo_hs_cTn_tempo_1h_o_2h",
      "referto_laboratorio_hs_cTn",
      "interpretazione_algoritmo_ESC"
    ],
    "required_documentation_elements": [
      "Valore di hs-cTn al tempo 0 con timestamp del prelievo",
      "Valore di hs-cTn al tempo 1h o 2h con timestamp del prelievo",
      "Delta assoluto di hs-cTn calcolato",
      "Classificazione algoritmata: rule-in, rule-out o zona di osservazione",
      "Decisione clinica conseguente documentata in cartella"
    ],
    "success_condition": "Due dosaggi di hs-cTn eseguiti nei tempi previsti (0h e 1h oppure 0h e 2h) AND risultati interpretati secondo algoritmo ESC AND decisione documentata di rule-in, rule-out o prosecuzione dell'osservazione."
  },
  "time_constraints": [
    {
      "constraint_id": "TC-008-01",
      "description": "Il primo prelievo ematico per il dosaggio di hs-cTn (tempo 0) deve essere effettuato il prima possibile dopo il primo contatto medico in pronto soccorso.",
      "relation_to_anchor": "immediate",
      "anchor_event": "primo_contatto_medico_PS",
      "duration_value": 10,
      "duration_unit": "minuti",
      "hard_deadline": false,
      "alert_threshold_value": null,
      "alert_threshold_unit": null
    },
    {
      "constraint_id": "TC-008-02",
      "description": "Il secondo prelievo ematico per hs-cTn deve essere eseguito a 1 ora dal primo prelievo nel protocollo 0h/1h.",
      "relation_to_anchor": "after",
      "anchor_event": "prelievo_hs_cTn_tempo_0",
      "duration_value": 1,
      "duration_unit": "ora",
      "hard_deadline": true,
      "alert_threshold_value": 50,
      "alert_threshold_unit": "minuti"
    },
    {
      "constraint_id": "TC-008-03",
      "description": "In alternativa, il secondo prelievo ematico per hs-cTn deve essere eseguito a 2 ore dal primo prelievo nel protocollo 0h/2h.",
      "relation_to_anchor": "after",
      "anchor_event": "prelievo_hs_cTn_tempo_0",
      "duration_value": 2,
      "duration_unit": "ore",
      "hard_deadline": true,
      "alert_threshold_value": 100,
      "alert_threshold_unit": "minuti"
    },
    {
      "constraint_id": "TC-008-04",
      "description": "I risultati del dosaggio di hs-cTn devono essere disponibili entro 60 minuti dal prelievo (turn-around time laboratorio).",
      "relation_to_anchor": "within",
      "anchor_event": "prelievo_hs_cTn",
      "duration_value": 60,
      "duration_unit": "minuti",
      "hard_deadline": false,
      "alert_threshold_value": 45,
      "alert_threshold_unit": "minuti"
    }
  ],
  "sequence_constraints": [
    {
      "constraint_id": "SC-008-01",
      "description": "L'ECG a 12 derivazioni deve essere eseguito prima o contestualmente al primo prelievo di hs-cTn per escludere STEMI.",
      "predecessor_event": "esecuzione_ECG_12_derivazioni",
      "successor_event": "prelievo_hs_cTn_tempo_0",
      "allowed_order": "predecessor_first",
      "violation_condition": "Il primo prelievo di hs-cTn viene eseguito senza un ECG precedente o concomitante che escluda STEMI."
    },
    {
      "constraint_id": "SC-008-02",
      "description": "Il prelievo di hs-cTn al tempo 0 deve precedere il prelievo seriato al tempo 1h o 2h.",
      "predecessor_event": "prelievo_hs_cTn_tempo_0",
      "successor_event": "prelievo_hs_cTn_tempo_1h_o_2h",
      "allowed_order": "predecessor_first",
      "violation_condition": "Il prelievo seriato viene eseguito prima del prelievo basale o senza il prelievo basale documentato."
    },
    {
      "constraint_id": "SC-008-03",
      "description": "L'interpretazione dell'algoritmo ESC deve avvenire dopo la disponibilità dei risultati di entrambi i dosaggi seriati.",
      "predecessor_event": "referto_hs_cTn_seriato_completo",
      "successor_event": "interpretazione_algoritmo_ESC",
      "allowed_order": "predecessor_first",
      "violation_condition": "La decisione diagnostica viene presa senza attendere i risultati completi dei dosaggi seriati."
    }
  ],
  "required_data_elements": [
    {
      "data_element_id": "DE-008-01",
      "name": "Sintomo di presentazione",
      "description": "Motivo di accesso al pronto soccorso (dolore toracico, dispnea, sincope o equivalente ischemico).",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": "ICD-10 / codifica locale di triage",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Campo motivo di accesso / chief complaint nella scheda di triage."
    },
    {
      "data_element_id": "DE-008-02",
      "name": "Referto ECG 12 derivazioni",
      "description": "Risultato dell'elettrocardiogramma a 12 derivazioni con indicazione della presenza o assenza di sopraslivellamento del tratto ST.",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": "Codifica locale ECG / SNOMED CT",
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Referto ECG strutturato o interpretazione automatica del dispositivo ECG; verificare anche note cliniche se non strutturato."
    },
    {
      "data_element_id": "DE-008-03",
      "name": "Disponibilità test hs-cTn",
      "description": "Indicazione sulla disponibilità di un dosaggio di troponina cardiaca ad alta sensibilità nel laboratorio di riferimento.",
      "source_location": "other",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Configurazione di sistema del catalogo analisi del laboratorio; verificare disponibilità del test hs-cTn."
    },
    {
      "data_element_id": "DE-008-04",
      "name": "Stato emodinamico del paziente",
      "description": "Valutazione dello stato emodinamico (stabile, instabile, shock cardiogeno, arresto cardiaco).",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": "Codifica locale / SNOMED CT",
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Parametri vitali, note di triage, documentazione medica d'urgenza."
    },
    {
      "data_element_id": "DE-008-05",
      "name": "Valore hs-cTn al tempo 0",
      "description": "Concentrazione di troponina cardiaca ad alta sensibilità misurata al momento del primo prelievo (baseline).",
      "source_location": "ehr_structured",
      "data_type": "numeric",
      "coding_system": "LOINC",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Risultato di laboratorio per hs-cTnT (LOINC 67151-1) o hs-cTnI (LOINC 89579-7) con timestamp del prelievo."
    },
    {
      "data_element_id": "DE-008-06",
      "name": "Valore hs-cTn al tempo 1h o 2h",
      "description": "Concentrazione di troponina cardiaca ad alta sensibilità misurata al secondo prelievo seriato (1 ora o 2 ore dopo il basale).",
      "source_location": "ehr_structured",
      "data_type": "numeric",
      "coding_system": "LOINC",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Risultato di laboratorio per hs-cTn seriata con timestamp del prelievo; calcolare intervallo dal primo prelievo."
    },
    {
      "data_element_id": "DE-008-07",
      "name": "Timestamp prelievo hs-cTn tempo 0",
      "description": "Data e ora del primo prelievo ematico per il dosaggio di hs-cTn.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Timestamp associato all'ordine o all'esecuzione del prelievo ematico per troponina basale."
    },
    {
      "data_element_id": "DE-008-08",
      "name": "Timestamp prelievo hs-cTn seriato",
      "description": "Data e ora del secondo prelievo ematico per il dosaggio seriato di hs-cTn.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Timestamp associato all'ordine o all'esecuzione del secondo prelievo ematico per troponina seriata."
    },
    {
      "data_element_id": "DE-008-09",
      "name": "Delta assoluto hs-cTn",
      "description": "Variazione assoluta della concentrazione di hs-cTn tra il primo e il secondo dosaggio, calcolata per l'applicazione dell'algoritmo ESC.",
      "source_location": "derived",
      "data_type": "numeric",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Calcolare: |hs-cTn(1h o 2h) - hs-cTn(0h)|. Utilizzare le soglie specifiche del test hs-cTn impiegato."
    },
    {
      "data_element_id": "DE-008-10",
      "name": "Esito algoritmo ESC (rule-in / rule-out / observe)",
      "description": "Risultato dell'applicazione dell'algoritmo ESC: conferma (rule-in), esclusione (rule-out) o zona di osservazione.",
      "source_location": "derived",
      "data_type": "coded concept",
      "coding_system": "Codifica locale (rule_in, rule_out, observe)",
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Derivato dall'applicazione delle soglie algoritmiche ESC ai valori di hs-cTn basale e delta; verificare documentazione clinica."
    }
  ],
  "evidence_of_compliance": [
    {
      "evidence_id": "EOC-008-01",
      "description": "Presenza nel sistema informativo di laboratorio di almeno due risultati di hs-cTn con timestamp compatibili con il protocollo 0h/1h o 0h/2h.",
      "evidence_type": "result",
      "minimum_occurrences": 2,
      "time_reference": "Entro 3 ore dal primo contatto medico in pronto soccorso",
      "derived_from_data_elements": [
        "DE-008-05",
        "DE-008-06",
        "DE-008-07",
        "DE-008-08"
      ]
    },
    {
      "evidence_id": "EOC-008-02",
      "description": "Documentazione clinica della classificazione algoritmica ESC (rule-in, rule-out o zona di osservazione) con riferimento ai valori e al delta di hs-cTn.",
      "evidence_type": "documentation",
      "minimum_occurrences": 1,
      "time_reference": "Dopo la disponibilità del secondo dosaggio di hs-cTn",
      "derived_from_data_elements": [
        "DE-008-09",
        "DE-008-10"
      ]
    },
    {
      "evidence_id": "EOC-008-03",
      "description": "Ordine di laboratorio per dosaggio seriato di hs-cTn documentato nel sistema informatico ospedaliero.",
      "evidence_type": "order",
      "minimum_occurrences": 1,
      "time_reference": "Entro 10 minuti dal primo contatto medico",
      "derived_from_data_elements": [
        "DE-008-05",
        "DE-008-07"
      ]
    }
  ],
  "evidence_of_non_compliance": [
    {
      "evidence_id": "EONC-008-01",
      "description": "Assenza di dosaggio seriato di hs-cTn: un solo valore di troponina disponibile oppure nessun dosaggio eseguito per il paziente con sospetta SCA.",
      "evidence_type": "absence_of_event",
      "minimum_occurrences": 1,
      "time_reference": "Entro 3 ore dal primo contatto medico in pronto soccorso",
      "derived_from_data_elements": [
        "DE-008-05",
        "DE-008-06"
      ]
    },
    {
      "evidence_id": "EONC-008-02",
      "description": "Intervallo tra i due prelievi di hs-cTn non conforme al protocollo ESC (significativamente diverso da 1 ora o 2 ore).",
      "evidence_type": "timestamp",
      "minimum_occurrences": 1,
      "time_reference": "Intervallo tra primo e secondo prelievo",
      "derived_from_data_elements": [
        "DE-008-07",
        "DE-008-08"
      ]
    },
    {
      "evidence_id": "EONC-008-03",
      "description": "Utilizzo di un dosaggio di troponina convenzionale (non ad alta sensibilità) senza giustificazione documentata.",
      "evidence_type": "result",
      "minimum_occurrences": 1,
      "time_reference": null,
      "derived_from_data_elements": [
        "DE-008-03",
        "DE-008-05"
      ]
    },
    {
      "evidence_id": "EONC-008-04",
      "description": "Assenza di documentazione dell'interpretazione algoritmica ESC (rule-in/rule-out/observe) nonostante la disponibilità dei risultati di hs-cTn seriati.",
      "evidence_type": "documentation_gap",
      "minimum_occurrences": 1,
      "time_reference": "Dopo la disponibilità del secondo risultato di hs-cTn",
      "derived_from_data_elements": [
        "DE-008-10"
      ]
    }
  ],
  "evaluation_logic": {
    "natural_language_test": "Verificare che per il paziente con sospetta SCA senza STEMI siano stati eseguiti almeno due dosaggi di troponina cardiaca ad alta sensibilità (hs-cTn) con un intervallo conforme al protocollo ESC (circa 1 ora o circa 2 ore), che i risultati siano stati interpretati secondo l'algoritmo ESC con calcolo del delta assoluto e che la classificazione diagnostica risultante (rule-in, rule-out o osservazione) sia stata documentata in cartella clinica.",
    "formal_expression_language": "pseudocode",
    "formal_expression": "IF (sospetta_SCA == true AND ecg_STEMI == false) THEN { ASSERT count(hs_cTn_results) >= 2; LET t0 = timestamp(hs_cTn_prelievo_0); LET t1 = timestamp(hs_cTn_prelievo_seriato); LET intervallo = t1 - t0; ASSERT (intervallo BETWEEN 50min AND 70min) OR (intervallo BETWEEN 110min AND 130min); LET delta = abs(hs_cTn_seriato - hs_cTn_basale); ASSERT esito_algoritmo_ESC IN ('rule_in', 'rule_out', 'observe'); ASSERT documentazione_esito_presente == true; RETURN 'compliant'; } ELSE IF (eccezione_documentata == true) THEN RETURN 'justified_deviation'; ELSE RETURN 'non_compliant';",
    "missing_data_policy": "not_evaluable",
    "ambiguity_policy": "review_required",
    "conflict_resolution_policy": "human_review",
    "notes": "L'intervallo accettabile tra i due prelievi include una tolleranza operativa di ±10 minuti rispetto ai tempi nominali (1h o 2h). Le soglie specifiche di rule-in/rule-out variano in base al tipo di test hs-cTn utilizzato (es. hs-cTnT Roche, hs-cTnI Abbott) e devono essere configurate localmente."
  },
  "evaluation_method": {
    "primary_method": "hybrid",
    "allowed_inference_sources": [
      "referti di laboratorio strutturati",
      "note cliniche del pronto soccorso",
      "ordini di laboratorio nel sistema informatico ospedaliero",
      "lettera di dimissione dal pronto soccorso"
    ],
    "human_review_required": false,
    "minimum_confidence": 0.85,
    "notes": "La valutazione primaria è deterministica basata sui dati strutturati di laboratorio (valori hs-cTn e timestamp). In caso di dati incompleti, si ricorre all'estrazione inferenziale dalle note cliniche per verificare la documentazione dell'interpretazione algoritmica."
  },
  "possible_outcomes": [
    "compliant",
    "non_compliant",
    "justified_deviation",
    "not_applicable",
    "not_evaluable",
    "probable_non_compliance"
  ],
  "risk_classification": {
    "clinical_risk_severity": "high",
    "process_risk_severity": "high",
    "likelihood_if_violated": "possible",
    "detectability": "easy",
    "priority_score": 8.5,
    "rationale": "Il mancato utilizzo dell'algoritmo ESC con dosaggi seriati di hs-cTn può portare a una diagnosi errata o ritardata di NSTEMI, con conseguente ritardo nel trattamento antitrombotico e nella strategia invasiva, aumentando il rischio di eventi cardiovascolari avversi maggiori (MACE). La violazione è facilmente rilevabile tramite i dati strutturati di laboratorio."
  },
  "documentation_requirements": {
    "mandatory_fields": [
      "Valore di hs-cTn al tempo 0 con timestamp",
      "Valore di hs-cTn al tempo 1h o 2h con timestamp",
      "Delta assoluto di hs-cTn",
      "Classificazione algoritmo ESC (rule-in / rule-out / observe)",
      "Decisione clinica conseguente (ricovero, dimissione, osservazione)"
    ],
    "acceptable_evidence_sources": [
      "Sistema informativo di laboratorio (LIS)",
      "Cartella clinica elettronica del pronto soccorso",
      "Ordini di laboratorio nel sistema informatico ospedaliero",
      "Note cliniche strutturate o narrative del medico d'urgenza",
      "Lettera di dimissione dal pronto soccorso"
    ],
    "justification_required_when_deviating": true,
    "justification_fields": [
      "Nota clinica di giustificazione nel diario medico di pronto soccorso",
      "Motivazione documentata per l'utilizzo di protocollo alternativo",
      "Documentazione dell'eccezione clinica applicabile"
    ],
    "free_text_allowed": true
  },
  "associated_weak_signal_ids": [
    "WS-STEMI-008-01",
    "WS-STEMI-008-02",
    "WS-STEMI-008-03"
  ],
  "extraction_metadata": {
    "generation_mode": "llm_inference",
    "source_interpretation_notes": "La raccomandazione originale è riferita specificamente all'NSTEMI ma è inserita nel contesto del percorso STEMI poiché la diagnosi differenziale STEMI/NSTEMI è parte integrante del pathway. Il testo originale è in inglese e utilizza 'is recommended' che corrisponde a Classe I ESC. I protocolli 0h/1h e 0h/2h sono presentati come alternative equivalenti.",
    "extraction_confidence": 0.92,
    "ambiguity_flags": [
      "La raccomandazione si riferisce a NSTEMI ma è inserita nel percorso STEMI: verificare se il contesto clinico previsto è solo la diagnosi differenziale o include anche il monitoraggio post-STEMI.",
      "Le soglie specifiche di rule-in/rule-out dipendono dal tipo di test hs-cTn utilizzato e devono essere configurate localmente.",
      "Il livello di evidenza non è esplicitamente indicato nel testo sorgente; è stato assegnato Livello B come plausibile sulla base delle linee guida ESC 2023."
    ],
    "human_validation_status": "not_reviewed",
    "validated_by": null,
    "validated_at": null
  },
  "governance_metadata": {
    "lifecycle_status": "draft",
    "version": "1.0.0",
    "authoring_body": "Team Clinical Pathway STEMI - Qualità e Sicurezza delle Cure",
    "rule_owner": "Direttore del Dipartimento di Emergenza-Urgenza",
    "effective_from": null,
    "effective_to": null,
    "review_cycle": "12 mesi",
    "last_reviewed_at": null,
    "approved_by": null
  }
}
$json_STEMI_DO_008$::jsonb)
ON CONFLICT (clinical_pathway_id, name) DO UPDATE
SET body = EXCLUDED.body;

INSERT INTO riskm_manager_model_evaluation.rule_definition (clinical_pathway_id, name, body)
VALUES (1, 'STEMI-DO-009', $json_STEMI_DO_009$
{
  "schema_version": "1.0.0",
  "rule_id": "STEMI-DO-009",
  "rule_type": "do",
  "title": "Eseguire test aggiuntivo di hs-cTn dopo 3 ore in caso di risultati inconcludenti dell'algoritmo 0 h/1 h",
  "short_label": "hs-cTn aggiuntiva a 3 h se inconcludente",
  "clinical_pathway_id": "PDTA-STEMI-001",
  "clinical_pathway_name": "Percorso Diagnostico Terapeutico Assistenziale per STEMI",
  "clinical_phase": "diagnosi",
  "care_settings": [
    "pronto soccorso",
    "unità di dolore toracico",
    "medicina d'urgenza"
  ],
  "responsible_actors": [
    {
      "role_name": "medico di pronto soccorso",
      "responsibility_type": "primary",
      "organization_unit": "Pronto Soccorso",
      "notes": "Responsabile della decisione di richiedere il terzo dosaggio di hs-cTn dopo 3 ore e della rivalutazione clinica."
    },
    {
      "role_name": "infermiere di triage/pronto soccorso",
      "responsibility_type": "supporting",
      "organization_unit": "Pronto Soccorso",
      "notes": "Responsabile dell'esecuzione del prelievo ematico al tempo stabilito e dell'invio del campione al laboratorio."
    },
    {
      "role_name": "laboratorista",
      "responsibility_type": "supporting",
      "organization_unit": "Laboratorio Analisi Urgenti",
      "notes": "Responsabile dell'esecuzione e refertazione tempestiva del dosaggio hs-cTn."
    },
    {
      "role_name": "cardiologo",
      "responsibility_type": "consulted",
      "organization_unit": "Cardiologia",
      "notes": "Consultato in caso di risultati persistentemente dubbi o peggioramento clinico."
    }
  ],
  "deontic_strength": "recommended",
  "recommendation_strength": "Classe I",
  "evidence_level": "B",
  "original_statement": "Additional testing after 3 h is recommended if the first two hs-cTn measurements of the 0 h/1 h algorithm are inconclusive and no alternative diagnoses explaining the condition have been made.",
  "normalized_statement": "Si raccomanda l'esecuzione di un dosaggio aggiuntivo di troponina cardiaca ad alta sensibilità (hs-cTn) dopo 3 ore dalla presentazione quando le prime due misurazioni dell'algoritmo 0 h/1 h risultano inconcludenti e non è stata formulata alcuna diagnosi alternativa che spieghi la condizione clinica.",
  "intent": "Garantire che i pazienti con sospetta sindrome coronarica acuta e risultati inconcludenti dell'algoritmo rapido 0 h/1 h di hs-cTn ricevano un ulteriore dosaggio a 3 ore per raggiungere una diagnosi definitiva, evitando dimissioni inappropriate o ritardi diagnostici.",
  "rationale": "L'algoritmo 0 h/1 h di hs-cTn consente di escludere o confermare l'infarto miocardico nella maggior parte dei pazienti, ma una quota di casi rimane nella zona inconcludente. Il dosaggio aggiuntivo a 3 ore, in assenza di diagnosi alternative, aumenta la sensibilità diagnostica e permette di identificare pazienti con infarto miocardico a cinetica più lenta della troponina, riducendo il rischio di mancata diagnosi.",
  "source_references": [
    {
      "source_id": "ESC-ACS-2023",
      "source_level": "international",
      "issuer": "European Society of Cardiology (ESC)",
      "document_title": "2023 ESC Guidelines for the management of acute coronary syndromes",
      "document_version": "2023",
      "publication_date": "2023-08-25",
      "section_reference": "Sezione Diagnosi - Algoritmo 0 h/1 h hs-cTn, raccomandazione sui casi inconcludenti",
      "page_reference": null,
      "statement_quote": "Additional testing after 3 h is recommended if the first two hs-cTn measurements of the 0 h/1 h algorithm are inconclusive and no alternative diagnoses explaining the condition have been made.",
      "citation_uri": "https://doi.org/10.1093/eurheartj/ehad191",
      "license_note": "Contenuto utilizzato a fini di supporto decisionale clinico conformemente alle linee guida ESC."
    }
  ],
  "applicability": {
    "population_description": "Pazienti adulti che si presentano in pronto soccorso con sospetta sindrome coronarica acuta e dolore toracico, sottoposti all'algoritmo rapido 0 h/1 h di troponina cardiaca ad alta sensibilità (hs-cTn), i cui risultati sono risultati inconcludenti.",
    "clinical_context": "Sospetta sindrome coronarica acuta (SCA) con risultati inconcludenti dell'algoritmo diagnostico rapido 0 h/1 h di hs-cTn, in assenza di una diagnosi alternativa definita.",
    "care_context": "Pronto soccorso o unità di dolore toracico durante la fase diagnostica iniziale.",
    "inclusion_criteria": [
      {
        "criterion_id": "STEMI-DO-009-INC-01",
        "label": "Risultato inconcludente algoritmo 0 h/1 h",
        "description": "Le prime due misurazioni di hs-cTn eseguite secondo l'algoritmo 0 h/1 h non hanno consentito né di escludere né di confermare l'infarto miocardico acuto (risultato nella zona grigia/inconcludente).",
        "logic_expression": "hs_cTn_0h_result == 'inconcludente' AND hs_cTn_1h_result == 'inconcludente' AND algoritmo_0h1h_esito == 'inconcludente'",
        "data_elements": [
          "DE-hs_cTn_0h_valore",
          "DE-hs_cTn_1h_valore",
          "DE-algoritmo_0h1h_esito"
        ],
        "inference_allowed": false
      },
      {
        "criterion_id": "STEMI-DO-009-INC-02",
        "label": "Assenza di diagnosi alternativa",
        "description": "Non è stata formulata alcuna diagnosi alternativa che possa spiegare adeguatamente il quadro clinico del paziente (ad esempio embolia polmonare, miocardite, dissecazione aortica, cause non cardiache).",
        "logic_expression": "diagnosi_alternativa_formulata == false",
        "data_elements": [
          "DE-diagnosi_alternativa"
        ],
        "inference_allowed": true
      },
      {
        "criterion_id": "STEMI-DO-009-INC-03",
        "label": "Sospetto clinico di SCA",
        "description": "Paziente con presentazione clinica compatibile con sindrome coronarica acuta (dolore toracico, dispnea, alterazioni ECG suggestive o anamnesi compatibile).",
        "logic_expression": "sospetto_SCA == true",
        "data_elements": [
          "DE-sospetto_SCA",
          "DE-sintomo_dolore_toracico"
        ],
        "inference_allowed": true
      }
    ],
    "exclusion_criteria": [
      {
        "criterion_id": "STEMI-DO-009-EXC-01",
        "label": "Diagnosi alternativa confermata",
        "description": "È stata identificata e confermata una diagnosi alternativa che spiega completamente il quadro clinico del paziente.",
        "logic_expression": "diagnosi_alternativa_formulata == true AND diagnosi_alternativa_confermata == true",
        "data_elements": [
          "DE-diagnosi_alternativa",
          "DE-diagnosi_alternativa_confermata"
        ],
        "inference_allowed": true
      },
      {
        "criterion_id": "STEMI-DO-009-EXC-02",
        "label": "Algoritmo 0 h/1 h già conclusivo",
        "description": "L'algoritmo 0 h/1 h ha già fornito un risultato conclusivo (rule-in o rule-out definitivo per infarto miocardico acuto).",
        "logic_expression": "algoritmo_0h1h_esito IN ('rule_in', 'rule_out')",
        "data_elements": [
          "DE-algoritmo_0h1h_esito"
        ],
        "inference_allowed": false
      },
      {
        "criterion_id": "STEMI-DO-009-EXC-03",
        "label": "STEMI evidente all'ECG",
        "description": "Il paziente presenta un sopraslivellamento del segmento ST diagnostico all'ECG che configura uno STEMI franco e richiede un percorso di riperfusione immediata senza necessità di ulteriori dosaggi di troponina.",
        "logic_expression": "ECG_STEMI == true",
        "data_elements": [
          "DE-ECG_risultato"
        ],
        "inference_allowed": false
      }
    ]
  },
  "trigger": {
    "trigger_type": "result",
    "trigger_description": "Il risultato dell'algoritmo 0 h/1 h di hs-cTn è classificato come inconcludente (zona grigia) dopo la valutazione delle prime due misurazioni, e non è stata formulata alcuna diagnosi alternativa plausibile.",
    "anchor_event": "completamento_algoritmo_0h1h_inconcludente",
    "start_of_applicability": "Dal momento in cui l'esito dell'algoritmo 0 h/1 h viene classificato come inconcludente e si conferma l'assenza di diagnosi alternative.",
    "end_of_applicability": "Fino all'esecuzione del dosaggio aggiuntivo di hs-cTn a 3 ore o fino alla formulazione di una diagnosi alternativa che spieghi il quadro clinico.",
    "trigger_data_elements": [
      "DE-algoritmo_0h1h_esito",
      "DE-hs_cTn_0h_valore",
      "DE-hs_cTn_1h_valore",
      "DE-diagnosi_alternativa"
    ],
    "inference_allowed": false
  },
  "exceptions": [
    {
      "exception_id": "STEMI-DO-009-EXP-01",
      "label": "Diagnosi alternativa sopravvenuta",
      "description": "Una diagnosi alternativa plausibile viene formulata e documentata tra il completamento dell'algoritmo 0 h/1 h e il tempo previsto per il dosaggio aggiuntivo a 3 ore, rendendo non necessario il prelievo aggiuntivo.",
      "condition_logic": "diagnosi_alternativa_formulata == true AND tempo_diagnosi < tempo_prelievo_3h",
      "required_justification": true,
      "required_evidence": [
        "Documentazione della diagnosi alternativa nel referto clinico",
        "Esami o indagini a supporto della diagnosi alternativa"
      ]
    },
    {
      "exception_id": "STEMI-DO-009-EXP-02",
      "label": "Instabilità emodinamica con necessità di intervento urgente",
      "description": "Il paziente sviluppa instabilità emodinamica o deterioramento clinico acuto che richiede un intervento terapeutico immediato (es. coronarografia urgente, rianimazione), rendendo il dosaggio aggiuntivo di hs-cTn non prioritario.",
      "condition_logic": "instabilita_emodinamica == true OR intervento_urgente_richiesto == true",
      "required_justification": true,
      "required_evidence": [
        "Documentazione di parametri vitali indicativi di instabilità",
        "Registrazione dell'intervento urgente e sua motivazione"
      ]
    },
    {
      "exception_id": "STEMI-DO-009-EXP-03",
      "label": "Dimissione volontaria del paziente",
      "description": "Il paziente rifiuta il completamento dell'iter diagnostico e richiede la dimissione volontaria, impedendo il prelievo a 3 ore.",
      "condition_logic": "dimissione_volontaria == true AND consenso_informato_rifiuto_documentato == true",
      "required_justification": true,
      "required_evidence": [
        "Modulo di dimissione volontaria firmato dal paziente",
        "Documentazione dell'informazione fornita sui rischi"
      ]
    }
  ],
  "expected_action": {
    "action_verb": "eseguire",
    "action_description": "Eseguire un dosaggio aggiuntivo di troponina cardiaca ad alta sensibilità (hs-cTn) mediante prelievo ematico a 3 ore dalla presentazione iniziale (tempo 0), in seguito a risultati inconcludenti dell'algoritmo 0 h/1 h e in assenza di diagnosi alternative.",
    "action_target": "Dosaggio hs-cTn (troponina cardiaca ad alta sensibilità) a 3 ore",
    "action_parameters": [
      {
        "parameter_name": "tempo_prelievo",
        "parameter_description": "Tempo di esecuzione del prelievo aggiuntivo rispetto alla presentazione iniziale (tempo 0).",
        "expected_value": "3",
        "comparison_operator": "equals",
        "unit": "ore",
        "mandatory": true
      },
      {
        "parameter_name": "analita",
        "parameter_description": "Tipo di biomarcatore da dosare nel prelievo aggiuntivo.",
        "expected_value": "hs-cTn (troponina cardiaca ad alta sensibilità)",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "tipo_campione",
        "parameter_description": "Tipo di campione biologico richiesto per il dosaggio.",
        "expected_value": "sangue venoso",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      }
    ],
    "alternative_compliant_actions": [
      "Dosaggio hs-cTn a 3 ore con differente assay hs-cTn validato, se il medesimo assay non è disponibile",
      "Dosaggio hs-cTn a 3 ore associato a rivalutazione clinica ed ECG come parte di un approccio integrato"
    ]
  },
  "completion_criteria": {
    "description": "Il dosaggio aggiuntivo di hs-cTn è considerato completato quando il prelievo ematico è stato eseguito a circa 3 ore dalla presentazione, il campione è stato analizzato dal laboratorio e il risultato è stato refertato e reso disponibile al medico richiedente, che lo ha integrato nella valutazione diagnostica.",
    "minimum_occurrences": 1,
    "required_event_types": [
      "prelievo ematico a 3 ore",
      "refertazione risultato hs-cTn",
      "valutazione clinica del risultato"
    ],
    "required_documentation_elements": [
      "Orario del prelievo ematico a 3 ore",
      "Valore numerico del dosaggio hs-cTn a 3 ore",
      "Interpretazione clinica del risultato nel contesto dell'algoritmo diagnostico"
    ],
    "success_condition": "risultato_hs_cTn_3h IS NOT NULL AND timestamp_prelievo_3h IS NOT NULL AND valutazione_clinica_3h_documentata == true"
  },
  "time_constraints": [
    {
      "constraint_id": "STEMI-DO-009-TC-01",
      "description": "Il prelievo aggiuntivo di hs-cTn deve essere eseguito a 3 ore dalla presentazione iniziale del paziente (tempo 0). Una tolleranza ragionevole di circa ±30 minuti è accettabile nella pratica clinica.",
      "relation_to_anchor": "after",
      "anchor_event": "presentazione_iniziale_tempo_0",
      "duration_value": 3,
      "duration_unit": "ore",
      "hard_deadline": false,
      "alert_threshold_value": 2.5,
      "alert_threshold_unit": "ore"
    },
    {
      "constraint_id": "STEMI-DO-009-TC-02",
      "description": "Il risultato del dosaggio a 3 ore deve essere disponibile al medico entro 60 minuti dall'esecuzione del prelievo per garantire una decisione tempestiva.",
      "relation_to_anchor": "within",
      "anchor_event": "prelievo_ematico_3h",
      "duration_value": 60,
      "duration_unit": "minuti",
      "hard_deadline": false,
      "alert_threshold_value": 45,
      "alert_threshold_unit": "minuti"
    }
  ],
  "sequence_constraints": [
    {
      "constraint_id": "STEMI-DO-009-SC-01",
      "description": "Le prime due misurazioni di hs-cTn dell'algoritmo 0 h/1 h devono essere state completate e classificate come inconcludenti prima dell'esecuzione del dosaggio aggiuntivo a 3 ore.",
      "predecessor_event": "completamento_algoritmo_0h1h_inconcludente",
      "successor_event": "prelievo_hs_cTn_3h",
      "allowed_order": "predecessor_first",
      "violation_condition": "prelievo_hs_cTn_3h eseguito PRIMA del completamento e classificazione dell'algoritmo 0 h/1 h come inconcludente"
    },
    {
      "constraint_id": "STEMI-DO-009-SC-02",
      "description": "La rivalutazione clinica del paziente deve essere effettuata dopo la disponibilità del risultato del dosaggio aggiuntivo a 3 ore.",
      "predecessor_event": "refertazione_hs_cTn_3h",
      "successor_event": "rivalutazione_clinica_post_3h",
      "allowed_order": "predecessor_first",
      "violation_condition": "rivalutazione_clinica_post_3h non effettuata OPPURE effettuata prima della disponibilità del referto hs-cTn a 3 ore"
    }
  ],
  "required_data_elements": [
    {
      "data_element_id": "DE-hs_cTn_0h_valore",
      "name": "Valore hs-cTn al tempo 0",
      "description": "Valore numerico del dosaggio di troponina cardiaca ad alta sensibilità al momento della presentazione iniziale (tempo 0).",
      "source_location": "ehr_structured",
      "data_type": "numeric",
      "coding_system": "LOINC",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare risultato di laboratorio con codice LOINC per hs-cTn (es. 89579-7 per hs-cTnI o 67151-1 per hs-cTnT) con timestamp corrispondente al tempo 0."
    },
    {
      "data_element_id": "DE-hs_cTn_1h_valore",
      "name": "Valore hs-cTn a 1 ora",
      "description": "Valore numerico del dosaggio di troponina cardiaca ad alta sensibilità a 1 ora dalla presentazione iniziale.",
      "source_location": "ehr_structured",
      "data_type": "numeric",
      "coding_system": "LOINC",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare risultato di laboratorio hs-cTn con timestamp circa 1 ora dopo il tempo 0."
    },
    {
      "data_element_id": "DE-algoritmo_0h1h_esito",
      "name": "Esito algoritmo 0 h/1 h",
      "description": "Classificazione dell'esito dell'algoritmo diagnostico rapido 0 h/1 h di hs-cTn: rule-in, rule-out o inconcludente.",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Verificare se esiste un campo strutturato per l'esito dell'algoritmo. In alternativa, derivare dai valori di hs-cTn 0h e 1h e dalla variazione assoluta secondo i cut-off del kit diagnostico in uso."
    },
    {
      "data_element_id": "DE-diagnosi_alternativa",
      "name": "Diagnosi alternativa formulata",
      "description": "Indicatore della presenza di una diagnosi alternativa documentata che spieghi il quadro clinico, rendendo non necessario il dosaggio aggiuntivo.",
      "source_location": "ehr_unstructured",
      "data_type": "boolean",
      "coding_system": "ICD-10",
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Cercare diagnosi codificate in cartella clinica o note cliniche che documentino una diagnosi alternativa alla SCA (es. embolia polmonare, miocardite, scompenso cardiaco, cause muscoloscheletriche)."
    },
    {
      "data_element_id": "DE-hs_cTn_3h_valore",
      "name": "Valore hs-cTn a 3 ore",
      "description": "Valore numerico del dosaggio aggiuntivo di troponina cardiaca ad alta sensibilità eseguito a 3 ore dalla presentazione iniziale.",
      "source_location": "ehr_structured",
      "data_type": "numeric",
      "coding_system": "LOINC",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare risultato di laboratorio hs-cTn con timestamp circa 3 ore dopo il tempo 0."
    },
    {
      "data_element_id": "DE-timestamp_presentazione",
      "name": "Timestamp presentazione iniziale (tempo 0)",
      "description": "Data e ora della presentazione iniziale del paziente in pronto soccorso, utilizzata come riferimento temporale per l'algoritmo 0 h/1 h/3 h.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Utilizzare il timestamp di registrazione in triage o di primo accesso al pronto soccorso."
    },
    {
      "data_element_id": "DE-timestamp_prelievo_3h",
      "name": "Timestamp prelievo ematico a 3 ore",
      "description": "Data e ora dell'esecuzione del prelievo ematico per il dosaggio aggiuntivo di hs-cTn a 3 ore.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare il timestamp di prelievo del campione associato al terzo dosaggio di hs-cTn."
    },
    {
      "data_element_id": "DE-sospetto_SCA",
      "name": "Sospetto clinico di SCA",
      "description": "Indicatore del sospetto clinico di sindrome coronarica acuta formulato dal medico al momento della valutazione iniziale.",
      "source_location": "ehr_unstructured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "inferential",
      "query_hint": "Cercare nelle note cliniche di accesso indicatori di sospetto SCA, dolore toracico acuto, o richiesta di dosaggio troponina con motivazione clinica compatibile."
    },
    {
      "data_element_id": "DE-sintomo_dolore_toracico",
      "name": "Dolore toracico",
      "description": "Presenza documentata di dolore toracico o equivalente anginoso come sintomo di presentazione.",
      "source_location": "ehr_structured",
      "data_type": "boolean",
      "coding_system": "ICD-10",
      "required_for_evaluation": false,
      "extraction_method": "hybrid",
      "query_hint": "Cercare codice ICD-10 R07.9 o equivalente, oppure nota clinica che riporti dolore toracico."
    },
    {
      "data_element_id": "DE-ECG_risultato",
      "name": "Risultato ECG",
      "description": "Esito dell'elettrocardiogramma eseguito all'arrivo, in particolare la presenza o assenza di sopraslivellamento del tratto ST.",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Cercare referto ECG e classificazione (STEMI, NSTEMI, alterazioni aspecifiche, normale)."
    },
    {
      "data_element_id": "DE-diagnosi_alternativa_confermata",
      "name": "Diagnosi alternativa confermata",
      "description": "Indicatore che la diagnosi alternativa è stata confermata mediante esami o indagini complementari.",
      "source_location": "ehr_unstructured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": false,
      "extraction_method": "inferential",
      "query_hint": "Verificare nelle note cliniche o referti diagnostici la conferma di una diagnosi alternativa alla SCA."
    }
  ],
  "evidence_of_compliance": [
    {
      "evidence_id": "STEMI-DO-009-EOC-01",
      "description": "Presenza di un risultato di laboratorio per hs-cTn con timestamp compatibile con 3 ore (±30 minuti) dalla presentazione iniziale, successivo a un esito inconcludente dell'algoritmo 0 h/1 h.",
      "evidence_type": "result",
      "minimum_occurrences": 1,
      "time_reference": "Circa 3 ore dopo la presentazione iniziale (tempo 0), con tolleranza ±30 minuti",
      "derived_from_data_elements": [
        "DE-hs_cTn_3h_valore",
        "DE-timestamp_prelievo_3h",
        "DE-timestamp_presentazione"
      ]
    },
    {
      "evidence_id": "STEMI-DO-009-EOC-02",
      "description": "Documentazione clinica della rivalutazione del paziente basata sul risultato del dosaggio aggiuntivo di hs-cTn a 3 ore, inclusa l'interpretazione diagnostica.",
      "evidence_type": "documentation",
      "minimum_occurrences": 1,
      "time_reference": "Dopo la disponibilità del risultato hs-cTn a 3 ore",
      "derived_from_data_elements": [
        "DE-hs_cTn_3h_valore",
        "DE-algoritmo_0h1h_esito"
      ]
    },
    {
      "evidence_id": "STEMI-DO-009-EOC-03",
      "description": "Ordine di laboratorio per dosaggio hs-cTn a 3 ore presente nel sistema informativo, con motivazione clinica coerente.",
      "evidence_type": "order",
      "minimum_occurrences": 1,
      "time_reference": "Tra il completamento dell'algoritmo 0 h/1 h inconcludente e le 3 ore dalla presentazione",
      "derived_from_data_elements": [
        "DE-hs_cTn_3h_valore",
        "DE-timestamp_prelievo_3h"
      ]
    }
  ],
  "evidence_of_non_compliance": [
    {
      "evidence_id": "STEMI-DO-009-EONC-01",
      "description": "Assenza di un terzo dosaggio di hs-cTn entro 4 ore dalla presentazione iniziale, in un paziente con esito inconcludente dell'algoritmo 0 h/1 h e senza diagnosi alternativa documentata.",
      "evidence_type": "absence_of_event",
      "minimum_occurrences": 1,
      "time_reference": "Entro 4 ore dalla presentazione iniziale (tempo 0)",
      "derived_from_data_elements": [
        "DE-hs_cTn_3h_valore",
        "DE-timestamp_presentazione",
        "DE-algoritmo_0h1h_esito",
        "DE-diagnosi_alternativa"
      ]
    },
    {
      "evidence_id": "STEMI-DO-009-EONC-02",
      "description": "Il paziente viene dimesso o trasferito dal pronto soccorso senza che sia stato eseguito il dosaggio aggiuntivo a 3 ore e senza una diagnosi alternativa documentata né una giustificazione clinica per la deviazione.",
      "evidence_type": "sequence",
      "minimum_occurrences": 1,
      "time_reference": "Prima delle 3 ore dalla presentazione o senza dosaggio hs-cTn a 3 ore",
      "derived_from_data_elements": [
        "DE-hs_cTn_3h_valore",
        "DE-diagnosi_alternativa",
        "DE-algoritmo_0h1h_esito"
      ]
    },
    {
      "evidence_id": "STEMI-DO-009-EONC-03",
      "description": "Dosaggio aggiuntivo eseguito ma con ritardo significativo (oltre 4.5 ore dalla presentazione) senza giustificazione documentata.",
      "evidence_type": "timestamp",
      "minimum_occurrences": 1,
      "time_reference": "Oltre 4.5 ore dalla presentazione iniziale",
      "derived_from_data_elements": [
        "DE-timestamp_prelievo_3h",
        "DE-timestamp_presentazione"
      ]
    }
  ],
  "evaluation_logic": {
    "natural_language_test": "Verificare se, in un paziente con sospetta SCA il cui algoritmo 0 h/1 h di hs-cTn ha dato esito inconcludente e per il quale non è stata formulata alcuna diagnosi alternativa, è stato eseguito un dosaggio aggiuntivo di hs-cTn a circa 3 ore dalla presentazione iniziale, e se il risultato è stato valutato clinicamente. Se il dosaggio è presente con timestamp appropriato e la rivalutazione è documentata, la regola è conforme. Se il dosaggio è assente oppure molto ritardato senza giustificazione, la regola è non conforme.",
    "formal_expression_language": "pseudocode",
    "formal_expression": "IF algoritmo_0h1h_esito == 'inconcludente' AND diagnosi_alternativa_formulata == false THEN IF EXISTS(hs_cTn_3h_valore) AND ABS(timestamp_prelievo_3h - timestamp_presentazione - 3h) <= 30min AND valutazione_clinica_3h_documentata == true THEN 'compliant' ELSE IF EXISTS(diagnosi_alternativa_sopravvenuta) AND diagnosi_alternativa_sopravvenuta_documentata == true THEN 'justified_deviation' ELSE IF hs_cTn_3h_valore IS NULL AND tempo_attuale - timestamp_presentazione > 4h THEN 'non_compliant' ELSE 'not_evaluable' END",
    "missing_data_policy": "review_required",
    "ambiguity_policy": "review_required",
    "conflict_resolution_policy": "human_review",
    "notes": "La classificazione dell'esito dell'algoritmo 0 h/1 h come inconcludente può dipendere dal kit diagnostico e dai cut-off locali. È necessario verificare la coerenza tra i valori di hs-cTn e i soglie specifiche del saggio in uso. Il termine 'circa 3 ore' ammette una tolleranza ragionevole di ±30 minuti."
  },
  "evaluation_method": {
    "primary_method": "hybrid",
    "allowed_inference_sources": [
      "note cliniche di pronto soccorso",
      "referti di laboratorio",
      "lettere di dimissione",
      "schede di triage",
      "ordini di laboratorio nel sistema informativo"
    ],
    "human_review_required": true,
    "minimum_confidence": 0.85,
    "notes": "L'assenza di diagnosi alternativa richiede spesso inferenza da note cliniche non strutturate. La classificazione dell'esito dell'algoritmo 0 h/1 h come inconcludente può non essere sempre codificata in modo strutturato e potrebbe richiedere derivazione dai valori numerici di hs-cTn rispetto ai cut-off del saggio locale."
  },
  "possible_outcomes": [
    "compliant",
    "non_compliant",
    "justified_deviation",
    "not_applicable",
    "not_evaluable",
    "probable_non_compliance"
  ],
  "risk_classification": {
    "clinical_risk_severity": "high",
    "process_risk_severity": "high",
    "likelihood_if_violated": "possible",
    "detectability": "moderate",
    "priority_score": 8.5,
    "rationale": "La mancata esecuzione del dosaggio aggiuntivo di hs-cTn a 3 ore in pazienti con risultato inconcludente dell'algoritmo 0 h/1 h può portare a dimissioni inappropriate di pazienti con infarto miocardico acuto non diagnosticato, con elevato rischio di eventi avversi maggiori (morte cardiaca improvvisa, scompenso cardiaco acuto, aritmie fatali). Il rischio clinico è classificato come alto perché l'omissione diagnostica può avere conseguenze potenzialmente fatali."
  },
  "documentation_requirements": {
    "mandatory_fields": [
      "Valore hs-cTn al tempo 0",
      "Valore hs-cTn a 1 ora",
      "Esito algoritmo 0 h/1 h (rule-in, rule-out, inconcludente)",
      "Valore hs-cTn a 3 ore (se applicabile)",
      "Timestamp di ciascun prelievo",
      "Valutazione clinica del risultato a 3 ore",
      "Eventuale diagnosi alternativa formulata"
    ],
    "acceptable_evidence_sources": [
      "Sistema informativo di laboratorio (LIS)",
      "Cartella clinica elettronica di pronto soccorso",
      "Note cliniche strutturate e narrative",
      "Ordini di laboratorio",
      "Scheda di osservazione breve"
    ],
    "justification_required_when_deviating": true,
    "justification_fields": [
      "Nota clinica motivante la deviazione",
      "Diagnosi alternativa documentata con relativa evidenza",
      "Motivo del mancato prelievo a 3 ore",
      "Modulo di dimissione volontaria (se applicabile)"
    ],
    "free_text_allowed": true
  },
  "associated_weak_signal_ids": [
    "STEMI-WS-009-01",
    "STEMI-WS-009-02"
  ],
  "extraction_metadata": {
    "generation_mode": "llm_inference",
    "source_interpretation_notes": "Il testo originale in inglese utilizza il termine 'recommended' che è stato mappato a forza deontica 'recommended'. L'algoritmo 0 h/1 h si riferisce al protocollo rapido ESC per il dosaggio seriale di hs-cTn con prelievi al tempo 0 e a 1 ora. Il termine 'inconclusive' è stato tradotto come 'inconcludente' e si riferisce ai pazienti che non soddisfano i criteri di rule-in né di rule-out dopo le prime due misurazioni. La condizione 'no alternative diagnoses' è stata interpretata come assenza di qualsiasi diagnosi alternativa plausibile documentata.",
    "extraction_confidence": 0.92,
    "ambiguity_flags": [
      "I cut-off per definire l'esito 'inconcludente' dell'algoritmo 0 h/1 h variano in base al tipo di saggio hs-cTn utilizzato (hs-cTnI vs hs-cTnT) e al produttore del kit diagnostico.",
      "Il testo non specifica una tolleranza temporale esatta per il prelievo a 3 ore; è stata assunta una tolleranza di ±30 minuti come ragionevole nella pratica clinica.",
      "La definizione di 'diagnosi alternativa' è ampia e richiede giudizio clinico per stabilire se una diagnosi sia sufficientemente plausibile da spiegare il quadro."
    ],
    "human_validation_status": "not_reviewed",
    "validated_by": null,
    "validated_at": null
  },
  "governance_metadata": {
    "lifecycle_status": "draft",
    "version": "1.0.0",
    "authoring_body": "Gruppo di Lavoro PDTA STEMI",
    "rule_owner": "Direttore UOC Cardiologia e Pronto Soccorso",
    "effective_from": null,
    "effective_to": null,
    "review_cycle": "12 mesi",
    "last_reviewed_at": null,
    "approved_by": null
  }
}
$json_STEMI_DO_009$::jsonb)
ON CONFLICT (clinical_pathway_id, name) DO UPDATE
SET body = EXCLUDED.body;

INSERT INTO riskm_manager_model_evaluation.rule_definition (clinical_pathway_id, name, body)
VALUES (1, 'STEMI-DO-010', $json_STEMI_DO_010$
{
  "schema_version": "1.0.0",
  "rule_id": "STEMI-DO-010",
  "rule_type": "do",
  "title": "Ecocardiografia transtoracica (TTE) d'emergenza raccomandata nei pazienti con sospetta SCA che presentano shock cardiogeno o sospette complicanze meccaniche",
  "short_label": "TTE emergenza in shock cardiogeno / complicanze meccaniche",
  "clinical_pathway_id": "PDTA-STEMI-001",
  "clinical_pathway_name": "Percorso Diagnostico-Terapeutico Assistenziale per STEMI",
  "clinical_phase": "diagnosi",
  "care_settings": [
    "pronto soccorso",
    "unità di terapia intensiva cardiologica",
    "sala di emodinamica",
    "unità coronarica"
  ],
  "responsible_actors": [
    {
      "role_name": "cardiologo ecocardiografista",
      "responsibility_type": "primary",
      "organization_unit": "servizio di cardiologia / laboratorio di ecocardiografia",
      "notes": "Responsabile dell'esecuzione e dell'interpretazione dell'ecocardiogramma transtoracico d'emergenza."
    },
    {
      "role_name": "medico d'emergenza",
      "responsibility_type": "supporting",
      "organization_unit": "pronto soccorso",
      "notes": "Responsabile dell'identificazione iniziale dello shock cardiogeno o delle sospette complicanze meccaniche e dell'attivazione della richiesta di TTE d'emergenza."
    },
    {
      "role_name": "cardiologo di guardia",
      "responsibility_type": "consulted",
      "organization_unit": "unità di terapia intensiva cardiologica",
      "notes": "Consulente per la valutazione clinica complessiva e l'interpretazione dei risultati ecocardiografici in contesto di emergenza."
    },
    {
      "role_name": "infermiere di area critica",
      "responsibility_type": "supporting",
      "organization_unit": "pronto soccorso / UTIC",
      "notes": "Supporto logistico e monitoraggio del paziente durante l'esecuzione dell'esame ecocardiografico."
    }
  ],
  "deontic_strength": "recommended",
  "recommendation_strength": "Classe I (Raccomandato)",
  "evidence_level": "Livello di evidenza C",
  "original_statement": "Emergency TTE is recommended in patients with suspected ACS presenting with cardiogenic shock or suspected mechanical complications.",
  "normalized_statement": "È raccomandata l'esecuzione di un ecocardiogramma transtoracico (TTE) d'emergenza nei pazienti con sospetta sindrome coronarica acuta (SCA) che presentano shock cardiogeno o sospette complicanze meccaniche.",
  "intent": "Garantire una rapida valutazione ecocardiografica per identificare cause trattabili di instabilità emodinamica e complicanze meccaniche potenzialmente letali nei pazienti con sospetta SCA.",
  "rationale": "Lo shock cardiogeno e le complicanze meccaniche (rottura del setto interventricolare, rottura della parete libera, insufficienza mitralica acuta) sono condizioni ad alto rischio di mortalità che richiedono una diagnosi immediata per guidare la strategia terapeutica, chirurgica o interventistica. La TTE d'emergenza consente una valutazione rapida e non invasiva della funzione ventricolare, dell'integrità strutturale cardiaca e della presenza di versamento pericardico o tamponamento.",
  "source_references": [
    {
      "source_id": "ESC-STEMI-2023",
      "source_level": "international",
      "issuer": "European Society of Cardiology (ESC)",
      "document_title": "2023 ESC Guidelines for the management of acute coronary syndromes",
      "document_version": "2023",
      "publication_date": "2023-08-25",
      "section_reference": "Sezione Imaging – Raccomandazioni per ecocardiografia in SCA",
      "page_reference": null,
      "statement_quote": "Emergency TTE is recommended in patients with suspected ACS presenting with cardiogenic shock or suspected mechanical complications.",
      "citation_uri": "https://doi.org/10.1093/eurheartj/ehad191",
      "license_note": "Contenuto utilizzato a fini clinici e di implementazione PDTA. Riferimento alle linee guida ESC 2023 per SCA."
    }
  ],
  "applicability": {
    "population_description": "Pazienti adulti con sospetta sindrome coronarica acuta (SCA), incluso STEMI, che presentano segni di shock cardiogeno o sospette complicanze meccaniche.",
    "clinical_context": "Sindrome coronarica acuta (SCA / STEMI) complicata da instabilità emodinamica (shock cardiogeno) o sospette complicanze meccaniche post-infarto.",
    "care_context": "Fase acuta dell'emergenza: pronto soccorso, UTIC o qualsiasi setting di prima valutazione del paziente critico con sospetta SCA.",
    "inclusion_criteria": [
      {
        "criterion_id": "STEMI-DO-010-INC-01",
        "label": "Sospetta sindrome coronarica acuta",
        "description": "Il paziente presenta segni e/o sintomi clinici compatibili con una sindrome coronarica acuta (dolore toracico, alterazioni ECG, elevazione dei marcatori di necrosi miocardica).",
        "logic_expression": "diagnosis.suspected == 'SCA' OR ecg.ste_elevation == true OR troponin.elevated == true",
        "data_elements": [
          "DE-STEMI-010-01",
          "DE-STEMI-010-02",
          "DE-STEMI-010-03"
        ],
        "inference_allowed": true
      },
      {
        "criterion_id": "STEMI-DO-010-INC-02",
        "label": "Shock cardiogeno",
        "description": "Il paziente presenta segni clinici di shock cardiogeno: ipotensione persistente (PAS < 90 mmHg), segni di ipoperfusione periferica, necessità di supporto con vasopressori/inotropi, o evidenza di congestione polmonare.",
        "logic_expression": "systolic_bp < 90 OR vasopressor_use == true OR signs_of_hypoperfusion == true",
        "data_elements": [
          "DE-STEMI-010-04",
          "DE-STEMI-010-05",
          "DE-STEMI-010-06"
        ],
        "inference_allowed": true
      },
      {
        "criterion_id": "STEMI-DO-010-INC-03",
        "label": "Sospette complicanze meccaniche",
        "description": "Il paziente presenta segni clinici sospetti di complicanze meccaniche post-infarto: soffio cardiaco di nuova insorgenza, deterioramento emodinamico improvviso, sospetto tamponamento cardiaco, sospetta rottura del setto interventricolare o della parete libera.",
        "logic_expression": "new_murmur == true OR sudden_hemodynamic_deterioration == true OR suspected_tamponade == true OR suspected_vsd == true OR suspected_free_wall_rupture == true",
        "data_elements": [
          "DE-STEMI-010-07",
          "DE-STEMI-010-08",
          "DE-STEMI-010-09"
        ],
        "inference_allowed": true
      }
    ],
    "exclusion_criteria": [
      {
        "criterion_id": "STEMI-DO-010-EXC-01",
        "label": "Paziente già sottoposto a TTE d'emergenza recente",
        "description": "Il paziente è già stato sottoposto a TTE d'emergenza durante lo stesso episodio clinico con risultati completi e conclusivi che hanno già guidato la decisione terapeutica.",
        "logic_expression": "tte_emergency.completed_in_current_episode == true AND tte_results.conclusive == true",
        "data_elements": [
          "DE-STEMI-010-10"
        ],
        "inference_allowed": false
      }
    ]
  },
  "trigger": {
    "trigger_type": "diagnostic_finding",
    "trigger_description": "Identificazione di un paziente con sospetta SCA che presenta segni clinici di shock cardiogeno (ipotensione, ipoperfusione, necessità di supporto emodinamico) oppure segni sospetti di complicanze meccaniche post-infarto (soffio di nuova insorgenza, deterioramento emodinamico improvviso, sospetto tamponamento).",
    "anchor_event": "riconoscimento_shock_cardiogeno_o_complicanza_meccanica",
    "start_of_applicability": "Dal momento in cui viene identificato lo shock cardiogeno o la sospetta complicanza meccanica nel paziente con sospetta SCA.",
    "end_of_applicability": "Fino al completamento della TTE d'emergenza con referto conclusivo o fino alla risoluzione dello stato clinico che ha generato il trigger.",
    "trigger_data_elements": [
      "DE-STEMI-010-04",
      "DE-STEMI-010-05",
      "DE-STEMI-010-06",
      "DE-STEMI-010-07",
      "DE-STEMI-010-08",
      "DE-STEMI-010-09"
    ],
    "inference_allowed": true
  },
  "exceptions": [
    {
      "exception_id": "STEMI-DO-010-EXP-01",
      "label": "Indisponibilità apparecchiatura ecocardiografica",
      "description": "L'apparecchiatura ecocardiografica non è disponibile o non funzionante nella sede in cui si trova il paziente, e il trasferimento immediato verso una sede dotata di ecografo è già in corso.",
      "condition_logic": "tte_equipment.available == false AND patient_transfer.in_progress == true",
      "required_justification": true,
      "required_evidence": [
        "Documentazione dell'indisponibilità dell'apparecchiatura",
        "Documentazione dell'attivazione del trasferimento verso centro con disponibilità ecocardiografica"
      ]
    },
    {
      "exception_id": "STEMI-DO-010-EXP-02",
      "label": "Paziente in arresto cardiaco con RCP in corso",
      "description": "Il paziente è in arresto cardiaco e le manovre di rianimazione cardiopolmonare (RCP) sono in corso; la TTE può essere posticipata o eseguita con modalità point-of-care focalizzata durante le pause della RCP.",
      "condition_logic": "cardiac_arrest == true AND cpr_in_progress == true",
      "required_justification": true,
      "required_evidence": [
        "Documentazione dello stato di arresto cardiaco",
        "Registrazione temporale delle manovre di RCP"
      ]
    },
    {
      "exception_id": "STEMI-DO-010-EXP-03",
      "label": "Trasferimento immediato in sala di emodinamica",
      "description": "Il paziente viene trasferito immediatamente in sala di emodinamica per coronarografia/PCI primaria e la TTE verrà eseguita contestualmente o immediatamente dopo la procedura.",
      "condition_logic": "cath_lab_transfer.immediate == true AND tte_planned_periprocedural == true",
      "required_justification": true,
      "required_evidence": [
        "Documentazione dell'attivazione della sala di emodinamica",
        "Piano documentato per esecuzione TTE peri-procedurale"
      ]
    }
  ],
  "expected_action": {
    "action_verb": "eseguire",
    "action_description": "Eseguire un ecocardiogramma transtoracico (TTE) d'emergenza per valutare la funzione ventricolare sinistra e destra, identificare eventuali complicanze meccaniche (difetto del setto interventricolare, rottura della parete libera, insufficienza mitralica acuta, tamponamento cardiaco) e guidare la gestione emodinamica del paziente.",
    "action_target": "ecocardiogramma transtoracico (TTE) d'emergenza",
    "action_parameters": [
      {
        "parameter_name": "modalità",
        "parameter_description": "Tipo di ecocardiografia da eseguire.",
        "expected_value": "transtoracica (TTE)",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "urgenza",
        "parameter_description": "Livello di urgenza dell'esecuzione dell'esame.",
        "expected_value": "emergenza",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "valutazione_funzione_ventricolare",
        "parameter_description": "L'esame deve includere la valutazione della funzione sistolica ventricolare sinistra e destra.",
        "expected_value": "sì",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "ricerca_complicanze_meccaniche",
        "parameter_description": "L'esame deve includere la ricerca attiva di complicanze meccaniche: rottura del setto interventricolare, rottura della parete libera, insufficienza mitralica acuta, versamento pericardico/tamponamento.",
        "expected_value": "sì",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      }
    ],
    "alternative_compliant_actions": [
      "Ecocardiografia point-of-care (POCUS) focalizzata se la TTE completa non è immediatamente eseguibile, seguita da TTE completa appena possibile",
      "Ecocardiografia transesofagea (TEE) d'emergenza se la finestra acustica transtoracica è inadeguata"
    ]
  },
  "completion_criteria": {
    "description": "La regola è soddisfatta quando l'ecocardiogramma transtoracico d'emergenza è stato eseguito, con referto che documenti la funzione ventricolare e l'eventuale presenza o assenza di complicanze meccaniche.",
    "minimum_occurrences": 1,
    "required_event_types": [
      "ordine_tte_emergenza",
      "esecuzione_tte_emergenza",
      "referto_tte_emergenza"
    ],
    "required_documentation_elements": [
      "Referto ecocardiografico con valutazione della funzione ventricolare sinistra (FEVS)",
      "Valutazione della funzione ventricolare destra",
      "Valutazione della presenza/assenza di complicanze meccaniche",
      "Valutazione del versamento pericardico",
      "Firma e timestamp del cardiologo ecocardiografista"
    ],
    "success_condition": "TTE d'emergenza eseguita con referto completo che includa funzione biventricolare e screening delle complicanze meccaniche, documentato nel sistema informativo clinico."
  },
  "time_constraints": [
    {
      "constraint_id": "STEMI-DO-010-TC-01",
      "description": "La TTE d'emergenza deve essere eseguita il prima possibile e comunque entro un breve intervallo temporale dal riconoscimento dello shock cardiogeno o della sospetta complicanza meccanica.",
      "relation_to_anchor": "immediate",
      "anchor_event": "riconoscimento_shock_cardiogeno_o_complicanza_meccanica",
      "duration_value": 30,
      "duration_unit": "minuti",
      "hard_deadline": false,
      "alert_threshold_value": 15,
      "alert_threshold_unit": "minuti"
    }
  ],
  "sequence_constraints": [
    {
      "constraint_id": "STEMI-DO-010-SC-01",
      "description": "L'identificazione dello shock cardiogeno o della sospetta complicanza meccanica deve precedere la richiesta e l'esecuzione della TTE d'emergenza.",
      "predecessor_event": "riconoscimento_shock_cardiogeno_o_complicanza_meccanica",
      "successor_event": "esecuzione_tte_emergenza",
      "allowed_order": "predecessor_first",
      "violation_condition": "La TTE d'emergenza risulta eseguita senza una documentata valutazione clinica precedente che identifichi lo shock cardiogeno o la complicanza meccanica sospetta."
    },
    {
      "constraint_id": "STEMI-DO-010-SC-02",
      "description": "Il referto della TTE d'emergenza deve essere disponibile prima o contestualmente alla decisione terapeutica definitiva (chirurgia, PCI, supporto meccanico circolatorio).",
      "predecessor_event": "referto_tte_emergenza",
      "successor_event": "decisione_terapeutica_definitiva",
      "allowed_order": "predecessor_first",
      "violation_condition": "La decisione terapeutica definitiva per la gestione della complicanza meccanica o dello shock viene presa senza che il referto TTE sia disponibile."
    }
  ],
  "required_data_elements": [
    {
      "data_element_id": "DE-STEMI-010-01",
      "name": "Sospetto diagnostico di SCA",
      "description": "Presenza di un sospetto clinico di sindrome coronarica acuta basato su anamnesi, sintomi, ECG e/o marcatori biochimici.",
      "source_location": "ehr_structured",
      "data_type": "boolean",
      "coding_system": "ICD-10 (I21.x, I24.x)",
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Cercare diagnosi di ingresso o sospetto di SCA/STEMI/NSTEMI nel registro di accettazione PS."
    },
    {
      "data_element_id": "DE-STEMI-010-02",
      "name": "Sopraslivellamento del tratto ST all'ECG",
      "description": "Presenza di sopraslivellamento del tratto ST all'elettrocardiogramma compatibile con STEMI.",
      "source_location": "ehr_structured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": false,
      "extraction_method": "deterministic",
      "query_hint": "Verificare referto ECG per presenza di sopraslivellamento ST."
    },
    {
      "data_element_id": "DE-STEMI-010-03",
      "name": "Troponina elevata",
      "description": "Valore di troponina cardiaca (I o T, ad alta sensibilità) superiore al 99° percentile del limite superiore di riferimento.",
      "source_location": "ehr_structured",
      "data_type": "numeric",
      "coding_system": "LOINC",
      "required_for_evaluation": false,
      "extraction_method": "deterministic",
      "query_hint": "Cercare risultato di laboratorio per troponina I hs o troponina T hs."
    },
    {
      "data_element_id": "DE-STEMI-010-04",
      "name": "Pressione arteriosa sistolica",
      "description": "Valore della pressione arteriosa sistolica del paziente al momento della valutazione.",
      "source_location": "ehr_structured",
      "data_type": "numeric",
      "coding_system": "LOINC",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Verificare parametri vitali per PAS < 90 mmHg."
    },
    {
      "data_element_id": "DE-STEMI-010-05",
      "name": "Utilizzo di vasopressori/inotropi",
      "description": "Indicazione se il paziente ha ricevuto o necessita di supporto farmacologico con vasopressori o inotropi.",
      "source_location": "ehr_structured",
      "data_type": "boolean",
      "coding_system": "ATC",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare prescrizioni/somministrazioni di noradrenalina, dopamina, dobutamina, adrenalina, levosimendan."
    },
    {
      "data_element_id": "DE-STEMI-010-06",
      "name": "Segni di ipoperfusione periferica",
      "description": "Presenza di segni clinici di ipoperfusione: estremità fredde, oliguria, alterazione dello stato di coscienza, lattati elevati.",
      "source_location": "ehr_unstructured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "inferential",
      "query_hint": "Inferire da note cliniche, parametri vitali (diuresi, lattati, GCS) la presenza di segni di ipoperfusione."
    },
    {
      "data_element_id": "DE-STEMI-010-07",
      "name": "Soffio cardiaco di nuova insorgenza",
      "description": "Riscontro all'esame obiettivo di un soffio cardiaco non precedentemente documentato.",
      "source_location": "ehr_unstructured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "inferential",
      "query_hint": "Cercare nelle note cliniche e nell'esame obiettivo menzione di soffio cardiaco di nuova insorgenza."
    },
    {
      "data_element_id": "DE-STEMI-010-08",
      "name": "Deterioramento emodinamico improvviso",
      "description": "Evento di deterioramento emodinamico acuto e improvviso durante l'episodio di cura.",
      "source_location": "ehr_unstructured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "inferential",
      "query_hint": "Cercare nelle note cliniche e nei parametri vitali un rapido peggioramento emodinamico."
    },
    {
      "data_element_id": "DE-STEMI-010-09",
      "name": "Sospetto di tamponamento cardiaco",
      "description": "Sospetto clinico di tamponamento cardiaco basato su segni clinici (toni cardiaci ovattati, distensione giugulare, ipotensione).",
      "source_location": "ehr_unstructured",
      "data_type": "boolean",
      "coding_system": "ICD-10 (I31.4)",
      "required_for_evaluation": true,
      "extraction_method": "inferential",
      "query_hint": "Cercare nelle note cliniche segni o sospetto di tamponamento cardiaco."
    },
    {
      "data_element_id": "DE-STEMI-010-10",
      "name": "TTE d'emergenza già eseguita nell'episodio corrente",
      "description": "Indicazione che una TTE d'emergenza completa e conclusiva è già stata eseguita durante l'episodio clinico in corso.",
      "source_location": "ehr_structured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare ordine e referto di TTE d'emergenza con timestamp nell'episodio corrente."
    },
    {
      "data_element_id": "DE-STEMI-010-11",
      "name": "Ordine di TTE d'emergenza",
      "description": "Ordine clinico per l'esecuzione di ecocardiogramma transtoracico in regime d'emergenza.",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": "codice prestazione locale / ICD-9-CM 88.72",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare ordine di ecocardiografia TT con priorità urgente/emergenza."
    },
    {
      "data_element_id": "DE-STEMI-010-12",
      "name": "Referto TTE d'emergenza",
      "description": "Referto dell'ecocardiogramma transtoracico d'emergenza con valutazione della funzione ventricolare e delle complicanze meccaniche.",
      "source_location": "ehr_structured",
      "data_type": "text",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Cercare referto ecocardiografico con timestamp compatibile con l'episodio corrente."
    },
    {
      "data_element_id": "DE-STEMI-010-13",
      "name": "Timestamp esecuzione TTE d'emergenza",
      "description": "Data e ora di esecuzione dell'ecocardiogramma transtoracico d'emergenza.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Recuperare il timestamp dall'ordine eseguito o dal referto TTE."
    }
  ],
  "evidence_of_compliance": [
    {
      "evidence_id": "STEMI-DO-010-EOC-01",
      "description": "Presenza di un ordine di TTE d'emergenza emesso dopo il riconoscimento dello shock cardiogeno o della complicanza meccanica sospetta.",
      "evidence_type": "order",
      "minimum_occurrences": 1,
      "time_reference": "Entro breve tempo dal riconoscimento dello shock cardiogeno o della complicanza meccanica.",
      "derived_from_data_elements": [
        "DE-STEMI-010-11",
        "DE-STEMI-010-13"
      ]
    },
    {
      "evidence_id": "STEMI-DO-010-EOC-02",
      "description": "Presenza di un referto di TTE d'emergenza completo con valutazione della funzione biventricolare e delle complicanze meccaniche.",
      "evidence_type": "result",
      "minimum_occurrences": 1,
      "time_reference": "Durante l'episodio di cura, successivamente al trigger.",
      "derived_from_data_elements": [
        "DE-STEMI-010-12",
        "DE-STEMI-010-13"
      ]
    },
    {
      "evidence_id": "STEMI-DO-010-EOC-03",
      "description": "Timestamp dell'esecuzione della TTE d'emergenza documentato nel sistema informativo clinico.",
      "evidence_type": "timestamp",
      "minimum_occurrences": 1,
      "time_reference": "Dopo il riconoscimento dello shock/complicanza meccanica.",
      "derived_from_data_elements": [
        "DE-STEMI-010-13"
      ]
    }
  ],
  "evidence_of_non_compliance": [
    {
      "evidence_id": "STEMI-DO-010-EONC-01",
      "description": "Assenza di ordine di TTE d'emergenza nel paziente con shock cardiogeno o sospetta complicanza meccanica durante l'episodio.",
      "evidence_type": "absence_of_event",
      "minimum_occurrences": 1,
      "time_reference": "Durante l'intero episodio di cura dal momento del trigger.",
      "derived_from_data_elements": [
        "DE-STEMI-010-11"
      ]
    },
    {
      "evidence_id": "STEMI-DO-010-EONC-02",
      "description": "Assenza di referto di TTE d'emergenza nel paziente con shock cardiogeno o sospetta complicanza meccanica.",
      "evidence_type": "absence_of_event",
      "minimum_occurrences": 1,
      "time_reference": "Durante l'intero episodio di cura dal momento del trigger.",
      "derived_from_data_elements": [
        "DE-STEMI-010-12"
      ]
    },
    {
      "evidence_id": "STEMI-DO-010-EONC-03",
      "description": "TTE d'emergenza eseguita con significativo ritardo rispetto al riconoscimento dello shock cardiogeno o della complicanza meccanica, senza giustificazione documentata.",
      "evidence_type": "timestamp",
      "minimum_occurrences": 1,
      "time_reference": "Timestamp TTE > 30 minuti dopo il riconoscimento del trigger, senza eccezione documentata.",
      "derived_from_data_elements": [
        "DE-STEMI-010-13"
      ]
    }
  ],
  "evaluation_logic": {
    "natural_language_test": "Per un paziente con sospetta SCA che presenta shock cardiogeno o sospette complicanze meccaniche: verificare che sia stato emesso un ordine di TTE d'emergenza e che il relativo referto, completo di valutazione della funzione biventricolare e delle complicanze meccaniche, sia stato prodotto durante l'episodio di cura. In caso di assenza dell'esame o del referto, e in assenza di eccezione documentata, la regola risulta non conforme.",
    "formal_expression_language": "pseudocode",
    "formal_expression": "IF (suspected_acs == TRUE) AND (cardiogenic_shock == TRUE OR suspected_mechanical_complication == TRUE) THEN IF (tte_emergency_order EXISTS AND tte_emergency_report EXISTS AND tte_report.includes_biventricular_function AND tte_report.includes_mechanical_complication_screening) THEN status = 'compliant' ELSE IF (documented_exception EXISTS) THEN status = 'justified_deviation' ELSE status = 'non_compliant'",
    "missing_data_policy": "review_required",
    "ambiguity_policy": "review_required",
    "conflict_resolution_policy": "human_review",
    "notes": "La valutazione dello shock cardiogeno e delle complicanze meccaniche sospette può richiedere inferenza da testo libero (note cliniche, esame obiettivo). In caso di dati mancanti o ambigui è necessaria la revisione umana. La tempistica dell'esame è un indicatore di qualità ma il vincolo temporale non è hard deadline dato che la raccomandazione indica l'urgenza senza specificare un intervallo cronometrico preciso."
  },
  "evaluation_method": {
    "primary_method": "hybrid",
    "allowed_inference_sources": [
      "note cliniche di pronto soccorso",
      "note cliniche UTIC",
      "referti ecocardiografici",
      "esame obiettivo documentato",
      "parametri vitali",
      "fogli di terapia",
      "registro ordini clinici"
    ],
    "human_review_required": true,
    "minimum_confidence": 0.85,
    "notes": "L'identificazione dello shock cardiogeno è spesso deterministica (parametri vitali, farmaci vasoattivi), ma le complicanze meccaniche sospette richiedono frequentemente inferenza da testo libero. Il referto TTE è generalmente strutturato ma può necessitare di NLP per estrarre i campi specifici relativi alle complicanze meccaniche."
  },
  "possible_outcomes": [
    "compliant",
    "non_compliant",
    "justified_deviation",
    "not_applicable",
    "not_evaluable",
    "probable_non_compliance"
  ],
  "risk_classification": {
    "clinical_risk_severity": "critical",
    "process_risk_severity": "high",
    "likelihood_if_violated": "likely",
    "detectability": "moderate",
    "priority_score": 9,
    "rationale": "La mancata esecuzione della TTE d'emergenza in un paziente con shock cardiogeno o complicanze meccaniche sospette può comportare un ritardo diagnostico fatale. Le complicanze meccaniche post-infarto (rottura del setto, rottura della parete libera, insufficienza mitralica acuta) richiedono un intervento chirurgico o interventistico urgente, e il loro mancato riconoscimento è associato a mortalità estremamente elevata."
  },
  "documentation_requirements": {
    "mandatory_fields": [
      "Ordine di TTE d'emergenza con timestamp",
      "Referto ecocardiografico completo",
      "Valutazione della funzione ventricolare sinistra (FEVS)",
      "Valutazione della funzione ventricolare destra",
      "Screening delle complicanze meccaniche",
      "Valutazione del versamento pericardico",
      "Identificazione dell'operatore e firma digitale",
      "Timestamp di esecuzione dell'esame"
    ],
    "acceptable_evidence_sources": [
      "Sistema informativo di cardiologia / ecocardiografia",
      "Cartella clinica elettronica (PS, UTIC)",
      "Registro ordini clinici",
      "Referto firmato digitalmente",
      "Immagini ecocardiografiche archiviate nel PACS"
    ],
    "justification_required_when_deviating": true,
    "justification_fields": [
      "Nota clinica con motivazione della mancata esecuzione della TTE d'emergenza",
      "Documentazione dell'eccezione applicata (indisponibilità apparecchiatura, arresto cardiaco, trasferimento immediato in emodinamica)",
      "Piano alternativo documentato"
    ],
    "free_text_allowed": true
  },
  "associated_weak_signal_ids": [
    "STEMI-WS-010-01",
    "STEMI-WS-010-02",
    "STEMI-WS-010-03"
  ],
  "extraction_metadata": {
    "generation_mode": "llm_inference",
    "source_interpretation_notes": "La raccomandazione originale utilizza il verbo 'is recommended' che corrisponde a una classe di raccomandazione I (forte raccomandazione, da eseguire). Il termine 'emergency' è stato interpretato come necessità di esecuzione urgente e non differibile. Il termine 'suspected ACS' include STEMI e NSTEMI, ma nel contesto del PDTA STEMI la regola è applicata primariamente ai pazienti STEMI. Il vincolo temporale specifico (30 minuti) è stato aggiunto come parametro operativo plausibile in quanto non esplicitamente indicato nella raccomandazione originale.",
    "extraction_confidence": 0.92,
    "ambiguity_flags": [
      "Il vincolo temporale di 30 minuti non è esplicitamente indicato nella linea guida originale ed è stato stimato come parametro operativo ragionevole.",
      "La definizione di 'suspected mechanical complications' è ampia e può richiedere interpretazione clinica contestuale.",
      "Il livello di evidenza C è stato assegnato in modo plausibile ma potrebbe variare nella specifica raccomandazione della linea guida."
    ],
    "human_validation_status": "not_reviewed",
    "validated_by": null,
    "validated_at": null
  },
  "governance_metadata": {
    "lifecycle_status": "draft",
    "version": "1.0.0",
    "authoring_body": "Gruppo di Lavoro PDTA STEMI - Clinical Pathway Engineering",
    "rule_owner": "Responsabile clinico PDTA STEMI",
    "effective_from": null,
    "effective_to": null,
    "review_cycle": "12 mesi",
    "last_reviewed_at": null,
    "approved_by": null
  }
}
$json_STEMI_DO_010$::jsonb)
ON CONFLICT (clinical_pathway_id, name) DO UPDATE
SET body = EXCLUDED.body;

INSERT INTO riskm_manager_model_evaluation.rule_definition (clinical_pathway_id, name, body)
VALUES (1, 'STEMI-DONOT-001', $json_STEMI_DONOT_001$
{
  "schema_version": "1.0.0",
  "rule_id": "STEMI-DONOT-001",
  "rule_type": "do_not",
  "title": "Non eseguire di routine angio-TC coronarica precoce nei pazienti con sospetta sindrome coronarica acuta",
  "short_label": "No angio-TC coronarica di routine in SCA sospetta",
  "clinical_pathway_id": "PDTA-STEMI-001",
  "clinical_pathway_name": "Percorso Diagnostico Terapeutico Assistenziale per STEMI",
  "clinical_phase": "diagnosi",
  "care_settings": [
    "Pronto Soccorso",
    "Dipartimento di Emergenza e Accettazione",
    "Unità di Terapia Intensiva Coronarica"
  ],
  "responsible_actors": [
    {
      "role_name": "Medico di Pronto Soccorso",
      "responsibility_type": "primary",
      "organization_unit": "Pronto Soccorso",
      "notes": "Responsabile primario della fase diagnostica iniziale e della decisione di non richiedere angio-TC coronarica di routine."
    },
    {
      "role_name": "Cardiologo di guardia",
      "responsibility_type": "consulted",
      "organization_unit": "Cardiologia / UTIC",
      "notes": "Consultato per la stratificazione diagnostica e per eventuali eccezioni cliniche alla regola."
    },
    {
      "role_name": "Radiologo interventista",
      "responsibility_type": "informed",
      "organization_unit": "Radiologia",
      "notes": "Informato della politica di non esecuzione routinaria per evitare richieste inappropriate."
    }
  ],
  "deontic_strength": "recommended",
  "recommendation_strength": "Classe III (nessun beneficio)",
  "evidence_level": "C",
  "original_statement": "Routine, early coronary computed tomography angiography in patients with suspected ACS is not recommended.",
  "normalized_statement": "Non è raccomandata l'esecuzione routinaria e precoce di angio-TC coronarica nei pazienti con sospetta sindrome coronarica acuta.",
  "intent": "Evitare l'uso inappropriato e routinario della angio-TC coronarica nella fase acuta della gestione dei pazienti con sospetta SCA, al fine di non ritardare il trattamento riperfusivo e di non esporre il paziente a rischi inutili.",
  "rationale": "Nei pazienti con sospetta sindrome coronarica acuta (SCA), l'angio-TC coronarica eseguita di routine in fase precoce non apporta benefici diagnostici incrementali significativi rispetto al percorso standard basato su ECG, biomarcatori cardiaci e coronarografia invasiva. Inoltre, può ritardare i tempi di riperfusione, esporre il paziente a mezzo di contrasto iodato e radiazioni ionizzanti non necessari e sottrarre risorse diagnostiche ad altri pazienti.",
  "source_references": [
    {
      "source_id": "ESC-GUIDELINES-ACS-2023",
      "source_level": "international",
      "issuer": "European Society of Cardiology (ESC)",
      "document_title": "2023 ESC Guidelines for the management of acute coronary syndromes",
      "document_version": "2023",
      "publication_date": "2023-08-25",
      "section_reference": "Sezione raccomandazioni diagnostiche - Imaging non invasivo",
      "page_reference": null,
      "statement_quote": "Routine, early coronary computed tomography angiography in patients with suspected ACS is not recommended.",
      "citation_uri": "https://doi.org/10.1093/eurheartj/ehad191",
      "license_note": "Contenuto soggetto a copyright ESC. Utilizzo a fini clinici e di implementazione locale del PDTA."
    }
  ],
  "applicability": {
    "population_description": "Pazienti adulti che si presentano con sospetta sindrome coronarica acuta (SCA), inclusi STEMI, NSTEMI e angina instabile, nella fase diagnostica iniziale.",
    "clinical_context": "Sospetta sindrome coronarica acuta in fase acuta, incluso lo STEMI, dove la priorità è la conferma diagnostica rapida e l'avvio tempestivo della strategia riperfusiva.",
    "care_context": "Pronto Soccorso, Dipartimento di Emergenza e Accettazione, fase diagnostica pre-coronarografia.",
    "inclusion_criteria": [
      {
        "criterion_id": "INC-001",
        "label": "Sospetta SCA",
        "description": "Il paziente presenta segni, sintomi o referti compatibili con una sindrome coronarica acuta (dolore toracico, alterazioni ECG, elevazione dei biomarcatori cardiaci).",
        "logic_expression": "diagnosis.suspected IN ('STEMI', 'NSTEMI', 'UA') OR ecg.ischemic_changes = true OR troponin.elevated = true",
        "data_elements": [
          "DE-001",
          "DE-002",
          "DE-003"
        ],
        "inference_allowed": true
      },
      {
        "criterion_id": "INC-002",
        "label": "Fase precoce della presentazione",
        "description": "Il paziente si trova nella fase precoce dell'episodio acuto, prima dell'esecuzione della coronarografia invasiva o della definizione completa della strategia terapeutica.",
        "logic_expression": "time_since_presentation <= 24h AND coronary_angiography.status != 'completed'",
        "data_elements": [
          "DE-004",
          "DE-005"
        ],
        "inference_allowed": false
      }
    ],
    "exclusion_criteria": [
      {
        "criterion_id": "EXC-001",
        "label": "Diagnosi alternativa confermata",
        "description": "Il paziente ha ricevuto una diagnosi alternativa definitiva che esclude la SCA (es. embolia polmonare, dissecazione aortica confermata con altra metodica).",
        "logic_expression": "diagnosis.confirmed NOT IN ('STEMI', 'NSTEMI', 'UA') AND diagnosis.alternative_confirmed = true",
        "data_elements": [
          "DE-001"
        ],
        "inference_allowed": true
      }
    ]
  },
  "trigger": {
    "trigger_type": "order",
    "trigger_description": "Richiesta o prescrizione di angio-TC coronarica in un paziente con sospetta sindrome coronarica acuta in fase precoce.",
    "anchor_event": "Presentazione in Pronto Soccorso con sospetta SCA",
    "start_of_applicability": "Dal momento della presentazione del paziente con sospetta SCA.",
    "end_of_applicability": "Fino alla definizione diagnostica definitiva o all'esecuzione della coronarografia invasiva.",
    "trigger_data_elements": [
      "DE-006",
      "DE-001"
    ],
    "inference_allowed": true
  },
  "exceptions": [
    {
      "exception_id": "EXP-001",
      "label": "Coronarografia invasiva controindicata",
      "description": "L'angio-TC coronarica può essere considerata quando la coronarografia invasiva è controindicata o non disponibile e vi è necessità clinica urgente di definizione anatomica coronarica.",
      "condition_logic": "coronary_angiography.contraindicated = true OR cath_lab.available = false",
      "required_justification": true,
      "required_evidence": [
        "Documentazione della controindicazione alla coronarografia invasiva",
        "Valutazione collegiale cardiologo-radiologo",
        "Nota clinica motivata nel verbale di PS"
      ]
    },
    {
      "exception_id": "EXP-002",
      "label": "Probabilità pre-test bassa/intermedia con diagnosi incerta",
      "description": "In casi selezionati con probabilità pre-test bassa o intermedia di SCA e diagnosi ancora incerta dopo ECG e biomarcatori iniziali, l'angio-TC coronarica può essere considerata come alternativa dopo consulenza cardiologica.",
      "condition_logic": "pretest_probability IN ('low', 'intermediate') AND ecg.diagnostic = false AND troponin.serial_negative = true",
      "required_justification": true,
      "required_evidence": [
        "ECG seriali non diagnostici",
        "Troponina seriata negativa",
        "Consulenza cardiologica documentata",
        "Score di rischio calcolato (es. HEART score)"
      ]
    }
  ],
  "prohibited_action": {
    "action_verb": "richiedere",
    "action_description": "Richiedere o eseguire di routine e in fase precoce un'angio-TC coronarica (coronary computed tomography angiography, CCTA) nei pazienti con sospetta sindrome coronarica acuta.",
    "action_target": "Angio-TC coronarica (CCTA)",
    "prohibition_parameters": [
      {
        "parameter_name": "modalità di utilizzo",
        "parameter_description": "L'esame è proibito quando richiesto in modalità routinaria e non selettiva.",
        "expected_value": "routine",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      },
      {
        "parameter_name": "tempistica",
        "parameter_description": "La proibizione riguarda specificamente la fase precoce dell'episodio acuto.",
        "expected_value": "precoce",
        "comparison_operator": "equals",
        "unit": null,
        "mandatory": true
      }
    ],
    "known_risk_if_performed": "Ritardo nella strategia riperfusiva (aumento del tempo door-to-balloon), esposizione non necessaria a mezzo di contrasto iodato e radiazioni ionizzanti, falsa rassicurazione o ritardo diagnostico, spreco di risorse diagnostiche."
  },
  "override_conditions": [
    {
      "exception_id": "OVR-001",
      "label": "Override per controindicazione alla coronarografia invasiva",
      "description": "L'angio-TC coronarica può essere eseguita se la coronarografia invasiva è controindicata o non disponibile e sussiste necessità clinica urgente.",
      "condition_logic": "coronary_angiography.contraindicated = true OR cath_lab.available = false",
      "required_justification": true,
      "required_evidence": [
        "Documentazione della controindicazione alla coronarografia invasiva nel verbale clinico",
        "Consulenza cardiologica documentata"
      ]
    },
    {
      "exception_id": "OVR-002",
      "label": "Override per decisione collegiale in caso dubbio",
      "description": "Decisione motivata e collegiale tra cardiologo e medico d'urgenza in caso di diagnosi differenziale complessa dove l'angio-TC può fornire informazioni decisive.",
      "condition_logic": "collegial_decision = true AND clinical_justification.documented = true",
      "required_justification": true,
      "required_evidence": [
        "Nota clinica collegiale firmata",
        "Motivazione esplicita della necessità dell'esame"
      ]
    }
  ],
  "override_justification_requirements": {
    "mandatory": true,
    "required_fields": [
      "Motivazione clinica dell'override nel verbale di Pronto Soccorso",
      "Nome e qualifica del medico autorizzante",
      "Data e ora della decisione",
      "Esito della consulenza cardiologica"
    ],
    "required_evidence_sources": [
      "Verbale di Pronto Soccorso",
      "Consulenza cardiologica",
      "Cartella clinica elettronica"
    ],
    "notes": "L'override deve essere sempre documentato prima dell'esecuzione dell'esame. La motivazione deve essere clinicamente fondata e non basata su sola preferenza del clinico."
  },
  "time_constraints": [
    {
      "constraint_id": "TC-001",
      "description": "La proibizione è attiva dalla presentazione del paziente in PS fino alla definizione diagnostica o all'esecuzione della coronarografia invasiva, tipicamente entro le prime 24 ore.",
      "relation_to_anchor": "within",
      "anchor_event": "Presentazione in Pronto Soccorso con sospetta SCA",
      "duration_value": 24,
      "duration_unit": "ore",
      "hard_deadline": false,
      "alert_threshold_value": null,
      "alert_threshold_unit": null
    }
  ],
  "sequence_constraints": [
    {
      "constraint_id": "SC-001",
      "description": "L'angio-TC coronarica non deve essere eseguita prima della valutazione clinica completa (ECG, biomarcatori) e della consulenza cardiologica nei pazienti con sospetta SCA.",
      "predecessor_event": "Valutazione clinica completa (ECG + biomarcatori + consulenza cardiologica)",
      "successor_event": "Eventuale angio-TC coronarica (solo se override giustificato)",
      "allowed_order": "predecessor_first",
      "violation_condition": "Angio-TC coronarica richiesta o eseguita prima del completamento della valutazione clinica standard."
    }
  ],
  "required_data_elements": [
    {
      "data_element_id": "DE-001",
      "name": "Diagnosi sospetta",
      "description": "Diagnosi clinica sospetta o confermata al momento della presentazione (es. STEMI, NSTEMI, angina instabile, SCA indifferenziata).",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": "ICD-10",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare codici ICD-10 I21.x, I20.0 o diagnosi di triage contenenti 'SCA', 'STEMI', 'infarto'."
    },
    {
      "data_element_id": "DE-002",
      "name": "Referto ECG",
      "description": "Risultato dell'elettrocardiogramma a 12 derivazioni eseguito alla presentazione, con particolare attenzione a sopraslivellamento ST, sottoslivellamento ST, o altre alterazioni ischemiche.",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "hybrid",
      "query_hint": "Cercare referto ECG con interpretazione automatica o manuale; parole chiave: sopraslivellamento ST, STEMI, ischemia."
    },
    {
      "data_element_id": "DE-003",
      "name": "Troponina cardiaca",
      "description": "Valore della troponina cardiaca ad alta sensibilità (hs-cTn) alla presentazione e nei controlli seriati.",
      "source_location": "ehr_structured",
      "data_type": "numeric",
      "coding_system": "LOINC",
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "LOINC 89579-7 (hs-cTnT) o 49563-0 (hs-cTnI). Verificare valore e cut-off del laboratorio locale."
    },
    {
      "data_element_id": "DE-004",
      "name": "Data e ora di presentazione in PS",
      "description": "Timestamp di arrivo del paziente in Pronto Soccorso o primo contatto medico.",
      "source_location": "ehr_structured",
      "data_type": "datetime",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Campo 'data_ora_accettazione' o 'triage_timestamp' nel sistema di PS."
    },
    {
      "data_element_id": "DE-005",
      "name": "Stato coronarografia invasiva",
      "description": "Stato della coronarografia invasiva (non eseguita, programmata, in corso, completata).",
      "source_location": "ehr_structured",
      "data_type": "coded concept",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare ordini o referti di coronarografia nel sistema di emodinamica o nel RIS/PACS."
    },
    {
      "data_element_id": "DE-006",
      "name": "Richiesta angio-TC coronarica",
      "description": "Presenza di una richiesta o ordine per angio-TC coronarica (CCTA) nel sistema informativo.",
      "source_location": "ehr_structured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare ordini radiologici con descrizione 'angio-TC coronarica', 'CCTA', 'TC coronarica' nel RIS o nel sistema ordini."
    },
    {
      "data_element_id": "DE-007",
      "name": "Esecuzione angio-TC coronarica",
      "description": "Evidenza dell'effettiva esecuzione dell'angio-TC coronarica (referto presente nel PACS/RIS).",
      "source_location": "ehr_structured",
      "data_type": "boolean",
      "coding_system": null,
      "required_for_evaluation": true,
      "extraction_method": "deterministic",
      "query_hint": "Cercare referti radiologici con modalità CT e descrizione 'coronarica' o 'CCTA' nel PACS."
    },
    {
      "data_element_id": "DE-008",
      "name": "Documentazione di giustificazione override",
      "description": "Presenza di una nota clinica o documentazione strutturata che giustifica l'eventuale override della proibizione.",
      "source_location": "ehr_unstructured",
      "data_type": "text",
      "coding_system": null,
      "required_for_evaluation": false,
      "extraction_method": "inferential",
      "query_hint": "Cercare nelle note cliniche del verbale di PS parole chiave: 'motivazione', 'controindicazione coronarografia', 'decisione collegiale', 'angio-TC giustificata'."
    }
  ],
  "evidence_of_violation": [
    {
      "evidence_id": "EV-VIOL-001",
      "description": "Presenza di un ordine o di un referto di angio-TC coronarica in un paziente con sospetta SCA nella fase precoce, senza documentazione di override giustificato.",
      "evidence_type": "order",
      "minimum_occurrences": 1,
      "time_reference": "Entro 24 ore dalla presentazione in PS con sospetta SCA",
      "derived_from_data_elements": [
        "DE-006",
        "DE-007",
        "DE-001",
        "DE-004"
      ]
    },
    {
      "evidence_id": "EV-VIOL-002",
      "description": "Referto di angio-TC coronarica completata nel PACS/RIS durante la fase acuta dell'episodio di sospetta SCA.",
      "evidence_type": "execution",
      "minimum_occurrences": 1,
      "time_reference": "Entro 24 ore dalla presentazione in PS con sospetta SCA",
      "derived_from_data_elements": [
        "DE-007",
        "DE-001",
        "DE-004"
      ]
    }
  ],
  "evidence_of_allowed_override": [
    {
      "evidence_id": "EV-OVR-001",
      "description": "Documentazione clinica strutturata o narrativa che attesta la controindicazione alla coronarografia invasiva e la necessità dell'angio-TC coronarica, con firma del cardiologo.",
      "evidence_type": "justification",
      "minimum_occurrences": 1,
      "time_reference": "Prima dell'esecuzione dell'angio-TC coronarica",
      "derived_from_data_elements": [
        "DE-008"
      ]
    },
    {
      "evidence_id": "EV-OVR-002",
      "description": "Nota di consulenza cardiologica che supporta la decisione di eseguire l'angio-TC coronarica come alternativa alla coronarografia invasiva.",
      "evidence_type": "documentation",
      "minimum_occurrences": 1,
      "time_reference": "Prima dell'esecuzione dell'angio-TC coronarica",
      "derived_from_data_elements": [
        "DE-008"
      ]
    }
  ],
  "evaluation_logic": {
    "natural_language_test": "Verificare se è stata richiesta o eseguita un'angio-TC coronarica in un paziente con sospetta SCA nella fase precoce (entro 24 ore dalla presentazione). Se l'esame è stato richiesto o eseguito, verificare la presenza di documentazione di override giustificato (controindicazione alla coronarografia invasiva o decisione collegiale documentata). Se l'esame è stato eseguito senza giustificazione, la regola è violata.",
    "formal_expression_language": "pseudocode",
    "formal_expression": "IF (DE-001.value IN ['STEMI','NSTEMI','SCA','angina_instabile']) AND (DE-006.value = true OR DE-007.value = true) AND (time(DE-006 OR DE-007) - time(DE-004) <= 24h) THEN IF (DE-008.override_justified = true) THEN outcome = 'justified_deviation' ELSE outcome = 'non_compliant' ELSE outcome = 'compliant'",
    "missing_data_policy": "review_required",
    "ambiguity_policy": "review_required",
    "conflict_resolution_policy": "human_review",
    "notes": "Prestare attenzione ai casi in cui la diagnosi sospetta viene modificata durante l'episodio; la regola si applica solo finché la sospetta SCA è attiva. Le angio-TC eseguite per altre indicazioni (es. sospetta dissecazione aortica, embolia polmonare) non costituiscono violazione."
  },
  "evaluation_method": {
    "primary_method": "hybrid",
    "allowed_inference_sources": [
      "Note cliniche di Pronto Soccorso",
      "Verbale di dimissione dal PS",
      "Consulenze cardiologiche",
      "Referti radiologici"
    ],
    "human_review_required": true,
    "minimum_confidence": 0.85,
    "notes": "L'identificazione dell'ordine e dell'esecuzione dell'angio-TC è deterministica tramite dati strutturati. La verifica della giustificazione dell'override può richiedere estrazione inferenziale da testo libero e conferma umana."
  },
  "possible_outcomes": [
    "compliant",
    "non_compliant",
    "justified_deviation",
    "not_applicable",
    "not_evaluable",
    "probable_non_compliance"
  ],
  "risk_classification": {
    "clinical_risk_severity": "moderate",
    "process_risk_severity": "moderate",
    "likelihood_if_violated": "possible",
    "detectability": "easy",
    "priority_score": 6,
    "rationale": "L'esecuzione routinaria di angio-TC coronarica nella fase acuta può ritardare la riperfusione coronarica (aumentando il tempo door-to-balloon), esporre il paziente a mezzo di contrasto e radiazioni non necessari, e consumare risorse diagnostiche. La severità clinica è moderata poiché il danno dipende dall'entità del ritardo e dalle condizioni del paziente. La rilevabilità è elevata perché l'ordine e il referto dell'esame sono facilmente tracciabili nei sistemi informativi."
  },
  "documentation_requirements": {
    "mandatory_fields": [
      "Diagnosi sospetta all'ingresso",
      "ECG a 12 derivazioni",
      "Troponina cardiaca",
      "Eventuali ordini di imaging cardiaco"
    ],
    "acceptable_evidence_sources": [
      "Cartella clinica elettronica di PS",
      "Sistema RIS/PACS",
      "Sistema ordini diagnostici",
      "Consulenze cardiologiche"
    ],
    "justification_required_when_deviating": true,
    "justification_fields": [
      "Nota clinica motivata nel verbale di PS",
      "Consulenza cardiologica con indicazione all'angio-TC",
      "Documentazione della controindicazione alla coronarografia invasiva"
    ],
    "free_text_allowed": true
  },
  "associated_weak_signal_ids": [
    "STEMI-WS-001"
  ],
  "extraction_metadata": {
    "generation_mode": "llm_inference",
    "source_interpretation_notes": "La raccomandazione originale in lingua inglese è stata tradotta e contestualizzata per il PDTA STEMI italiano. Il termine 'routine, early' è stato interpretato come uso non selettivo in fase precoce (entro 24 ore). La raccomandazione è classificata come Classe III (nessun beneficio) secondo la terminologia ESC.",
    "extraction_confidence": 0.92,
    "ambiguity_flags": [
      "Il confine tra uso 'routinario' e uso 'selettivo/mirato' dell'angio-TC può variare tra centri e richiede definizione operativa locale.",
      "La definizione di 'fase precoce' non è quantificata nella fonte originale; è stata interpretata come entro 24 ore dalla presentazione.",
      "La regola copre la SCA in generale (incluso STEMI); verificare se il contesto locale richiede distinzioni più granulari."
    ],
    "human_validation_status": "not_reviewed",
    "validated_by": null,
    "validated_at": null
  },
  "governance_metadata": {
    "lifecycle_status": "draft",
    "version": "1.0.0",
    "authoring_body": "Gruppo di lavoro PDTA STEMI",
    "rule_owner": "Direttore UOC Cardiologia / Responsabile PDTA STEMI",
    "effective_from": null,
    "effective_to": null,
    "review_cycle": "12 mesi",
    "last_reviewed_at": null,
    "approved_by": null
  }
}
$json_STEMI_DONOT_001$::jsonb)
ON CONFLICT (clinical_pathway_id, name) DO UPDATE
SET body = EXCLUDED.body;

COMMIT;

