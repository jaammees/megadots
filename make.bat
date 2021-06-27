set KICKASM=java -cp C:\mega65\kickassembler\kickassembler-5.19-65ce02.a.jar kickass.KickAssembler65CE02 -vicesymbols -showmem

%KICKASM% main.s -odir ./bin

"D:\xemu-merger\xmega65.exe" -besure -prg "./bin/main.prg"
