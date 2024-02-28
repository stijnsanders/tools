unit Shell32_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 28/02/2024 17:32:54 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Windows\SysWOW64\shell32.dll (1)
// LIBID: {50A7E9B0-70EF-11D1-B75A-00A0C90564FE}
// LCID: 0
// Helpfile: 
// HelpString: Microsoft Shell Controls And Automation
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// Errors:
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Parameter 'File' of IShellDispatch2.ShellExecute changed to 'File_'
//   Hint: Member 'Property' of 'IWebWizardHost' changed to 'Property_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  Shell32MajorVersion = 1;
  Shell32MinorVersion = 0;

  LIBID_Shell32: TGUID = '{50A7E9B0-70EF-11D1-B75A-00A0C90564FE}';

  IID_IFolderViewOC: TGUID = '{9BA05970-F6A8-11CF-A442-00A0C90A8F39}';
  DIID_DShellFolderViewEvents: TGUID = '{62112AA2-EBE4-11CF-A5FB-0020AFE7292D}';
  CLASS_ShellFolderViewOC: TGUID = '{9BA05971-F6A8-11CF-A442-00A0C90A8F39}';
  IID_DFConstraint: TGUID = '{4A3DF050-23BD-11D2-939F-00A0C91EEDBA}';
  IID_FolderItem: TGUID = '{FAC32C80-CBE4-11CE-8350-444553540000}';
  IID_FolderItemVerbs: TGUID = '{1F8352C0-50B0-11CF-960C-0080C7F4EE85}';
  IID_FolderItemVerb: TGUID = '{08EC3E00-50B0-11CF-960C-0080C7F4EE85}';
  IID_FolderItems: TGUID = '{744129E0-CBE5-11CE-8350-444553540000}';
  IID_Folder: TGUID = '{BBCBDE60-C3FF-11CE-8350-444553540000}';
  IID_Folder2: TGUID = '{F0D2D8EF-3890-11D2-BF8B-00C04FB93661}';
  IID_Folder3: TGUID = '{A7AE5F64-C4D7-4D7F-9307-4D24EE54B841}';
  IID_FolderItem2: TGUID = '{EDC817AA-92B8-11D1-B075-00C04FC33AA5}';
  CLASS_ShellFolderItem: TGUID = '{2FE352EA-FD1F-11D2-B1F4-00C04F8EEB3E}';
  IID_FolderItems2: TGUID = '{C94F0AD0-F363-11D2-A327-00C04F8EEC7F}';
  IID_FolderItems3: TGUID = '{EAA7C309-BBEC-49D5-821D-64D966CB667F}';
  IID_IShellLinkDual: TGUID = '{88A05C00-F000-11CE-8350-444553540000}';
  IID_IShellLinkDual2: TGUID = '{317EE249-F12E-11D2-B1E4-00C04F8EEB3E}';
  CLASS_ShellLinkObject: TGUID = '{11219420-1768-11D1-95BE-00609797EA4F}';
  IID_IShellFolderViewDual: TGUID = '{E7A1AF80-4D96-11CF-960C-0080C7F4EE85}';
  IID_IShellFolderViewDual2: TGUID = '{31C147B6-0ADE-4A3C-B514-DDF932EF6D17}';
  IID_IShellFolderViewDual3: TGUID = '{29EC8E6C-46D3-411F-BAAA-611A6C9CAC66}';
  CLASS_ShellFolderView: TGUID = '{62112AA1-EBE4-11CF-A5FB-0020AFE7292D}';
  IID_IShellDispatch: TGUID = '{D8F015C0-C278-11CE-A49E-444553540000}';
  IID_IShellDispatch2: TGUID = '{A4C6892C-3BA9-11D2-9DEA-00C04FB16162}';
  IID_IShellDispatch3: TGUID = '{177160CA-BB5A-411C-841D-BD38FACDEAA0}';
  IID_IShellDispatch4: TGUID = '{EFD84B2D-4BCF-4298-BE25-EB542A59FBDA}';
  IID_IShellDispatch5: TGUID = '{866738B9-6CF2-4DE8-8767-F794EBE74F4E}';
  IID_IShellDispatch6: TGUID = '{286E6F1B-7113-4355-9562-96B7E9D64C54}';
  CLASS_Shell: TGUID = '{13709620-C279-11CE-A49E-444553540000}';
  CLASS_ShellDispatchInproc: TGUID = '{0A89A860-D7B1-11CE-8350-444553540000}';
  IID_IFileSearchBand: TGUID = '{2D91EEA1-9932-11D2-BE86-00A0C9A83DA1}';
  CLASS_FileSearchBand: TGUID = '{C4EE31F3-4768-11D2-BE5C-00A0C9A83DA1}';
  IID_IWebWizardHost: TGUID = '{18BCC359-4990-4BFB-B951-3C83702BE5F9}';
  IID_IWebWizardHost2: TGUID = '{F9C013DC-3C23-4041-8E39-CFB402F7EA59}';
  IID_INewWDEvents: TGUID = '{0751C551-7568-41C9-8E5B-E22E38919236}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum OfflineFolderStatus
type
  OfflineFolderStatus = TOleEnum;
const
  OFS_INACTIVE = $FFFFFFFF;
  OFS_ONLINE = $00000000;
  OFS_OFFLINE = $00000001;
  OFS_SERVERBACK = $00000002;
  OFS_DIRTYCACHE = $00000003;

// Constants for enum ShellFolderViewOptions
type
  ShellFolderViewOptions = TOleEnum;
const
  SFVVO_SHOWALLOBJECTS = $00000001;
  SFVVO_SHOWEXTENSIONS = $00000002;
  SFVVO_SHOWCOMPCOLOR = $00000008;
  SFVVO_SHOWSYSFILES = $00000020;
  SFVVO_WIN95CLASSIC = $00000040;
  SFVVO_DOUBLECLICKINWEBVIEW = $00000080;
  SFVVO_DESKTOPHTML = $00000200;

// Constants for enum ShellSpecialFolderConstants
type
  ShellSpecialFolderConstants = TOleEnum;
const
  ssfDESKTOP = $00000000;
  ssfPROGRAMS = $00000002;
  ssfCONTROLS = $00000003;
  ssfPRINTERS = $00000004;
  ssfPERSONAL = $00000005;
  ssfFAVORITES = $00000006;
  ssfSTARTUP = $00000007;
  ssfRECENT = $00000008;
  ssfSENDTO = $00000009;
  ssfBITBUCKET = $0000000A;
  ssfSTARTMENU = $0000000B;
  ssfDESKTOPDIRECTORY = $00000010;
  ssfDRIVES = $00000011;
  ssfNETWORK = $00000012;
  ssfNETHOOD = $00000013;
  ssfFONTS = $00000014;
  ssfTEMPLATES = $00000015;
  ssfCOMMONSTARTMENU = $00000016;
  ssfCOMMONPROGRAMS = $00000017;
  ssfCOMMONSTARTUP = $00000018;
  ssfCOMMONDESKTOPDIR = $00000019;
  ssfAPPDATA = $0000001A;
  ssfPRINTHOOD = $0000001B;
  ssfLOCALAPPDATA = $0000001C;
  ssfALTSTARTUP = $0000001D;
  ssfCOMMONALTSTARTUP = $0000001E;
  ssfCOMMONFAVORITES = $0000001F;
  ssfINTERNETCACHE = $00000020;
  ssfCOOKIES = $00000021;
  ssfHISTORY = $00000022;
  ssfCOMMONAPPDATA = $00000023;
  ssfWINDOWS = $00000024;
  ssfSYSTEM = $00000025;
  ssfPROGRAMFILES = $00000026;
  ssfMYPICTURES = $00000027;
  ssfPROFILE = $00000028;
  ssfSYSTEMx86 = $00000029;
  ssfPROGRAMFILESx86 = $00000030;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IFolderViewOC = interface;
  IFolderViewOCDisp = dispinterface;
  DShellFolderViewEvents = dispinterface;
  DFConstraint = interface;
  DFConstraintDisp = dispinterface;
  FolderItem = interface;
  FolderItemDisp = dispinterface;
  FolderItemVerbs = interface;
  FolderItemVerbsDisp = dispinterface;
  FolderItemVerb = interface;
  FolderItemVerbDisp = dispinterface;
  FolderItems = interface;
  FolderItemsDisp = dispinterface;
  Folder = interface;
  FolderDisp = dispinterface;
  Folder2 = interface;
  Folder2Disp = dispinterface;
  Folder3 = interface;
  Folder3Disp = dispinterface;
  FolderItem2 = interface;
  FolderItem2Disp = dispinterface;
  FolderItems2 = interface;
  FolderItems2Disp = dispinterface;
  FolderItems3 = interface;
  FolderItems3Disp = dispinterface;
  IShellLinkDual = interface;
  IShellLinkDualDisp = dispinterface;
  IShellLinkDual2 = interface;
  IShellLinkDual2Disp = dispinterface;
  IShellFolderViewDual = interface;
  IShellFolderViewDualDisp = dispinterface;
  IShellFolderViewDual2 = interface;
  IShellFolderViewDual2Disp = dispinterface;
  IShellFolderViewDual3 = interface;
  IShellFolderViewDual3Disp = dispinterface;
  IShellDispatch = interface;
  IShellDispatchDisp = dispinterface;
  IShellDispatch2 = interface;
  IShellDispatch2Disp = dispinterface;
  IShellDispatch3 = interface;
  IShellDispatch3Disp = dispinterface;
  IShellDispatch4 = interface;
  IShellDispatch4Disp = dispinterface;
  IShellDispatch5 = interface;
  IShellDispatch5Disp = dispinterface;
  IShellDispatch6 = interface;
  IShellDispatch6Disp = dispinterface;
  IFileSearchBand = interface;
  IFileSearchBandDisp = dispinterface;
  IWebWizardHost = interface;
  IWebWizardHostDisp = dispinterface;
  IWebWizardHost2 = interface;
  IWebWizardHost2Disp = dispinterface;
  INewWDEvents = interface;
  INewWDEventsDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ShellFolderViewOC = IFolderViewOC;
  ShellFolderItem = FolderItem2;
  ShellLinkObject = IShellLinkDual2;
  ShellFolderView = IShellFolderViewDual3;
  Shell = IShellDispatch6;
  ShellDispatchInproc = IUnknown;
  FileSearchBand = IFileSearchBand;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  POleVariant1 = ^OleVariant; {*}
  PWideString1 = ^WideString; {*}


