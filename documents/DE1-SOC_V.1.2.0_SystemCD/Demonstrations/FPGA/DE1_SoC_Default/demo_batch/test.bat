@echo off  
set project.sof=DE1_SoC_Default.sof
set project.jic=DE1_SoC_Default.jic
set device_sfl.sof=sfl_enhanced_01_02d120dd.sof
set fpga_device=5csema5 
goto main

:main
echo **********************************
echo Plesase choise your operation
echo "1" for programming .sof to FPGA.
echo "2" for converting .sof to .jic 
echo "3" for programming .jic to EPCQ.
echo "4" for erasing .jic from EPCQ.
echo **********************************
choice /C 1234 /M "Please enter your choise:" 
if errorlevel 4 goto d 
if errorlevel 3 goto c  
if errorlevel 2 goto b  
if errorlevel 1 goto a 


:a
echo ===========================================================
echo "Progrming .sof to FPGA"
echo ===========================================================
%QUARTUS_ROOTDIR%\\bin\\quartus_pgm.exe -m jtag -c 1 -o "p;%project.sof%@1"
@ set SOPC_BUILDER_PATH=%SOPC_KIT_NIOS2%+%SOPC_BUILDER_PATH%
goto end


:b 
echo ===========================================================
echo "Convert .sof to .jic"
echo ===========================================================
%QUARTUS_ROOTDIR%\\bin\\quartus_cpf -c -d epcq256 -s %fpga_device% %project.sof% %project.jic%
goto end

:c
echo ===========================================================
echo "Programming EPCQ with .jic"
echo ===========================================================
%QUARTUS_ROOTDIR%\\bin\\quartus_pgm.exe -m jtag -c 1 -o "p;%device_sfl.sof%@1"
%QUARTUS_ROOTDIR%\\bin\\quartus_pgm.exe -m jtag -c 1 -o "p;%project.jic%@1"
goto end

:d
echo ===========================================================
echo "Erasing EPCQ with .jic"
echo ===========================================================
%QUARTUS_ROOTDIR%\\bin\\quartus_pgm.exe -m jtag -c 1 -o "p;%device_sfl.sof%@1"
%QUARTUS_ROOTDIR%\\bin\\quartus_pgm.exe -m jtag -c 1 -o "r;%project.jic%@1"
goto end

:end
echo Job Done!!
goto main
