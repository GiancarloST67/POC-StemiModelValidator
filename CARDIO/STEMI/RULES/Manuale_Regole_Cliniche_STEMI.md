# Manuale delle Regole Cliniche: PDTA STEMI
**Percorso Diagnostico Terapeutico Assistenziale per Infarto Miocardico con Sopraslivellamento del tratto ST**

---

## 1. Controllo Revisioni e Approvazioni (Policy Management)

### 1.1 Storico delle Revisioni

| Versione | Data | Autore / Redazione | Descrizione delle Modifiche |
| :--- | :--- | :--- | :--- |
| 1.0.0 | *[Da definire]* | Team Clinical Pathway STEMI | Prima stesura del documento e inserimento Regola STEMI-DO-001 |

### 1.2 Matrice delle Approvazioni

| Ruolo di Governance | Funzione / Unità Operativa | Firma e Data |
| :--- | :--- | :--- |
| **Redazione / Preparazione** | Clinical Risk Management | |
| **Approvazione Clinica** | Direzione Unità Operativa Complessa (UOC) Cardiologia | |
| **Approvazione Strategica** | Direzione Sanitaria | |

---

## 2. Repository delle Regole Cliniche (Rule Engine)

Di seguito sono riportate le regole cliniche formalizzate, afferenti al monitoraggio della compliance applicabile al PDTA STEMI.

### Regola 1: Valutazione riperfusione STEMI (STEMI-DO-001)

#### 2.1.1 Identificativi della Regola Clinica
- **Codice Univoco:** `STEMI-DO-001`
- **Versione Schema:** 1.0.0
- **Tipologia di Regola:** Azione Raccomandata / Prescrittiva (DO)
- **Titolo Esteso:** Valutazione immediata per strategia di riperfusione d'emergenza nei pazienti con sospetto STEMI
- **Etichetta Breve:** Valutazione riperfusione STEMI
- **ID Percorso Aziendale:** PDTA-STEMI-001
- **Nome Percorso Aziendale:** Percorso Diagnostico Terapeutico Assistenziale per Infarto Miocardico con Sopraslivellamento del tratto ST (STEMI)
- **Fase del Percorso Clinico:** Triage e valutazione iniziale
- **Setting Assistenziale:** Pronto Soccorso, Sistema di Emergenza Territoriale 118, Unità di Terapia Intensiva Cardiologica

#### 2.1.2 Mappa delle Responsabilità

| Ruolo Assistenziale | Tipologia di Responsabilità | Unità Organizzativa | Note Operative |
| :--- | :--- | :--- | :--- |
| **Medico d'emergenza-urgenza** | Primaria | Pronto Soccorso / Dipartimento di Emergenza e Accettazione (DEA) | Responsabile della valutazione clinica iniziale e dell'attivazione della strategia di riperfusione. |
| **Cardiologo interventista** | Consultazione | Laboratorio di Emodinamica / Cardiologia Interventistica | Consulente per la definizione della strategia di riperfusione più appropriata (PCI primaria vs fibrinolisi). |
| **Infermiere di triage** | Supporto | Pronto Soccorso | Supporto nell'identificazione precoce dei pazienti con sospetto STEMI e nell'esecuzione dell'ECG a 12 derivazioni. |
| **Medico del Sistema 118** | Primaria | Centrale Operativa 118 / Ambulanza medicalizzata | Responsabile della valutazione pre-ospedaliera e dell'attivazione del percorso STEMI in fase pre-ospedaliera. |
| **Coordinatore rete STEMI** | Monitoraggio | Rete cardiologica regionale | Supervisione del rispetto dei tempi e delle procedure della rete per lo STEMI. |

#### 2.1.3 Forza della Regola ed Evidenze Scientifiche
- **Grado di Obbligatorietà:** Raccomandata
- **Forza della Raccomandazione Clinica:** Classe I (fortemente raccomandato)
- **Livello di Evidenza Scientifico:** Livello di evidenza B
- **Dichiarazione Originale:** Si raccomanda che i pazienti con sospetto STEMI siano immediatamente valutati per una emergency reperfusion strategy.
- **Declinazione Operativa per la Valutazione:** Ogni paziente con sospetto clinico ed elettrocardiografico di STEMI deve essere immediatamente valutato per determinare la strategia di riperfusione d'emergenza più appropriata.
- **Intento di Risk Management:** Garantire che ogni paziente con sospetto STEMI riceva una valutazione tempestiva finalizzata alla selezione e attivazione della strategia di riperfusione d'emergenza più appropriata, riducendo il tempo totale di ischemia miocardica.
- **Razionale Scientifico:** La tempestività della riperfusione miocardica è il principale determinante della prognosi nei pazienti con STEMI. La valutazione immediata per la strategia di riperfusione consente di ridurre il ritardo tra il primo contatto medico e l'apertura del vaso coronarico occluso, migliorando la sopravvivenza e riducendo l'estensione dell'infarto.

#### 2.1.4 Fonti e Riferimenti Normativi
- **Codice Fonte:** `SRC-ESC-STEMI-2023`
- **Livello Autorità:** Internazionale
- **Ente Emittente:** European Society of Cardiology (ESC)
- **Titolo del Documento Relato:** 2023 ESC Guidelines for the management of acute coronary syndromes (Versione: 2023, Pubblicato il: 2023-08-25)
- **Sezione di Riferimento:** Sezione 5 - Strategia di riperfusione (p. 28-35)
- **Citazione Esatta:** "Si raccomanda che i pazienti con sospetto STEMI siano immediatamente valutati per una emergency reperfusion strategy."
- **Avvertenza Licenza:** Contenuto soggetto a copyright ESC. Utilizzo consentito per finalità cliniche e di ricerca.

#### 2.1.5 Condizioni di Applicabilità Clinica
- **Popolazione Target:** Pazienti adulti (età ≥ 18 anni) con sospetto clinico di infarto miocardico con sopraslivellamento del tratto ST (STEMI), inclusi pazienti con dolore toracico acuto e alterazioni ECG compatibili con STEMI.
- **Contesto Clinico:** Sospetto clinico ed elettrocardiografico di STEMI in fase acuta, indipendentemente dal tempo di insorgenza dei sintomi.
- **Contesto di Cura:** Fase pre-ospedaliera (ambulanza 118) e fase di accesso al Pronto Soccorso / DEA, fino alla decisione sulla strategia di riperfusione.

**Criteri di Inclusione:**

1. **[INC-001] Dolore toracico acuto suggestivo di sindrome coronarica acuta:** Paziente che presenta dolore toracico acuto, oppressivo, retrosternale, eventualmente irradiato, o equivalente anginoso (es. dispnea improvvisa), suggestivo di ischemia miocardica acuta. *(Parametri di controllo: DE-001, DE-002)*
2. **[INC-002] Sopraslivellamento del tratto ST all'ECG a 12 derivazioni:** ECG a 12 derivazioni che mostra sopraslivellamento del tratto ST in almeno due derivazioni contigue, oppure blocco di branca sinistra di nuova insorgenza, compatibile con diagnosi di STEMI. *(Parametri di controllo: DE-003, DE-004)*
3. **[INC-003] Età adulta:** Paziente di età maggiore o uguale a 18 anni. *(Parametro di controllo: DE-005)*

**Criteri di Esclusione:**

1. **[EXC-001] Direttive anticipate di trattamento che escludono interventi invasivi:** Paziente con direttive anticipate di trattamento (DAT) valide che escludono esplicitamente interventi cardiologici invasivi o manovre di riperfusione. *(Parametro di controllo: DE-006)*
2. **[EXC-002] Diagnosi alternativa confermata:** Paziente per il quale è stata confermata da un medico una diagnosi alternativa che esclude lo STEMI, come pericardite acuta, sindrome di Takotsubo confermata, o artefatto ECG documentato. *(Parametro di controllo: DE-007)*

#### 2.1.6 Condizione di Avvio del Monitoraggio (Evento Scatenante)
- **Evento Registrato:** Riscontro di sopraslivellamento del tratto ST su ECG a 12 derivazioni in un paziente con sintomatologia clinica compatibile con sindrome coronarica acuta, oppure sospetto clinico fondato di STEMI comunicato dal personale del 118 o dal medico di triage. *(Chiavi referenziate: DE-001, DE-002, DE-003, DE-008)*
- **Evento di Riferimento (Tempo Zero):** Primo contatto medico con riscontro di sospetto STEMI (FMC - First Medical Contact). Da questo momento inizia la valutazione temporale della Compliance.
- **Finestra temporale:** Dal momento del primo contatto medico (FMC) fino alla documentazione clinica formale della decisione sulla strategia di riperfusione (PCI primaria, fibrinolisi, o esclusione motivata).

#### 2.1.7 Eccezioni Cliniche Ammesse (Giustificazioni)
Le seguenti condizioni, se documentate, sollevano dalla non conformità per ritardo o mancata esecuzione:

1. **[EXP-001] Arresto cardiaco refrattario con prognosi infausta:** Paziente in arresto cardiaco refrattario a manovre di rianimazione cardiopolmonare avanzata prolungate (>30 min), con segni di prognosi infausta. Il team medico ritiene non indicato proseguire con la strategia di riperfusione. *Richiede giustificazione scritta e motivazione medica.*
2. **[EXP-002] Rifiuto informato del paziente:** Il paziente, adeguatamente informato, rifiuta espressamente la valutazione o il trattamento di riperfusione. *Richiede modulo di rifiuto firmato o attestazione clinica esplicita.*
3. **[EXP-003] Comorbidità terminali con aspettativa di vita molto limitata:** Paziente con patologie terminali preesistenti note (es. neoplasia in fase terminale) ove la riperfusione non è ritenuta dal team nel miglior interesse terapeutico. *Richiede nota di cartella per esenzione dalle cure acute.*

#### 2.1.8 Azione Attesa e Comportamento Conforme
- **Azione Attesa:** Valutare immediatamente il paziente con sospetto STEMI per determinare la strategia di riperfusione d'emergenza più appropriata, considerando il tempo dall'insorgenza, la disponibilità del laboratorio di emodinamica, eventuali controindicazioni, le condizioni del paziente e il trasporto.
- **Obiettivo Clinico:** Stabilire al più presto l'iter terapeutico (PCI primaria, fibrinolisi sistemica, o strategia farmaco-invasiva).

**Parametri di Azione (Soglie Temporali per la Qualità):**

| Oggetto del Controllo | Descrizione Parametro | Valore Atteso | Unità |
| :--- | :--- | :--- | :--- |
| Tempistica Valutazione | La valutazione clinica segue immediatamente il sospetto diagnostico | Immediata | N/A |
| Tempistica Esecuzione ECG | Esecuzione e refertazione medica dell'ECG a 12 derivazioni dal Primo Contatto | Entro 10 | minuti |
| Valutazione fattibilità PCI | Orizzonte di garanzia PCI primaria calcolato dal Primo Contatto | Entro 120 (o 90) | minuti |

**Alternative Terapeutiche/Organizzative Conformi ai Percorsi:**

- Se la PCI primaria non è accessibile/garantibile nei tempi, la fibrinolisi sistemica va considerata entro 10 minuti dalla diagnosi di STEMI.
- Pre-ospedaliero: attivazione diretta e trasporto al macchinario per l'emodinamica, bypassando il PS.

#### 2.1.9 Criteri di Completamento del Processo
- **Definizione di Ottemperanza:** Decisione documentata in cartella clinica (o fascicolo elettronico) sulla strategia d'emergenza scelta, corredata da motivazioni cliniche e tempistiche. 
- **Verifica Operativa:** Affinché il sistema segnali "Conformità Piena", devono sussistere: ECG interpretato e allegato + Strategia documentata descritta + Orario (FMC) chiaramente indicato + Decisione riperfusione presa senza colpevoli latenze temporali.

#### 2.1.10 Standard Temporali e Criteri di Precedenza
- **Il Controllo dell'Interpretazione [TC-001/SC-001]:** L'ECG a 12 derivazioni deve essere letto prima della decisione strategica di riperfusione, con la refertazione avvenuta entro la soglia aurea dei 10 minuti dal FMC. Se il controllo ECG risulta post-datato rispetto alla decisione emodinamica o mancante, scatterà un "Alert".
- **Il Controllo Decisionale [TC-002]:** La decisione medica (PCI o Trombolisi) deve occorrere "immediatamente" non appena formalizzata la diagnosi STEMI.
- **Accesso all'Unità [TC-003]:** Il crossing dell'apertura del vaso (per chi affronta la PCI primaria) deve chiudersi al max entro 120 minuti dal FMC. (Scatta la soglia di allarme interna passati i 90 min per verifiche ispettive retrospettive).
- **Il Controllo d'Accesso [SC-002]:** Cronologicamente il primo contatto in pronto soccorso o in blocco di pronto intervento territoriale (FMC) precede la decisione medica.

#### 2.1.11 Set Minimo di Dati (Clinical Data Elements)
La conformità del percorso si basa sull'adeguata compilazione dei seguenti campi nel Fascicolo Sanitario Elettronico:

- **`DE-001` - Sintomatologia di presentazione:** (Dolore toracico o equivalente inserito nelle note logiche di reparto)
- **`DE-003` - Referto ECG a 12 derivazioni:** (Presenza formale o caricamento del tracciato o diagnosi I21.x)
- **`DE-005` - Età del paziente**
- **`DE-008` - Data e Ora del primo contatto medico (FMC):** L'ora di arrivo è imprescindibile, da cui si misurano poi tutti i ritardi.
- **`DE-009` - Data e Ora referto ECG**
- **`DE-010` - Decisione strategica di Riperfusione prescritta dal Medico**
- **`DE-011` - Data e Ora apposizione nota/decisione di reperfusione**

#### 2.1.12 Requisiti Cogenti di Qualità Organizzativa (Risk Classification)
- **Rischio Clinico / Sicurezza Paziente:** Danno Critico
- **Rischio Operativo / Di Processo:** Danno Critico per il Pathway
- **Probabilità di accadimento di complicanze senza aderenza:** Molto Probabile
- **Priority Score (Risk Management):** `9.5` / 10
- **Razionale d'Azione Coordinata:** Ritardare l'ingaggio per riperfusione dilata esponenzialmente per ogni minuto le lesioni al muscolo cardiaco.

#### 2.1.13 Esiti del Monitoraggio Clinico
- **Esiti Possibili dell'Analisi Cartelle:** Percorso Conforme, Percorso Non Conforme, Deviazione Giustificata (Applicazione corretta dell'Eccezione), Dati Insufficienti o Omissivi, Non Applicabile al Caso.

**Evidenze positive di adeguatezza (Conformità):**

- [EC-001] Referto ECG caricato e attestante STEMI con tempo inserito coerente coi <10 min da Arrivo in struttura/FMC.
- [EC-002] Terapia vitale ascritta immediatamente a valle.
- [EC-003] Ora di primo contatto clinico presente in modo chiaro (punto zero per Audit).

**Evidenze documentate di Eventi Avversi (Non-Conformità e Allarmi):**

- [ENC-001] Mancata traccia che attesti l'ECG entro i primissimi 10 minuti di valutazione per quel paziente e sospetto.
- [ENC-002] Sospensione decisionale ("Sospetto Accertato, Nessuna Procedura intrapresa e nessuna Disposizione").
- [ENC-003] Intervallo patologico registrato tra l'Arrivo al PS e il triage verso Emodinamica.
- [ENC-004] Assente Ora Arrivo FMC; Impossibile quantificare il Quality Check sui tempi medici.

#### 2.1.14 Governance e Controllo d'Aggiornamento Clinico
- **Proprietà del Processo:** Direttore Dipartimento Emergenza e Accettazione (DEA)
- **Frequenza di Revisione PDTA:** Ciclo 12 mesi o in adeguamento stringente alla variazione delle linee guida (ESC/ANMCO).

### Regola 2: Diagnosi SCA multiparametrica (STEMI-DO-002)

#### 2.2.1 Identificativi della Regola Clinica
- **Codice Univoco:** STEMI-DO-002
- **Versione Schema:** 1.0.0
- **Tipologia di Regola:** Azione Raccomandata / Prescrittiva (DO)
- **Titolo Esteso:** Diagnosi e stratificazione del rischio a breve termine della SCA basata su anamnesi, sintomi, segni vitali, esame obiettivo, ECG e troponina ad alta sensibilità
- **Etichetta Breve:** Diagnosi SCA multiparametrica
- **ID Percorso Aziendale:** PDTA-STEMI-001
- **Nome Percorso Aziendale:** Percorso Diagnostico Terapeutico Assistenziale per STEMI
- **Fase del Percorso Clinico:** Diagnosi
- **Setting Assistenziale:** Pronto Soccorso, Servizio di Emergenza Territoriale (118), Unità di Terapia Intensiva Cardiologica

#### 2.2.2 Mappa delle Responsabilità

| Ruolo Assistenziale | Tipologia di Responsabilità | Unità Organizzativa | Note Operative |
| :--- | :--- | :--- | :--- |
| **Medico di Pronto Soccorso** | Primaria | Pronto Soccorso / Dipartimento di Emergenza-Urgenza | Responsabile principale della valutazione diagnostica iniziale integrata del paziente con sospetta SCA. |
| **Cardiologo di guardia** | Consultazione | Unità di Terapia Intensiva Cardiologica (UTIC) | Consulente per la conferma diagnostica e la stratificazione del rischio nei casi complessi. |
| **Infermiere di Triage** | Supporto | Pronto Soccorso | Supporta la raccolta dei parametri vitali, l'esecuzione dell'ECG e il prelievo ematico per troponina. |
| **Medico del Servizio di Emergenza Territoriale** | Primaria | Servizio 118 | In fase pre-ospedaliera è responsabile della valutazione clinica iniziale, dell'ECG e della trasmissione dei dati. |

#### 2.2.3 Forza della Regola ed Evidenze Scientifiche
- **Grado di Obbligatorietà:** Obbligatoria (Mandatory)
- **Forza della Raccomandazione Clinica:** Classe I
- **Livello di Evidenza Scientifico:** Livello di evidenza B
- **Dichiarazione Originale:** It is recommended to base the diagnosis and initial short-term risk stratification of ACS on a combination of clinical history, symptoms, vital signs, other physical findings, ECG, and hs-cTn.
- **Declinazione Operativa per la Valutazione:** La diagnosi e la stratificazione iniziale del rischio a breve termine della sindrome coronarica acuta devono essere basate sulla combinazione di anamnesi clinica, sintomi, segni vitali, altri reperti dell'esame obiettivo, elettrocardiogramma e troponina cardiaca ad alta sensibilità.
- **Intento di Risk Management:** Garantire una diagnosi accurata e una stratificazione del rischio a breve termine della SCA mediante un approccio diagnostico multiparametrico integrato che combini dati clinici, strumentali e di laboratorio.
- **Razionale Scientifico:** L'utilizzo combinato di anamnesi, sintomi, parametri vitali, esame obiettivo, ECG e troponina ad alta sensibilità consente di aumentare la sensibilità e la specificità diagnostica della SCA, riducendo il rischio di mancata diagnosi e permettendo una stratificazione prognostica precoce che orienta il trattamento tempestivo.

#### 2.2.4 Fonti e Riferimenti Normativi
- **Codice Fonte:** ESC-ACS-2023
- **Livello Autorità:** Internazionale
- **Ente Emittente:** European Society of Cardiology (ESC)
- **Titolo del Documento Relato:** 2023 ESC Guidelines for the management of acute coronary syndromes (Versione: 2023, Pubblicato il: 2023-08-25)
- **Sezione di Riferimento:** Sezione 3 - Diagnosi
- **Citazione Esatta:** "It is recommended to base the diagnosis and initial short-term risk stratification of ACS on a combination of clinical history, symptoms, vital signs, other physical findings, ECG, and hs-cTn."
- **Avvertenza Licenza:** Contenuto protetto da copyright ESC. Uso a fini clinici e di ricerca conforme alle condizioni di utilizzo dell'editore.

#### 2.2.5 Condizioni di Applicabilità Clinica
- **Popolazione Target:** Pazienti adulti (età >= 18 anni) che si presentano con sospetta sindrome coronarica acuta, incluso STEMI, NSTEMI e angina instabile.
- **Contesto Clinico:** Sospetto clinico di sindrome coronarica acuta (SCA) in fase acuta, inclusa la presentazione con dolore toracico, dispnea, sintomi equivalenti anginosi o alterazioni emodinamiche suggestive.
- **Contesto di Cura:** Fase diagnostica iniziale in ambito pre-ospedaliero (118) e in Pronto Soccorso, fino alla conferma o esclusione della diagnosi di SCA.

**Criteri di Inclusione:**

1. **[IC-001] Sospetta SCA:** Paziente adulto che si presenta con sintomi compatibili con sindrome coronarica acuta, come dolore toracico, dispnea acuta, sincope o equivalenti anginosi. *(Parametri di controllo: DE-001, DE-002)*

**Criteri di Esclusione:**

1. **[EC-001] Causa non cardiaca chiaramente identificata:** Paziente in cui una causa non cardiaca dei sintomi è stata chiaramente identificata e documentata prima della valutazione multiparametrica (ad es. trauma toracico diretto, pneumotorace evidente alla radiografia). *(Parametro di controllo: DE-010)*

#### 2.2.6 Condizione di Avvio del Monitoraggio (Evento Scatenante)
- **Evento Registrato:** Il paziente si presenta al Pronto Soccorso o viene valutato dal Servizio di Emergenza Territoriale con sintomi suggestivi di sindrome coronarica acuta (dolore toracico acuto, dispnea, sudorazione, nausea, sincope o equivalenti anginosi). *(Chiavi referenziate: DE-001, DE-002, DE-003)*
- **Evento di Riferimento (Tempo Zero):** Primo contatto medico (FMC).
- **Finestra temporale:** Dal momento del primo contatto medico con il paziente che presenta sospetta SCA, fino al completamento della valutazione diagnostica iniziale integrata e alla formulazione della diagnosi di lavoro.

#### 2.2.7 Eccezioni Cliniche Ammesse (Giustificazioni)
Le seguenti condizioni, se documentate, sollevano dalla non conformità per ritardo o mancata esecuzione:

1. **[EX-001] Arresto cardiaco in corso con necessità di rianimazione immediata:** Nel paziente in arresto cardiaco, le manovre rianimatorie hanno priorità assoluta. La valutazione diagnostica multiparametrica completa può essere posticipata fino al ripristino della circolazione spontanea (ROSC). *Richiede documentazione dello stato di arresto cardiaco, tempi di RCP e nota clinica di differimento.*
2. **[EX-002] Instabilità emodinamica critica che richiede intervento immediato:** In presenza di shock cardiogeno o instabilità emodinamica grave (es. Sistolica <90) con necessità di supporto circolatorio immediato, alcune componenti della valutazione diagnostica possono essere differite o eseguite in parallelo con le manovre di stabilizzazione. *Richiede documentazione parametri critici e nota clinica di prioritizzazione.*

#### 2.2.8 Azione Attesa e Comportamento Conforme
- **Azione Attesa:** Eseguire una valutazione diagnostica integrata e una stratificazione iniziale del rischio a breve termine della SCA basata sulla combinazione sistematica di anamnesi clinica, valutazione sintomi, segni vitali, esame obiettivo, ECG a 12 derivazioni e troponina cardiaca ad alta sensibilità (hs-cTn).
- **Obiettivo Clinico:** Valutazione diagnostica integrata multiparametrica per SCA.

**Parametri di Azione (Soglie Temporali per la Qualità):**

| Oggetto del Controllo | Descrizione Parametro | Valore Atteso | Unità |
| :--- | :--- | :--- | :--- |
| Anamnesi clinica | Raccolta storia cardiovascolare, fattori di rischio, terapie | Completata | N/A |
| Valutazione dei sintomi | Caratterizzazione dolore toracico e sintomi associati | Completata | N/A |
| Segni vitali | Rilevazione PA, FC, FR, SpO2 e TC | Completata | N/A |
| Esame obiettivo | Esame obiettivo cardiovascolare e sistemico | Completato | N/A |
| ECG a 12 derivazioni | Registrazione e interpretazione standard | Eseguito e Interpretato | N/A |
| Troponina (hs-cTn) | Dosaggio su prelievo ematico per danno acuto | Dosata | ng/L |

**Alternative Terapeutiche/Organizzative Conformi ai Percorsi:**

- In fase pre-ospedaliera, se il dosaggio hs-cTn non è disponibile, eseguire tutte le altre componenti della valutazione e assicurare il prelievo ematico più precoce possibile all'arrivo in Pronto Soccorso.

#### 2.2.9 Criteri di Completamento del Processo
- **Definizione di Ottemperanza:** La regola è soddisfatta quando tutte e sei le componenti della valutazione diagnostica integrata sono state eseguite e documentate (anamnesi, sintomi, segni vitali, esame obiettivo, ECG refertato e dosaggio hs-cTn refertato). La diagnosi di lavoro e la stratificazione iniziale del rischio devono essere documentate.
- **Verifica Operativa:** Affinché il sistema segnali "Conformità Piena", serve la presenza documentale simultanea di: Referto anamnesi + Descrizione sintomi + Parametri vitali + Esame obiettivo + Tracciato ECG interpretato + Risultato Troponina + Diagnosi di lavoro formulata.