// *********************************************************************//
// Interface: IFolderViewOC
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {9BA05970-F6A8-11CF-A442-00A0C90A8F39}
// *********************************************************************//
  IFolderViewOC = interface(IDispatch)
    ['{9BA05970-F6A8-11CF-A442-00A0C90A8F39}']
    procedure SetFolderView(const pdisp: IDispatch); safecall;
  end;

// *********************************************************************//
// DispIntf:  IFolderViewOCDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {9BA05970-F6A8-11CF-A442-00A0C90A8F39}
// *********************************************************************//
  IFolderViewOCDisp = dispinterface
    ['{9BA05970-F6A8-11CF-A442-00A0C90A8F39}']
    procedure SetFolderView(const pdisp: IDispatch); dispid 1610743808;
  end;

// *********************************************************************//
// DispIntf:  DShellFolderViewEvents
// Flags:     (4096) Dispatchable
// GUID:      {62112AA2-EBE4-11CF-A5FB-0020AFE7292D}
// *********************************************************************//
  DShellFolderViewEvents = dispinterface
    ['{62112AA2-EBE4-11CF-A5FB-0020AFE7292D}']
    procedure SelectionChanged; dispid 200;
    procedure EnumDone; dispid 201;
    function VerbInvoked: WordBool; dispid 202;
    function DefaultVerbInvoked: WordBool; dispid 203;
    function BeginDrag: WordBool; dispid 204;
  end;

// *********************************************************************//
// Interface: DFConstraint
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4A3DF050-23BD-11D2-939F-00A0C91EEDBA}
// *********************************************************************//
  DFConstraint = interface(IDispatch)
    ['{4A3DF050-23BD-11D2-939F-00A0C91EEDBA}']
    function Get_Name: WideString; safecall;
    function Get_Value: OleVariant; safecall;
    property Name: WideString read Get_Name;
    property Value: OleVariant read Get_Value;
  end;

// *********************************************************************//
// DispIntf:  DFConstraintDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4A3DF050-23BD-11D2-939F-00A0C91EEDBA}
// *********************************************************************//
  DFConstraintDisp = dispinterface
    ['{4A3DF050-23BD-11D2-939F-00A0C91EEDBA}']
    property Name: WideString readonly dispid 1610743808;
    property Value: OleVariant readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: FolderItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FAC32C80-CBE4-11CE-8350-444553540000}
// *********************************************************************//
  FolderItem = interface(IDispatch)
    ['{FAC32C80-CBE4-11CE-8350-444553540000}']
    function Get_Application: IDispatch; safecall;
    function Get_Parent: IDispatch; safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const pbs: WideString); safecall;
    function Get_Path: WideString; safecall;
    function Get_GetLink: IDispatch; safecall;
    function Get_GetFolder: IDispatch; safecall;
    function Get_IsLink: WordBool; safecall;
    function Get_IsFolder: WordBool; safecall;
    function Get_IsFileSystem: WordBool; safecall;
    function Get_IsBrowsable: WordBool; safecall;
    function Get_ModifyDate: TDateTime; safecall;
    procedure Set_ModifyDate(pdt: TDateTime); safecall;
    function Get_Size: Integer; safecall;
    function Get_type_: WideString; safecall;
    function Verbs: FolderItemVerbs; safecall;
    procedure InvokeVerb(vVerb: OleVariant); safecall;
    property Application: IDispatch read Get_Application;
    property Parent: IDispatch read Get_Parent;
    property Name: WideString read Get_Name write Set_Name;
    property Path: WideString read Get_Path;
    property GetLink: IDispatch read Get_GetLink;
    property GetFolder: IDispatch read Get_GetFolder;
    property IsLink: WordBool read Get_IsLink;
    property IsFolder: WordBool read Get_IsFolder;
    property IsFileSystem: WordBool read Get_IsFileSystem;
    property IsBrowsable: WordBool read Get_IsBrowsable;
    property ModifyDate: TDateTime read Get_ModifyDate write Set_ModifyDate;
    property Size: Integer read Get_Size;
    property type_: WideString read Get_type_;
  end;

// *********************************************************************//
// DispIntf:  FolderItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FAC32C80-CBE4-11CE-8350-444553540000}
// *********************************************************************//
  FolderItemDisp = dispinterface
    ['{FAC32C80-CBE4-11CE-8350-444553540000}']
    property Application: IDispatch readonly dispid 1610743808;
    property Parent: IDispatch readonly dispid 1610743809;
    property Name: WideString dispid 0;
    property Path: WideString readonly dispid 1610743812;
    property GetLink: IDispatch readonly dispid 1610743813;
    property GetFolder: IDispatch readonly dispid 1610743814;
    property IsLink: WordBool readonly dispid 1610743815;
    property IsFolder: WordBool readonly dispid 1610743816;
    property IsFileSystem: WordBool readonly dispid 1610743817;
    property IsBrowsable: WordBool readonly dispid 1610743818;
    property ModifyDate: TDateTime dispid 1610743819;
    property Size: Integer readonly dispid 1610743821;
    property type_: WideString readonly dispid 1610743822;
    function Verbs: FolderItemVerbs; dispid 1610743823;
    procedure InvokeVerb(vVerb: OleVariant); dispid 1610743824;
  end;

// *********************************************************************//
// Interface: FolderItemVerbs
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1F8352C0-50B0-11CF-960C-0080C7F4EE85}
// *********************************************************************//
  FolderItemVerbs = interface(IDispatch)
    ['{1F8352C0-50B0-11CF-960C-0080C7F4EE85}']
    function Get_Count: Integer; safecall;
    function Get_Application: IDispatch; safecall;
    function Get_Parent: IDispatch; safecall;
    function Item(index: OleVariant): FolderItemVerb; safecall;
    function _NewEnum: IUnknown; safecall;
    property Count: Integer read Get_Count;
    property Application: IDispatch read Get_Application;
    property Parent: IDispatch read Get_Parent;
  end;

// *********************************************************************//
// DispIntf:  FolderItemVerbsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1F8352C0-50B0-11CF-960C-0080C7F4EE85}
// *********************************************************************//
  FolderItemVerbsDisp = dispinterface
    ['{1F8352C0-50B0-11CF-960C-0080C7F4EE85}']
    property Count: Integer readonly dispid 1610743808;
    property Application: IDispatch readonly dispid 1610743809;
    property Parent: IDispatch readonly dispid 1610743810;
    function Item(index: OleVariant): FolderItemVerb; dispid 1610743811;
    function _NewEnum: IUnknown; dispid -4;
  end;

// *********************************************************************//
// Interface: FolderItemVerb
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {08EC3E00-50B0-11CF-960C-0080C7F4EE85}
// *********************************************************************//
  FolderItemVerb = interface(IDispatch)
    ['{08EC3E00-50B0-11CF-960C-0080C7F4EE85}']
    function Get_Application: IDispatch; safecall;
    function Get_Parent: IDispatch; safecall;
    function Get_Name: WideString; safecall;
    procedure DoIt; safecall;
    property Application: IDispatch read Get_Application;
    property Parent: IDispatch read Get_Parent;
    property Name: WideString read Get_Name;
  end;

