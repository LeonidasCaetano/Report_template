import os

append = "Apendices"
anex = "Anexos"

apendices = [f for f in os.listdir(append)]
anexos = [f for f in os.listdir(anex)]

with open("Append_and_Anex.tex", "w", encoding="utf-8") as file:
    file.write("% Apêndices\n\n")
    for i in apendices:
        file.write(f"\\input{{3-PosTextual/Apendices/{i}}}\n\n")
    file.write("% Anexos\n\n")
    for i in anexos:
        file.write(f"\\input{{3-PosTextual/Apendices/{i}}}\n\n")
