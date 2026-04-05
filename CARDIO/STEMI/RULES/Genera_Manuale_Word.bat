@echo off
chcp 65001 >nul
echo Generazione del documento Word con Table of Contents in corso...
pandoc Manuale_Regole_Cliniche_STEMI.md -o Manuale_Regole_Cliniche_STEMI.docx --toc
echo Generazione completata con successo!
pause