// *********************************************************************//
// DispIntf:  FolderItemVerbDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {08EC3E00-50B0-11CF-960C-0080C7F4EE85}
// *********************************************************************//
  FolderItemVerbDisp = dispinterface
    ['{08EC3E00-50B0-11CF-960C-0080C7F4EE85}']
    property Application: IDispatch readonly dispid 1610743808;
    property Parent: IDispatch readonly dispid 1610743809;
    property Name: WideString readonly dispid 0;
    procedure DoIt; dispid 1610743811;
  end;

// *********************************************************************//
// Interface: FolderItems
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {744129E0-CBE5-11CE-8350-444553540000}
// *********************************************************************//
  FolderItems = interface(IDispatch)
    ['{744129E0-CBE5-11CE-8350-444553540000}']
    function Get_Count: Integer; safecall;
    function Get_Application: IDispatch; safecall;
    function Get_Parent: IDispatch; safecall;
    function Item(index: OleVariant): FolderItem; safecall;
    function _NewEnum: IUnknown; safecall;
    property Count: Integer read Get_Count;
    property Application: IDispatch read Get_Application;
    property Parent: IDispatch read Get_Parent;
  end;

// *********************************************************************//
// DispIntf:  FolderItemsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {744129E0-CBE5-11CE-8350-444553540000}
// *********************************************************************//
  FolderItemsDisp = dispinterface
    ['{744129E0-CBE5-11CE-8350-444553540000}']
    property Count: Integer readonly dispid 1610743808;
    property Application: IDispatch readonly dispid 1610743809;
    property Parent: IDispatch readonly dispid 1610743810;
    function Item(index: OleVariant): FolderItem; dispid 1610743811;
    function _NewEnum: IUnknown; dispid -4;
  end;

// *********************************************************************//
// Interface: Folder
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BBCBDE60-C3FF-11CE-8350-444553540000}
// *********************************************************************//
  Folder = interface(IDispatch)
    ['{BBCBDE60-C3FF-11CE-8350-444553540000}']
    function Get_Title: WideString; safecall;
    function Get_Application: IDispatch; safecall;
    function Get_Parent: IDispatch; safecall;
    function Get_ParentFolder: Folder; safecall;
    function Items: FolderItems; safecall;
    function ParseName(const bName: WideString): FolderItem; safecall;
    procedure NewFolder(const bName: WideString; vOptions: OleVariant); safecall;
    procedure MoveHere(vItem: OleVariant; vOptions: OleVariant); safecall;
    procedure CopyHere(vItem: OleVariant; vOptions: OleVariant); safecall;
    function GetDetailsOf(vItem: OleVariant; iColumn: SYSINT): WideString; safecall;
    property Title: WideString read Get_Title;
    property Application: IDispatch read Get_Application;
    property Parent: IDispatch read Get_Parent;
    property ParentFolder: Folder read Get_ParentFolder;
  end;

// *********************************************************************//
// DispIntf:  FolderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BBCBDE60-C3FF-11CE-8350-444553540000}
// *********************************************************************//
  FolderDisp = dispinterface
    ['{BBCBDE60-C3FF-11CE-8350-444553540000}']
    property Title: WideString readonly dispid 0;
    property Application: IDispatch readonly dispid 1610743809;
    property Parent: IDispatch readonly dispid 1610743810;
    property ParentFolder: Folder readonly dispid 1610743811;
    function Items: FolderItems; dispid 1610743812;
    function ParseName(const bName: WideString): FolderItem; dispid 1610743813;
    procedure NewFolder(const bName: WideString; vOptions: OleVariant); dispid 1610743814;
    procedure MoveHere(vItem: OleVariant; vOptions: OleVariant); dispid 1610743815;
    procedure CopyHere(vItem: OleVariant; vOptions: OleVariant); dispid 1610743816;
    function GetDetailsOf(vItem: OleVariant; iColumn: SYSINT): WideString; dispid 1610743817;
  end;

// *********************************************************************//
// Interface: Folder2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F0D2D8EF-3890-11D2-BF8B-00C04FB93661}
// *********************************************************************//
  Folder2 = interface(Folder)
    ['{F0D2D8EF-3890-11D2-BF8B-00C04FB93661}']
    function Get_Self: FolderItem; safecall;
    function Get_OfflineStatus: Integer; safecall;
    procedure Synchronize; safecall;
    function Get_HaveToShowWebViewBarricade: WordBool; safecall;
    procedure DismissedWebViewBarricade; safecall;
    property Self: FolderItem read Get_Self;
    property OfflineStatus: Integer read Get_OfflineStatus;
    property HaveToShowWebViewBarricade: WordBool read Get_HaveToShowWebViewBarricade;
  end;

// *********************************************************************//
// DispIntf:  Folder2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F0D2D8EF-3890-11D2-BF8B-00C04FB93661}
// *********************************************************************//
  Folder2Disp = dispinterface
    ['{F0D2D8EF-3890-11D2-BF8B-00C04FB93661}']
    property Self: FolderItem readonly dispid 1610809344;
    property OfflineStatus: Integer readonly dispid 1610809345;
    procedure Synchronize; dispid 1610809346;
    property HaveToShowWebViewBarricade: WordBool readonly dispid 1;
    procedure DismissedWebViewBarricade; dispid 1610809348;
    property Title: WideString readonly dispid 0;
    property Application: IDispatch readonly dispid 1610743809;
    property Parent: IDispatch readonly dispid 1610743810;
    property ParentFolder: Folder readonly dispid 1610743811;
    function Items: FolderItems; dispid 1610743812;
    function ParseName(const bName: WideString): FolderItem; dispid 1610743813;
    procedure NewFolder(const bName: WideString; vOptions: OleVariant); dispid 1610743814;
    procedure MoveHere(vItem: OleVariant; vOptions: OleVariant); dispid 1610743815;
    procedure CopyHere(vItem: OleVariant; vOptions: OleVariant); dispid 1610743816;
    function GetDetailsOf(vItem: OleVariant; iColumn: SYSINT): WideString; dispid 1610743817;
  end;

// *********************************************************************//
// Interface: Folder3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A7AE5F64-C4D7-4D7F-9307-4D24EE54B841}
// *********************************************************************//
  Folder3 = interface(Folder2)
    ['{A7AE5F64-C4D7-4D7F-9307-4D24EE54B841}']
    function Get_ShowWebViewBarricade: WordBool; safecall;
    procedure Set_ShowWebViewBarricade(pbShowWebViewBarricade: WordBool); safecall;
    property ShowWebViewBarricade: WordBool read Get_ShowWebViewBarricade write Set_ShowWebViewBarricade;
  end;

// *********************************************************************//
// DispIntf:  Folder3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A7AE5F64-C4D7-4D7F-9307-4D24EE54B841}
// *********************************************************************//
  Folder3Disp = dispinterface
    ['{A7AE5F64-C4D7-4D7F-9307-4D24EE54B841}']
    property ShowWebViewBarricade: WordBool dispid 2;
    property Self: FolderItem readonly dispid 1610809344;
    property OfflineStatus: Integer readonly dispid 1610809345;
    procedure Synchronize; dispid 1610809346;
    property HaveToShowWebViewBarricade: WordBool readonly dispid 1;
    procedure DismissedWebViewBarricade; dispid 1610809348;
    property Title: WideString readonly dispid 0;
    property Application: IDispatch readonly dispid 1610743809;
    property Parent: IDispatch readonly dispid 1610743810;
    property ParentFolder: Folder readonly dispid 1610743811;
    function Items: FolderItems; dispid 1610743812;
    function ParseName(const bName: WideString): FolderItem; dispid 1610743813;
    procedure NewFolder(const bName: WideString; vOptions: OleVariant); dispid 1610743814;
    procedure MoveHere(vItem: OleVariant; vOptions: OleVariant); dispid 1610743815;
    procedure CopyHere(vItem: OleVariant; vOptions: OleVariant); dispid 1610743816;
    function GetDetailsOf(vItem: OleVariant; iColumn: SYSINT): WideString; dispid 1610743817;
  end;

// *********************************************************************//
// Interface: FolderItem2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EDC817AA-92B8-11D1-B075-00C04FC33AA5}
// *********************************************************************//
  FolderItem2 = interface(FolderItem)
    ['{EDC817AA-92B8-11D1-B075-00C04FC33AA5}']
    procedure InvokeVerbEx(vVerb: OleVariant; vArgs: OleVariant); safecall;
    function ExtendedProperty(const bstrPropName: WideString): OleVariant; safecall;
  end;