#### 2.2.10 Standard Temporali e Criteri di Precedenza
- **Il Controllo dell'Interpretazione ECG [TC-001]:** L'ECG a 12 derivazioni deve essere eseguito e interpretato entro 10 minuti dal primo contatto medico.
- **Il Controllo del Prelievo (hs-cTn) [TC-002]:** Il prelievo ematico per il dosaggio deve essere effettuato il prima possibile e comunque contestualmente al primo accesso venoso (entro 20 minuti dall'accesso o FMC).
- **Il Controllo della Valutazione Completa [TC-003]:** La diagnostica integrata completa deve essere chiusa (raccolta anamnesi fino a risultato troponina) entro 60 minuti dal primo contatto medico.
- **La Diagnosi post-ECG [SC-001]:** L'ECG a 12 derivazioni deve essere eseguito "prima" o contestualmente alla formulazione della diagnosi di lavoro e della stratificazione del rischio.
- **Prelievo pre-Obiettivo [SC-002]:** Il dosaggio refertativo hs-cTn deve essere richiesto indipendentemente "prima o in parallelo" all'esame obiettivo al fine di velocizzarne i tempi di refertazione.

#### 2.2.11 Set Minimo di Dati (Clinical Data Elements)
La conformità del percorso si basa sull'adeguata compilazione dei seguenti campi nel Fascicolo Sanitario Elettronico:

- **DE-001 - Età del paziente**
- **DE-002 - Motivo di accesso / sintomo principale:** (es. dolore toracico, ICD-10)
- **DE-003 - Data e Ora primo contatto medico:** (FMC 118 o Triage PS)
- **DE-004 - Anamnesi clinica documentata:** (Fattori CV, storia cardiologica)
- **DE-005 - Segni vitali rilevati:** (Set completo LOINC)
- **DE-006 - Data e Ora esecuzione ECG a 12 derivazioni**
- **DE-007 - Referto interpretativo dell'ECG a 12 derivazioni**
- **DE-008 - Risultato troponina ad alta sensibilità (hs-cTn)** (Referto testuale/numerico LOINC)
- **DE-009 - Esame obiettivo documentato**
- **DE-010 - Diagnosi alternativa non cardiaca confermata** (Se applicata una esclusione)

#### 2.2.12 Requisiti Cogenti di Qualità Organizzativa (Risk Classification)
- **Rischio Clinico / Sicurezza Paziente:** Danno Critico
- **Rischio Operativo / Di Processo:** Rischio Alto
- **Probabilità di accadimento di complicanze senza aderenza:** Molto Probabile
- **Priority Score (Risk Management):** 95 / 100
- **Razionale d'Azione Coordinata:** La mancata esecuzione di una valutazione diagnostica integrata completa per la SCA può portare a diagnosi mancate o ritardate, con conseguenze potenzialmente fatali (infarto miocardico non riconosciuto, ritardo nella riperfusione). L'omissione di singole componenti riduce significativamente la sensibilità diagnostica.

#### 2.2.13 Esiti del Monitoraggio Clinico
- **Esiti Possibili dell'Analisi Cartelle:** Percorso Conforme, Percorso Non Conforme, Deviazione Giustificata (Applicazione corretta dell'Eccezione), Dati Insufficienti o Omissivi, Non Applicabile al Caso.

**Evidenze positive di adeguatezza (Conformità):**

- [EOC-001/005] Presenza di Anamnesi clinica ed Esame obiettivo documentati nei primi 60 min.
- [EOC-002] Registrazione completa dei segni vitali entro 10 min.
- [EOC-003] Presenza deterministica del referto dell'ECG caricato <10 min da Arrivo FMC.
- [EOC-004] Presenza del valore refertato della Troponina (hs-cTn) nei primi 60 minuti da FMC.
- [EOC-006] Diagnosi di lavoro e stratificazione del rischio documentati.

**Evidenze documentate di Eventi Avversi (Non-Conformità e Allarmi):**

- [EONC-001] Assenza ECG o refertazione oltre i limiti prescritti senza note cliniche avversative mediche.
- [EONC-002] Assenza prescrizione o refertazione della Troponina entro il traguardo d'audit (60 min).
- [EONC-003] Omissione formale di registrazione anamnestica/esame obbiettivo.
- [EONC-004] Diagnosi di Lavoro precoce stilata senza attesa del panel complessivo (es. senza validare ECG).

#### 2.2.14 Governance e Controllo d'Aggiornamento Clinico
- **Proprietà del Processo:** Direttore Clinico del Dipartimento di Emergenza-Urgenza
- **Frequenza di Revisione PDTA:** Ogni 12 mesi o in caso di aggiornamento delle linee guida ESC.

---

### Regola 3: Esecuzione e interpretazione ECG entro 10 min (STEMI-DO-003)

#### 2.3.1 Identificativi della Regola Clinica
- **Codice Univoco:** STEMI-DO-003
- **Versione Schema:** 1.0.0
- **Tipologia di Regola:** Azione Raccomandata / Prescrittiva (DO)
- **Titolo Esteso:** Esecuzione e interpretazione dell'ECG a 12 derivazioni entro 10 minuti dal primo contatto medico
- **Etichetta Breve:** ECG 12 derivazioni <=10 min da FMC
- **ID Percorso Aziendale:** PDTA-STEMI-001
- **Nome Percorso Aziendale:** Percorso Diagnostico Terapeutico Assistenziale per STEMI
- **Fase del Percorso Clinico:** Primo contatto medico / triage
- **Setting Assistenziale:** Pre-ospedaliero (118/ambulanza), Pronto Soccorso, Punto di primo contatto medico

#### 2.3.2 Mappa delle Responsabilità

| Ruolo Assistenziale | Tipologia di Responsabilità | Unità Organizzativa | Note Operative |
| :--- | :--- | :--- | :--- |
| **Medico di emergenza territoriale (118)** | Primaria | Servizio di Emergenza Territoriale 118 | Responsabile principale dell'esecuzione e interpretazione dell'ECG a 12 derivazioni in ambito pre-ospedaliero. |
| **Medico di pronto soccorso** | Primaria | Pronto Soccorso / DEA | Responsabile principale dell'esecuzione e interpretazione dell'ECG a 12 derivazioni se il primo contatto medico avviene in pronto soccorso. |
| **Infermiere di triage** | Supporto | Pronto Soccorso / DEA | Supporto nell'esecuzione dell'ECG a 12 derivazioni; può avviare la registrazione ECG prima della valutazione medica secondo protocollo locale. |
| **Equipaggio ambulanza** | Supporto | Servizio di Emergenza Territoriale 118 | Supporto tecnico per l'esecuzione dell'ECG nella fase pre-ospedaliera. |

#### 2.3.3 Forza della Regola ed Evidenze Scientifiche
- **Grado di Obbligatorietà:** Raccomandata
- **Forza della Raccomandazione Clinica:** Classe I (Raccomandato)
- **Livello di Evidenza Scientifico:** Livello di evidenza B
- **Dichiarazione Originale:** Twelve-lead ECG recording and interpretation is recommended as soon as possible at the point of first medical contact, with a target of <10 min.
- **Declinazione Operativa per la Valutazione:** La registrazione e l'interpretazione dell'ECG a 12 derivazioni devono essere eseguite il prima possibile al punto di primo contatto medico, con un obiettivo temporale inferiore a 10 minuti.
- **Intento di Risk Management:** Garantire una diagnosi ECG rapida di STEMI per consentire l'attivazione tempestiva del percorso di riperfusione e ridurre il tempo totale di ischemia miocardica.
- **Razionale Scientifico:** La diagnosi precoce mediante ECG a 12 derivazioni è fondamentale per l'identificazione dello STEMI e l'attivazione immediata della strategia di riperfusione. Il ritardo comporta un prolungamento del tempo di ischemia, con conseguente aumento dell'area di necrosi miocardica e peggioramento degli esiti clinici.

#### 2.3.4 Fonti e Riferimenti Normativi
- **Codice Fonte:** ESC-STEMI-2023
- **Livello Autorità:** Internazionale
- **Ente Emittente:** European Society of Cardiology (ESC)
- **Titolo del Documento Relato:** 2023 ESC Guidelines for the management of acute coronary syndromes (Versione: 2023, Pubblicato il: 2023-08-25)
- **Sezione di Riferimento:** Sezione Diagnosi â€“ Raccomandazione ECG al primo contatto medico
- **Citazione Esatta:** "Twelve-lead ECG recording and interpretation is recommended as soon as possible at the point of first medical contact, with a target of <10 min."
- **Avvertenza Licenza:** Contenuto soggetto a copyright ESC. Utilizzo ai fini di codifica interna del PDTA.

#### 2.3.5 Condizioni di Applicabilità Clinica
- **Popolazione Target:** Pazienti adulti con sospetto clinico di sindrome coronarica acuta, in particolare con dolore toracico suggestivo di infarto miocardico acuto con sopraslivellamento del tratto ST (STEMI).
- **Contesto Clinico:** Sospetto clinico di sindrome coronarica acuta / STEMI al primo contatto medico.
- **Contesto di Cura:** Fase pre-ospedaliera (primo contatto medico con equipaggio 118) o fase di arrivo in pronto soccorso, qualunque sia il punto di primo contatto medico.

**Criteri di Inclusione:**

1. **[INC-01] Dolore toracico acuto sospetto ischemico:** Paziente adulto che presenta dolore toracico acuto o equivalente ischemico (dispnea, sudorazione algida, dolore epigastrico) suggestivo di sindrome coronarica acuta. *(Parametri di controllo: DE-sintomo-presentazione, DE-eta-paziente)*
2. **[INC-02] Primo contatto medico avvenuto:** Il paziente ha raggiunto il punto di primo contatto medico (first medical contact), sia in ambito pre-ospedaliero sia in pronto soccorso. *(Parametri di controllo: DE-timestamp-primo-contatto-medico)*

**Criteri di Esclusione:**

1. **[EXC-01] Arresto cardiaco in corso con rianimazione attiva:** Paziente in arresto cardiaco con manovre di rianimazione cardiopolmonare in corso, per il quale l'ECG a 12 derivazioni non è tecnicamente eseguibile in modo affidabile. *(Parametri di controllo: DE-stato-clinico, DE-RCP-in-corso)*

#### 2.3.6 Condizione di Avvio del Monitoraggio (Evento Scatenante)
- **Evento Registrato:** Il primo contatto medico (FMC) con un paziente che presenta sintomi suggestivi di sindrome coronarica acuta / sospetto STEMI. *(Chiavi referenziate: DE-timestamp-primo-contatto-medico, DE-sintomo-presentazione)*
- **Evento di Riferimento (Tempo Zero):** Primo contatto medico.
- **Finestra temporale:** Dal momento esatto del primo contatto medico con il paziente sintomatico, fino al completamento della registrazione e interpretazione dell'ECG a 12 derivazioni, oppure fino alla decisione clinica di non procedere con l'ECG per motivazione documentata.

#### 2.3.7 Eccezioni Cliniche Ammesse (Giustificazioni)
Le seguenti condizioni, se documentate, sollevano dalla non conformità per ritardo o mancata esecuzione:

1. **[EXP-01] Arresto cardiaco con RCP in corso:** L'ECG non può essere eseguito in modo attendibile durante le manovre di RCP attiva. L'esecuzione viene differita fino al ripristino della circolazione spontanea (ROSC). *Richiede documentazione.*
2. **[EXP-02] Indisponibilità temporanea dell'elettrocardiografo:** L'apparecchio ECG non è disponibile o malfunzionante al punto di primo contatto medico. In tal caso il paziente deve essere trasferito al più presto verso una sede dotata. *Richiede documentazione del guasto/indisponibilità e tempestivo transfer.*
3. **[EXP-03] Condizioni cliniche che impediscono l'esecuzione tecnica:** Es. agitazione psicomotoria estrema, ustioni toraciche estese, che impediscono il posizionamento degli elettrodi. *Richiede nota dell'impedimento e manovre attuate.*

#### 2.3.8 Azione Attesa e Comportamento Conforme
- **Azione Attesa:** Registrare e interpretare un ECG a 12 derivazioni il prima possibile al punto di primo contatto medico, con un obiettivo temporale inferiore a 10 minuti dal FMC.
- **Obiettivo Clinico:** ECG a 12 derivazioni.

**Parametri di Azione (Soglie Temporali per la Qualità):**

| Oggetto del Controllo | Descrizione Parametro | Valore Atteso | Unità |
| :--- | :--- | :--- | :--- |
| Qualità Dispositivo | Numero minimo di derivazioni dell'ECG registrato | 12 | derivazioni |
| Tempistica Massima | Tempo massimo FMC -> Acquisizione e Lettura ECG | < 10 | minuti |
| Interpretazione Medica | L'ECG deve essere non solo stampato refertato in identificazione tratti | Completata | N/A |

**Alternative Terapeutiche/Organizzative Conformi ai Percorsi:**

- Trasmissione telematica dell'ECG a 12 derivazioni a un centro hub per tele-interpretazione da parte di un cardiologo esperto, entro il medesimo limite temporale.

#### 2.3.9 Criteri di Completamento del Processo
- **Definizione di Ottemperanza:** Un ECG a 12 derivazioni è stato registrato e interpretato (con refertazione o annotazione diagnostica documentata) entro 10 minuti dal momento del primo contatto medico.
- **Verifica Operativa:** Affinché il sistema segnali "Conformità Piena", serve la presenza temporale di: Tracciato ECG salvato + Data e Ora ECG refertato + Data e Ora FMC registrate nel flusso in coerenza inferiore a 10 minuti.

#### 2.3.10 Standard Temporali e Criteri di Precedenza
- **Il Controllo Stringente STEMI [TC-01]:** La finestra dei 10 minuti per ottenere registrazione e lettura di tracciato dal Primo Contatto non è raccomandatoria ma perentoria (Hard Deadline), con threshold d'attenzione del QA a 7 minuti.
- **La Procedura di Emodinamica [SC-01]:** L'ECG a 12 derivazioni deve essere letto *prima* di attivare l'emodinamica (il codice di attivazione del Cath-Lab in assenza pregressa di referto farà scattare un audit). 
- **La Procedura d'Accesso [SC-02]:** A logica stringente l'arrivo del paziente (FMC) cronologicamente deve anticipare l'Esecuzione ECG.

