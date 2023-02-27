unit WIA_TLB;

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
// File generated on 14/06/2022 20:14:00 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\WINDOWS\System32\wiaaut.dll (1)
// LIBID: {94A0E92D-43C0-494E-AC29-FD45948A5221}
// LCID: 0
// Helpfile: 
// HelpString: Microsoft Windows Image Acquisition Library v2.0
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// Errors:
//   Hint: TypeInfo 'Property' changed to 'Property_'
//   Hint: Member 'String' of 'IVector' changed to 'String_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Symbol 'Type' renamed to 'type_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  WIAMajorVersion = 1;
  WIAMinorVersion = 0;

  LIBID_WIA: TGUID = '{94A0E92D-43C0-494E-AC29-FD45948A5221}';

  IID_IRational: TGUID = '{3BF1B24A-01A5-4AA3-91F9-25A60B50E49B}';
  CLASS_Rational: TGUID = '{0C5672F9-3EDC-4B24-95B5-A6C54C0B79AD}';
  IID_IImageFile: TGUID = '{F4243B65-3F63-4D99-93CD-86B6D62C5EB2}';
  IID_IVector: TGUID = '{696F2367-6619-49BD-BA96-904DC2609990}';
  IID_IProperties: TGUID = '{40571E58-A308-470A-80AA-FA10F88793A0}';
  IID_IProperty: TGUID = '{706038DC-9F4B-4E45-88E2-5EB7D665B815}';
  CLASS_Vector: TGUID = '{4DD1D1C3-B36A-4EB4-AAEF-815891A58A30}';
  CLASS_Property_: TGUID = '{2014DE3F-3723-4178-8643-3317A32D4A2B}';
  CLASS_Properties: TGUID = '{96F887FC-08B1-4F97-A69C-75280C6A9CF8}';
  CLASS_ImageFile: TGUID = '{A2E6DDA0-06EF-4DF3-B7BD-5AA224BB06E8}';
  IID_IFilterInfo: TGUID = '{EFD1219F-8229-4B30-809D-8F6D83341569}';
  CLASS_FilterInfo: TGUID = '{318D6B52-9B1C-4E3B-8D90-1F0E857FA9B0}';
  IID_IFilterInfos: TGUID = '{AF49723A-499C-411C-B19A-1B8244D67E44}';
  CLASS_FilterInfos: TGUID = '{56FA88D3-F3DA-4DE3-94E8-811040C3CCD4}';
  IID_IFilter: TGUID = '{851E9802-B338-4AB3-BB6B-6AA57CC699D0}';
  CLASS_Filter: TGUID = '{52AD8A74-F064-4F4C-8544-FF494D349F7B}';
  IID_IFilters: TGUID = '{C82FFED4-0A8D-4F85-B90A-AC8E720D39C1}';
  CLASS_Filters: TGUID = '{31CDD60C-C04C-424D-95FC-36A52646D71C}';
  IID_IImageProcess: TGUID = '{41506929-7855-4392-9E6F-98D88513E55D}';
  CLASS_ImageProcess: TGUID = '{BD0D38E4-74C8-4904-9B5A-269F8E9994E9}';
  IID_IFormats: TGUID = '{882A274F-DF2F-4F6D-9F5A-AF4FD484530D}';
  CLASS_Formats: TGUID = '{6F62E261-0FE6-476B-A244-50CF7440DDEB}';
  IID_IDeviceCommand: TGUID = '{7CF694C0-F589-451C-B56E-398B5855B05E}';
  CLASS_DeviceCommand: TGUID = '{72226184-AFBB-4059-BF55-0F6C076E669D}';
  IID_IDeviceCommands: TGUID = '{C53AE9D5-6D91-4815-AF93-5F1E1B3B08BD}';
  CLASS_DeviceCommands: TGUID = '{25B047DB-4AAD-4FC2-A0BE-31DDA687FF32}';
  IID_IItems: TGUID = '{46102071-60B4-4E58-8620-397D17B0BB5B}';
  IID_IItem: TGUID = '{68F2BF12-A755-4E2B-9BCD-37A22587D078}';
  CLASS_Item: TGUID = '{36F479F3-C258-426E-B5FA-2793DCFDA881}';
  CLASS_Items: TGUID = '{B243B765-CA9C-4F30-A457-C8B2B57A585E}';
  IID_IDeviceEvent: TGUID = '{80D0880A-BB10-4722-82D1-07DC8DA157E2}';
  CLASS_DeviceEvent: TGUID = '{617CF892-783C-43D3-B04B-F0F1DE3B326D}';
  IID_IDeviceEvents: TGUID = '{03985C95-581B-44D1-9403-8488B347538B}';
  CLASS_DeviceEvents: TGUID = '{3563A59A-BBCD-4C86-94A0-92136C80A8B4}';
  IID_IDevice: TGUID = '{3714EAC4-F413-426B-B1E8-DEF2BE99EA55}';
  IID_IDeviceInfo: TGUID = '{2A99020A-E325-4454-95E0-136726ED4818}';
  CLASS_DeviceInfo: TGUID = '{F09CFB7A-E561-4625-9BB5-208BCA0DE09F}';
  IID_IDeviceInfos: TGUID = '{FE076B64-8406-4E92-9CAC-9093F378E05F}';
  CLASS_DeviceInfos: TGUID = '{2DFEE16B-E4AC-4A19-B660-AE71A745D34F}';
  CLASS_Device: TGUID = '{DBAA8843-B1C4-4EDC-B7E0-D6F61162BE58}';
  IID_ICommonDialog: TGUID = '{B4760F13-D9F3-4DF8-94B5-D225F86EE9A1}';
  CLASS_CommonDialog: TGUID = '{850D1D11-70F3-4BE5-9A11-77AA6B2BB201}';
  IID_IDeviceManager: TGUID = '{73856D9A-2720-487A-A584-21D5774E9D0F}';
  DIID__IDeviceManagerEvents: TGUID = '{2E9A5206-2360-49DF-9D9B-1762B4BEAE77}';
  CLASS_DeviceManager: TGUID = '{E1C5D730-7E97-4D8A-9E42-BBAE87C2059F}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum WiaSubType
type
  WiaSubType = TOleEnum;
const
  UnspecifiedSubType = $00000000;
  RangeSubType = $00000001;
  ListSubType = $00000002;
  FlagSubType = $00000003;

// Constants for enum WiaDeviceType
type
  WiaDeviceType = TOleEnum;
const
  UnspecifiedDeviceType = $00000000;
  ScannerDeviceType = $00000001;
  CameraDeviceType = $00000002;
  VideoDeviceType = $00000003;

// Constants for enum WiaItemFlag
type
  WiaItemFlag = TOleEnum;
const
  FreeItemFlag = $00000000;
  ImageItemFlag = $00000001;
  FileItemFlag = $00000002;
  FolderItemFlag = $00000004;
  RootItemFlag = $00000008;
  AnalyzeItemFlag = $00000010;
  AudioItemFlag = $00000020;
  DeviceItemFlag = $00000040;
  DeletedItemFlag = $00000080;
  DisconnectedItemFlag = $00000100;
  HPanoramaItemFlag = $00000200;
  VPanoramaItemFlag = $00000400;
  BurstItemFlag = $00000800;
  StorageItemFlag = $00001000;
  TransferItemFlag = $00002000;
  GeneratedItemFlag = $00004000;
  HasAttachmentsItemFlag = $00008000;
  VideoItemFlag = $00010000;
  RemovedItemFlag = $80000000;

