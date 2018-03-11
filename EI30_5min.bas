Attribute VB_Name = "Módulo2"
Sub P_mm_5min()
'soma as precipitações de 5 min
Dim comeco, termino, fim, inter As Integer

soma = 0
termino = 3         'laço interno para acumular o nº da linha onde termina o intervalo de 5min
comeco = 3          ' linha onde começa o intervalo de tempo
fim = Cells(1, 5)

Cells(1, 6) = "P_5min (mm)"
Cells(1, 7) = "I5(mm h-1)"
Cells(1, 8) = "Ec (MJ ha-1 mm-1)"
Cells(1, 9) = "Ec total (MJ ha-1 mm-1)"
Cells(1, 10) = "I30 (mm h-1)"
Cells(1, 11) = "EI30 (MJ mm ha-1 h-1)"
Cells(1, 12) = "P 6h (mm)"

For comeco = 3 To fim
   
    Do While tempo5min < 0.003472223 'confere se o tempo é 5 min
    
    tempo5min = Cells(termino, 3) - Cells(comeco, 3)
    If tempo5min < 0.003472223 Then termino = termino + 1
    
    Loop
 
 temporario = 0
    
    For inter = comeco To termino - 1 ' soma as precipitações de 5 em 5 min
     soma = temporario + Cells(inter, 4)
     temporario = soma
     
     Next inter
     

Cells(termino - 1, 6) = soma
Cells(termino - 1, 7) = soma * 60 / 5 ' calcula e escreve a I_5min
I = soma * 60 / 5
Cells(termino - 1, 8) = (0.119 + 0.0873 * WorksheetFunction.Log10(I)) 'Calcula Ec
If I > 76 Then Cells(termino - 1, 8) = 0.283 ' restrição encontrada no trabalho de Foster 1981
comeco = termino - 1
tempo5min = 0
Next comeco

End Sub

Sub ECtotal()
'soma as EC de eventos com intervalo máx de 6h

Dim comeco, termino, fim, inter, inter30 As Integer

soma = 0
termino = 3         'laço interno para acumular o nº da linha onde termina o intervalo de 6h
fim = Cells(1, 5)   ' laço externo para fazer a soma. Será igual ao total de dados
comeco = 3          ' linha onde começa o intervalo de tempo

For comeco = 3 To fim
   
    Do While tempo6h < 0.25 'confere se o tempo é 6h
        tempo6h = Cells(termino + 1, 3) - Cells(termino, 3)
        termino = termino + 1
    Loop
 
    temporario = 0
    
    For inter = comeco To termino - 1 ' soma a Ec do evento e multiplica pela P5min para obter Ec em MJ /ha
  
     soma = temporario + (Cells(inter, 8) * Cells(inter, 6))
     temporario = soma
        atua = 0
         For inter1 = comeco To termino - 1
            Prec6h = atua + Cells(inter1, 6)
            atua = Prec6h
         Next inter1
     Cells(termino - 1, 12) = Prec6h
     If Prec6h < 10 Then soma = 0 'restrição de De Maria (1994) para P < 10 mm
    Next inter
    
For comeco30 = comeco To termino - 1
        dT30 = comeco30 + 1
        T30min = 0
           Do While T30min <= 0.0208 'confere se o tempo é 30 min
             T30min = Cells(dT30, 3) - Cells(comeco30, 3)
             If T30min <= 0.0208 Then dT30 = dT30 + 1
           Loop
        
        ' 2º calcular a I para estes 30 min
             temp = 0
            For inter30 = comeco30 To dT30 - 1
             Int30 = temp + Cells(inter30, 4)
             temp = Int30
            Next inter30
            Int30 = Int30 * 2
            Cells(comeco30, 15) = Int30
          
    Next comeco30
        termino = termino - 1
        Int_max_30min = WorksheetFunction.Max(Range(Cells(comeco, 15), Cells(termino, 15)))
        termino = termino + 1
    
Cells(termino - 1, 10) = Int_max_30min
Cells(termino - 1, 9) = soma
Cells(termino - 1, 11) = Cells(termino - 1, 10) * Cells(termino - 1, 9)
comeco = termino - 1
tempo6h = 0
Next comeco
Columns("O:O").Select
    Selection.ClearContents
End Sub