#### 2.3.11 Set Minimo di Dati (Clinical Data Elements)
La conformità del percorso si basa sull'adeguata compilazione dei seguenti campi nel Fascicolo Elettronico:

- **DE-timestamp-primo-contatto-medico - Data e Ora del primo contatto (FMC):** Data d'arrivo sul posto (118) o accettazione Triage (PS).
- **DE-timestamp-registrazione-ECG - Data e Ora registrazione ECG**
- **DE-timestamp-interpretazione-ECG - Data e Ora interpretazione/refertazione ECG:** Se in concomitanza, spesso coincide con registrazione. L'hub telemedicina può averne altro differente.
- **DE-sintomo-presentazione - Sintomo principale:** (es. dispnea, algia)
- **DE-eta-paziente - Età anagrafica**
- **DE-referto-ECG - Referto clinico o testo codificato STEMI dell'ECG**
- **DE-stato-clinico - Stato del pz all'arrivo** (per rintracciare giustificate eccezioni di rianimazione)
- **DE-numero-derivazioni-ECG - Derivazioni:** Assicurarsi non sia una striscia di monitor a <=3 derivazioni ma macchinario a 12.

#### 2.3.12 Requisiti Cogenti di Qualità Organizzativa (Risk Classification)
- **Rischio Clinico / Sicurezza Paziente:** Danno Critico
- **Rischio Operativo / Di Processo:** Rischio Alto
- **Probabilità di accadimento di complicanze senza aderenza:** Molto Probabile
- **Priority Score (Risk Management):** 95 / 100
- **Razionale d'Azione Coordinata:** Il ritardo nell'ECG ritarda la riperfusione. Ogni minuto costa quota miocardica e inficia la prognosi post-infartuale. Estremamente critico ai fini medico-legali. La rilevabilità automatica è garantita dal flusso macchinari/cartelle.

#### 2.3.13 Esiti del Monitoraggio Clinico
- **Esiti Possibili dell'Analisi Cartelle:** Percorso Conforme, Percorso Non Conforme, Deviazione Giustificata (Applicazione corretta dell'Eccezione), Dati Insufficienti o Omissivi, Non Applicabile al Caso.

**Evidenze positive di adeguatezza (Conformità):**

- [EOC-01] Stampato ECG a 12 dev registrato <10 minuti da FMC.
- [EOC-02] Esistenza di prescrizione, nota diagnostica o referto relativo al tracciato di cui sopra.
- [EOC-03] Prova computazionale Delta-T che confermi T(Interpretazione) - T(FMC) < 10 minuti.

**Evidenze documentate di Eventi Avversi (Non-Conformità e Allarmi):**

- [EONC-01] Assenza materiale d'ECG nei 10 min dal contatto col professionista.
- [EONC-02] Oltrepassato il Time Target (>= 10minuti) senza valida documentazione scusante.
- [EONC-03] ECG registrato e refertato o letto solo a distanza siderale dal tracciato.
- [EONC-04] Utilizzo di apparecchi di monitoraggio parziali (< 12 derivazioni diagnostiche) ove non giustificato.

#### 2.3.14 Governance e Controllo d'Aggiornamento Clinico
- **Proprietà del Processo:** Responsabile Clinico PDTA STEMI
- **Frequenza di Revisione PDTA:** 12 mesi


---

### Regola 4: Monitoraggio ECG continuo e disponibilità di defibrillatore nei pazienti con sospetto STEMI o SCA (STEMI-DO-004)

#### 2.4.1 Identificativi della Regola Clinica
- **Codice Univoco:** STEMI-DO-004
- **Versione Schema:** 1.0.0
- **Tipologia di Regola:** Azione Prescrittiva (DO)
- **Titolo Esteso:** Monitoraggio ECG continuo e disponibilità di defibrillatore nei pazienti con sospetto STEMI o SCA
- **Etichetta Breve:** ECG continuo + defibrillatore
- **ID Percorso Aziendale:** PDTA-STEMI-001
- **Nome Percorso Aziendale:** Percorso Diagnostico Terapeutico Assistenziale per STEMI
- **Fase del Percorso Clinico:** Monitoraggio precoce
- **Setting Assistenziale:** Pronto soccorso, ambulanza 118, unità di terapia intensiva cardiologica, laboratorio di emodinamica, reparto di cardiologia

#### 2.4.2 Mappa delle Responsabilità

| Ruolo Assistenziale | Tipologia di Responsabilità | Unità Organizzativa | Note Operative |
| :--- | :--- | :--- | :--- |
| **Medico d'emergenza** | Primaria | Pronto Soccorso / DEA | Responsabile dell'attivazione tempestiva del monitoraggio ECG continuo e della verifica della disponibilità del defibrillatore al primo contatto con il paziente. |
| **Infermiere di triage** | Supporto | Pronto Soccorso / DEA | Supporto nell'applicazione immediata del monitoraggio ECG e nella verifica della funzionalità del defibrillatore. |
| **Personale del 118** | Primaria | Servizio di Emergenza Territoriale 118 | Responsabile dell'avvio del monitoraggio ECG continuo e della disponibilità del defibrillatore in fase pre-ospedaliera. |
| **Cardiologo di guardia** | Consultazione | Unità di Terapia Intensiva Cardiologica (UTIC) | Consultato per la gestione avanzata del monitoraggio e per eventuali aritmie rilevate. |
| **Infermiere UTIC** | Supporto | Unità di Terapia Intensiva Cardiologica (UTIC) | Responsabile della continuità del monitoraggio ECG durante il ricovero in UTIC. |

#### 2.4.3 Forza della Regola ed Evidenze Scientifiche
- **Grado di Obbligatorietà:** Obbligatoria
- **Forza della Raccomandazione Clinica:** Classe I
- **Livello di Evidenza Scientifico:** Livello di evidenza B
- **Dichiarazione Originale:** Continuous ECG monitoring and the availability of defibrillator capacity is recommended as soon as possible in all patients with suspected STEMI, in suspected ACS with other ECG changes or ongoing chest pain, and once the diagnosis of MI is made.
- **Declinazione Operativa per la Valutazione:** Il monitoraggio ECG continuo e la disponibilità di un defibrillatore devono essere garantiti il prima possibile in tutti i pazienti con sospetto STEMI, con sospetta SCA con alterazioni ECG o dolore toracico in corso, e una volta che la diagnosi di infarto miocardico sia stata posta.
- **Intento di Risk Management:** Garantire la sorveglianza elettrocardiografica continua e la capacità di defibrillazione immediata per la rilevazione e il trattamento tempestivo di aritmie potenzialmente fatali nei pazienti con sindrome coronarica acuta sospetta o confermata.
- **Razionale Scientifico:** I pazienti con STEMI o SCA sono a elevato rischio di aritmie ventricolari maligne, inclusa la fibrillazione ventricolare, specialmente nelle prime ore dall'esordio dei sintomi. Il monitoraggio ECG continuo consente la rilevazione precoce di aritmie, mentre la disponibilità immediata di un defibrillatore permette la defibrillazione tempestiva, riducendo significativamente la mortalità per arresto cardiaco.

#### 2.4.4 Fonti e Riferimenti Normativi
- **Codice Fonte:** ESC-STEMI-2023
- **Livello Autorità:** Internazionale
- **Ente Emittente:** European Society of Cardiology (ESC)
- **Titolo del Documento Relato:** 2023 ESC Guidelines for the management of acute coronary syndromes (Versione: 2023, Pubblicato il: 2023-08-25)
- **Sezione di Riferimento:** Sezione Monitoraggio e gestione delle aritmie nella fase acuta
- **Citazione Esatta:** "Continuous ECG monitoring and the availability of defibrillator capacity is recommended as soon as possible in all patients with suspected STEMI, in suspected ACS with other ECG changes or ongoing chest pain, and once the diagnosis of MI is made."
- **Avvertenza Licenza:** Contenuto derivato dalle linee guida ESC; utilizzato a scopo clinico-assistenziale e di ricerca sotto fair use accademico.

#### 2.4.5 Condizioni di Applicabilità Clinica
- **Popolazione Target:** Tutti i pazienti adulti con sospetto STEMI, sospetta sindrome coronarica acuta (SCA) con alterazioni ECG o dolore toracico in corso, oppure con diagnosi confermata di infarto miocardico.
- **Contesto Clinico:** Sindrome coronarica acuta sospetta o confermata, inclusi STEMI, NSTEMI e angina instabile con alterazioni elettrocardiografiche o sintomatologia toracica persistente.
- **Contesto di Cura:** Fase pre-ospedaliera (118/ambulanza), pronto soccorso, triage, laboratorio di emodinamica, UTIC e qualsiasi setting in cui il paziente sia in fase acuta.

**Criteri di Inclusione:**

1. **[STEMI-DO-004-INC-01] Sospetto STEMI:** Paziente con presentazione clinica e/o elettrocardiografica compatibile con sospetto infarto miocardico con sopraslivellamento del tratto ST. *(Parametri di controllo: DE-ECG-001, DE-CLINICAL-SUSPICION-001)*
2. **[STEMI-DO-004-INC-02] Sospetta SCA con alterazioni ECG:** Paziente con sospetta sindrome coronarica acuta che presenta alterazioni elettrocardiografiche diverse dal sopraslivellamento ST (es. sottoslivellamento ST, inversione onda T, blocco di branca di nuova insorgenza). *(Parametri di controllo: DE-ECG-001, DE-CLINICAL-SUSPICION-002)*
3. **[STEMI-DO-004-INC-03] Sospetta SCA con dolore toracico in corso:** Paziente con sospetta sindrome coronarica acuta e dolore toracico persistente al momento della valutazione. *(Parametri di controllo: DE-CHEST-PAIN-001, DE-CLINICAL-SUSPICION-002)*
4. **[STEMI-DO-004-INC-04] Diagnosi confermata di infarto miocardico:** Paziente con diagnosi confermata di infarto miocardico acuto (STEMI o NSTEMI) sulla base di criteri clinici, elettrocardiografici e bioumorali. *(Parametri di controllo: DE-DIAGNOSIS-MI-001)*

**Criteri di Esclusione:**

1. **[STEMI-DO-004-EXC-01] Paziente deceduto prima dell'applicazione:** La regola non si applica se il paziente è deceduto prima del primo contatto medico o se si è deciso di non procedere a rianimazione. *(Parametri di controllo: DE-PATIENT-STATUS-001, DE-DNR-001)*
2. **[STEMI-DO-004-EXC-02] Diagnosi alternativa definitivamente confermata:** La regola non si applica se una diagnosi alternativa non cardiaca è stata definitivamente confermata e la SCA è stata esclusa con certezza. *(Parametro di controllo: DE-ACS-EXCLUSION-001)*

#### 2.4.6 Condizione di Avvio del Monitoraggio (Evento Scatenante)
- **Evento Registrato:** Il trigger si attiva al momento del primo sospetto clinico di STEMI o SCA (basato su sintomi, ECG o anamnesi), oppure al momento della conferma diagnostica di infarto miocardico acuto. *(Chiavi referenziate: DE-ECG-001, DE-CHEST-PAIN-001, DE-CLINICAL-SUSPICION-001, DE-CLINICAL-SUSPICION-002, DE-DIAGNOSIS-MI-001)*
- **Evento di Riferimento (Tempo Zero):** Primo contatto medico con sospetto SCA.
- **Finestra temporale:** Dal momento del primo sospetto clinico o diagnostico, fino alla stabilizzazione clinica del paziente e alla dimissione dalla fase di monitoraggio intensivo.

#### 2.4.7 Eccezioni Cliniche Ammesse (Giustificazioni)
Le seguenti condizioni, se documentate, sollevano dalla non conformità per ritardo o mancata esecuzione:

1. **[STEMI-DO-004-EXP-01] Indisponibilità tecnica temporanea del monitor ECG:** In caso di indisponibilità tecnica temporanea del dispositivo di monitoraggio ECG (es. guasto, mancanza di apparecchiatura), è necessario documentare il motivo e attivare immediatamente procedure alternative di sorveglianza clinica ravvicinata. *Richiede documentazione del guasto o indisponibilità.*
2. **[STEMI-DO-004-EXP-02] Rifiuto del paziente:** Il paziente, adeguatamente informato, rifiuta esplicitamente il monitoraggio ECG continuo. Il rifiuto deve essere documentato formalmente. *Richiede consenso informato con documentazione del rifiuto e nota medica.*

#### 2.4.8 Azione Attesa e Comportamento Conforme
- **Azione Attesa:** Attivare il monitoraggio ECG continuo e garantire la disponibilità immediata di un defibrillatore funzionante il prima possibile in tutti i pazienti con sospetto STEMI, sospetta SCA con alterazioni ECG o dolore toracico in corso, e in tutti i pazienti con diagnosi confermata di infarto miocardico.
- **Obiettivo Clinico:** Monitoraggio ECG continuo e defibrillatore.

**Parametri di Azione (Soglie Temporali per la Qualità):**