// Constants for enum WiaPropertyType
type
  WiaPropertyType = TOleEnum;
const
  UnsupportedPropertyType = $00000000;
  BooleanPropertyType = $00000001;
  BytePropertyType = $00000002;
  IntegerPropertyType = $00000003;
  UnsignedIntegerPropertyType = $00000004;
  LongPropertyType = $00000005;
  UnsignedLongPropertyType = $00000006;
  ErrorCodePropertyType = $00000007;
  LargeIntegerPropertyType = $00000008;
  UnsignedLargeIntegerPropertyType = $00000009;
  SinglePropertyType = $0000000A;
  DoublePropertyType = $0000000B;
  CurrencyPropertyType = $0000000C;
  DatePropertyType = $0000000D;
  FileTimePropertyType = $0000000E;
  ClassIDPropertyType = $0000000F;
  StringPropertyType = $00000010;
  ObjectPropertyType = $00000011;
  HandlePropertyType = $00000012;
  VariantPropertyType = $00000013;
  VectorOfBooleansPropertyType = $00000065;
  VectorOfBytesPropertyType = $00000066;
  VectorOfIntegersPropertyType = $00000067;
  VectorOfUnsignedIntegersPropertyType = $00000068;
  VectorOfLongsPropertyType = $00000069;
  VectorOfUnsignedLongsPropertyType = $0000006A;
  VectorOfErrorCodesPropertyType = $0000006B;
  VectorOfLargeIntegersPropertyType = $0000006C;
  VectorOfUnsignedLargeIntegersPropertyType = $0000006D;
  VectorOfSinglesPropertyType = $0000006E;
  VectorOfDoublesPropertyType = $0000006F;
  VectorOfCurrenciesPropertyType = $00000070;
  VectorOfDatesPropertyType = $00000071;
  VectorOfFileTimesPropertyType = $00000072;
  VectorOfClassIDsPropertyType = $00000073;
  VectorOfStringsPropertyType = $00000074;
  VectorOfVariantsPropertyType = $00000077;

// Constants for enum WiaImagePropertyType
type
  WiaImagePropertyType = TOleEnum;
const
  UndefinedImagePropertyType = $000003E8;
  ByteImagePropertyType = $000003E9;
  StringImagePropertyType = $000003EA;
  UnsignedIntegerImagePropertyType = $000003EB;
  LongImagePropertyType = $000003EC;
  UnsignedLongImagePropertyType = $000003ED;
  RationalImagePropertyType = $000003EE;
  UnsignedRationalImagePropertyType = $000003EF;
  VectorOfUndefinedImagePropertyType = $0000044C;
  VectorOfBytesImagePropertyType = $0000044D;
  VectorOfUnsignedIntegersImagePropertyType = $0000044E;
  VectorOfLongsImagePropertyType = $0000044F;
  VectorOfUnsignedLongsImagePropertyType = $00000450;
  VectorOfRationalsImagePropertyType = $00000451;
  VectorOfUnsignedRationalsImagePropertyType = $00000452;

// Constants for enum WiaEventFlag
type
  WiaEventFlag = TOleEnum;
const
  NotificationEvent = $00000001;
  ActionEvent = $00000002;

// Constants for enum WiaImageIntent
type
  WiaImageIntent = TOleEnum;
const
  UnspecifiedIntent = $00000000;
  ColorIntent = $00000001;
  GrayscaleIntent = $00000002;
  TextIntent = $00000004;

// Constants for enum WiaImageBias
type
  WiaImageBias = TOleEnum;
const
  MinimizeSize = $00010000;
  MaximizeQuality = $00020000;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRational = interface;
  IRationalDisp = dispinterface;
  IImageFile = interface;
  IImageFileDisp = dispinterface;
  IVector = interface;
  IVectorDisp = dispinterface;
  IProperties = interface;
  IPropertiesDisp = dispinterface;
  IProperty = interface;
  IPropertyDisp = dispinterface;
  IFilterInfo = interface;
  IFilterInfoDisp = dispinterface;
  IFilterInfos = interface;
  IFilterInfosDisp = dispinterface;
  IFilter = interface;
  IFilterDisp = dispinterface;
  IFilters = interface;
  IFiltersDisp = dispinterface;
  IImageProcess = interface;
  IImageProcessDisp = dispinterface;
  IFormats = interface;
  IFormatsDisp = dispinterface;
  IDeviceCommand = interface;
  IDeviceCommandDisp = dispinterface;
  IDeviceCommands = interface;
  IDeviceCommandsDisp = dispinterface;
  IItems = interface;
  IItemsDisp = dispinterface;
  IItem = interface;
  IItemDisp = dispinterface;
  IDeviceEvent = interface;
  IDeviceEventDisp = dispinterface;
  IDeviceEvents = interface;
  IDeviceEventsDisp = dispinterface;
  IDevice = interface;
  IDeviceDisp = dispinterface;
  IDeviceInfo = interface;
  IDeviceInfoDisp = dispinterface;
  IDeviceInfos = interface;
  IDeviceInfosDisp = dispinterface;
  ICommonDialog = interface;
  ICommonDialogDisp = dispinterface;
  IDeviceManager = interface;
  IDeviceManagerDisp = dispinterface;
  _IDeviceManagerEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Rational = IRational;
  Vector = IVector;
  Property_ = IProperty;
  Properties = IProperties;
  ImageFile = IImageFile;
  FilterInfo = IFilterInfo;
  FilterInfos = IFilterInfos;
  Filter = IFilter;
  Filters = IFilters;
  ImageProcess = IImageProcess;
  Formats = IFormats;
  DeviceCommand = IDeviceCommand;
  DeviceCommands = IDeviceCommands;
  Item = IItem;
  Items = IItems;
  DeviceEvent = IDeviceEvent;
  DeviceEvents = IDeviceEvents;
  DeviceInfo = IDeviceInfo;
  DeviceInfos = IDeviceInfos;
  Device = IDevice;
  CommonDialog = ICommonDialog;
  DeviceManager = IDeviceManager;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  POleVariant1 = ^OleVariant; {*}


// *********************************************************************//
// Interface: IRational
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3BF1B24A-01A5-4AA3-91F9-25A60B50E49B}
// *********************************************************************//
  IRational = interface(IDispatch)
    ['{3BF1B24A-01A5-4AA3-91F9-25A60B50E49B}']
    function Get_Value: Double; safecall;
    function Get_Numerator: Integer; safecall;
    procedure Set_Numerator(plResult: Integer); safecall;
    function Get_Denominator: Integer; safecall;
    procedure Set_Denominator(plResult: Integer); safecall;
    property Value: Double read Get_Value;
    property Numerator: Integer read Get_Numerator write Set_Numerator;
    property Denominator: Integer read Get_Denominator write Set_Denominator;
  end;

// *********************************************************************//
// DispIntf:  IRationalDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3BF1B24A-01A5-4AA3-91F9-25A60B50E49B}
// *********************************************************************//
  IRationalDisp = dispinterface
    ['{3BF1B24A-01A5-4AA3-91F9-25A60B50E49B}']
    property Value: Double readonly dispid 0;
    property Numerator: Integer dispid 1;
    property Denominator: Integer dispid 2;
  end;