// *********************************************************************//
// DispIntf:  FolderItem2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EDC817AA-92B8-11D1-B075-00C04FC33AA5}
// *********************************************************************//
  FolderItem2Disp = dispinterface
    ['{EDC817AA-92B8-11D1-B075-00C04FC33AA5}']
    procedure InvokeVerbEx(vVerb: OleVariant; vArgs: OleVariant); dispid 1610809344;
    function ExtendedProperty(const bstrPropName: WideString): OleVariant; dispid 1610809345;
    property Application: IDispatch readonly dispid 1610743808;
    property Parent: IDispatch readonly dispid 1610743809;
    property Name: WideString dispid 0;
    property Path: WideString readonly dispid 1610743812;
    property GetLink: IDispatch readonly dispid 1610743813;
    property GetFolder: IDispatch readonly dispid 1610743814;
    property IsLink: WordBool readonly dispid 1610743815;
    property IsFolder: WordBool readonly dispid 1610743816;
    property IsFileSystem: WordBool readonly dispid 1610743817;
    property IsBrowsable: WordBool readonly dispid 1610743818;
    property ModifyDate: TDateTime dispid 1610743819;
    property Size: Integer readonly dispid 1610743821;
    property type_: WideString readonly dispid 1610743822;
    function Verbs: FolderItemVerbs; dispid 1610743823;
    procedure InvokeVerb(vVerb: OleVariant); dispid 1610743824;
  end;

// *********************************************************************//
// Interface: FolderItems2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C94F0AD0-F363-11D2-A327-00C04F8EEC7F}
// *********************************************************************//
  FolderItems2 = interface(FolderItems)
    ['{C94F0AD0-F363-11D2-A327-00C04F8EEC7F}']
    procedure InvokeVerbEx(vVerb: OleVariant; vArgs: OleVariant); safecall;
  end;

// *********************************************************************//
// DispIntf:  FolderItems2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C94F0AD0-F363-11D2-A327-00C04F8EEC7F}
// *********************************************************************//
  FolderItems2Disp = dispinterface
    ['{C94F0AD0-F363-11D2-A327-00C04F8EEC7F}']
    procedure InvokeVerbEx(vVerb: OleVariant; vArgs: OleVariant); dispid 1610809344;
    property Count: Integer readonly dispid 1610743808;
    property Application: IDispatch readonly dispid 1610743809;
    property Parent: IDispatch readonly dispid 1610743810;
    function Item(index: OleVariant): FolderItem; dispid 1610743811;
    function _NewEnum: IUnknown; dispid -4;
  end;

// *********************************************************************//
// Interface: FolderItems3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EAA7C309-BBEC-49D5-821D-64D966CB667F}
// *********************************************************************//
  FolderItems3 = interface(FolderItems2)
    ['{EAA7C309-BBEC-49D5-821D-64D966CB667F}']
    procedure Filter(grfFlags: Integer; const bstrFileSpec: WideString); safecall;
    function Get_Verbs: FolderItemVerbs; safecall;
    property Verbs: FolderItemVerbs read Get_Verbs;
  end;

// *********************************************************************//
// DispIntf:  FolderItems3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EAA7C309-BBEC-49D5-821D-64D966CB667F}
// *********************************************************************//
  FolderItems3Disp = dispinterface
    ['{EAA7C309-BBEC-49D5-821D-64D966CB667F}']
    procedure Filter(grfFlags: Integer; const bstrFileSpec: WideString); dispid 1610874880;
    property Verbs: FolderItemVerbs readonly dispid 0;
    procedure InvokeVerbEx(vVerb: OleVariant; vArgs: OleVariant); dispid 1610809344;
    property Count: Integer readonly dispid 1610743808;
    property Application: IDispatch readonly dispid 1610743809;
    property Parent: IDispatch readonly dispid 1610743810;
    function Item(index: OleVariant): FolderItem; dispid 1610743811;
    function _NewEnum: IUnknown; dispid -4;
  end;

// *********************************************************************//
// Interface: IShellLinkDual
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {88A05C00-F000-11CE-8350-444553540000}
// *********************************************************************//
  IShellLinkDual = interface(IDispatch)
    ['{88A05C00-F000-11CE-8350-444553540000}']
    function Get_Path: WideString; safecall;
    procedure Set_Path(const pbs: WideString); safecall;
    function Get_Description: WideString; safecall;
    procedure Set_Description(const pbs: WideString); safecall;
    function Get_WorkingDirectory: WideString; safecall;
    procedure Set_WorkingDirectory(const pbs: WideString); safecall;
    function Get_Arguments: WideString; safecall;
    procedure Set_Arguments(const pbs: WideString); safecall;
    function Get_Hotkey: SYSINT; safecall;
    procedure Set_Hotkey(piHK: SYSINT); safecall;
    function Get_ShowCommand: SYSINT; safecall;
    procedure Set_ShowCommand(piShowCommand: SYSINT); safecall;
    procedure Resolve(fFlags: SYSINT); safecall;
    function GetIconLocation(out pbs: WideString): SYSINT; safecall;
    procedure SetIconLocation(const bs: WideString; iIcon: SYSINT); safecall;
    procedure Save(vWhere: OleVariant); safecall;
    property Path: WideString read Get_Path write Set_Path;
    property Description: WideString read Get_Description write Set_Description;
    property WorkingDirectory: WideString read Get_WorkingDirectory write Set_WorkingDirectory;
    property Arguments: WideString read Get_Arguments write Set_Arguments;
    property Hotkey: SYSINT read Get_Hotkey write Set_Hotkey;
    property ShowCommand: SYSINT read Get_ShowCommand write Set_ShowCommand;
  end;

// *********************************************************************//
// DispIntf:  IShellLinkDualDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {88A05C00-F000-11CE-8350-444553540000}
// *********************************************************************//
  IShellLinkDualDisp = dispinterface
    ['{88A05C00-F000-11CE-8350-444553540000}']
    property Path: WideString dispid 1610743808;
    property Description: WideString dispid 1610743810;
    property WorkingDirectory: WideString dispid 1610743812;
    property Arguments: WideString dispid 1610743814;
    property Hotkey: SYSINT dispid 1610743816;
    property ShowCommand: SYSINT dispid 1610743818;
    procedure Resolve(fFlags: SYSINT); dispid 1610743820;
    function GetIconLocation(out pbs: WideString): SYSINT; dispid 1610743821;
    procedure SetIconLocation(const bs: WideString; iIcon: SYSINT); dispid 1610743822;
    procedure Save(vWhere: OleVariant); dispid 1610743823;
  end;

// *********************************************************************//
// Interface: IShellLinkDual2
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {317EE249-F12E-11D2-B1E4-00C04F8EEB3E}
// *********************************************************************//
  IShellLinkDual2 = interface(IShellLinkDual)
    ['{317EE249-F12E-11D2-B1E4-00C04F8EEB3E}']
    function Get_Target: FolderItem; safecall;
    property Target: FolderItem read Get_Target;
  end;

// *********************************************************************//
// DispIntf:  IShellLinkDual2Disp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {317EE249-F12E-11D2-B1E4-00C04F8EEB3E}
// *********************************************************************//
  IShellLinkDual2Disp = dispinterface
    ['{317EE249-F12E-11D2-B1E4-00C04F8EEB3E}']
    property Target: FolderItem readonly dispid 1610809344;
    property Path: WideString dispid 1610743808;
    property Description: WideString dispid 1610743810;
    property WorkingDirectory: WideString dispid 1610743812;
    property Arguments: WideString dispid 1610743814;
    property Hotkey: SYSINT dispid 1610743816;
    property ShowCommand: SYSINT dispid 1610743818;
    procedure Resolve(fFlags: SYSINT); dispid 1610743820;
    function GetIconLocation(out pbs: WideString): SYSINT; dispid 1610743821;
    procedure SetIconLocation(const bs: WideString; iIcon: SYSINT); dispid 1610743822;
    procedure Save(vWhere: OleVariant); dispid 1610743823;
  end;

// *********************************************************************//
// Interface: IShellFolderViewDual
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {E7A1AF80-4D96-11CF-960C-0080C7F4EE85}
// *********************************************************************//
  IShellFolderViewDual = interface(IDispatch)
    ['{E7A1AF80-4D96-11CF-960C-0080C7F4EE85}']
    function Get_Application: IDispatch; safecall;
    function Get_Parent: IDispatch; safecall;
    function Get_Folder: Folder; safecall;
    function SelectedItems: FolderItems; safecall;
    function Get_FocusedItem: FolderItem; safecall;
    procedure SelectItem(var pvfi: OleVariant; dwFlags: SYSINT); safecall;
    function PopupItemMenu(const pfi: FolderItem; vx: OleVariant; vy: OleVariant): WideString; safecall;
    function Get_Script: IDispatch; safecall;
    function Get_ViewOptions: Integer; safecall;
    property Application: IDispatch read Get_Application;
    property Parent: IDispatch read Get_Parent;
    property Folder: Folder read Get_Folder;
    property FocusedItem: FolderItem read Get_FocusedItem;
    property Script: IDispatch read Get_Script;
    property ViewOptions: Integer read Get_ViewOptions;
  end;