| Oggetto del Controllo | Descrizione Parametro | Valore Atteso | Unità |
| :--- | :--- | :--- | :--- |
| Modalità monitoraggio ECG | Il monitoraggio ECG deve essere continuo (non intermittente) | continuo | N/A |
| Disponibilità defibrillatore | Un defibrillatore funzionante deve essere immediatamente disponibile | immediatamente disponibile | N/A |
| Tempistica attivazione | Attivazione del monitoraggio e verifica disponibilità | il prima possibile | N/A |

**Alternative Terapeutiche/Organizzative Conformi ai Percorsi:**

- Utilizzo di telemetria portatile con allarmi aritmici in caso di indisponibilità di monitor ECG fisso.
- Utilizzo di defibrillatore automatico esterno (DAE) in sostituzione del defibrillatore manuale se quest'ultimo non è disponibile.

#### 2.4.9 Criteri di Completamento del Processo
- **Definizione di Ottemperanza:** La regola è considerata soddisfatta quando il monitoraggio ECG continuo è stato attivato e un defibrillatore funzionante è stato reso disponibile nella prossimità del paziente, con documentazione dell'ora di attivazione.
- **Verifica Operativa:** Affinché il sistema segnali "Conformità Piena", devono essere documentati l'orario di inizio del monitoraggio ECG continuo, la conferma della disponibilità del defibrillatore, l'identificativo del dispositivo.

#### 2.4.10 Standard Temporali e Criteri di Precedenza
- **Il Controllo Temporale [STEMI-DO-004-TC-01]:** Il monitoraggio ECG continuo e la disponibilità del defibrillatore devono essere garantiti il prima possibile dal momento del sospetto clinico di STEMI/SCA o dalla conferma diagnostica.
- **Precedenza rispetto alle Procedure [STEMI-DO-004-SC-01]:** Il monitoraggio ECG continuo e la disponibilità del defibrillatore devono essere attivati *prima* di qualsiasi procedura interventistica o trasferimento intra-ospedaliero.
- **Sequenza dopo ECG [STEMI-DO-004-SC-02]:** Il monitoraggio ECG continuo deve essere attivato contestualmente o immediatamente dopo il primo ECG diagnostico.

#### 2.4.11 Set Minimo di Dati (Clinical Data Elements)
La conformità del percorso si basa sull'adeguata compilazione dei seguenti campi nel Fascicolo Sanitario Elettronico:

- **DE-ECG-001 - Risultato ECG a 12 derivazioni**
- **DE-CHEST-PAIN-001 - Dolore toracico in corso**
- **DE-CLINICAL-SUSPICION-001 - Sospetto clinico di STEMI**
- **DE-CLINICAL-SUSPICION-002 - Sospetto clinico di SCA**
- **DE-DIAGNOSIS-MI-001 - Diagnosi confermata di infarto miocardico**
- **DE-ECG-MONITOR-001 - Stato monitoraggio ECG continuo:** Registrazione dell'attivazione, orario e dispositivo.
- **DE-DEFIB-001 - Disponibilità defibrillatore**
- **DE-PATIENT-STATUS-001 - Stato vitale del paziente**
- **DE-DNR-001 - Ordine di non rianimazione (DNR)**
- **DE-ACS-EXCLUSION-001 - Esclusione di SCA**

#### 2.4.12 Requisiti Cogenti di Qualità Organizzativa (Risk Classification)
- **Rischio Clinico / Sicurezza Paziente:** Danno Critico
- **Rischio Operativo / Di Processo:** Rischio Alto
- **Probabilità di accadimento di complicanze senza aderenza:** Probabile
- **Priority Score (Risk Management):** 95 / 100
- **Razionale d'Azione Coordinata:** L'assenza di monitoraggio ECG continuo e/o di defibrillatore disponibile in pazienti con STEMI/SCA espone il paziente a rischio di morte improvvisa per fibrillazione ventricolare non rilevata o non trattata tempestivamente.

#### 2.4.13 Esiti del Monitoraggio Clinico
- **Esiti Possibili dell'Analisi Cartelle:** Percorso Conforme, Percorso Non Conforme, Deviazione Giustificata.

**Evidenze positive di adeguatezza (Conformità):**

- [STEMI-DO-004-EOC-01] Registrazione documentata dell'attivazione del monitoraggio ECG continuo con orario di inizio.
- [STEMI-DO-004-EOC-02] Documentazione della disponibilità e funzionalità del defibrillatore nell'area del paziente.
- [STEMI-DO-004-EOC-03] Presenza di tracciati ECG continui nel sistema per la fase acuta.

**Evidenze documentate di Eventi Avversi (Non-Conformità e Allarmi):**

- [STEMI-DO-004-EONC-01] Assenza di documentazione di attivazione del monitoraggio ECG continuo durante la fase acuta.
- [STEMI-DO-004-EONC-02] Assenza di documentazione della disponibilità del defibrillatore.
- [STEMI-DO-004-EONC-03] Ritardo significativo (> 10 min) nell'attivazione del monitoraggio ECG continuo rispetto al primo contatto medico.

#### 2.4.14 Governance e Controllo d'Aggiornamento Clinico
- **Proprietà del Processo:** Direzione Unità Operativa Complessa (UOC) Cardiologia
- **Frequenza di Revisione PDTA:** Ciclo 12 mesi o in caso di aggiornamento normativo.

---

### Regola 5: Utilizzo di derivazioni ECG aggiuntive in caso di STEMI inferiore o sospetta occlusione (STEMI-DO-005)

#### 2.5.1 Identificativi della Regola Clinica
- **Codice Univoco:** STEMI-DO-005
- **Versione Schema:** 1.0.0
- **Tipologia di Regola:** Azione Prescrittiva (DO)
- **Titolo Esteso:** Utilizzo di derivazioni ECG aggiuntive (V3R, V4R e V7–V9) in caso di STEMI inferiore o sospetta occlusione coronarica totale con derivazioni standard non conclusive
- **Etichetta Breve:** ECG derivazioni aggiuntive STEMI inferiore
- **ID Percorso Aziendale:** PDTA-STEMI-001
- **Nome Percorso Aziendale:** Percorso Diagnostico-Terapeutico Assistenziale per STEMI
- **Fase del Percorso Clinico:** Diagnosi
- **Setting Assistenziale:** Pronto soccorso, unità di terapia intensiva cardiologica, pre-ospedaliero (ambulanza medicalizzata)

#### 2.5.2 Mappa delle Responsabilità

| Ruolo Assistenziale | Tipologia di Responsabilità | Unità Organizzativa | Note Operative |
| :--- | :--- | :--- | :--- |
| **Medico d'emergenza** | Primaria | Pronto Soccorso | Responsabile dell'esecuzione e dell'interpretazione dell'ECG a 12 derivazioni e delle derivazioni aggiuntive. |
| **Infermiere di triage/emergenza** | Supporto | Pronto Soccorso | Esegue materialmente la registrazione ECG con le derivazioni aggiuntive su indicazione medica. |
| **Cardiologo interventista** | Consultazione | Emodinamica / UTIC | Può essere consultato per l'interpretazione delle derivazioni aggiuntive e per la pianificazione dell'eventuale coronarografia. |

#### 2.5.3 Forza della Regola ed Evidenze Scientifiche
- **Grado di Obbligatorietà:** Raccomandata
- **Forza della Raccomandazione Clinica:** Classe I
- **Livello di Evidenza Scientifico:** Livello di evidenza C
- **Dichiarazione Originale:** The use of additional ECG leads (V3R, V4R, and V7–V9) is recommended in cases of inferior STEMI or if total vessel occlusion is suspected and standard leads are inconclusive.
- **Declinazione Operativa per la Valutazione:** In presenza di STEMI inferiore o di sospetta occlusione coronarica totale con derivazioni ECG standard non conclusive, si raccomanda l'esecuzione di un ECG con derivazioni aggiuntive V3R, V4R e V7–V9.
- **Intento di Risk Management:** Migliorare la sensibilità diagnostica dell'ECG per identificare l'estensione dell'infarto al ventricolo destro e alla parete posteriore, nonché per confermare un'occlusione coronarica totale.
- **Razionale Scientifico:** Le derivazioni standard a 12 canali possono non evidenziare il sopraslivellamento del tratto ST nel coinvolgimento del ventricolo destro o della parete posteriore. La mancata identificazione di tali territori può comportare una sottovalutazione dell'estensione dell'infarto e un trattamento inadeguato.

#### 2.5.4 Fonti e Riferimenti Normativi
- **Codice Fonte:** ESC-STEMI-GL-2023
- **Livello Autorità:** Internazionale
- **Ente Emittente:** European Society of Cardiology (ESC)
- **Titolo del Documento Relato:** 2023 ESC Guidelines for the management of acute coronary syndromes
- **Sezione di Riferimento:** Sezione Diagnosi – Raccomandazioni ECG
- **Citazione Esatta:** "The use of additional ECG leads (V3R, V4R, and V7–V9) is recommended in cases of inferior STEMI or if total vessel occlusion is suspected and standard leads are inconclusive."
- **Avvertenza Licenza:** Contenuto soggetto a copyright ESC. Utilizzato a scopo di sintesi clinica non commerciale.

#### 2.5.5 Condizioni di Applicabilità Clinica
- **Popolazione Target:** Pazienti adulti con sospetto clinico o diagnosi elettrocardiografica di STEMI inferiore oppure con sospetta occlusione coronarica totale e derivazioni ECG standard non conclusive.
- **Contesto Clinico:** Infarto miocardico acuto con sopraslivellamento del tratto ST in sede inferiore (derivazioni II, III, aVF) oppure quadro clinico suggestivo di occlusione coronarica acuta con ECG standard non diagnostico.
- **Contesto di Cura:** Fase diagnostica in pronto soccorso, in ambiente pre-ospedaliero o in UTIC.

**Criteri di Inclusione:**

1. **[INCL-005-01] STEMI inferiore all'ECG standard:** Sopraslivellamento del tratto ST >= 1 mm in almeno due derivazioni contigue tra II, III e aVF all'ECG a 12 derivazioni. *(Parametri di controllo: DE-005-01, DE-005-02)*
2. **[INCL-005-02] Sospetta occlusione coronarica totale con ECG standard non conclusivo:** Quadro clinico altamente suggestivo di sindrome coronarica acuta con occlusione totale, ma ECG standard non diagnostico. *(Parametri di controllo: DE-005-03, DE-005-04)*

**Criteri di Esclusione:**

1. **[EXCL-005-01] Impossibilità tecnica di posizionamento elettrodi aggiuntivi:** Condizioni cliniche o anatomiche che impediscono fisicamente il posizionamento degli elettrodi. *(Parametri di controllo: DE-005-05)*

#### 2.5.6 Condizione di Avvio del Monitoraggio (Evento Scatenante)
- **Evento Registrato:** Riscontro di sopraslivellamento del tratto ST in sede inferiore all'ECG standard o sospetto di occlusione coronarica totale. *(Chiavi referenziate: DE-005-01, DE-005-02, DE-005-03, DE-005-04)*
- **Evento di Riferimento (Tempo Zero):** Registrazione ECG a 12 derivazioni standard.
- **Finestra temporale:** Subito dopo l'identificazione, fino al completamento della registrazione ECG aggiuntivo o decisione definitiva.

#### 2.5.7 Eccezioni Cliniche Ammesse (Giustificazioni)
Le seguenti condizioni, se documentate, sollevano dalla non conformità per ritardo o mancata esecuzione:

1. **[EXC-005-01] Impossibilità tecnica di posizionamento degli elettrodi aggiuntivi:** Lesioni cutanee estese o ustioni. *Richiede documentazione clinica e nota nel verbale.*
2. **[EXC-005-02] Priorità di intervento immediato per instabilità emodinamica critica:** Paziente in arresto cardiaco o shock cardiogeno grave, rendendo l'ECG aggiuntivo non prioritario in quel momento. *Richiede documentazione delle manovre salvavita eseguite.*

#### 2.5.8 Azione Attesa e Comportamento Conforme
- **Azione Attesa:** Eseguire la registrazione di un ECG con derivazioni aggiuntive destre (V3R, V4R) e posteriori (V7, V8, V9) per valutare il coinvolgimento del ventricolo destro e della parete posteriore.
- **Obiettivo Clinico:** ECG a derivazioni aggiuntive (V3R, V4R, V7–V9).

**Parametri di Azione (Soglie Temporali per la Qualità):**

| Oggetto del Controllo | Descrizione Parametro | Valore Atteso | Unità |
| :--- | :--- | :--- | :--- |
| Derivazioni destre | Derivazioni per valutare il ventricolo destro | V3R, V4R | N/A |
| Derivazioni posteriori | Derivazioni per identificare infarto posteriore | V7, V8, V9 | N/A |
| Soglia ST (opzionale) | Soglia considerata significativa (posteriore) | > 0.5 | mm |

**Alternative Terapeutiche/Organizzative Conformi ai Percorsi:**

- Esecuzione di ECG a 15 o 18 derivazioni in un'unica registrazione idonea.

#### 2.5.9 Criteri di Completamento del Processo
- **Definizione di Ottemperanza:** La regola si considera soddisfatta quando è stata registrata e documentata in cartella clinica almeno una traccia ECG che includa le derivazioni aggiuntive V3R, V4R e V7–V9, con relativa interpretazione medica.
- **Verifica Operativa:** Affinché il sistema segnali "Conformità Piena", deve essere allegato il tracciato ECG formale con referto interpretativo attestante la lettura delle derivazioni destre e posteriori.