// *********************************************************************//
// Interface: IImageFile
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F4243B65-3F63-4D99-93CD-86B6D62C5EB2}
// *********************************************************************//
  IImageFile = interface(IDispatch)
    ['{F4243B65-3F63-4D99-93CD-86B6D62C5EB2}']
    function Get_FormatID: WideString; safecall;
    function Get_FileExtension: WideString; safecall;
    function Get_FileData: IVector; safecall;
    function Get_ARGBData: IVector; safecall;
    function Get_Height: Integer; safecall;
    function Get_Width: Integer; safecall;
    function Get_HorizontalResolution: Double; safecall;
    function Get_VerticalResolution: Double; safecall;
    function Get_PixelDepth: Integer; safecall;
    function Get_IsIndexedPixelFormat: WordBool; safecall;
    function Get_IsAlphaPixelFormat: WordBool; safecall;
    function Get_IsExtendedPixelFormat: WordBool; safecall;
    function Get_IsAnimated: WordBool; safecall;
    function Get_FrameCount: Integer; safecall;
    function Get_ActiveFrame: Integer; safecall;
    procedure Set_ActiveFrame(plResult: Integer); safecall;
    function Get_Properties: IProperties; safecall;
    procedure LoadFile(const Filename: WideString); safecall;
    procedure SaveFile(const Filename: WideString); safecall;
    property FormatID: WideString read Get_FormatID;
    property FileExtension: WideString read Get_FileExtension;
    property FileData: IVector read Get_FileData;
    property ARGBData: IVector read Get_ARGBData;
    property Height: Integer read Get_Height;
    property Width: Integer read Get_Width;
    property HorizontalResolution: Double read Get_HorizontalResolution;
    property VerticalResolution: Double read Get_VerticalResolution;
    property PixelDepth: Integer read Get_PixelDepth;
    property IsIndexedPixelFormat: WordBool read Get_IsIndexedPixelFormat;
    property IsAlphaPixelFormat: WordBool read Get_IsAlphaPixelFormat;
    property IsExtendedPixelFormat: WordBool read Get_IsExtendedPixelFormat;
    property IsAnimated: WordBool read Get_IsAnimated;
    property FrameCount: Integer read Get_FrameCount;
    property ActiveFrame: Integer read Get_ActiveFrame write Set_ActiveFrame;
    property Properties: IProperties read Get_Properties;
  end;

// *********************************************************************//
// DispIntf:  IImageFileDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F4243B65-3F63-4D99-93CD-86B6D62C5EB2}
// *********************************************************************//
  IImageFileDisp = dispinterface
    ['{F4243B65-3F63-4D99-93CD-86B6D62C5EB2}']
    property FormatID: WideString readonly dispid 1;
    property FileExtension: WideString readonly dispid 2;
    property FileData: IVector readonly dispid 3;
    property ARGBData: IVector readonly dispid 4;
    property Height: Integer readonly dispid 5;
    property Width: Integer readonly dispid 6;
    property HorizontalResolution: Double readonly dispid 7;
    property VerticalResolution: Double readonly dispid 8;
    property PixelDepth: Integer readonly dispid 9;
    property IsIndexedPixelFormat: WordBool readonly dispid 10;
    property IsAlphaPixelFormat: WordBool readonly dispid 11;
    property IsExtendedPixelFormat: WordBool readonly dispid 12;
    property IsAnimated: WordBool readonly dispid 13;
    property FrameCount: Integer readonly dispid 14;
    property ActiveFrame: Integer dispid 15;
    property Properties: IProperties readonly dispid 16;
    procedure LoadFile(const Filename: WideString); dispid 17;
    procedure SaveFile(const Filename: WideString); dispid 18;
  end;

// *********************************************************************//
// Interface: IVector
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {696F2367-6619-49BD-BA96-904DC2609990}
// *********************************************************************//
  IVector = interface(IDispatch)
    ['{696F2367-6619-49BD-BA96-904DC2609990}']
    function Get_Item(Index: Integer): OleVariant; safecall;
    procedure Set_Item(Index: Integer; var pResult: OleVariant); safecall;
    procedure _Set_Item(Index: Integer; var pResult: OleVariant); safecall;
    function Get_Count: Integer; safecall;
    function Get_Picture(Width: Integer; Height: Integer): OleVariant; safecall;
    function Get_ImageFile(Width: Integer; Height: Integer): IImageFile; safecall;
    function Get_BinaryData: OleVariant; safecall;
    procedure Set_BinaryData(var pvResult: OleVariant); safecall;
    function Get_String_(Unicode: WordBool): WideString; safecall;
    function Get_Date: TDateTime; safecall;
    procedure Set_Date(pdResult: TDateTime); safecall;
    function Get__NewEnum: IUnknown; safecall;
    procedure Add(var Value: OleVariant; Index: Integer); safecall;
    function Remove(Index: Integer): OleVariant; safecall;
    procedure Clear; safecall;
    procedure SetFromString(const Value: WideString; Resizable: WordBool; Unicode: WordBool); safecall;
    property Count: Integer read Get_Count;
    property Picture[Width: Integer; Height: Integer]: OleVariant read Get_Picture;
    property ImageFile[Width: Integer; Height: Integer]: IImageFile read Get_ImageFile;
    property String_[Unicode: WordBool]: WideString read Get_String_;
    property Date: TDateTime read Get_Date write Set_Date;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  IVectorDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {696F2367-6619-49BD-BA96-904DC2609990}
// *********************************************************************//
  IVectorDisp = dispinterface
    ['{696F2367-6619-49BD-BA96-904DC2609990}']
    function Item(Index: Integer): OleVariant; dispid 0;
    property Count: Integer readonly dispid 1;
    property Picture[Width: Integer; Height: Integer]: OleVariant readonly dispid 2;
    property ImageFile[Width: Integer; Height: Integer]: IImageFile readonly dispid 3;
    function BinaryData: OleVariant; dispid 4;
    property String_[Unicode: WordBool]: WideString readonly dispid 5;
    property Date: TDateTime dispid 6;
    property _NewEnum: IUnknown readonly dispid -4;
    procedure Add(var Value: OleVariant; Index: Integer); dispid 7;
    function Remove(Index: Integer): OleVariant; dispid 8;
    procedure Clear; dispid 9;
    procedure SetFromString(const Value: WideString; Resizable: WordBool; Unicode: WordBool); dispid 10;
  end;

// *********************************************************************//
// Interface: IProperties
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {40571E58-A308-470A-80AA-FA10F88793A0}
// *********************************************************************//
  IProperties = interface(IDispatch)
    ['{40571E58-A308-470A-80AA-FA10F88793A0}']
    function Get_Item(var Index: OleVariant): IProperty; safecall;
    function Get_Count: Integer; safecall;
    function Exists(var Index: OleVariant): WordBool; safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Item[var Index: OleVariant]: IProperty read Get_Item; default;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  IPropertiesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {40571E58-A308-470A-80AA-FA10F88793A0}