// *********************************************************************//
// DispIntf:  IShellFolderViewDualDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {E7A1AF80-4D96-11CF-960C-0080C7F4EE85}
// *********************************************************************//
  IShellFolderViewDualDisp = dispinterface
    ['{E7A1AF80-4D96-11CF-960C-0080C7F4EE85}']
    property Application: IDispatch readonly dispid 1610743808;
    property Parent: IDispatch readonly dispid 1610743809;
    property Folder: Folder readonly dispid 1610743810;
    function SelectedItems: FolderItems; dispid 1610743811;
    property FocusedItem: FolderItem readonly dispid 1610743812;
    procedure SelectItem(var pvfi: OleVariant; dwFlags: SYSINT); dispid 1610743813;
    function PopupItemMenu(const pfi: FolderItem; vx: OleVariant; vy: OleVariant): WideString; dispid 1610743814;
    property Script: IDispatch readonly dispid 1610743815;
    property ViewOptions: Integer readonly dispid 1610743816;
  end;

// *********************************************************************//
// Interface: IShellFolderViewDual2
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {31C147B6-0ADE-4A3C-B514-DDF932EF6D17}
// *********************************************************************//
  IShellFolderViewDual2 = interface(IShellFolderViewDual)
    ['{31C147B6-0ADE-4A3C-B514-DDF932EF6D17}']
    function Get_CurrentViewMode: SYSUINT; safecall;
    procedure Set_CurrentViewMode(pViewMode: SYSUINT); safecall;
    procedure SelectItemRelative(iRelative: SYSINT); safecall;
    property CurrentViewMode: SYSUINT read Get_CurrentViewMode write Set_CurrentViewMode;
  end;

// *********************************************************************//
// DispIntf:  IShellFolderViewDual2Disp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {31C147B6-0ADE-4A3C-B514-DDF932EF6D17}
// *********************************************************************//
  IShellFolderViewDual2Disp = dispinterface
    ['{31C147B6-0ADE-4A3C-B514-DDF932EF6D17}']
    property CurrentViewMode: SYSUINT dispid 1610809344;
    procedure SelectItemRelative(iRelative: SYSINT); dispid 1610809346;
    property Application: IDispatch readonly dispid 1610743808;
    property Parent: IDispatch readonly dispid 1610743809;
    property Folder: Folder readonly dispid 1610743810;
    function SelectedItems: FolderItems; dispid 1610743811;
    property FocusedItem: FolderItem readonly dispid 1610743812;
    procedure SelectItem(var pvfi: OleVariant; dwFlags: SYSINT); dispid 1610743813;
    function PopupItemMenu(const pfi: FolderItem; vx: OleVariant; vy: OleVariant): WideString; dispid 1610743814;
    property Script: IDispatch readonly dispid 1610743815;
    property ViewOptions: Integer readonly dispid 1610743816;
  end;

// *********************************************************************//
// Interface: IShellFolderViewDual3
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {29EC8E6C-46D3-411F-BAAA-611A6C9CAC66}
// *********************************************************************//
  IShellFolderViewDual3 = interface(IShellFolderViewDual2)
    ['{29EC8E6C-46D3-411F-BAAA-611A6C9CAC66}']
    function Get_GroupBy: WideString; safecall;
    procedure Set_GroupBy(const pbstrGroupBy: WideString); safecall;
    function Get_FolderFlags: LongWord; safecall;
    procedure Set_FolderFlags(pdwFlags: LongWord); safecall;
    function Get_SortColumns: WideString; safecall;
    procedure Set_SortColumns(const pbstrSortColumns: WideString); safecall;
    procedure Set_IconSize(piIconSize: SYSINT); safecall;
    function Get_IconSize: SYSINT; safecall;
    procedure FilterView(const bstrFilterText: WideString); safecall;
    property GroupBy: WideString read Get_GroupBy write Set_GroupBy;
    property FolderFlags: LongWord read Get_FolderFlags write Set_FolderFlags;
    property SortColumns: WideString read Get_SortColumns write Set_SortColumns;
    property IconSize: SYSINT read Get_IconSize write Set_IconSize;
  end;

// *********************************************************************//
// DispIntf:  IShellFolderViewDual3Disp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {29EC8E6C-46D3-411F-BAAA-611A6C9CAC66}
// *********************************************************************//
  IShellFolderViewDual3Disp = dispinterface
    ['{29EC8E6C-46D3-411F-BAAA-611A6C9CAC66}']
    property GroupBy: WideString dispid 1610874880;
    property FolderFlags: LongWord dispid 1610874882;
    property SortColumns: WideString dispid 1610874884;
    property IconSize: SYSINT dispid 1610874886;
    procedure FilterView(const bstrFilterText: WideString); dispid 1610874888;
    property CurrentViewMode: SYSUINT dispid 1610809344;
    procedure SelectItemRelative(iRelative: SYSINT); dispid 1610809346;
    property Application: IDispatch readonly dispid 1610743808;
    property Parent: IDispatch readonly dispid 1610743809;
    property Folder: Folder readonly dispid 1610743810;
    function SelectedItems: FolderItems; dispid 1610743811;
    property FocusedItem: FolderItem readonly dispid 1610743812;
    procedure SelectItem(var pvfi: OleVariant; dwFlags: SYSINT); dispid 1610743813;
    function PopupItemMenu(const pfi: FolderItem; vx: OleVariant; vy: OleVariant): WideString; dispid 1610743814;
    property Script: IDispatch readonly dispid 1610743815;
    property ViewOptions: Integer readonly dispid 1610743816;
  end;

// *********************************************************************//
// Interface: IShellDispatch
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {D8F015C0-C278-11CE-A49E-444553540000}
// *********************************************************************//
  IShellDispatch = interface(IDispatch)
    ['{D8F015C0-C278-11CE-A49E-444553540000}']
    function Get_Application: IDispatch; safecall;
    function Get_Parent: IDispatch; safecall;
    function NameSpace(vDir: OleVariant): Folder; safecall;
    function BrowseForFolder(Hwnd: Integer; const Title: WideString; Options: Integer; 
                             RootFolder: OleVariant): Folder; safecall;
    function Windows: IDispatch; safecall;
    procedure Open(vDir: OleVariant); safecall;
    procedure Explore(vDir: OleVariant); safecall;
    procedure MinimizeAll; safecall;
    procedure UndoMinimizeALL; safecall;
    procedure FileRun; safecall;
    procedure CascadeWindows; safecall;
    procedure TileVertically; safecall;
    procedure TileHorizontally; safecall;
    procedure ShutdownWindows; safecall;
    procedure Suspend; safecall;
    procedure EjectPC; safecall;
    procedure SetTime; safecall;
    procedure TrayProperties; safecall;
    procedure Help; safecall;
    procedure FindFiles; safecall;
    procedure FindComputer; safecall;
    procedure RefreshMenu; safecall;
    procedure ControlPanelItem(const bstrDir: WideString); safecall;
    property Application: IDispatch read Get_Application;
    property Parent: IDispatch read Get_Parent;
  end;

// *********************************************************************//
// DispIntf:  IShellDispatchDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {D8F015C0-C278-11CE-A49E-444553540000}
// *********************************************************************//
  IShellDispatchDisp = dispinterface
    ['{D8F015C0-C278-11CE-A49E-444553540000}']
    property Application: IDispatch readonly dispid 1610743808;
    property Parent: IDispatch readonly dispid 1610743809;
    function NameSpace(vDir: OleVariant): Folder; dispid 1610743810;
    function BrowseForFolder(Hwnd: Integer; const Title: WideString; Options: Integer; 
                             RootFolder: OleVariant): Folder; dispid 1610743811;
    function Windows: IDispatch; dispid 1610743812;
    procedure Open(vDir: OleVariant); dispid 1610743813;
    procedure Explore(vDir: OleVariant); dispid 1610743814;
    procedure MinimizeAll; dispid 1610743815;
    procedure UndoMinimizeALL; dispid 1610743816;
    procedure FileRun; dispid 1610743817;
    procedure CascadeWindows; dispid 1610743818;
    procedure TileVertically; dispid 1610743819;
    procedure TileHorizontally; dispid 1610743820;
    procedure ShutdownWindows; dispid 1610743821;
    procedure Suspend; dispid 1610743822;
    procedure EjectPC; dispid 1610743823;
    procedure SetTime; dispid 1610743824;
    procedure TrayProperties; dispid 1610743825;
    procedure Help; dispid 1610743826;
    procedure FindFiles; dispid 1610743827;
    procedure FindComputer; dispid 1610743828;
    procedure RefreshMenu; dispid 1610743829;
    procedure ControlPanelItem(const bstrDir: WideString); dispid 1610743830;
  end;

// *********************************************************************//
// Interface: IShellDispatch2
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {A4C6892C-3BA9-11D2-9DEA-00C04FB16162}
// *********************************************************************//
  IShellDispatch2 = interface(IShellDispatch)
    ['{A4C6892C-3BA9-11D2-9DEA-00C04FB16162}']
    function IsRestricted(const Group: WideString; const Restriction: WideString): Integer; safecall;
    procedure ShellExecute(const File_: WideString; vArgs: OleVariant; vDir: OleVariant; 
                           vOperation: OleVariant; vShow: OleVariant); safecall;
    procedure FindPrinter(const Name: WideString; const location: WideString; 
                          const model: WideString); safecall;
    function GetSystemInformation(const Name: WideString): OleVariant; safecall;
    function ServiceStart(const ServiceName: WideString; Persistent: OleVariant): OleVariant; safecall;
    function ServiceStop(const ServiceName: WideString; Persistent: OleVariant): OleVariant; safecall;
    function IsServiceRunning(const ServiceName: WideString): OleVariant; safecall;
    function CanStartStopService(const ServiceName: WideString): OleVariant; safecall;
    function ShowBrowserBar(const bstrClsid: WideString; bShow: OleVariant): OleVariant; safecall;
  end;