#### 2.5.10 Standard Temporali e Criteri di Precedenza
- **Il Controllo Temporale [TC-005-01]:** L'ECG con derivazioni aggiuntive deve essere eseguito entro 10 minuti dalla registrazione dell'ECG standard con riscontro diagnostico motivante.
- **La Sequenza Normale [SC-005-01]:** L'ECG a 12 derivazioni standard deve precedere la registrazione delle derivazioni aggiuntive per stabilirne l'indicazione.
- **Precedenza sull'Intervento [SC-005-02]:** L'ECG con derivazioni aggiuntive deve essere completato prima dell'attivazione del laboratorio di emodinamica.

#### 2.5.11 Set Minimo di Dati (Clinical Data Elements)
La conformità del percorso si basa sull'adeguata compilazione dei seguenti campi nel Fascicolo Sanitario Elettronico:

- **DE-005-01 - Tracciato ECG a 12 derivazioni standard**
- **DE-005-02 - Sopraslivellamento ST in derivazioni inferiori**
- **DE-005-03 - Sospetto clinico di occlusione coronarica totale**
- **DE-005-04 - ECG standard non conclusivo**
- **DE-005-05 - Impossibilità posizionamento elettrodi aggiuntivi**
- **DE-005-06 - Tracciato ECG con derivazioni aggiuntive**
- **DE-005-07 - Timestamp registrazione ECG aggiuntivo**

#### 2.5.12 Requisiti Cogenti di Qualità Organizzativa (Risk Classification)
- **Rischio Clinico / Sicurezza Paziente:** Danno Alto
- **Rischio Operativo / Di Processo:** Rischio Moderato
- **Probabilità di accadimento di complicanze senza aderenza:** Possibile
- **Priority Score (Risk Management):** 7.5 / 10
- **Razionale d'Azione Coordinata:** La mancata esecuzione delle derivazioni aggiuntive può comportare il mancato riconoscimento dell'estensione dell'infarto, portando a trattamenti inadeguati.

#### 2.5.13 Esiti del Monitoraggio Clinico
- **Esiti Possibili dell'Analisi Cartelle:** Percorso Conforme, Percorso Non Conforme, Deviazione Giustificata.

**Evidenze positive di adeguatezza (Conformità):**

- [EC-005-01] Presenza in cartella clinica di un tracciato ECG con derivazioni aggiuntive V3R, V4R, V7–V9 registrato.
- [EC-005-02] Referto medico con interpretazione delle derivazioni aggiuntive.

**Evidenze documentate di Eventi Avversi (Non-Conformità e Allarmi):**

- [ENC-005-01] Assenza di tracciato ECG con derivazioni aggiuntive in cartella clinica in presenza di STEMI inferiore.
- [ENC-005-02] Ritardo > 10 minuti nell'esecuzione dell'ECG con derivazioni aggiuntive rispetto all'ECG standard diagnostico.

#### 2.5.14 Governance e Controllo d'Aggiornamento Clinico
- **Proprietà del Processo:** Direttore UOC Cardiologia d'Urgenza
- **Frequenza di Revisione PDTA:** Ciclo 12 mesi.

---

### Regola 6: Esecuzione di un ECG a 12 derivazioni aggiuntivo in caso di sintomi ricorrenti o incertezza diagnostica (STEMI-DO-006)

#### 2.6.1 Identificativi della Regola Clinica
- **Codice Univoco:** STEMI-DO-006
- **Versione Schema:** 1.0.0
- **Tipologia di Regola:** Azione Prescrittiva (DO)
- **Titolo Esteso:** Esecuzione di un ECG a 12 derivazioni aggiuntivo in caso di sintomi ricorrenti o incertezza diagnostica
- **Etichetta Breve:** ECG aggiuntivo per sintomi ricorrenti/incertezza
- **ID Percorso Aziendale:** PDTA-STEMI-001
- **Nome Percorso Aziendale:** Percorso Diagnostico Terapeutico Assistenziale per STEMI
- **Fase del Percorso Clinico:** Diagnosi
- **Setting Assistenziale:** Pronto soccorso, unità di terapia intensiva coronarica, pre-ospedaliero, reparto di cardiologia

#### 2.6.2 Mappa delle Responsabilità

| Ruolo Assistenziale | Tipologia di Responsabilità | Unità Organizzativa | Note Operative |
| :--- | :--- | :--- | :--- |
| **Medico d'emergenza** | Primaria | Pronto Soccorso | Responsabile della decisione clinica di eseguire un ECG aggiuntivo e dell'interpretazione del tracciato. |
| **Infermiere di pronto soccorso** | Supporto | Pronto Soccorso | Responsabile dell'esecuzione tecnica dell'ECG a 12 derivazioni su indicazione medica. |
| **Cardiologo di guardia** | Consultazione | Cardiologia / UTIC | Consultato in caso di persistenza dell'incertezza diagnostica dopo l'ECG aggiuntivo. |

#### 2.6.3 Forza della Regola ed Evidenze Scientifiche
- **Grado di Obbligatorietà:** Raccomandata
- **Forza della Raccomandazione Clinica:** Classe I
- **Livello di Evidenza Scientifico:** Livello di evidenza C
- **Dichiarazione Originale:** An additional 12-lead ECG is recommended in cases with recurrent symptoms or diagnostic uncertainty.
- **Declinazione Operativa per la Valutazione:** In presenza di sintomi ricorrenti o incertezza diagnostica, è raccomandata l'esecuzione di un ECG a 12 derivazioni aggiuntivo.
- **Intento di Risk Management:** Garantire una rivalutazione elettrocardiografica tempestiva per identificare variazioni ischemiche evolutive e supportare decisioni terapeutiche appropriate.
- **Razionale Scientifico:** Un ECG a 12 derivazioni aggiuntivo consente di identificare alterazioni del segmento ST di nuova insorgenza o in evoluzione nei casi di incertezza e nei pazienti con sintomi ricorrenti. L'omissione potrebbe ritardare il riconoscimento di STEMI.

#### 2.6.4 Fonti e Riferimenti Normativi
- **Codice Fonte:** ESC-STEMI-2023
- **Livello Autorità:** Internazionale
- **Ente Emittente:** European Society of Cardiology (ESC)
- **Titolo del Documento Relato:** 2023 ESC Guidelines for the management of acute coronary syndromes
- **Sezione di Riferimento:** Sezione Diagnosi – Elettrocardiogramma
- **Citazione Esatta:** "An additional 12-lead ECG is recommended in cases with recurrent symptoms or diagnostic uncertainty."
- **Avvertenza Licenza:** Contenuto soggetto a copyright ESC. Uso a fini clinici e di ricerca secondo i termini dell'editore.

#### 2.6.5 Condizioni di Applicabilità Clinica
- **Popolazione Target:** Pazienti adulti con sospetto clinico di STEMI che presentano sintomi ricorrenti o incertezza diagnostica dopo l'ECG iniziale.
- **Contesto Clinico:** Sospetto STEMI con dolorabilità toracica recidivante o tracciato ECG iniziale non conclusivo.
- **Contesto di Cura:** Fase diagnostica, in ambito pre-ospedaliero, pronto soccorso e unità coronarica.

**Criteri di Inclusione:**

1. **[STEMI-DO-006-INC-01] Sintomi ricorrenti suggestivi di ischemia:** Il paziente presenta recidiva di dolore toracico o sintomi ischemici dopo l'esecuzione del primo ECG. *(Parametri di controllo: DE-STEMI-006-01, DE-STEMI-006-02)*
2. **[STEMI-DO-006-INC-02] Incertezza diagnostica persistente:** Il tracciato ECG iniziale non è conclusivo o il quadro clinico è discordante dai reperti strumentali. *(Parametri di controllo: DE-STEMI-006-03, DE-STEMI-006-04)*

**Criteri di Esclusione:**

1. **[STEMI-DO-006-EXC-01] Diagnosi STEMI già confermata e trattamento avviato:** Se STEMI è stato confermato e la strategia di riperfusione è attiva, la regola non si applica. *(Parametri di controllo: DE-STEMI-006-05, DE-STEMI-006-06)*

#### 2.6.6 Condizione di Avvio del Monitoraggio (Evento Scatenante)
- **Evento Registrato:** Presenza di recidiva di sintomi ischemici o documentazione da parte del clinico di incertezza diagnostica dopo il primo ECG. *(Chiavi referenziate: DE-STEMI-006-01, DE-STEMI-006-02, DE-STEMI-006-03)*
- **Evento di Riferimento (Tempo Zero):** Esecuzione del primo ECG a 12 derivazioni / comparsa sintomi ricorrenti.
- **Finestra temporale:** Dalla comparsa dei sintomi ricorrenti o dell'incertezza, fino alla conferma o esclusione del quadro clinico.

#### 2.6.7 Eccezioni Cliniche Ammesse (Giustificazioni)
Le seguenti condizioni, se documentate, sollevano dalla non conformità per ritardo o mancata esecuzione:

1. **[STEMI-DO-006-EXP-01] Paziente in arresto cardiaco non recuperato:** Arresto cardiaco refrattario dove l'aggiuntivo ECG è ineseguibile per via delle manovre in corso. *Richiede documentazione dello stato in corso.*
2. **[STEMI-DO-006-EXP-02] Trasferimento emergente in atto verso sala di emodinamica:** Il paziente è in rapido trasbordo verso l'emodinamica; fermarsi comporterebbe pericoli inaccettabili. *Richiede nota di rapido trasbordo.*

#### 2.6.8 Azione Attesa e Comportamento Conforme
- **Azione Attesa:** Eseguire un ECG a 12 derivazioni aggiuntivo provvedendo a un'interpretazione rapida del tracciato alla ricerca di modifiche ischemiche.
- **Obiettivo Clinico:** ECG a 12 derivazioni.

**Parametri di Azione (Soglie Temporali per la Qualità):**

| Oggetto del Controllo | Descrizione Parametro | Valore Atteso | Unità |
| :--- | :--- | :--- | :--- |
| Numero di derivazioni | Devono essere incluse le derivazioni standard | 12 | derivazioni |
| Interpretazione clinica documentata | Esito ispezionato da un medico e refertato | presente | N/A |

**Alternative Terapeutiche/Organizzative Conformi ai Percorsi:**

- Monitoraggio ECG continuo con estrapolazione del tracciato periodico standard se la presa separata non è disponibile a braccio.

#### 2.6.9 Criteri di Completamento del Processo
- **Definizione di Ottemperanza:** Acquisizione ed interpretazione loggiata per un ECG a 12 derivazioni pervenuto susseguentemente al primo tracciato, a fronte del trigger emerso.
- **Verifica Operativa:** Affinché il sistema segnali "Conformità Piena", deve esserci acquisizione dell'ECG, l'interpretazione documentata in cartella e relativo timestamp di referto.

#### 2.6.10 Standard Temporali e Criteri di Precedenza
- **Tempistica Attesa [STEMI-DO-006-TC-01]:** Deve essere eseguito entro 10 minuti dalla registrazione dell'evento avverso scatenante (sintomi o insorgere incertezza).
- **La Sequenza [STEMI-DO-006-SC-01]:** Segue l'evento sintomatico e deve occorrere *prima* della delibera definitiva al ripagamento ischemico organico.

#### 2.6.11 Set Minimo di Dati (Clinical Data Elements)
La conformità del percorso si basa sull'adeguata compilazione dei seguenti campi nel Fascicolo Sanitario Elettronico:

- **DE-STEMI-006-01 - Presenza di sintomi ricorrenti**
- **DE-STEMI-006-02 - Timestamp comparsa sintomi ricorrenti**
- **DE-STEMI-006-03 - Incertezza diagnostica documentata**
- **DE-STEMI-006-04 - Referto ECG iniziale**
- **DE-STEMI-006-05 - Diagnosi STEMI confermata**
- **DE-STEMI-006-06 - Attivazione strategia di riperfusione**
- **DE-STEMI-006-07 - Timestamp ECG aggiuntivo**
- **DE-STEMI-006-08 - Referto ECG aggiuntivo**

#### 2.6.12 Requisiti Cogenti di Qualità Organizzativa (Risk Classification)
- **Rischio Clinico / Sicurezza Paziente:** Danno Alto
- **Rischio Operativo / Di Processo:** Rischio Moderato
- **Probabilità di accadimento di complicanze senza aderenza:** Possibile
- **Priority Score (Risk Management):** 7.5 / 10
- **Razionale d'Azione Coordinata:** Il ritardato riconoscimento di una deviazione infartuale grave a causa della latitanza strumentale allunga smisuratamente l'inizio delle procedure salvavita.

#### 2.6.13 Esiti del Monitoraggio Clinico
- **Esiti Possibili dell'Analisi Cartelle:** Percorso Conforme, Percorso Non Conforme, Deviazione Giustificata.

**Evidenze positive di adeguatezza (Conformità):**

- [STEMI-DO-006-EOC-01] Presenza di ECG a 12 derivazioni aggiuntivo dopo la comparsa del trigger.
- [STEMI-DO-006-EOC-02] Refertazione formale del monitor diagnostico aggiuntivo.

**Evidenze documentate di Eventi Avversi (Non-Conformità e Allarmi):**