// *********************************************************************//
  IPropertiesDisp = dispinterface
    ['{40571E58-A308-470A-80AA-FA10F88793A0}']
    property Item[var Index: OleVariant]: IProperty readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    function Exists(var Index: OleVariant): WordBool; dispid 2;
    property _NewEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// Interface: IProperty
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {706038DC-9F4B-4E45-88E2-5EB7D665B815}
// *********************************************************************//
  IProperty = interface(IDispatch)
    ['{706038DC-9F4B-4E45-88E2-5EB7D665B815}']
    function Get_Value: OleVariant; safecall;
    procedure Set_Value(var pvResult: OleVariant); safecall;
    procedure _Set_Value(var pvResult: OleVariant); safecall;
    function Get_Name: WideString; safecall;
    function Get_PropertyID: Integer; safecall;
    function Get_type_: Integer; safecall;
    function Get_IsReadOnly: WordBool; safecall;
    function Get_IsVector: WordBool; safecall;
    function Get_SubType: WiaSubType; safecall;
    function Get_SubTypeDefault: OleVariant; safecall;
    function Get_SubTypeValues: IVector; safecall;
    function Get_SubTypeMin: Integer; safecall;
    function Get_SubTypeMax: Integer; safecall;
    function Get_SubTypeStep: Integer; safecall;
    property Name: WideString read Get_Name;
    property PropertyID: Integer read Get_PropertyID;
    property type_: Integer read Get_type_;
    property IsReadOnly: WordBool read Get_IsReadOnly;
    property IsVector: WordBool read Get_IsVector;
    property SubType: WiaSubType read Get_SubType;
    property SubTypeDefault: OleVariant read Get_SubTypeDefault;
    property SubTypeValues: IVector read Get_SubTypeValues;
    property SubTypeMin: Integer read Get_SubTypeMin;
    property SubTypeMax: Integer read Get_SubTypeMax;
    property SubTypeStep: Integer read Get_SubTypeStep;
  end;

// *********************************************************************//
// DispIntf:  IPropertyDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {706038DC-9F4B-4E45-88E2-5EB7D665B815}
// *********************************************************************//
  IPropertyDisp = dispinterface
    ['{706038DC-9F4B-4E45-88E2-5EB7D665B815}']
    function Value: OleVariant; dispid 0;
    property Name: WideString readonly dispid 1;
    property PropertyID: Integer readonly dispid 2;
    property type_: Integer readonly dispid 3;
    property IsReadOnly: WordBool readonly dispid 4;
    property IsVector: WordBool readonly dispid 5;
    property SubType: WiaSubType readonly dispid 6;
    property SubTypeDefault: OleVariant readonly dispid 7;
    property SubTypeValues: IVector readonly dispid 8;
    property SubTypeMin: Integer readonly dispid 9;
    property SubTypeMax: Integer readonly dispid 10;
    property SubTypeStep: Integer readonly dispid 11;
  end;

// *********************************************************************//
// Interface: IFilterInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EFD1219F-8229-4B30-809D-8F6D83341569}
// *********************************************************************//
  IFilterInfo = interface(IDispatch)
    ['{EFD1219F-8229-4B30-809D-8F6D83341569}']
    function Get_Name: WideString; safecall;
    function Get_Description: WideString; safecall;
    function Get_FilterID: WideString; safecall;
    property Name: WideString read Get_Name;
    property Description: WideString read Get_Description;
    property FilterID: WideString read Get_FilterID;
  end;

// *********************************************************************//
// DispIntf:  IFilterInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EFD1219F-8229-4B30-809D-8F6D83341569}
// *********************************************************************//
  IFilterInfoDisp = dispinterface
    ['{EFD1219F-8229-4B30-809D-8F6D83341569}']
    property Name: WideString readonly dispid 1;
    property Description: WideString readonly dispid 2;
    property FilterID: WideString readonly dispid 3;
  end;

// *********************************************************************//
// Interface: IFilterInfos
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AF49723A-499C-411C-B19A-1B8244D67E44}
// *********************************************************************//
  IFilterInfos = interface(IDispatch)
    ['{AF49723A-499C-411C-B19A-1B8244D67E44}']
    function Get_Item(var Index: OleVariant): IFilterInfo; safecall;
    function Get_Count: Integer; safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Item[var Index: OleVariant]: IFilterInfo read Get_Item; default;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  IFilterInfosDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AF49723A-499C-411C-B19A-1B8244D67E44}
// *********************************************************************//
  IFilterInfosDisp = dispinterface
    ['{AF49723A-499C-411C-B19A-1B8244D67E44}']
    property Item[var Index: OleVariant]: IFilterInfo readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    property _NewEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// Interface: IFilter
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {851E9802-B338-4AB3-BB6B-6AA57CC699D0}
// *********************************************************************//
  IFilter = interface(IDispatch)
    ['{851E9802-B338-4AB3-BB6B-6AA57CC699D0}']
    function Get_Name: WideString; safecall;
    function Get_Description: WideString; safecall;
    function Get_FilterID: WideString; safecall;
    function Get_Properties: IProperties; safecall;
    property Name: WideString read Get_Name;
    property Description: WideString read Get_Description;
    property FilterID: WideString read Get_FilterID;
    property Properties: IProperties read Get_Properties;
  end;

// *********************************************************************//
// DispIntf:  IFilterDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {851E9802-B338-4AB3-BB6B-6AA57CC699D0}
// *********************************************************************//
  IFilterDisp = dispinterface
    ['{851E9802-B338-4AB3-BB6B-6AA57CC699D0}']
    property Name: WideString readonly dispid 1;
    property Description: WideString readonly dispid 2;
    property FilterID: WideString readonly dispid 3;
    property Properties: IProperties readonly dispid 4;
  end;

// *********************************************************************//
// Interface: IFilters
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C82FFED4-0A8D-4F85-B90A-AC8E720D39C1}
// *********************************************************************//
  IFilters = interface(IDispatch)
    ['{C82FFED4-0A8D-4F85-B90A-AC8E720D39C1}']
    function Get_Item(Index: Integer): IFilter; safecall;
    function Get_Count: Integer; safecall;
    function Get__NewEnum: IUnknown; safecall;
    procedure Add(const FilterID: WideString; Index: Integer); safecall;
    procedure Remove(Index: Integer); safecall;
    property Item[Index: Integer]: IFilter read Get_Item; default;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  IFiltersDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C82FFED4-0A8D-4F85-B90A-AC8E720D39C1}
// *********************************************************************//
  IFiltersDisp = dispinterface
    ['{C82FFED4-0A8D-4F85-B90A-AC8E720D39C1}']
    property Item[Index: Integer]: IFilter readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    property _NewEnum: IUnknown readonly dispid -4;
    procedure Add(const FilterID: WideString; Index: Integer); dispid 2;
    procedure Remove(Index: Integer); dispid 3;
  end;

// *********************************************************************//
// Interface: IImageProcess
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {41506929-7855-4392-9E6F-98D88513E55D}
// *********************************************************************//
  IImageProcess = interface(IDispatch)
    ['{41506929-7855-4392-9E6F-98D88513E55D}']
    function Get_FilterInfos: IFilterInfos; safecall;
    function Get_Filters: IFilters; safecall;
    function Apply(const Source: IImageFile): IImageFile; safecall;
    property FilterInfos: IFilterInfos read Get_FilterInfos;
    property Filters: IFilters read Get_Filters;
  end;

// *********************************************************************//
// DispIntf:  IImageProcessDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {41506929-7855-4392-9E6F-98D88513E55D}
// *********************************************************************//
  IImageProcessDisp = dispinterface
    ['{41506929-7855-4392-9E6F-98D88513E55D}']
    property FilterInfos: IFilterInfos readonly dispid 1;
    property Filters: IFilters readonly dispid 2;
    function Apply(const Source: IImageFile): IImageFile; dispid 4;
  end;

