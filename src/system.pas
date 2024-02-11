// ----------------------------------------------------------
// This file is part of RTL.
//
// (c) Copyright 2021 Jens Kallup - paule32
// only for non-profit usage !!!
// ----------------------------------------------------------
{$mode delphi}
unit system;

interface

//type Smallint = -32768..32767;
//type LongWord =      0..4294967295;

type Integer  = SmallInt;
type SizeInt  = LongInt;

type Cardinal = LongWord;
type DWord    = LongWord;
type UInt32   = Cardinal;
type SizeUInt = DWord;

type CodePointer = Pointer;
type PShortString = ^ShortString;

type HRESULT  = LongInt;

type
	PJmp_buf = ^jmp_buf;
	jmp_buf  = packed record
		ebx:   LongInt;
		esi:   LongInt;
		edi:   LongInt;
		bp:    Pointer;
		sp:    Pointer;
		pc:    Pointer;
	end;

type
	PExceptAddr = ^TExceptAddr;
	TExceptAddr = record
		buf       : pjmp_buf;
		next      : PExceptAddr;
		frametype : Longint;
	end;

type
	FileRec = record
		Mode: LongInt;
	end;

type
	PGuid = ^TGuid;
	TGuid = packed record
		case Integer of
			1 : (
				Data1 : DWord;
				Data2 : word;
				Data3 : word;
				Data4 : array[0..7] of byte;
			);
			2 : (
				D1 : DWord;
				D2 : word;
				D3 : word;
				D4 : array[0..7] of byte;
			);
			3 : ( { uuid fields according to RFC4122 }
				time_low : dword;
				time_mid : word;
				time_hi_and_version : word;
				clock_seq_hi_and_reserved : byte;
				clock_seq_low : byte;
				node : array[0..5] of byte;
			);
		end;

type
	TTypeKind = (
		tkUnknown,		// Unknown property type.
		tkInteger,		// Integer property.
		tkChar, 		// Char property.
		tkEnumeration,	// Enumeration type property.
		tkFloat,		// Float property.
		tkSet,			// Set property.
		tkMethod,		// Method property.
		tkSString,		// Shortstring property.
		tkLString,		// Longstring property.
		tkAString,		// Ansistring property.
		tkWString,		// Widestring property.
		tkVariant,		// Variant property.
		tkArray,		// Array property.
		tkRecord,		// Record property.
		tkInterface,	// Interface property.
		tkClass,		// Class property.
		tkObject,		// Object property.
		tkWChar,		// Widechar property.
		tkBool,			// Boolean property.
		tkInt64,		// Int64 property.
		tkQWord,		// QWord property.
		tkDynArray, 	// Dynamic array property.
		tkInterfaceRaw, // Raw interface property.
		tkProcVar,		// Procedural variable
		tkUString,		// Unicode string
		tkUChar,		// Unicode character
		tkHelper,		// Helper type
		tkFile, 		// File type
		tkClassRef, 	// Class reference type
		tkPointer		// Generic pointer type
	);

type
	PText = ^Text;
	
	TextRec = packed  record
//		Handle    : THandle;
		Mode      : longint;
		bufsize   : SizeInt;
		_private  : SizeInt;
		bufpos,
		bufend    : SizeInt;
//		bufptr    : ^textbuf;
//		openfunc,
//		inoutfunc,
//		flushfunc,
//		closefunc : codepointer;
//		UserData  : array[1..32] of byte;
//		name      : array[0..textrecnamelength-1] of TFileTextRecChar;
//		LineEnd   : TLineEndStr;
//		buffer    : textbuf;
  End;


type
	TMsgStrTable = record
		name: PShortString;			// Message name
		method: CodePointer;		// Method to call
	end;

type
	TStringMessageTable = record
		count: LongInt; 			// Number of messages in the string table.
		msgstrtable: array [0..0] of TMsgStrTable;
	end;

type
	PStringMessageTable = ^TStringMessageTable;

type
	TInterfaceEntryType = (
		etStandard, 				// Standard entry
		etVirtualMethodResult,		// Virtual method
		etStaticMethodResult,		// Static method
		etFieldValue,				// Field value
		etVirtualMethodClass,		// Interface provided by a virtual class method
		etStaticMethodClass,		// Interface provided by a static class method
		etFieldValueClass			// Interface provided by a class field
	);

