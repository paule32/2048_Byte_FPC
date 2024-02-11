set fpcdir=C:\FPC\3.2.0\bin\i386-win32
set fpcx64=%fpcdir%\ppcrossX64.exe
set fpcstr=%fpcdir%\strip.exe

set fpcdst=-Twin64 -Mdelphi -dwindows -dwin64
set fpcasm=-Anasmwin64 -al

set fpcflags=%fpcdst% -b- -Sg -O2 -Os -Fu./units -vl ^
	-Fu./units           ^
	-Fu./units/rtl       ^
	-Fu./sources/fpc-sys ^
	-Fu./sources/fpc-rtl

mkdir units
%fpcdir%\x86_64-win64-nasm.exe -fwin64 -o.\units\fpcinit.o .\sources\fpc-sys\fpcinit.asm

%fpcx64% -FE./units %fpcflags% -Us ./sources/fpc-sys/system.pas
%fpcx64% -FE./units/fpc-rtl %fpcflags% ./sources/fpc-rtl/rtl.utils.pas

%fpcx64% -FE./tests/units %fpcflags% %fpcasm% -XMmainCRTstartup ./sources/fpc-test/test1.pas

grep -v "SECTION .fpc" .\tests\units\test1.s > .\tests\units\test2.s
grep -v "__fpc_ident"  .\tests\units\test2.s > .\tests\units\test1.s

sed -i '/\; Begin asmlist al_dwarf_frame.*/,/\; End asmlist al_dwarf_frame.*/d' .\tests\units\system.s
sed -i '/\; Begin asmlist al_indirectglobals.*/,/\; End asmlist al_indirectglobals.*/d' .\tests\units\system.s
sed -i '/\; Begin asmlist al_rtti.*/,/\; End asmlist al_rtti.*/d' .\tests\units\system.s

sed -i '/\; Begin asmlist al_dwarf_frame.*/,/\; End asmlist al_dwarf_frame.*/d' .\tests\units\test1.s
sed -i '/\; Begin asmlist al_rtti.*/,/\; End asmlist al_rtti.*/d' .\tests\units\test1.s
sed -i '/File \..*/d' .\tests\units\test1.s

nasm -f win64 -o .\tests\units\system.o .\tests\units\system.s
nasm -f win64 -o .\tests\units\test1.o  .\tests\units\test1.s

x86_64-win64-ld.exe -b pei-x86-64 -nostdlib -s --entry=_mainCRTstartup -o .\tests\units\test1.exe .\tests\test1.ld

copy .\tests\units\test1.exe .\tests\test1.exe
%fpcstr%   .\tests\test1.exe