// *********************************************************************//
// Interface: IFormats
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {882A274F-DF2F-4F6D-9F5A-AF4FD484530D}
// *********************************************************************//
  IFormats = interface(IDispatch)
    ['{882A274F-DF2F-4F6D-9F5A-AF4FD484530D}']
    function Get_Item(Index: Integer): WideString; safecall;
    function Get_Count: Integer; safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Item[Index: Integer]: WideString read Get_Item; default;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  IFormatsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {882A274F-DF2F-4F6D-9F5A-AF4FD484530D}
// *********************************************************************//
  IFormatsDisp = dispinterface
    ['{882A274F-DF2F-4F6D-9F5A-AF4FD484530D}']
    property Item[Index: Integer]: WideString readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    property _NewEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// Interface: IDeviceCommand
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7CF694C0-F589-451C-B56E-398B5855B05E}
// *********************************************************************//
  IDeviceCommand = interface(IDispatch)
    ['{7CF694C0-F589-451C-B56E-398B5855B05E}']
    function Get_CommandID: WideString; safecall;
    function Get_Name: WideString; safecall;
    function Get_Description: WideString; safecall;
    property CommandID: WideString read Get_CommandID;
    property Name: WideString read Get_Name;
    property Description: WideString read Get_Description;
  end;

// *********************************************************************//
// DispIntf:  IDeviceCommandDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7CF694C0-F589-451C-B56E-398B5855B05E}
// *********************************************************************//
  IDeviceCommandDisp = dispinterface
    ['{7CF694C0-F589-451C-B56E-398B5855B05E}']
    property CommandID: WideString readonly dispid 1;
    property Name: WideString readonly dispid 2;
    property Description: WideString readonly dispid 3;
  end;

// *********************************************************************//
// Interface: IDeviceCommands
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C53AE9D5-6D91-4815-AF93-5F1E1B3B08BD}
// *********************************************************************//
  IDeviceCommands = interface(IDispatch)
    ['{C53AE9D5-6D91-4815-AF93-5F1E1B3B08BD}']
    function Get_Item(Index: Integer): IDeviceCommand; safecall;
    function Get_Count: Integer; safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Item[Index: Integer]: IDeviceCommand read Get_Item; default;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  IDeviceCommandsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C53AE9D5-6D91-4815-AF93-5F1E1B3B08BD}
// *********************************************************************//
  IDeviceCommandsDisp = dispinterface
    ['{C53AE9D5-6D91-4815-AF93-5F1E1B3B08BD}']
    property Item[Index: Integer]: IDeviceCommand readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    property _NewEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// Interface: IItems
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {46102071-60B4-4E58-8620-397D17B0BB5B}
// *********************************************************************//
  IItems = interface(IDispatch)
    ['{46102071-60B4-4E58-8620-397D17B0BB5B}']
    function Get_Item(Index: Integer): IItem; safecall;
    function Get_Count: Integer; safecall;
    function Get__NewEnum: IUnknown; safecall;
    procedure Add(const Name: WideString; Flags: Integer); safecall;
    procedure Remove(Index: Integer); safecall;
    property Item[Index: Integer]: IItem read Get_Item; default;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  IItemsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {46102071-60B4-4E58-8620-397D17B0BB5B}
// *********************************************************************//
  IItemsDisp = dispinterface
    ['{46102071-60B4-4E58-8620-397D17B0BB5B}']
    property Item[Index: Integer]: IItem readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    property _NewEnum: IUnknown readonly dispid -4;
    procedure Add(const Name: WideString; Flags: Integer); dispid 2;
    procedure Remove(Index: Integer); dispid 3;
  end;

// *********************************************************************//
// Interface: IItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {68F2BF12-A755-4E2B-9BCD-37A22587D078}
// *********************************************************************//
  IItem = interface(IDispatch)
    ['{68F2BF12-A755-4E2B-9BCD-37A22587D078}']
    function Get_ItemID: WideString; safecall;
    function Get_Properties: IProperties; safecall;
    function Get_Items: IItems; safecall;
    function Get_Formats: IFormats; safecall;
    function Get_Commands: IDeviceCommands; safecall;
    function Get_WiaItem: IUnknown; safecall;
    function Transfer(const FormatID: WideString): OleVariant; safecall;
    function ExecuteCommand(const CommandID: WideString): IItem; safecall;
    property ItemID: WideString read Get_ItemID;
    property Properties: IProperties read Get_Properties;
    property Items: IItems read Get_Items;
    property Formats: IFormats read Get_Formats;
    property Commands: IDeviceCommands read Get_Commands;
    property WiaItem: IUnknown read Get_WiaItem;
  end;

// *********************************************************************//
// DispIntf:  IItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {68F2BF12-A755-4E2B-9BCD-37A22587D078}
// *********************************************************************//
  IItemDisp = dispinterface
    ['{68F2BF12-A755-4E2B-9BCD-37A22587D078}']
    property ItemID: WideString readonly dispid 1;
    property Properties: IProperties readonly dispid 2;
    property Items: IItems readonly dispid 3;
    property Formats: IFormats readonly dispid 4;
    property Commands: IDeviceCommands readonly dispid 5;
    property WiaItem: IUnknown readonly dispid 6;
    function Transfer(const FormatID: WideString): OleVariant; dispid 7;
    function ExecuteCommand(const CommandID: WideString): IItem; dispid 8;
  end;

// *********************************************************************//
// Interface: IDeviceEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {80D0880A-BB10-4722-82D1-07DC8DA157E2}
// *********************************************************************//
  IDeviceEvent = interface(IDispatch)
    ['{80D0880A-BB10-4722-82D1-07DC8DA157E2}']
    function Get_EventID: WideString; safecall;
    function Get_type_: WiaEventFlag; safecall;
    function Get_Name: WideString; safecall;
    function Get_Description: WideString; safecall;
    property EventID: WideString read Get_EventID;
    property type_: WiaEventFlag read Get_type_;
    property Name: WideString read Get_Name;
    property Description: WideString read Get_Description;
  end;

// *********************************************************************//
// DispIntf:  IDeviceEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {80D0880A-BB10-4722-82D1-07DC8DA157E2}
// *********************************************************************//
  IDeviceEventDisp = dispinterface
    ['{80D0880A-BB10-4722-82D1-07DC8DA157E2}']
    property EventID: WideString readonly dispid 1;
    property type_: WiaEventFlag readonly dispid 2;
    property Name: WideString readonly dispid 3;
    property Description: WideString readonly dispid 4;
  end;

// *********************************************************************//
// Interface: IDeviceEvents
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {03985C95-581B-44D1-9403-8488B347538B}
// *********************************************************************//
  IDeviceEvents = interface(IDispatch)
    ['{03985C95-581B-44D1-9403-8488B347538B}']
    function Get_Item(Index: Integer): IDeviceEvent; safecall;
    function Get_Count: Integer; safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Item[Index: Integer]: IDeviceEvent read Get_Item; default;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  IDeviceEventsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {03985C95-581B-44D1-9403-8488B347538B}