// *********************************************************************//
// DispIntf:  IShellDispatch2Disp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {A4C6892C-3BA9-11D2-9DEA-00C04FB16162}
// *********************************************************************//
  IShellDispatch2Disp = dispinterface
    ['{A4C6892C-3BA9-11D2-9DEA-00C04FB16162}']
    function IsRestricted(const Group: WideString; const Restriction: WideString): Integer; dispid 1610809344;
    procedure ShellExecute(const File_: WideString; vArgs: OleVariant; vDir: OleVariant; 
                           vOperation: OleVariant; vShow: OleVariant); dispid 1610809345;
    procedure FindPrinter(const Name: WideString; const location: WideString; 
                          const model: WideString); dispid 1610809346;
    function GetSystemInformation(const Name: WideString): OleVariant; dispid 1610809347;
    function ServiceStart(const ServiceName: WideString; Persistent: OleVariant): OleVariant; dispid 1610809348;
    function ServiceStop(const ServiceName: WideString; Persistent: OleVariant): OleVariant; dispid 1610809349;
    function IsServiceRunning(const ServiceName: WideString): OleVariant; dispid 1610809350;
    function CanStartStopService(const ServiceName: WideString): OleVariant; dispid 1610809351;
    function ShowBrowserBar(const bstrClsid: WideString; bShow: OleVariant): OleVariant; dispid 1610809352;
    property Application: IDispatch readonly dispid 1610743808;
    property Parent: IDispatch readonly dispid 1610743809;
    function NameSpace(vDir: OleVariant): Folder; dispid 1610743810;
    function BrowseForFolder(Hwnd: Integer; const Title: WideString; Options: Integer; 
                             RootFolder: OleVariant): Folder; dispid 1610743811;
    function Windows: IDispatch; dispid 1610743812;
    procedure Open(vDir: OleVariant); dispid 1610743813;
    procedure Explore(vDir: OleVariant); dispid 1610743814;
    procedure MinimizeAll; dispid 1610743815;
    procedure UndoMinimizeALL; dispid 1610743816;
    procedure FileRun; dispid 1610743817;
    procedure CascadeWindows; dispid 1610743818;
    procedure TileVertically; dispid 1610743819;
    procedure TileHorizontally; dispid 1610743820;
    procedure ShutdownWindows; dispid 1610743821;
    procedure Suspend; dispid 1610743822;
    procedure EjectPC; dispid 1610743823;
    procedure SetTime; dispid 1610743824;
    procedure TrayProperties; dispid 1610743825;
    procedure Help; dispid 1610743826;
    procedure FindFiles; dispid 1610743827;
    procedure FindComputer; dispid 1610743828;
    procedure RefreshMenu; dispid 1610743829;
    procedure ControlPanelItem(const bstrDir: WideString); dispid 1610743830;
  end;

