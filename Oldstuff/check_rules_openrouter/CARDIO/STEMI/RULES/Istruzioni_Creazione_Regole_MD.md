# Istruzioni per la Redazione e l'Aggiunta di Nuove Regole Cliniche (PDTA STEMI)

Questo documento definisce le linee guida e le convenzioni per aggiungere nuove regole cliniche (espresse nativamente in JSON) al file `Manuale_Regole_Cliniche_STEMI.md`. Serve a garantire **omogeneità clinica e corretta compilazione tipografica tramite Pandoc**.

---

## 1. Struttura Generale della Regola nel Manuale Markdown
Ogni nuova regola deve essere aggiunta in coda al manuale. Deve iniziare con un titolo di livello 3 (`### Regola [N]: [Nome] ([ID])`) e suddividersi nativamente in 14 sottosezioni di livello 4 (`####`), seguite da liste e paragrafi:

1. **Identificativi della Regola Clinica:** Codice, Versione, Fase del Percorso.
2. **Mappa delle Responsabilità:** Tabella riepilogativa (Medico PS, Cardiologo, ecc.).
3. **Forza della Regola ed Evidenze Scientifiche:** Livello di evidenza B/I, Classi e Intento di Risk Management descrittivo.
4. **Fonti e Riferimenti Normativi:** Codice Fonte e Citazione esatta (es. ESC 2023).
5. **Condizioni di Applicabilità Clinica:** Elenco puntato di "Criteri di Inclusione" ed "Esclusione".
6. **Condizione di Avvio del Monitoraggio (Evento Scatenante):** Quando inizia il calcolo.
7. **Eccezioni Cliniche Ammesse (Giustificazioni):** Elenco numerato di esenzioni (arresto cardiaco, Rifiuto).
8. **Azione Attesa e Comportamento Conforme:** Con espressione dei `Parametri di Azione (Soglie Temporali per la Qualità)` tramite Tabella dedicata.
9. **Criteri di Completamento del Processo:** Definizione verbale di fine processo.
10. **Standard Temporali e Criteri di Precedenza:** Descrizione logica dei tempi hard/soft.
11. **Set Minimo di Dati (Clinical Data Elements):** Lista puntata di eventi necessari con la propria ID (es. `DE-001`).
12. **Requisiti Cogenti di Qualità Organizzativa (Risk Classification):** Rischio clinico, Severity e Score.
13. **Esiti del Monitoraggio Clinico:** Elenchi puntati separati tra `Evidenze positive di adeguatezza (Conformità)` ed `Evidenze documentate di Eventi Avversi (Non-Conformità e Allarmi)`.
14. **Governance e Controllo d'Aggiornamento Clinico:** Responsabile e revisione.

---

## 2. Traduzione della Terminologia (Divieto di IT Jargon)
L'agente AI che esegue la traduzione dal file `.json` sorgente **non deve mai esporre terminologia informatica** (jargon del Rule Engine) al lettore (Medici, Dirigenti Sanitari), operando le seguenti sostituzioni fisse:

*   **Forza Deontica / Deontic Strength** ➔ `Grado di Obbligatorietà` (es. Obbligatoria/Mandatory o Raccomandata)
*   **Dichiarazione Originale (o Declinazione Originale)** ➔ `Deve essere omessa e rimossa del tutto` dal testo finale in italiano.
*   **Trigger** ➔ `Evento Scatenante`
*   **Timestamp / Time target** ➔ `Data e Ora` / `Tempo Zero` / `Orizzonte Temporale`
*   **Clinical Data Element / Data Array** ➔ `Set Minimo di Dati` (identificati come parametri clinici, non come var informatiche)
*   *Condizioni logiche ad albero (AND/OR espliciti, if/else, operatori)* ➔ `Devono essere convertite testualmente` in un registro clinico narrativo fluido (es: "Per la piena conformità è necessaria la presenza simultanea di X, Y e Z").

---

## 3. Regole di Formattazione Markdown (Estremamente Importanti per Pandoc)
Affinché i tools di rigenerazione automatica come **Pandoc** non fondano tra loro il testo quando compilano formati finali `.docx` o `.pdf`, è obbligatorio applicare le seguenti regole:

1. **Prima di una Tabella (caratterizzata da righe `| Valore | ... |`), ci DEVE essere una riga di spaziatura completamente vuota.**
2. **Prima di un Elenco Puntato (`- `) o Numerato (`1. `), ci DEVE essere una riga di spaziatura completamente vuota.**
3. **Le righe contenenti i subheader `####` devono andare sempre precedute da uno spazio a capo.**

**Esempio Positivo:**
```markdown
- **Obiettivo Clinico:** Valutazione diagnostica.

**Parametri di Azione (Soglie Temporali per la Qualità):**

| Oggetto del Controllo | Descrizione Parametro | Valore Atteso | Unità |
| :--- | :--- | :--- | :--- |
| Valore | Valore | Valore | N/A |
```

**Esempio Da Evitare (Mischia la tabella o l'elenco):**
```markdown
- **Obiettivo Clinico:** Valutazione diagnostica.
**Parametri di Azione (Soglie Temporali per la Qualità):**
| Oggetto del Controllo | Descrizione Parametro | Valore Atteso | Unità |
| :--- | :--- | :--- | :--- |
```

---

## 4. Codifica del File
*   Le modifiche al file Markdown devono rispettare rigorosamente l'encoding **UTF-8 (senza BOM)**, specialmente se iniettate tramite PowerShell.
*   Lettere accentate (`à, è, ì, ò, ù`) non devono essere corrotte (es. `UnitÃ `). L'editor o lo script dell'Agent vi farà sempre attenzione.

### Come richiedere una nuova Regola
Nelle conversazioni future o nelle procedure, per convertire un nuovo file si potranno impartire le istruzioni fornendo come prompt d'ambiente questo file stesso. Esempio verbale:
> *"Aggiungi la regola STEMI-DO-004 leggendo il JSON e rispettando precisamente lo stile, i termini e gli spazi per Pandoc definiti nel file `Istruzioni_Creazione_Regole_MD.md`."*