// *********************************************************************//
  IDeviceEventsDisp = dispinterface
    ['{03985C95-581B-44D1-9403-8488B347538B}']
    property Item[Index: Integer]: IDeviceEvent readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    property _NewEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// Interface: IDevice
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3714EAC4-F413-426B-B1E8-DEF2BE99EA55}
// *********************************************************************//
  IDevice = interface(IDispatch)
    ['{3714EAC4-F413-426B-B1E8-DEF2BE99EA55}']
    function Get_DeviceID: WideString; safecall;
    function Get_type_: WiaDeviceType; safecall;
    function Get_Properties: IProperties; safecall;
    function Get_Items: IItems; safecall;
    function Get_Commands: IDeviceCommands; safecall;
    function Get_Events: IDeviceEvents; safecall;
    function Get_WiaItem: IUnknown; safecall;
    function GetItem(const ItemID: WideString): IItem; safecall;
    function ExecuteCommand(const CommandID: WideString): IItem; safecall;
    property DeviceID: WideString read Get_DeviceID;
    property type_: WiaDeviceType read Get_type_;
    property Properties: IProperties read Get_Properties;
    property Items: IItems read Get_Items;
    property Commands: IDeviceCommands read Get_Commands;
    property Events: IDeviceEvents read Get_Events;
    property WiaItem: IUnknown read Get_WiaItem;
  end;

// *********************************************************************//
// DispIntf:  IDeviceDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3714EAC4-F413-426B-B1E8-DEF2BE99EA55}
// *********************************************************************//
  IDeviceDisp = dispinterface
    ['{3714EAC4-F413-426B-B1E8-DEF2BE99EA55}']
    property DeviceID: WideString readonly dispid 1;
    property type_: WiaDeviceType readonly dispid 2;
    property Properties: IProperties readonly dispid 3;
    property Items: IItems readonly dispid 4;
    property Commands: IDeviceCommands readonly dispid 5;
    property Events: IDeviceEvents readonly dispid 6;
    property WiaItem: IUnknown readonly dispid 7;
    function GetItem(const ItemID: WideString): IItem; dispid 8;
    function ExecuteCommand(const CommandID: WideString): IItem; dispid 9;
  end;

// *********************************************************************//
// Interface: IDeviceInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2A99020A-E325-4454-95E0-136726ED4818}
// *********************************************************************//
  IDeviceInfo = interface(IDispatch)
    ['{2A99020A-E325-4454-95E0-136726ED4818}']
    function Get_DeviceID: WideString; safecall;
    function Get_type_: WiaDeviceType; safecall;
    function Get_Properties: IProperties; safecall;
    function Connect: IDevice; safecall;
    property DeviceID: WideString read Get_DeviceID;
    property type_: WiaDeviceType read Get_type_;
    property Properties: IProperties read Get_Properties;
  end;

// *********************************************************************//
// DispIntf:  IDeviceInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2A99020A-E325-4454-95E0-136726ED4818}
// *********************************************************************//
  IDeviceInfoDisp = dispinterface
    ['{2A99020A-E325-4454-95E0-136726ED4818}']
    property DeviceID: WideString readonly dispid 1;
    property type_: WiaDeviceType readonly dispid 2;
    property Properties: IProperties readonly dispid 3;
    function Connect: IDevice; dispid 4;
  end;

// *********************************************************************//
// Interface: IDeviceInfos
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FE076B64-8406-4E92-9CAC-9093F378E05F}
// *********************************************************************//
  IDeviceInfos = interface(IDispatch)
    ['{FE076B64-8406-4E92-9CAC-9093F378E05F}']
    function Get_Item(var Index: OleVariant): IDeviceInfo; safecall;
    function Get_Count: Integer; safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Item[var Index: OleVariant]: IDeviceInfo read Get_Item; default;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  IDeviceInfosDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FE076B64-8406-4E92-9CAC-9093F378E05F}
// *********************************************************************//
  IDeviceInfosDisp = dispinterface
    ['{FE076B64-8406-4E92-9CAC-9093F378E05F}']
    property Item[var Index: OleVariant]: IDeviceInfo readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    property _NewEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// Interface: ICommonDialog
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B4760F13-D9F3-4DF8-94B5-D225F86EE9A1}
// *********************************************************************//
  ICommonDialog = interface(IDispatch)
    ['{B4760F13-D9F3-4DF8-94B5-D225F86EE9A1}']
    function ShowAcquisitionWizard(const Device: IDevice): OleVariant; safecall;
    function ShowAcquireImage(DeviceType: WiaDeviceType; Intent: WiaImageIntent;
                              Bias: WiaImageBias; const FormatID: WideString;
                              AlwaysSelectDevice: WordBool; UseCommonUI: WordBool;
                              CancelError: WordBool): IImageFile; safecall;
    function ShowSelectDevice(DeviceType: WiaDeviceType; AlwaysSelectDevice: WordBool;
                              CancelError: WordBool): IDevice; safecall;
    function ShowSelectItems(const Device: IDevice; Intent: WiaImageIntent; Bias: WiaImageBias;
                             SingleSelect: WordBool; UseCommonUI: WordBool; CancelError: WordBool): IItems; safecall;
    procedure ShowDeviceProperties(const Device: IDevice; CancelError: WordBool); safecall;
    procedure ShowItemProperties(const Item: IItem; CancelError: WordBool); safecall;
    function ShowTransfer(const Item: IItem; const FormatID: WideString; CancelError: WordBool): OleVariant; safecall;
    procedure ShowPhotoPrintingWizard(var Files: OleVariant); safecall;
  end;

// *********************************************************************//
// DispIntf:  ICommonDialogDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B4760F13-D9F3-4DF8-94B5-D225F86EE9A1}
// *********************************************************************//
  ICommonDialogDisp = dispinterface
    ['{B4760F13-D9F3-4DF8-94B5-D225F86EE9A1}']
    function ShowAcquisitionWizard(const Device: IDevice): OleVariant; dispid 1;
    function ShowAcquireImage(DeviceType: WiaDeviceType; Intent: WiaImageIntent; 
                              Bias: WiaImageBias; const FormatID: WideString; 
                              AlwaysSelectDevice: WordBool; UseCommonUI: WordBool; 
                              CancelError: WordBool): IImageFile; dispid 2;
    function ShowSelectDevice(DeviceType: WiaDeviceType; AlwaysSelectDevice: WordBool; 
                              CancelError: WordBool): IDevice; dispid 3;
    function ShowSelectItems(const Device: IDevice; Intent: WiaImageIntent; Bias: WiaImageBias; 
                             SingleSelect: WordBool; UseCommonUI: WordBool; CancelError: WordBool): IItems; dispid 4;
    procedure ShowDeviceProperties(const Device: IDevice; CancelError: WordBool); dispid 5;
    procedure ShowItemProperties(const Item: IItem; CancelError: WordBool); dispid 6;
    function ShowTransfer(const Item: IItem; const FormatID: WideString; CancelError: WordBool): OleVariant; dispid 7;
    procedure ShowPhotoPrintingWizard(var Files: OleVariant); dispid 8;
  end;