- [STEMI-DO-006-EONC-01] Assenza manifesta dell'ECG in esame a valle della recrudescenza sintomatica.
- [STEMI-DO-006-EONC-02] ECG eseguito in reazione all'evento ma destituito della necessaria lettura.

#### 2.6.14 Governance e Controllo d'Aggiornamento Clinico
- **Proprietà del Processo:** Dipartimento di Cardiologia d'Urgenza
- **Frequenza di Revisione PDTA:** Ogni 12 mesi.


---

### Regola 7: Dosaggio delle troponine cardiache ad alta sensibilità entro 60 minuti (STEMI-DO-007)

#### 2.7.1 Identificativi della Regola Clinica
- **Codice Univoco:** STEMI-DO-007
- **Versione Schema:** 1.0.0
- **Tipologia di Regola:** Azione Prescrittiva (DO)
- **Titolo Esteso:** Dosaggio delle troponine cardiache con metodo ad alta sensibilità immediatamente dopo la presentazione e ottenimento dei risultati entro 60 minuti dal prelievo ematico
- **Etichetta Breve:** Troponina hs entro 60 min
- **ID Percorso Aziendale:** PDTA-STEMI-001
- **Nome Percorso Aziendale:** Percorso Diagnostico Terapeutico Assistenziale per STEMI
- **Fase del Percorso Clinico:** Diagnosi
- **Setting Assistenziale:** Pronto soccorso, dipartimento di emergenza-urgenza, unità di terapia intensiva cardiologica

#### 2.7.2 Mappa delle Responsabilità

| Ruolo Assistenziale | Tipologia di Responsabilità | Unità Organizzativa | Note Operative |
| :--- | :--- | :--- | :--- |
| **Medico di pronto soccorso** | Primaria | Pronto soccorso | Responsabile della prescrizione del dosaggio della troponina ad alta sensibilità al momento della presentazione del paziente. |
| **Infermiere di triage** | Supporto | Pronto soccorso | Responsabile dell'esecuzione del prelievo ematico e dell'invio del campione al laboratorio secondo protocollo fast-track. |
| **Tecnico di laboratorio biomedico** | Primaria | Laboratorio analisi d'urgenza | Responsabile dell'elaborazione del campione e della refertazione della troponina hs nel tempo stabilito. |
| **Cardiologo di guardia** | Consultazione | Unità di terapia intensiva coronarica | Consultato per l'interpretazione clinica del risultato della troponina nel contesto del sospetto STEMI. |

#### 2.7.3 Forza della Regola ed Evidenze Scientifiche
- **Grado di Obbligatorietà:** Obbligatoria (Mandatory)
- **Forza della Raccomandazione Clinica:** Classe I
- **Livello di Evidenza Scientifico:** Livello B
- **Dichiarazione Originale:** It is recommended to measure cardiac troponins with high-sensitivity assays immediately after presentation and to obtain the results within 60 min of blood sampling.
- **Declinazione Operativa per la Valutazione:** Si raccomanda di dosare le troponine cardiache con metodo ad alta sensibilità immediatamente dopo la presentazione del paziente e di ottenere i risultati entro 60 minuti dal prelievo ematico.
- **Intento di Risk Management:** Garantire una diagnosi biochimica tempestiva di necrosi miocardica mediante il dosaggio rapido delle troponine cardiache ad alta sensibilità per supportare la diagnosi differenziale e la stratificazione del rischio nei pazienti con sospetto STEMI.
- **Razionale Scientifico:** Il dosaggio precoce consente di confermare o escludere rapidamente la necrosi miocardica, supportando le decisioni terapeutiche urgenti e migliorando gli outcome clinici.

#### 2.7.4 Fonti e Riferimenti Normativi
- **Codice Fonte:** ESC-STEMI-GL-2023
- **Livello Autorità:** Internazionale
- **Ente Emittente:** European Society of Cardiology (ESC)
- **Titolo del Documento Relato:** 2023 ESC Guidelines for the management of acute coronary syndromes (Versione: 2023, Pubblicato il: 2023-08-25)
- **Sezione di Riferimento:** Sezione 4 - Diagnosi
- **Citazione Esatta:** "It is recommended to measure cardiac troponins with high-sensitivity assays immediately after presentation and to obtain the results within 60 min of blood sampling."
- **Avvertenza Licenza:** Copyright European Society of Cardiology.

#### 2.7.5 Condizioni di Applicabilità Clinica
- **Popolazione Target:** Pazienti adulti che si presentano al pronto soccorso con sospetta sindrome coronarica acuta con sopraslivellamento del tratto ST (STEMI).
- **Contesto Clinico:** Sospetto clinico di infarto miocardico acuto nell'arrivo al PS.
- **Contesto di Cura:** Pronto soccorso o dipartimento emergenza.

**Criteri di Inclusione:**

1. **[STEMI-DO-007-INC-01] Presentazione con dolore toracico sospetto per SCA:** Il paziente si presenta con dolore toracico o sintomi equivalenti suggestivi di sindrome coronarica acuta. *(Parametri di controllo: DE-STEMI-007-01, DE-STEMI-007-02)*
2. **[STEMI-DO-007-INC-02] Alterazioni ECG compatibili con STEMI:** L'ECG mostra sopraslivellamento del tratto ST o equivalenti elettrocardiografici. *(Parametri di controllo: DE-STEMI-007-03)*

**Criteri di Esclusione:**

1. **[STEMI-DO-007-EXC-01] Diagnosi alternativa certa all'arrivo:** Diagnosi alternativa non cardiaca identificata con certezza che esclude la valutazione cardiologica. *(Parametri di controllo: DE-STEMI-007-08)*

#### 2.7.6 Condizione di Avvio del Monitoraggio (Evento Scatenante)
- **Evento Registrato:** Presentazione del paziente al PS con sospetto STEMI. *(Chiavi referenziate: DE-STEMI-007-01, DE-STEMI-007-02, DE-STEMI-007-03)*
- **Evento di Riferimento (Tempo Zero):** Presentazione del paziente.
- **Finestra temporale:** Dalla presentazione fino alla ricezione del risultato troponina hs.

#### 2.7.7 Eccezioni Cliniche Ammesse (Giustificazioni)

1. **[STEMI-DO-007-EXC-COND-01] Diagnosi STEMI evidente con trasferimento immediato in emodinamica:** Il paziente viene portato in PCI prima che il risultato sia pronto. *Richiede ordine attivazione immediata.*
2. **[STEMI-DO-007-EXC-COND-02] Indisponibilità temporanea del metodo ad alta sensibilità:** Guasto strumentale o del reagente, inibisce temporalmente il test hs. *Richiede documentazione del guasto.*

#### 2.7.8 Azione Attesa e Comportamento Conforme
- **Azione Attesa:** Eseguire immediatamente il prelievo ematico per hs-cTn, ottenendo il referto entro 60 minuti dal prelievo.
- **Obiettivo Clinico:** Refertazione troponina cardiaca ad alta sensibilità (hs-cTnI o hs-cTnT).

**Parametri di Azione (Soglie Temporali per la Qualità):**

| Oggetto del Controllo | Descrizione Parametro | Valore Atteso | Unità |
| :--- | :--- | :--- | :--- |
| Metodo analitico | Dosaggio troponina | alta sensibilità (hs) | N/A |
| Tempistica prelievo | Dal momento dell'arrivo | immediato | N/A |
| Tempo massimo refertazione | Dal prelievo alla refertazione | < 60 | minuti |