// *********************************************************************//
// Interface: IShellDispatch3
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {177160CA-BB5A-411C-841D-BD38FACDEAA0}
// *********************************************************************//
  IShellDispatch3 = interface(IShellDispatch2)
    ['{177160CA-BB5A-411C-841D-BD38FACDEAA0}']
    procedure AddToRecent(varFile: OleVariant; const bstrCategory: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IShellDispatch3Disp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {177160CA-BB5A-411C-841D-BD38FACDEAA0}
// *********************************************************************//
  IShellDispatch3Disp = dispinterface
    ['{177160CA-BB5A-411C-841D-BD38FACDEAA0}']
    procedure AddToRecent(varFile: OleVariant; const bstrCategory: WideString); dispid 1610874880;
    function IsRestricted(const Group: WideString; const Restriction: WideString): Integer; dispid 1610809344;
    procedure ShellExecute(const File_: WideString; vArgs: OleVariant; vDir: OleVariant; 
                           vOperation: OleVariant; vShow: OleVariant); dispid 1610809345;
    procedure FindPrinter(const Name: WideString; const location: WideString; 
                          const model: WideString); dispid 1610809346;
    function GetSystemInformation(const Name: WideString): OleVariant; dispid 1610809347;
    function ServiceStart(const ServiceName: WideString; Persistent: OleVariant): OleVariant; dispid 1610809348;
    function ServiceStop(const ServiceName: WideString; Persistent: OleVariant): OleVariant; dispid 1610809349;
    function IsServiceRunning(const ServiceName: WideString): OleVariant; dispid 1610809350;
    function CanStartStopService(const ServiceName: WideString): OleVariant; dispid 1610809351;
    function ShowBrowserBar(const bstrClsid: WideString; bShow: OleVariant): OleVariant; dispid 1610809352;
    property Application: IDispatch readonly dispid 1610743808;
    property Parent: IDispatch readonly dispid 1610743809;
    function NameSpace(vDir: OleVariant): Folder; dispid 1610743810;
    function BrowseForFolder(Hwnd: Integer; const Title: WideString; Options: Integer; 
                             RootFolder: OleVariant): Folder; dispid 1610743811;
    function Windows: IDispatch; dispid 1610743812;
    procedure Open(vDir: OleVariant); dispid 1610743813;
    procedure Explore(vDir: OleVariant); dispid 1610743814;
    procedure MinimizeAll; dispid 1610743815;
    procedure UndoMinimizeALL; dispid 1610743816;
    procedure FileRun; dispid 1610743817;
    procedure CascadeWindows; dispid 1610743818;
    procedure TileVertically; dispid 1610743819;
    procedure TileHorizontally; dispid 1610743820;
    procedure ShutdownWindows; dispid 1610743821;
    procedure Suspend; dispid 1610743822;
    procedure EjectPC; dispid 1610743823;
    procedure SetTime; dispid 1610743824;
    procedure TrayProperties; dispid 1610743825;
    procedure Help; dispid 1610743826;
    procedure FindFiles; dispid 1610743827;
    procedure FindComputer; dispid 1610743828;
    procedure RefreshMenu; dispid 1610743829;
    procedure ControlPanelItem(const bstrDir: WideString); dispid 1610743830;
  end;

// *********************************************************************//
// Interface: IShellDispatch4
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {EFD84B2D-4BCF-4298-BE25-EB542A59FBDA}
// *********************************************************************//
  IShellDispatch4 = interface(IShellDispatch3)
    ['{EFD84B2D-4BCF-4298-BE25-EB542A59FBDA}']
    procedure WindowsSecurity; safecall;
    procedure ToggleDesktop; safecall;
    function ExplorerPolicy(const bstrPolicyName: WideString): OleVariant; safecall;
    function GetSetting(lSetting: Integer): WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf:  IShellDispatch4Disp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {EFD84B2D-4BCF-4298-BE25-EB542A59FBDA}
// *********************************************************************//
  IShellDispatch4Disp = dispinterface
    ['{EFD84B2D-4BCF-4298-BE25-EB542A59FBDA}']
    procedure WindowsSecurity; dispid 1610940416;
    procedure ToggleDesktop; dispid 1610940417;
    function ExplorerPolicy(const bstrPolicyName: WideString): OleVariant; dispid 1610940418;
    function GetSetting(lSetting: Integer): WordBool; dispid 1610940419;
    procedure AddToRecent(varFile: OleVariant; const bstrCategory: WideString); dispid 1610874880;
    function IsRestricted(const Group: WideString; const Restriction: WideString): Integer; dispid 1610809344;
    procedure ShellExecute(const File_: WideString; vArgs: OleVariant; vDir: OleVariant; 
                           vOperation: OleVariant; vShow: OleVariant); dispid 1610809345;
    procedure FindPrinter(const Name: WideString; const location: WideString; 
                          const model: WideString); dispid 1610809346;
    function GetSystemInformation(const Name: WideString): OleVariant; dispid 1610809347;
    function ServiceStart(const ServiceName: WideString; Persistent: OleVariant): OleVariant; dispid 1610809348;
    function ServiceStop(const ServiceName: WideString; Persistent: OleVariant): OleVariant; dispid 1610809349;
    function IsServiceRunning(const ServiceName: WideString): OleVariant; dispid 1610809350;
    function CanStartStopService(const ServiceName: WideString): OleVariant; dispid 1610809351;
    function ShowBrowserBar(const bstrClsid: WideString; bShow: OleVariant): OleVariant; dispid 1610809352;
    property Application: IDispatch readonly dispid 1610743808;
    property Parent: IDispatch readonly dispid 1610743809;
    function NameSpace(vDir: OleVariant): Folder; dispid 1610743810;
    function BrowseForFolder(Hwnd: Integer; const Title: WideString; Options: Integer; 
                             RootFolder: OleVariant): Folder; dispid 1610743811;
    function Windows: IDispatch; dispid 1610743812;
    procedure Open(vDir: OleVariant); dispid 1610743813;
    procedure Explore(vDir: OleVariant); dispid 1610743814;
    procedure MinimizeAll; dispid 1610743815;
    procedure UndoMinimizeALL; dispid 1610743816;
    procedure FileRun; dispid 1610743817;
    procedure CascadeWindows; dispid 1610743818;
    procedure TileVertically; dispid 1610743819;
    procedure TileHorizontally; dispid 1610743820;
    procedure ShutdownWindows; dispid 1610743821;
    procedure Suspend; dispid 1610743822;
    procedure EjectPC; dispid 1610743823;
    procedure SetTime; dispid 1610743824;
    procedure TrayProperties; dispid 1610743825;
    procedure Help; dispid 1610743826;
    procedure FindFiles; dispid 1610743827;
    procedure FindComputer; dispid 1610743828;
    procedure RefreshMenu; dispid 1610743829;
    procedure ControlPanelItem(const bstrDir: WideString); dispid 1610743830;
  end;

// *********************************************************************//
// Interface: IShellDispatch5
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {866738B9-6CF2-4DE8-8767-F794EBE74F4E}
// *********************************************************************//
  IShellDispatch5 = interface(IShellDispatch4)
    ['{866738B9-6CF2-4DE8-8767-F794EBE74F4E}']
    procedure WindowSwitcher; safecall;
  end;

// *********************************************************************//
// DispIntf:  IShellDispatch5Disp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {866738B9-6CF2-4DE8-8767-F794EBE74F4E}
// *********************************************************************//
  IShellDispatch5Disp = dispinterface
    ['{866738B9-6CF2-4DE8-8767-F794EBE74F4E}']
    procedure WindowSwitcher; dispid 1611005952;
    procedure WindowsSecurity; dispid 1610940416;
    procedure ToggleDesktop; dispid 1610940417;
    function ExplorerPolicy(const bstrPolicyName: WideString): OleVariant; dispid 1610940418;
    function GetSetting(lSetting: Integer): WordBool; dispid 1610940419;
    procedure AddToRecent(varFile: OleVariant; const bstrCategory: WideString); dispid 1610874880;
    function IsRestricted(const Group: WideString; const Restriction: WideString): Integer; dispid 1610809344;
    procedure ShellExecute(const File_: WideString; vArgs: OleVariant; vDir: OleVariant; 
                           vOperation: OleVariant; vShow: OleVariant); dispid 1610809345;
    procedure FindPrinter(const Name: WideString; const location: WideString; 
                          const model: WideString); dispid 1610809346;
    function GetSystemInformation(const Name: WideString): OleVariant; dispid 1610809347;
    function ServiceStart(const ServiceName: WideString; Persistent: OleVariant): OleVariant; dispid 1610809348;
    function ServiceStop(const ServiceName: WideString; Persistent: OleVariant): OleVariant; dispid 1610809349;
    function IsServiceRunning(const ServiceName: WideString): OleVariant; dispid 1610809350;
    function CanStartStopService(const ServiceName: WideString): OleVariant; dispid 1610809351;
    function ShowBrowserBar(const bstrClsid: WideString; bShow: OleVariant): OleVariant; dispid 1610809352;
    property Application: IDispatch readonly dispid 1610743808;
    property Parent: IDispatch readonly dispid 1610743809;
    function NameSpace(vDir: OleVariant): Folder; dispid 1610743810;
    function BrowseForFolder(Hwnd: Integer; const Title: WideString; Options: Integer; 
                             RootFolder: OleVariant): Folder; dispid 1610743811;
    function Windows: IDispatch; dispid 1610743812;
    procedure Open(vDir: OleVariant); dispid 1610743813;
    procedure Explore(vDir: OleVariant); dispid 1610743814;
    procedure MinimizeAll; dispid 1610743815;
    procedure UndoMinimizeALL; dispid 1610743816;
    procedure FileRun; dispid 1610743817;
    procedure CascadeWindows; dispid 1610743818;
    procedure TileVertically; dispid 1610743819;
    procedure TileHorizontally; dispid 1610743820;
    procedure ShutdownWindows; dispid 1610743821;
    procedure Suspend; dispid 1610743822;
    procedure EjectPC; dispid 1610743823;
    procedure SetTime; dispid 1610743824;
    procedure TrayProperties; dispid 1610743825;
    procedure Help; dispid 1610743826;
    procedure FindFiles; dispid 1610743827;
    procedure FindComputer; dispid 1610743828;
    procedure RefreshMenu; dispid 1610743829;
    procedure ControlPanelItem(const bstrDir: WideString); dispid 1610743830;
  end;

// *********************************************************************//
// Interface: IShellDispatch6
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {286E6F1B-7113-4355-9562-96B7E9D64C54}
// *********************************************************************//
  IShellDispatch6 = interface(IShellDispatch5)
    ['{286E6F1B-7113-4355-9562-96B7E9D64C54}']
    procedure SearchCommand; safecall;
  end;

// *********************************************************************//
// DispIntf:  IShellDispatch6Disp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {286E6F1B-7113-4355-9562-96B7E9D64C54}
// *********************************************************************//
  IShellDispatch6Disp = dispinterface
    ['{286E6F1B-7113-4355-9562-96B7E9D64C54}']
    procedure SearchCommand; dispid 1611071488;
    procedure WindowSwitcher; dispid 1611005952;
    procedure WindowsSecurity; dispid 1610940416;
    procedure ToggleDesktop; dispid 1610940417;
    function ExplorerPolicy(const bstrPolicyName: WideString): OleVariant; dispid 1610940418;
    function GetSetting(lSetting: Integer): WordBool; dispid 1610940419;
    procedure AddToRecent(varFile: OleVariant; const bstrCategory: WideString); dispid 1610874880;
    function IsRestricted(const Group: WideString; const Restriction: WideString): Integer; dispid 1610809344;
    procedure ShellExecute(const File_: WideString; vArgs: OleVariant; vDir: OleVariant; 
                           vOperation: OleVariant; vShow: OleVariant); dispid 1610809345;
    procedure FindPrinter(const Name: WideString; const location: WideString; 
                          const model: WideString); dispid 1610809346;
    function GetSystemInformation(const Name: WideString): OleVariant; dispid 1610809347;
    function ServiceStart(const ServiceName: WideString; Persistent: OleVariant): OleVariant; dispid 1610809348;
    function ServiceStop(const ServiceName: WideString; Persistent: OleVariant): OleVariant; dispid 1610809349;
    function IsServiceRunning(const ServiceName: WideString): OleVariant; dispid 1610809350;
    function CanStartStopService(const ServiceName: WideString): OleVariant; dispid 1610809351;
    function ShowBrowserBar(const bstrClsid: WideString; bShow: OleVariant): OleVariant; dispid 1610809352;
    property Application: IDispatch readonly dispid 1610743808;
    property Parent: IDispatch readonly dispid 1610743809;
    function NameSpace(vDir: OleVariant): Folder; dispid 1610743810;
    function BrowseForFolder(Hwnd: Integer; const Title: WideString; Options: Integer; 
                             RootFolder: OleVariant): Folder; dispid 1610743811;
    function Windows: IDispatch; dispid 1610743812;
    procedure Open(vDir: OleVariant); dispid 1610743813;
    procedure Explore(vDir: OleVariant); dispid 1610743814;
    procedure MinimizeAll; dispid 1610743815;
    procedure UndoMinimizeALL; dispid 1610743816;
    procedure FileRun; dispid 1610743817;
    procedure CascadeWindows; dispid 1610743818;
    procedure TileVertically; dispid 1610743819;
    procedure TileHorizontally; dispid 1610743820;
    procedure ShutdownWindows; dispid 1610743821;
    procedure Suspend; dispid 1610743822;
    procedure EjectPC; dispid 1610743823;
    procedure SetTime; dispid 1610743824;
    procedure TrayProperties; dispid 1610743825;
    procedure Help; dispid 1610743826;
    procedure FindFiles; dispid 1610743827;
    procedure FindComputer; dispid 1610743828;
    procedure RefreshMenu; dispid 1610743829;
    procedure ControlPanelItem(const bstrDir: WideString); dispid 1610743830;
  end;

// *********************************************************************//
// Interface: IFileSearchBand
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {2D91EEA1-9932-11D2-BE86-00A0C9A83DA1}
// *********************************************************************//
  IFileSearchBand = interface(IDispatch)
    ['{2D91EEA1-9932-11D2-BE86-00A0C9A83DA1}']
    procedure SetFocus; safecall;
    procedure SetSearchParameters(var pbstrSearchID: WideString; bNavToResults: WordBool; 
                                  var pvarScope: OleVariant; var pvarQueryFile: OleVariant); safecall;
    function Get_SearchID: WideString; safecall;
    function Get_Scope: OleVariant; safecall;
    function Get_QueryFile: OleVariant; safecall;
    property SearchID: WideString read Get_SearchID;
    property Scope: OleVariant read Get_Scope;
    property QueryFile: OleVariant read Get_QueryFile;
  end;

// *********************************************************************//
// DispIntf:  IFileSearchBandDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {2D91EEA1-9932-11D2-BE86-00A0C9A83DA1}
// *********************************************************************//
  IFileSearchBandDisp = dispinterface
    ['{2D91EEA1-9932-11D2-BE86-00A0C9A83DA1}']
    procedure SetFocus; dispid 1;
    procedure SetSearchParameters(var pbstrSearchID: WideString; bNavToResults: WordBool; 
                                  var pvarScope: OleVariant; var pvarQueryFile: OleVariant); dispid 2;
    property SearchID: WideString readonly dispid 3;
    property Scope: OleVariant readonly dispid 4;
    property QueryFile: OleVariant readonly dispid 5;
  end;

// *********************************************************************//
// Interface: IWebWizardHost
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {18BCC359-4990-4BFB-B951-3C83702BE5F9}
// *********************************************************************//
  IWebWizardHost = interface(IDispatch)
    ['{18BCC359-4990-4BFB-B951-3C83702BE5F9}']
    procedure FinalBack; safecall;
    procedure FinalNext; safecall;
    procedure Cancel; safecall;
    procedure Set_Caption(const pbstrCaption: WideString); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Property_(const bstrPropertyName: WideString; var pvProperty: OleVariant); safecall;
    function Get_Property_(const bstrPropertyName: WideString): OleVariant; safecall;
    procedure SetWizardButtons(vfEnableBack: WordBool; vfEnableNext: WordBool; vfLastPage: WordBool); safecall;
    procedure SetHeaderText(const bstrHeaderTitle: WideString; const bstrHeaderSubtitle: WideString); safecall;
    property Caption: WideString read Get_Caption write Set_Caption;
  end;

// *********************************************************************//
// DispIntf:  IWebWizardHostDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {18BCC359-4990-4BFB-B951-3C83702BE5F9}
// *********************************************************************//
  IWebWizardHostDisp = dispinterface
    ['{18BCC359-4990-4BFB-B951-3C83702BE5F9}']
    procedure FinalBack; dispid 0;
    procedure FinalNext; dispid 1;
    procedure Cancel; dispid 2;
    property Caption: WideString dispid 3;
    function Property_(const bstrPropertyName: WideString): {??POleVariant1}OleVariant; dispid 4;
    procedure SetWizardButtons(vfEnableBack: WordBool; vfEnableNext: WordBool; vfLastPage: WordBool); dispid 5;
    procedure SetHeaderText(const bstrHeaderTitle: WideString; const bstrHeaderSubtitle: WideString); dispid 6;
  end;

// *********************************************************************//
// Interface: IWebWizardHost2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F9C013DC-3C23-4041-8E39-CFB402F7EA59}
// *********************************************************************//
  IWebWizardHost2 = interface(IWebWizardHost)
    ['{F9C013DC-3C23-4041-8E39-CFB402F7EA59}']
    function SignString(const Value: WideString): WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  IWebWizardHost2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F9C013DC-3C23-4041-8E39-CFB402F7EA59}