// *********************************************************************//
// Interface: IDeviceManager
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {73856D9A-2720-487A-A584-21D5774E9D0F}
// *********************************************************************//
  IDeviceManager = interface(IDispatch)
    ['{73856D9A-2720-487A-A584-21D5774E9D0F}']
    function Get_DeviceInfos: IDeviceInfos; safecall;
    procedure RegisterEvent(const EventID: WideString; const DeviceID: WideString); safecall;
    procedure UnregisterEvent(const EventID: WideString; const DeviceID: WideString); safecall;
    procedure RegisterPersistentEvent(const Command: WideString; const Name: WideString; 
                                      const Description: WideString; const Icon: WideString; 
                                      const EventID: WideString; const DeviceID: WideString); safecall;
    procedure UnregisterPersistentEvent(const Command: WideString; const Name: WideString; 
                                        const Description: WideString; const Icon: WideString; 
                                        const EventID: WideString; const DeviceID: WideString); safecall;
    property DeviceInfos: IDeviceInfos read Get_DeviceInfos;
  end;

// *********************************************************************//
// DispIntf:  IDeviceManagerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {73856D9A-2720-487A-A584-21D5774E9D0F}
// *********************************************************************//
  IDeviceManagerDisp = dispinterface
    ['{73856D9A-2720-487A-A584-21D5774E9D0F}']
    property DeviceInfos: IDeviceInfos readonly dispid 1;
    procedure RegisterEvent(const EventID: WideString; const DeviceID: WideString); dispid 2;
    procedure UnregisterEvent(const EventID: WideString; const DeviceID: WideString); dispid 3;
    procedure RegisterPersistentEvent(const Command: WideString; const Name: WideString; 
                                      const Description: WideString; const Icon: WideString; 
                                      const EventID: WideString; const DeviceID: WideString); dispid 4;
    procedure UnregisterPersistentEvent(const Command: WideString; const Name: WideString; 
                                        const Description: WideString; const Icon: WideString; 
                                        const EventID: WideString; const DeviceID: WideString); dispid 5;
  end;

// *********************************************************************//
// DispIntf:  _IDeviceManagerEvents
// Flags:     (4096) Dispatchable
// GUID:      {2E9A5206-2360-49DF-9D9B-1762B4BEAE77}
// *********************************************************************//
  _IDeviceManagerEvents = dispinterface
    ['{2E9A5206-2360-49DF-9D9B-1762B4BEAE77}']
    procedure OnEvent(const EventID: WideString; const DeviceID: WideString; 
                      const ItemID: WideString); dispid 1;
  end;

// *********************************************************************//
// The Class CoRational provides a Create and CreateRemote method to          
// create instances of the default interface IRational exposed by              
// the CoClass Rational. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRational = class
    class function Create: IRational;
    class function CreateRemote(const MachineName: string): IRational;
  end;

// *********************************************************************//
// The Class CoVector provides a Create and CreateRemote method to          
// create instances of the default interface IVector exposed by              
// the CoClass Vector. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoVector = class
    class function Create: IVector;
    class function CreateRemote(const MachineName: string): IVector;
  end;

// *********************************************************************//
// The Class CoProperty_ provides a Create and CreateRemote method to          
// create instances of the default interface IProperty exposed by              
// the CoClass Property_. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoProperty_ = class
    class function Create: IProperty;
    class function CreateRemote(const MachineName: string): IProperty;
  end;

// *********************************************************************//
// The Class CoProperties provides a Create and CreateRemote method to          
// create instances of the default interface IProperties exposed by              
// the CoClass Properties. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoProperties = class
    class function Create: IProperties;
    class function CreateRemote(const MachineName: string): IProperties;
  end;

// *********************************************************************//
// The Class CoImageFile provides a Create and CreateRemote method to          
// create instances of the default interface IImageFile exposed by              
// the CoClass ImageFile. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoImageFile = class
    class function Create: IImageFile;
    class function CreateRemote(const MachineName: string): IImageFile;
  end;

// *********************************************************************//
// The Class CoFilterInfo provides a Create and CreateRemote method to          
// create instances of the default interface IFilterInfo exposed by              
// the CoClass FilterInfo. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFilterInfo = class
    class function Create: IFilterInfo;
    class function CreateRemote(const MachineName: string): IFilterInfo;
  end;

// *********************************************************************//
// The Class CoFilterInfos provides a Create and CreateRemote method to          
// create instances of the default interface IFilterInfos exposed by              
// the CoClass FilterInfos. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFilterInfos = class
    class function Create: IFilterInfos;
    class function CreateRemote(const MachineName: string): IFilterInfos;
  end;

// *********************************************************************//
// The Class CoFilter provides a Create and CreateRemote method to          
// create instances of the default interface IFilter exposed by              
// the CoClass Filter. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFilter = class
    class function Create: IFilter;
    class function CreateRemote(const MachineName: string): IFilter;
  end;

// *********************************************************************//
// The Class CoFilters provides a Create and CreateRemote method to          
// create instances of the default interface IFilters exposed by              
// the CoClass Filters. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFilters = class
    class function Create: IFilters;
    class function CreateRemote(const MachineName: string): IFilters;
  end;

// *********************************************************************//
// The Class CoImageProcess provides a Create and CreateRemote method to          
// create instances of the default interface IImageProcess exposed by              
// the CoClass ImageProcess. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoImageProcess = class
    class function Create: IImageProcess;
    class function CreateRemote(const MachineName: string): IImageProcess;
  end;

// *********************************************************************//
// The Class CoFormats provides a Create and CreateRemote method to          
// create instances of the default interface IFormats exposed by              
// the CoClass Formats. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFormats = class
    class function Create: IFormats;
    class function CreateRemote(const MachineName: string): IFormats;
  end;

// *********************************************************************//
// The Class CoDeviceCommand provides a Create and CreateRemote method to          
// create instances of the default interface IDeviceCommand exposed by              
// the CoClass DeviceCommand. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDeviceCommand = class
    class function Create: IDeviceCommand;
    class function CreateRemote(const MachineName: string): IDeviceCommand;
  end;

// *********************************************************************//
// The Class CoDeviceCommands provides a Create and CreateRemote method to          
// create instances of the default interface IDeviceCommands exposed by              
// the CoClass DeviceCommands. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDeviceCommands = class
    class function Create: IDeviceCommands;
    class function CreateRemote(const MachineName: string): IDeviceCommands;
  end;

// *********************************************************************//
// The Class CoItem provides a Create and CreateRemote method to          
// create instances of the default interface IItem exposed by              
// the CoClass Item. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoItem = class
    class function Create: IItem;
    class function CreateRemote(const MachineName: string): IItem;
  end;

// *********************************************************************//
// The Class CoItems provides a Create and CreateRemote method to          
// create instances of the default interface IItems exposed by              
// the CoClass Items. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoItems = class
    class function Create: IItems;
    class function CreateRemote(const MachineName: string): IItems;
  end;

// *********************************************************************//
// The Class CoDeviceEvent provides a Create and CreateRemote method to          
// create instances of the default interface IDeviceEvent exposed by              
// the CoClass DeviceEvent. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDeviceEvent = class
    class function Create: IDeviceEvent;
    class function CreateRemote(const MachineName: string): IDeviceEvent;
  end;

// *********************************************************************//
// The Class CoDeviceEvents provides a Create and CreateRemote method to          
// create instances of the default interface IDeviceEvents exposed by              
// the CoClass DeviceEvents. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDeviceEvents = class
    class function Create: IDeviceEvents;
    class function CreateRemote(const MachineName: string): IDeviceEvents;
  end;