#### 2.7.9 Criteri di Completamento del Processo
- **Definizione di Ottemperanza:** Prelievo eseguito immediatamente dopo presentazione, refertato entro 60 min.
- **Verifica Operativa:** Affinché il sistema segnali Conformità, presenza documentale del timestamp prelievo (entro 15 min dall'arrivo) e timestamp refertazione (entro 60 min dal prelievo).

#### 2.7.10 Standard Temporali e Criteri di Precedenza
- **Il Controllo Tempistica [STEMI-DO-007-TC-01]:** Il prelievo ematico deve essere eseguito entro 15 minuti dalla presentazione.
- **Il Controllo Refertazione [STEMI-DO-007-TC-02]:** Il risultato deve essere reso disponibile entro 60 minuti dal prelievo.
- **La Precedenza [STEMI-DO-007-SC-01]:** La presentazione deve precedere il prelievo, il prelievo deve precedere il risultato.

#### 2.7.11 Set Minimo di Dati (Clinical Data Elements)
- **DE-STEMI-007-01 - Motivo di accesso al PS**
- **DE-STEMI-007-02 - Sospetto clinico di SCA**
- **DE-STEMI-007-03 - Risultato ECG**
- **DE-STEMI-007-04 - Data e ora presentazione PS**
- **DE-STEMI-007-05 - Data e ora prelievo troponina**
- **DE-STEMI-007-06 - Data e ora refertazione troponina**

#### 2.7.12 Requisiti Cogenti di Qualità Organizzativa (Risk Classification)
- **Rischio Clinico / Sicurezza Paziente:** Danno Critico
- **Rischio Operativo / Di Processo:** Rischio Alto
- **Priority Score (Risk Management):** 90 / 100
- **Razionale d'Azione Coordinata:** Il ritardo nel test preclude le decisioni salvavita congiunte di rule-in/rule-out.

#### 2.7.13 Esiti del Monitoraggio Clinico
- **Esiti Possibili dell'Analisi Cartelle:** Conforme, Non Conforme, Deviazione Giustificata.

**Evidenze positive di adeguatezza (Conformità):**

- Registrazione di esecuzione prelievo hs-cTn entro rapido delta temporale.
- Esistenza referto rilasciato entro 60 min dal prelievo.

**Evidenze documentate di Eventi Avversi (Non-Conformità):**

- Nessuna prescrizione di biomarker nonostante il trigger.
- Referto ritardato oltre i 60 minuti dal timestamp di raccolta.

#### 2.7.14 Governance e Controllo d'Aggiornamento Clinico
- **Proprietà del Processo:** Direttore Laboratorio Analisi / PS.
- **Frequenza di Revisione PDTA:** 12 mesi.

---

### Regola 8: Utilizzo algoritmo ESC dosaggi seriati hs-cTn (0h/1h o 0h/2h) (STEMI-DO-008)

#### 2.8.1 Identificativi della Regola Clinica
- **Codice Univoco:** STEMI-DO-008
- **Versione Schema:** 1.0.0
- **Tipologia di Regola:** Azione Raccomandata (DO)
- **Titolo Esteso:** Utilizzo dell'approccio algoritmico ESC con dosaggi seriati di troponina cardiaca ad alta sensibilità (hs-cTn) per confermare o escludere NSTEMI
- **Etichetta Breve:** Algoritmo ESC hs-cTn 0h/1h o 0h/2h
- **Fase del Percorso Clinico:** Diagnosi
- **Setting Assistenziale:** Pronto soccorso, dipartimento emergenza-urgenza, unità dolore toracico

#### 2.8.2 Mappa delle Responsabilità

| Ruolo Assistenziale | Tipologia di Responsabilità | Unità Organizzativa | Note Operative |
| :--- | :--- | :--- | :--- |
| **Medico d'urgenza** | Primaria | Pronto soccorso | Responsabile richiesta/interpretazione indici hs-cTn secondo ESC. |
| **Cardiologo** | Consultazione | UTIC | Consulente per casi complessi o per NSTEMI differenziale. |
| **Infermiere di triage** | Supporto | Pronto soccorso | Gestione prelievi tempo 0 e tempo 1h/2h. |
| **Laboratorio analisi** | Supporto | Laboratorio centralizzato | Esecuzione test troponina con fast-track (< 60m). |

#### 2.8.3 Forza della Regola ed Evidenze Scientifiche
- **Grado di Obbligatorietà:** Raccomandata
- **Forza della Raccomandazione Clinica:** Classe I
- **Livello di Evidenza Scientifico:** Livello B

#### 2.8.4 Fonti e Riferimenti Normativi
- **Codice Fonte:** ESC-ACS-2023
- **Ente Emittente:** European Society of Cardiology (ESC)
- **Sezione di Riferimento:** Sezione 3.3.

#### 2.8.5 Condizioni di Applicabilità Clinica
- **Popolazione Target:** Pazienti adulti in pronto soccorso con sospetta SCA senza sopraslivellamento ST, nel percorso differenziale NSTEMI.

**Criteri di Inclusione:**

1. **[IC-008-01] Dolore toracico suggestivo di SCA**
2. **[IC-008-02] ECG senza sopraslivellamento persistente ST**
3. **[IC-008-03] Disponibilità del dosaggio hs-cTn**

**Criteri di Esclusione:**

1. **[EC-008-01] STEMI conclamato all'ECG (indirizzo immediato a lab)**
2. **[EC-008-02] Shock cardiogeno/arresto cardiaco in corso in emodinamico crollo**

#### 2.8.6 Condizione di Avvio del Monitoraggio (Evento Scatenante)
- **Evento Registrato:** Paziente in PS lamenta sintomi sospetto SCA, ed ha un ECG non diagnostico per STEMI.
- **Evento di Riferimento (Tempo Zero):** Primo contatto medico in PS.

#### 2.8.7 Eccezioni Cliniche Ammesse (Giustificazioni)

1. **[EX-008-01] Presentazione molto tardiva (>72h):** Troponina forse in calo, regola 0/1h incerta. *Richiede giustificazione medica.*
2. **[EX-008-02] Dialisi / GFR < 15:** Pazienti terminali renali con Tn persistentemente alta. *Richiede nota clinica.*
3. **[EX-008-03] Indisponibilità Test:** Mancanza della dotazione adeguata, adozione curve prolungate. *Richiede verbale carenza.*

#### 2.8.8 Azione Attesa e Comportamento Conforme
- **Azione Attesa:** Eseguire prelievi seriati di hs-cTn a 0h e a 1h (o 2h) interpretando i valori di transizione basali (Delta).

**Parametri Temporali e Algoritmici:**

| Oggetto del Controllo | Descrizione Parametro | Valore Atteso | Unità |
| :--- | :--- | :--- | :--- |
| Primo Prelievo | Dalla presentazione | 0 | ore |
| Prelievo Seriale 1 | Intervallo da tempo 0 | 1 | ora |
| Prelievo Seriale 2 (alt) | Alternativa se 1h non idoneo | 2 | ore |

#### 2.8.9 Criteri di Completamento del Processo
- **Definizione di Ottemperanza:** Prelievo al T0 e T1h/T2h con delta valutato ed espresso in cartella.

#### 2.8.10 Standard Temporali e Criteri di Precedenza
- L'ECG deve precedere il primo test Tn [SC-008-01]. T0 precede il seriato T1/T2 [SC-008-02].

#### 2.8.11 Set Minimo di Dati (Clinical Data Elements)
- **DE-008-01 - Dolore Toracico**
- **DE-008-02 - ECG non-STEMI**
- **DE-hs_cTn_T0 - Timestamp T0 hs-cTn**
- **DE-hs_cTn_T1 - Timestamp Seriale hs-cTn**

#### 2.8.12 Requisiti Cogenti di Qualità Organizzativa (Risk Classification)
- L'infarto NSTEMI non identificato comporta Danno Critico al paziente.

#### 2.8.13 Esiti del Monitoraggio Clinico
- [Conformità] Tracciabilità dei 2 prelievi nei tempi descritti.
- [Allarmi] Assenza del dosaggio o interruzione non giustificata in paziente ammissibile.

#### 2.8.14 Governance e Controllo d'Aggiornamento Clinico
- Revisione 12 mesi da parte di Dipartimento Emergenza-Urgenza.

---

### Regola 9: Eseguire test aggiuntivo di hs-cTn a 3 ore per risultati inconcludenti (STEMI-DO-009)

#### 2.9.1 Identificativi della Regola Clinica
- **Codice Univoco:** STEMI-DO-009
- **Etichetta Breve:** hs-cTn aggiuntiva a 3 h se inconcludente
- **Tipologia di Regola:** Azione Raccomandata (DO)
- **Fase del Percorso Clinico:** Diagnosi

#### 2.9.2 Mappa delle Responsabilità
- Medico di PS (Primaria), Infermiere (Supporto), Laboratorio, Cardiologia (Consulenza).

#### 2.9.3 Forza della Regola ed Evidenze Scientifiche
- **Grado di Obbligatorietà:** Raccomandata
- **Dichiarazione Originale:** Additional testing after 3 h is recommended if the first two hs-cTn measurements of the 0 h/1 h algorithm are inconclusive and no alternative diagnoses explaining the condition have been made.

#### 2.9.4 Fonti e Riferimenti Normativi
- **Codice Fonte:** ESC-ACS-2023

#### 2.9.5 Condizioni di Applicabilità Clinica
- **Criteri di Inclusione:** Algoritmo 0h/1h precedente terminato nella **"zona grigia"** (inconcludente) in assenza di diagnostica alternativa.
- **Criteri di Esclusione:** Evidenza accertata di STEMI o patologie extra-cardiache esimenti diagnosticate in frattempo.

#### 2.9.6 Condizione di Avvio del Monitoraggio (Evento Scatenante)
- **Evento Registrato:** Fine step algoritmo 0h/1h con esito "inconcludente".
- **Tempo Zero:** Arrivo paziente (per computo totale le 3 ore nascono dal record di arrivo in PS).

#### 2.9.7 Eccezioni Cliniche Ammesse (Giustificazioni)

1. Scoperta sopravvenuta patologia o instabilità emodinamica subentrante tale da bloccare il processo standard in emergenza.
2. Dimissione volontaria (il paziente rifiuta prelievo firmando).

#### 2.9.8 Azione Attesa e Comportamento Conforme
- Effettuare test hs-cTn a 3 ore da evento arrivo qualora la curva si limiti a borderlines.

| Oggetto del Controllo | Descrizione Parametro | Valore Atteso | Unità |
| :--- | :--- | :--- | :--- |
| Timing Test a 3 h | Tempo da t0 (arrivo) per il 3° dosaggio | 3 | ore |

#### 2.9.9 Criteri di Completamento del Processo
- Presenza numerica e refertata del dosaggio effettuato in traguardo "terza ora", con valutazione clinica annessa.

#### 2.9.10 Standard Temporali e Criteri di Precedenza
- Il 3° prelievo segue la refertazione insoddisfacente del T0/T1. Refertazione del T3 auspicabile in <60m.

#### 2.9.11 Set Minimo di Dati (Clinical Data Elements)
- Registratori del Laboratorio a T0, T1, T3 e verbale refertativo del medico che indica sospetto in persistenza.

#### 2.9.12 Requisiti Cogenti di Qualità Organizzativa (Risk Classification)
- Rischio clinico elevato a causa della potenzialità di dismissione errata di un pz infartuato nella sola "zona grigia" iniziale.

#### 2.9.13 Esiti del Monitoraggio Clinico
- [Conformità] Dosaggio rilevato in 3° ora e valutato in nota clinica d'esito in PS.

#### 2.9.14 Governance e Controllo d'Aggiornamento Clinico
- Primario Pronto Soccorso, rinnovo ogni 12 mesi.

---

### Regola 10: Ecocardiografia TTE di emergenza in shock / complicanze (STEMI-DO-010)

#### 2.10.1 Identificativi della Regola Clinica
- **Codice Univoco:** STEMI-DO-010
- **Etichetta Breve:** TTE emergenza in shock cardiogeno / complicanze
- **Tipologia di Regola:** Azione Raccomandata (DO)

#### 2.10.2 Mappa delle Responsabilità
- Cardiologo ecocardiografista responsabile primario; Medico PS o UTIC richiedente d'attivazione.

#### 2.10.3 Forza della Regola ed Evidenze Scientifiche
- **Grado di Obbligatorietà:** Raccomandata
- **Razionale:** Le complicanze meccaniche o lo shock esigono visibilità emodinamica impellente per identificazione versamenti/rotture che necessitano procedure eroiche in lab o in chirurgia.

#### 2.10.4 Fonti e Riferimenti Normativi
- ESC-STEMI-2023

#### 2.10.5 Condizioni di Applicabilità Clinica
- Trovata caduta emodinamica, ipotensione e collasso, o soffi improvvisi ascrivibili a rottura del setto dopo l'infarto.

#### 2.10.6 Condizione di Avvio del Monitoraggio (Evento Scatenante)
- Ingresso documentato del quadro di instabilità/shock cardiogeno o soffio cardiaco ex-novo.

#### 2.10.7 Eccezioni Cliniche Ammesse (Giustificazioni)
1. Macchina non agibile per guasto a fronte di trasbordo urgente immediato a cardiochirurgia. 
2. CPR continua invasiva dove l'eco causerebbe stop alle manovre BLS vitali protratte.

#### 2.10.8 Azione Attesa e Comportamento Conforme
- Erogazione TTE transtoracica tempestiva con disamina funzionale e screening pericardico.

| Oggetto del Controllo | Descrizione Parametro | Valore Atteso | Unità |
| :--- | :--- | :--- | :--- |
| Valutazione integrata | Sistolica/Diastolica, versamenti, setto | Completata | N/A |
| Tolleranza d'urgenza | < 30 minuti da avvistamento calo vitale | 30 | minuti |

#### 2.10.9 Criteri di Completamento del Processo
- Valutazione refertata con diagnosi chiara di "esclusione problemi meccanici" oppure "accertata lesione/tamponamento".

#### 2.10.10 Standard Temporali e Criteri di Precedenza
- TTE debita entro 30 minuti dall'innesco dello shock. Non deve precedere manovre di pur rianimazione cardiopolmonare base.

#### 2.10.11 Set Minimo di Dati (Clinical Data Elements)
- Dati di Shock (Ipotensione arteriosa, marker ipoperfusivo), referto ETE/TTE formalizzato.

#### 2.10.12 Requisiti Cogenti di Qualità Organizzativa (Risk Classification)
- Rischio estremo per il paziente in assenza diagnostica e impossibilità alle chirurgie mirate.

#### 2.10.13 Esiti del Monitoraggio Clinico
- [Non Conformità] Sgravio del pz grave in cardiogenia senza documentazione d'immagini pre-operatorie di valenza clinico-legale.

#### 2.10.14 Governance
- Primario UOC Cardiologia interventistica.

---

### Regola 11: Non eseguire di routine angio-TC coronarica in SCA sospetta (STEMI-DONOT-001)

#### 2.11.1 Identificativi della Regola Clinica
- **Codice Univoco:** STEMI-DONOT-001
- **Tipologia di Regola:** Azione Proibita (DONOT)
- **Titolo Esteso:** Non eseguire di routine angio-TC coronarica precoce nei pazienti con sospetta sindrome coronarica acuta.
- **Etichetta Breve:** No angio-TC coronarica di routine in SCA sospetta

#### 2.11.2 Mappa delle Responsabilità
- Medico di Pronto Soccorso in quanto emettitore potenziale di un esame errato. Radiologo e Cardiologo di Guardia avvisati.

#### 2.11.3 Forza della Regola ed Evidenze Scientifiche
- **Grado di Obbligatorietà:** Proibita (Classe III - nessun beneficio).
- **Razionale:** Una diagnostica TAC cardiaca abusa e ritarda il tempo Door-To-Balloon in un sospetto SCA, recando contrasti e dilatando i pre-tempi inemendabilmente a sfavore della diagnostica Emodinamica Standard.

#### 2.11.4 Fonti e Riferimenti Normativi
- ESC-GUIDELINES-ACS-2023, Classe III (Non Raccomandato).

#### 2.11.5 Condizioni di Applicabilità Clinica
- Tutti i pazienti in setting Triage PS con referto SCA, nell'arco delle iniziali 24 ore senza indicazioni particolari per coronarografia.

#### 2.11.6 Condizione di Avvio del Monitoraggio (Evento Scatenante)
- L'evento avverso per il monitoring di compliance è quando viene redatto un ticket RIS ospedaliero per un esame tipo CCTA (Angio-TC) recando codice diagnostico "sospetto infarto / dolore ischemico acuto".

#### 2.11.7 Eccezioni Cliniche Ammesse (Giustificazioni Operative e Override)

1. Paziente non idoneo ed in palese controindicazione all'angiografia invasiva per emodinamica (allergie estreme assodate da referto escludente, ecc.) dove l'unica indagine ammissibile all'anatomia sia una TC come ripiego valutato.
2. In rarissimi consulti tra primario-cardiologo e radiologo dove il referto di SCA non sia univoco e serva dirimere emergenze vascolari polimorfe (ex probabilità pre-test bassissima ma in cerca di conferme con Tn negative).

#### 2.11.8 Azione Attesa e Comportamento Conforme
- L'Azione richiesta è **non richiedere** standardmente questa CT-Scan in PS in paziente coronaro-acuto.

| Oggetto della Proibizione | Modalità d'Interdizione |
| :--- | :--- |
| Valutazione | Esame da sbarrare nei software radiologici senza nota clinica d'assoluta esenzione override. |
| Tolleranza Temporale | L'inibitoria permane solida specialmente per le prime <24h calde del percorso inziale. |

#### 2.11.9 Criteri di Completamento del Processo
- Completa aderenza se in fase di dimissioni dall'episodio non figurano addebiti DICOM per refertazione Angio-TC in quadro isolato STEMI/NSTEMI congiunto.

#### 2.11.10 Standard Temporali e Criteri di Precedenza
- La proibitiva vige assoluta nelle 24h dall'acceso e prima dell'Emodinamica Invasiva regolare.

#### 2.11.11 Set Minimo di Dati (Clinical Data Elements)
- Richieste DICOM in PS per la topografia Radiologica, matchate coi codici ICD per l'infarto all'atto della dimissione di Triage.

#### 2.11.12 Requisiti Cogenti di Qualità Organizzativa (Risk Classification)
- Somma sprechi e dilazione ingiustificata del processo d'Emodinamica in paziente che abbisogna di Cateterizzazione in luogo standard e non di immagine radiologica d'ambulatoriata.

#### 2.11.13 Esiti del Monitoraggio Clinico
- [Non Conformità] Emissione di richiesta RIS e suo adempimento a cura del dipartimento d'urgenza. Fallimento di compliance nel pathway organizzativo.

#### 2.11.14 Governance e Controllo d'Aggiornamento Clinico
- Direzione Inter-Dipartimentale Radiologia e Cardiologia.