// *********************************************************************//
  IWebWizardHost2Disp = dispinterface
    ['{F9C013DC-3C23-4041-8E39-CFB402F7EA59}']
    function SignString(const Value: WideString): WideString; dispid 7;
    procedure FinalBack; dispid 0;
    procedure FinalNext; dispid 1;
    procedure Cancel; dispid 2;
    property Caption: WideString dispid 3;
    function Property_(const bstrPropertyName: WideString): {??POleVariant1}OleVariant; dispid 4;
    procedure SetWizardButtons(vfEnableBack: WordBool; vfEnableNext: WordBool; vfLastPage: WordBool); dispid 5;
    procedure SetHeaderText(const bstrHeaderTitle: WideString; const bstrHeaderSubtitle: WideString); dispid 6;
  end;

// *********************************************************************//
// Interface: INewWDEvents
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0751C551-7568-41C9-8E5B-E22E38919236}
// *********************************************************************//
  INewWDEvents = interface(IWebWizardHost)
    ['{0751C551-7568-41C9-8E5B-E22E38919236}']
    function PassportAuthenticate(const bstrSignInUrl: WideString): WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf:  INewWDEventsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0751C551-7568-41C9-8E5B-E22E38919236}
// *********************************************************************//
  INewWDEventsDisp = dispinterface
    ['{0751C551-7568-41C9-8E5B-E22E38919236}']
    function PassportAuthenticate(const bstrSignInUrl: WideString): WordBool; dispid 7;
    procedure FinalBack; dispid 0;
    procedure FinalNext; dispid 1;
    procedure Cancel; dispid 2;
    property Caption: WideString dispid 3;
    function Property_(const bstrPropertyName: WideString): {??POleVariant1}OleVariant; dispid 4;
    procedure SetWizardButtons(vfEnableBack: WordBool; vfEnableNext: WordBool; vfLastPage: WordBool); dispid 5;
    procedure SetHeaderText(const bstrHeaderTitle: WideString; const bstrHeaderSubtitle: WideString); dispid 6;
  end;

// *********************************************************************//
// The Class CoShellFolderItem provides a Create and CreateRemote method to          
// create instances of the default interface FolderItem2 exposed by              
// the CoClass ShellFolderItem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoShellFolderItem = class
    class function Create: FolderItem2;
    class function CreateRemote(const MachineName: string): FolderItem2;
  end;

// *********************************************************************//
// The Class CoShellLinkObject provides a Create and CreateRemote method to          
// create instances of the default interface IShellLinkDual2 exposed by              
// the CoClass ShellLinkObject. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoShellLinkObject = class
    class function Create: IShellLinkDual2;
    class function CreateRemote(const MachineName: string): IShellLinkDual2;
  end;

// *********************************************************************//
// The Class CoShellFolderView provides a Create and CreateRemote method to          
// create instances of the default interface IShellFolderViewDual3 exposed by              
// the CoClass ShellFolderView. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoShellFolderView = class
    class function Create: IShellFolderViewDual3;
    class function CreateRemote(const MachineName: string): IShellFolderViewDual3;
  end;

// *********************************************************************//
// The Class CoShell provides a Create and CreateRemote method to          
// create instances of the default interface IShellDispatch6 exposed by              
// the CoClass Shell. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoShell = class
    class function Create: IShellDispatch6;
    class function CreateRemote(const MachineName: string): IShellDispatch6;
  end;

// *********************************************************************//
// The Class CoShellDispatchInproc provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass ShellDispatchInproc. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoShellDispatchInproc = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

// *********************************************************************//
// The Class CoFileSearchBand provides a Create and CreateRemote method to          
// create instances of the default interface IFileSearchBand exposed by              
// the CoClass FileSearchBand. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFileSearchBand = class
    class function Create: IFileSearchBand;
    class function CreateRemote(const MachineName: string): IFileSearchBand;
  end;

implementation

uses ComObj;

class function CoShellFolderItem.Create: FolderItem2;
begin
  Result := CreateComObject(CLASS_ShellFolderItem) as FolderItem2;
end;

class function CoShellFolderItem.CreateRemote(const MachineName: string): FolderItem2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ShellFolderItem) as FolderItem2;
end;

class function CoShellLinkObject.Create: IShellLinkDual2;
begin
  Result := CreateComObject(CLASS_ShellLinkObject) as IShellLinkDual2;
end;

class function CoShellLinkObject.CreateRemote(const MachineName: string): IShellLinkDual2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ShellLinkObject) as IShellLinkDual2;
end;

class function CoShellFolderView.Create: IShellFolderViewDual3;
begin
  Result := CreateComObject(CLASS_ShellFolderView) as IShellFolderViewDual3;
end;

class function CoShellFolderView.CreateRemote(const MachineName: string): IShellFolderViewDual3;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ShellFolderView) as IShellFolderViewDual3;
end;

class function CoShell.Create: IShellDispatch6;
begin
  Result := CreateComObject(CLASS_Shell) as IShellDispatch6;
end;

class function CoShell.CreateRemote(const MachineName: string): IShellDispatch6;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Shell) as IShellDispatch6;
end;

class function CoShellDispatchInproc.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_ShellDispatchInproc) as IUnknown;
end;

class function CoShellDispatchInproc.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ShellDispatchInproc) as IUnknown;
end;

class function CoFileSearchBand.Create: IFileSearchBand;
begin
  Result := CreateComObject(CLASS_FileSearchBand) as IFileSearchBand;
end;

class function CoFileSearchBand.CreateRemote(const MachineName: string): IFileSearchBand;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FileSearchBand) as IFileSearchBand;
end;

end.