// *********************************************************************//
// The Class CoDeviceInfo provides a Create and CreateRemote method to          
// create instances of the default interface IDeviceInfo exposed by              
// the CoClass DeviceInfo. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDeviceInfo = class
    class function Create: IDeviceInfo;
    class function CreateRemote(const MachineName: string): IDeviceInfo;
  end;

// *********************************************************************//
// The Class CoDeviceInfos provides a Create and CreateRemote method to          
// create instances of the default interface IDeviceInfos exposed by              
// the CoClass DeviceInfos. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDeviceInfos = class
    class function Create: IDeviceInfos;
    class function CreateRemote(const MachineName: string): IDeviceInfos;
  end;

// *********************************************************************//
// The Class CoDevice provides a Create and CreateRemote method to          
// create instances of the default interface IDevice exposed by              
// the CoClass Device. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDevice = class
    class function Create: IDevice;
    class function CreateRemote(const MachineName: string): IDevice;
  end;

// *********************************************************************//
// The Class CoCommonDialog provides a Create and CreateRemote method to          
// create instances of the default interface ICommonDialog exposed by              
// the CoClass CommonDialog. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCommonDialog = class
    class function Create: ICommonDialog;
    class function CreateRemote(const MachineName: string): ICommonDialog;
  end;

// *********************************************************************//
// The Class CoDeviceManager provides a Create and CreateRemote method to          
// create instances of the default interface IDeviceManager exposed by              
// the CoClass DeviceManager. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDeviceManager = class
    class function Create: IDeviceManager;
    class function CreateRemote(const MachineName: string): IDeviceManager;
  end;

implementation

uses ComObj;

class function CoRational.Create: IRational;
begin
  Result := CreateComObject(CLASS_Rational) as IRational;
end;

class function CoRational.CreateRemote(const MachineName: string): IRational;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Rational) as IRational;
end;

class function CoVector.Create: IVector;
begin
  Result := CreateComObject(CLASS_Vector) as IVector;
end;

class function CoVector.CreateRemote(const MachineName: string): IVector;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Vector) as IVector;
end;

class function CoProperty_.Create: IProperty;
begin
  Result := CreateComObject(CLASS_Property_) as IProperty;
end;

class function CoProperty_.CreateRemote(const MachineName: string): IProperty;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Property_) as IProperty;
end;

class function CoProperties.Create: IProperties;
begin
  Result := CreateComObject(CLASS_Properties) as IProperties;
end;

class function CoProperties.CreateRemote(const MachineName: string): IProperties;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Properties) as IProperties;
end;

class function CoImageFile.Create: IImageFile;
begin
  Result := CreateComObject(CLASS_ImageFile) as IImageFile;
end;

class function CoImageFile.CreateRemote(const MachineName: string): IImageFile;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ImageFile) as IImageFile;
end;

class function CoFilterInfo.Create: IFilterInfo;
begin
  Result := CreateComObject(CLASS_FilterInfo) as IFilterInfo;
end;

class function CoFilterInfo.CreateRemote(const MachineName: string): IFilterInfo;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FilterInfo) as IFilterInfo;
end;

class function CoFilterInfos.Create: IFilterInfos;
begin
  Result := CreateComObject(CLASS_FilterInfos) as IFilterInfos;
end;

class function CoFilterInfos.CreateRemote(const MachineName: string): IFilterInfos;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FilterInfos) as IFilterInfos;
end;

class function CoFilter.Create: IFilter;
begin
  Result := CreateComObject(CLASS_Filter) as IFilter;
end;

class function CoFilter.CreateRemote(const MachineName: string): IFilter;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Filter) as IFilter;
end;

class function CoFilters.Create: IFilters;
begin
  Result := CreateComObject(CLASS_Filters) as IFilters;
end;

class function CoFilters.CreateRemote(const MachineName: string): IFilters;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Filters) as IFilters;
end;

class function CoImageProcess.Create: IImageProcess;
begin
  Result := CreateComObject(CLASS_ImageProcess) as IImageProcess;
end;

class function CoImageProcess.CreateRemote(const MachineName: string): IImageProcess;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ImageProcess) as IImageProcess;
end;

class function CoFormats.Create: IFormats;
begin
  Result := CreateComObject(CLASS_Formats) as IFormats;
end;

class function CoFormats.CreateRemote(const MachineName: string): IFormats;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Formats) as IFormats;
end;

class function CoDeviceCommand.Create: IDeviceCommand;
begin
  Result := CreateComObject(CLASS_DeviceCommand) as IDeviceCommand;
end;

class function CoDeviceCommand.CreateRemote(const MachineName: string): IDeviceCommand;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DeviceCommand) as IDeviceCommand;
end;

class function CoDeviceCommands.Create: IDeviceCommands;
begin
  Result := CreateComObject(CLASS_DeviceCommands) as IDeviceCommands;
end;

class function CoDeviceCommands.CreateRemote(const MachineName: string): IDeviceCommands;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DeviceCommands) as IDeviceCommands;
end;

class function CoItem.Create: IItem;
begin
  Result := CreateComObject(CLASS_Item) as IItem;
end;

class function CoItem.CreateRemote(const MachineName: string): IItem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Item) as IItem;
end;

class function CoItems.Create: IItems;
begin
  Result := CreateComObject(CLASS_Items) as IItems;
end;

class function CoItems.CreateRemote(const MachineName: string): IItems;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Items) as IItems;
end;

class function CoDeviceEvent.Create: IDeviceEvent;
begin
  Result := CreateComObject(CLASS_DeviceEvent) as IDeviceEvent;
end;

class function CoDeviceEvent.CreateRemote(const MachineName: string): IDeviceEvent;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DeviceEvent) as IDeviceEvent;
end;

class function CoDeviceEvents.Create: IDeviceEvents;
begin
  Result := CreateComObject(CLASS_DeviceEvents) as IDeviceEvents;
end;

class function CoDeviceEvents.CreateRemote(const MachineName: string): IDeviceEvents;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DeviceEvents) as IDeviceEvents;
end;

class function CoDeviceInfo.Create: IDeviceInfo;
begin
  Result := CreateComObject(CLASS_DeviceInfo) as IDeviceInfo;
end;

class function CoDeviceInfo.CreateRemote(const MachineName: string): IDeviceInfo;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DeviceInfo) as IDeviceInfo;
end;

class function CoDeviceInfos.Create: IDeviceInfos;
begin
  Result := CreateComObject(CLASS_DeviceInfos) as IDeviceInfos;
end;

class function CoDeviceInfos.CreateRemote(const MachineName: string): IDeviceInfos;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DeviceInfos) as IDeviceInfos;
end;

class function CoDevice.Create: IDevice;
begin
  Result := CreateComObject(CLASS_Device) as IDevice;
end;

class function CoDevice.CreateRemote(const MachineName: string): IDevice;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Device) as IDevice;
end;

class function CoCommonDialog.Create: ICommonDialog;
begin
  Result := CreateComObject(CLASS_CommonDialog) as ICommonDialog;
end;

class function CoCommonDialog.CreateRemote(const MachineName: string): ICommonDialog;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CommonDialog) as ICommonDialog;
end;

class function CoDeviceManager.Create: IDeviceManager;
begin
  Result := CreateComObject(CLASS_DeviceManager) as IDeviceManager;
end;

class function CoDeviceManager.CreateRemote(const MachineName: string): IDeviceManager;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DeviceManager) as IDeviceManager;
end;

end.