type
	TInterfaceEntry = record
		IID: PGuid;
		IIDStr: PShortString;
		IIDRef: Pointer;
		VTable: Pointer;
		case Integer of
		1: (
			IOffset: SizeUInt;
		);
		2: (
			IOffsetAsCodePtr: CodePointer;
			IIDStrRef: Pointer;
			IType: TInterfaceEntryType;
      );
	end;

type
	PInterfaceTable = ^TInterfaceTable;
	TInterfaceTable = record
		EntryCount: SizeUInt;
		Entries: array [0..0] of TInterfaceEntry;
	end;

type
	PPVmt = ^PVmt;
	PVmt  = ^TVmt;
	TVmt = record
		vInstanceSize: SizeInt;
        	vInstanceSize2: SizeInt;
        	vParentRef: PPVmt;
        	vClassName: PShortString;
        	vDynamicTable: Pointer;
        	vMethodTable: Pointer;
        	vFieldTable: Pointer;
        	vTypeInfo: Pointer;
        	vInitTable: Pointer;
        	vAutoTable: Pointer;
        	vIntfTable: PInterfaceTable;
        	vMsgStrPtr: pstringmessagetable;
        	vDestroy: CodePointer;
        	vNewInstance: CodePointer;
        	vFreeInstance: CodePointer;
        	vSafeCallException: CodePointer;
        	vDefaultHandler: CodePointer;
        	vAfterConstruction: CodePointer;
        	vBeforeDestruction: CodePointer;
        	vDefaultHandlerStr: CodePointer;
        	vDispatch: CodePointer;
        	vDispatchStr: CodePointer;
        	vEquals: CodePointer;
        	vGetHashCode: CodePointer;
        	vToString: CodePointer;
	private
		function GetvParent: PVmt; inline;
	public
		property vParent: PVmt read GetvParent;
	end;

procedure fpc_ansistr_decr_ref(Var S : Pointer); compilerproc;

function  fpc_get_input: PText;         compilerproc;
procedure fpc_iocheck;                  compilerproc;
procedure fpc_readln_end(var f: Text);	compilerproc;

function  fpc_help_constructor(_self:pointer;var _vmt:pointer;_vmt_pos:cardinal):pointer;compilerproc;
procedure fpc_help_destructor(_self,_vmt:pointer;vmt_pos:cardinal);compilerproc;
procedure fpc_help_fail(_self:pointer;var _vmt:pointer;vmt_pos:cardinal);compilerproc;

procedure fpc_ReRaise; compilerproc;

procedure LazExitProcess(ExitCode: LongInt); cdecl; external 'kernel32.dll' name 'ExitProcess';

procedure fpc_initializeunits; cdecl; external name 'fpc_initializeunits'; compilerproc;
procedure fpc_do_exit; compilerproc;

implementation

procedure PascalMain; external name 'PASCALMAIN';

procedure Entry; [public, alias: '_mainCRTstartup'];
begin
  PascalMain;
  LazExitProcess(0);
end;

function TVmt.GetvParent: PVMT;
begin
	result := nil;
end;

function  fpc_get_input: PText; compilerproc;
begin
	result := nil;
end;

procedure fpc_readln_end(var f: Text); [public,alias:'FPC_READLN_END']; iocheck; compilerproc;
begin end;

procedure fpc_do_exit; alias: 'FPC_DO_EXIT'; compilerproc;
begin
  LazExitProcess(0);
end;

procedure fpc_iocheck; compilerproc;
begin end;

procedure fpc_ansistr_decr_ref(var s: Pointer); compilerproc;
begin end;

// -----------------------------------------------------
// object pascal ...
// -----------------------------------------------------
function  fpc_help_constructor(_self:pointer;var _vmt:pointer;_vmt_pos:cardinal):pointer;compilerproc;
begin result := nil end;

procedure fpc_help_destructor(_self,_vmt:pointer;vmt_pos:cardinal);compilerproc;
begin end;

procedure fpc_help_fail(_self:pointer;var _vmt:pointer;vmt_pos:cardinal);compilerproc;
begin end;

procedure fpc_ReRaise; compilerproc;
begin end;

end.
