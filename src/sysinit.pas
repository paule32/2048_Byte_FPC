// ----------------------------------------------------------
// This file is part of RTL.
//
// (c) Copyright 2021 Jens Kallup - paule32
// only for non-profit usage !!!
// ----------------------------------------------------------
{$mode delphi}
unit sysinit;

interface

//procedure LazExitProcess (ExitCode: LongInt); cdecl; external 'laz_rtl.dll' name 'LazExitProcess';

implementation

procedure PascalMain; external name 'PASCALMAIN';

procedure Entry; [public, alias: '_mainCRTStartup'];
begin
  PascalMain;
//  LazExitProcess(0);
end;

end.
