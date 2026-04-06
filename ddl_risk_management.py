import subprocess
import os
import sys

def extract_ddl(dbname="RiskMgm", host="localhost", user="postgres", output_file="RiskMgm_DDL.sql"):
    """
    Estrae il DDL completo di un database PostgreSQL utilizzando l'utility nativa pg_dump.
    Questo garantisce l'estrazione integrale e corretta di tabelle, viste, indici, trigger, ecc.
    """
    
    # Percorso assoluto per pg_dump.exe trovato sul sistema
    pg_dump_path = r"C:\Program Files\PostgreSQL\18\bin\pg_dump.exe"
    
    print(f"Inizio estrazione del DDL per il database '{dbname}'...")
    
    try:
        # Argomenti di pg_dump:
        # -s : Estrae solo lo schema (DDL), senza i dati
        # -O : Non include le istruzioni per impostare l'owner (più agnostico)
        # -x : Non include le istruzioni GRANT/REVOKE sui privilegi
        # -f : Specifica il file di output
        command = [
            pg_dump_path,
            "-h", host,
            "-U", user,
            "-s",         # Schema only
            "-O",         # No ownership info
            "-x",         # No privileges
            "-f", output_file,
            dbname
        ]
        
        env = os.environ.copy()
        env['PGPASSWORD'] = 'Sanbarra123' # Password inserita

        print(f"Esecuzione comando per lo schema...")
        subprocess.run(command, env=env, check=True, capture_output=True, text=True)
        
        # Tabelle di cui estrarre i dati
        tables_with_data = [
            "riskm_manager_model_evaluation.clinical_pathway",
            "riskm_manager_model_evaluation.rule_definition",
            "riskm_manager_model_evaluation.compliance_type",
            "riskm_manager_model_evaluation.model",
            "riskm_manager_model_evaluation.router",
        ]
        
        # Comando per i dati
        data_command = [
            pg_dump_path,
            "-h", host,
            "-U", user,
            "-a",                 # Solo dati
            "--inserts",          # Export formato INSERT invece di COPY (molto più robusto e leggibile)
        ]
        for tbl in tables_with_data:
            data_command.extend(["-t", tbl])
        data_command.append(dbname)
        
        print("Estrazione in corso in append dei dati (INSERT) per le tabelle anagrafiche scelte...")
        data_result = subprocess.run(data_command, env=env, check=True, capture_output=True, text=True)
        
        # Accoda il risultato al file esistente
        with open(output_file, 'a', encoding='utf-8') as f_out:
            f_out.write("\n\n-- ==========================================================\n")
            f_out.write("-- DATI AGGIUNTIVI DELLE TABELLE ANAGRAFICHE SELEZIONATE\n")
            f_out.write("-- ==========================================================\n\n")
            f_out.write(data_result.stdout)
            
        print(f"Estrazione completata con successo. Il DDL e i dati anagrafici sono stati salvati in: {output_file}")
        
    except FileNotFoundError:
        print("ERRORE: L'utility 'pg_dump' non è stata trovata.")
        print("Assicurati che gli strumenti a riga di comando di PostgreSQL (bin) siano aggiunti alla variabile d'ambiente PATH della tua macchina Windows.")
        sys.exit(1)
    except subprocess.CalledProcessError as e:
        print(f"ERRORE durante l'esecuzione di pg_dump: {e}")
        if e.stderr:
            print(f"Dettaglio dell'errore (stderr):\n{e.stderr}")
        sys.exit(1)
    except Exception as e:
        print(f"Si è verificato un errore imprevisto: {e}")
        sys.exit(1)

if __name__ == "__main__":
    # Parametri passati specificamente:
    # Database: RiskMgm
    # Host: localhost (sulla stessa macchina)
    # Nessuna password: Il comando pg_dump si aspetta che non sia richiesta, o che sia usata l'autenticazione trust/ident.
    
    # Esegue l'estrazione. Assumiamo che l'utente sia 'postgres', altrimenti cambialo nel parametro 'user'.
    extract_ddl(dbname="RiskMgm", host="localhost", user="postgres", output_file="RiskMgm_DDL.sql")