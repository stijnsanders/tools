unit ddXmlTools;

interface

uses MSXML2_TLB, ddData, ddDiff, ComCtrls;

type
  TDiffXmlInfo=class(TObject)
  public
    IsDir:boolean;
    NodeType:DOMNodeType;
    Match:string;
    Info:array of record
      Node:IXMLDOMNode;
    end;
    constructor Create(SetSize:integer);
    function GetIconIndex:integer;
  end;

  IDiffXmlSource=interface(IUnknown)
  ['{BF76FF87-F2B7-4B15-9B7B-C1AC2D9D8A27}']
    function LineDisplay(Index:integer):string;
    function LineNode(Index:integer):IXMLDOMNode;
  end;

  TDiffNodeSource1=class(TInterfacedObject,IDiffSource,IDiffXmlSource)
  private
    FSet:TDiffSet;
    FList:IXMLDOMNamedNodeMap;
  protected
    function LineData(Index:integer):UTF8String;
    function LineDisplay(Index:integer):string;
    function LineNode(Index:integer):IXMLDOMNode;
    function Count:integer;
  public
    constructor Create(DiffSet:TDiffSet;Node:IXMLDOMNode);
    destructor Destroy; override;
  end;

  TDiffNodeSource2=class(TInterfacedObject,IDiffSource,IDiffXmlSource)
  private
    FSet:TDiffSet;
    FList:IXMLDOMNodeList;
  protected
    function LineData(Index:integer):UTF8String;
    function LineDisplay(Index:integer):string;
    function LineNode(Index:integer):IXMLDOMNode;
    function Count:integer;
  public
    constructor Create(DiffSet:TDiffSet;Node:IXMLDOMNode);
    destructor Destroy; override;
  end;

  TDiffNodeLister=class(TInterfacedObject,IDiffOutput)
  private
    FNodes:TTreeNodes;
    FNode:TTreeNode;
  protected
    procedure RenderLines(const Sources:array of IDiffSource;
      const Indexes:array of integer;Count:integer);
  public
    constructor Create(Nodes:TTreeNodes;Node:TTreeNode);
  end;

implementation

uses SysUtils;

{ TDiffXmlInfo }

constructor TDiffXmlInfo.Create(SetSize: integer);
var
  i:integer;
begin
  inherited Create;
  SetLength(Info,SetSize);
  for i:=0 to SetSize-1 do Info[i].Node:=nil;
  Match:='';
  NodeType:=NODE_INVALID;
end;

function TDiffXmlInfo.GetIconIndex: integer;
var
  i:integer;
begin
  if NodeType=NODE_INVALID then
   begin
    i:=0;
    while (i<>Length(Info)) and (Info[i].Node=nil) do inc(i);
    if i<>Length(Info) then NodeType:=Info[i].Node.nodeType;
   end;
  case NodeType of
    NODE_ELEMENT:
      Result:=iiXmlNone;
    NODE_ATTRIBUTE:
      Result:=iiAttNone;
    NODE_TEXT,
    NODE_CDATA_SECTION,
    NODE_ENTITY_REFERENCE,
    NODE_ENTITY,
    NODE_PROCESSING_INSTRUCTION,
    NODE_COMMENT:
      Result:=iiItemNone;
    else
      Result:=iiXmlNone;
  end;
  if Info[0].Node<>nil then
    if Info[1].Node<>nil then
     begin
      //TODO: proper walking down!
      if Info[0].Node.xml=Info[1].Node.xml then
        inc(Result,3)//equal
      else
        inc(Result,4);//unequal
     end
    else
      inc(Result,1)//only left
  else
    if Info[1].Node<>nil then
      inc(Result,2);//only right
end;

{ TDiffNodeSource1 }

constructor TDiffNodeSource1.Create(DiffSet:TDiffSet;Node:IXMLDOMNode);
begin
  inherited Create;
  FSet:=DiffSet;
  if Node=nil then FList:=nil else FList:=Node.attributes;
end;

destructor TDiffNodeSource1.Destroy;
begin
  FList:=nil;
  inherited;
end;

function TDiffNodeSource1.Count: integer;
begin
  if FList=nil then Result:=0 else Result:=FList.length;
end;

function TDiffNodeSource1.LineData(Index: integer): UTF8String;
begin
  if FList=nil then Result:='' else
    Result:=FSet.XmlMatch(FList.item[Index]);
end;

function TDiffNodeSource1.LineDisplay(Index: integer): string;
begin
  if FList=nil then Result:='' else
    Result:=FSet.XmlDisplay(FList.item[Index]);
end;

function TDiffNodeSource1.LineNode(Index: integer): IXMLDOMNode;
begin
  if FList=nil then Result:=nil else
    Result:=FList.item[Index];
end;

{ TDiffNodeSource2 }

constructor TDiffNodeSource2.Create(DiffSet:TDiffSet;Node:IXMLDOMNode);
begin
  inherited Create;
  FSet:=DiffSet;
  if Node=nil then Flist:=nil else FList:=Node.childNodes;
end;

destructor TDiffNodeSource2.Destroy;
begin
  FList:=nil;
  inherited;
end;

function TDiffNodeSource2.Count: integer;
begin
  if FList=nil then Result:=0 else Result:=FList.length;
end;

function TDiffNodeSource2.LineData(Index: integer): UTF8String;
begin
  if FList=nil then Result:='' else
    Result:=FSet.XmlMatch(FList.item[Index]);
end;

function TDiffNodeSource2.LineDisplay(Index: integer): string;
begin
  if FList=nil then Result:='' else
    Result:=FSet.XmlDisplay(FList.item[Index]);
end;

function TDiffNodeSource2.LineNode(Index: integer): IXMLDOMNode;
begin
  if FList=nil then Result:=nil else
    Result:=FList.item[Index];
end;

{ TDiffNodeLister }

constructor TDiffNodeLister.Create(Nodes:TTreeNodes;Node:TTreeNode);
begin
  inherited Create;
  FNodes:=Nodes;
  FNode:=Node;
end;

procedure TDiffNodeLister.RenderLines(const Sources: array of IDiffSource;
  const Indexes: array of integer; Count: integer);
var
  n:TTreeNode;
  d:TDiffXmlInfo;
  i,j,dc:integer;
  s:string;
  ss:array of IDiffXmlSource;
  x:IXMLDOMNode;
  hc:boolean;
begin
  dc:=Length(Sources);
  SetLength(ss,dc);
  for i:=0 to dc-1 do
    if Sources[i].QueryInterface(IDiffXmlSource,ss[i])<>S_OK then
      RaiseLastOSError;
  for j:=0 to Count-1 do
   begin
    i:=0;
    while (i<>dc) and (Indexes[i]=-1) do inc(i);
    if i=dc then s:='' else
      s:=(Sources[i] as IDiffXmlSource).LineDisplay(Indexes[i]+j);
    n:=FNodes.AddChild(FNode,s);
    d:=TDiffXmlInfo.Create(dc);
    n.Data:=d;
    hc:=false;
    for i:=0 to dc-1 do
      if Indexes[i]=-1 then d.Info[i].Node:=nil else
       begin
        x:=(Sources[i] as IDiffXmlSource).LineNode(Indexes[i]+j);
        d.Info[i].Node:=x;
        hc:=hc or ((x.childNodes.length<>0)
          or ((x.attributes<>nil) and (x.attributes.length<>0)));
       end;
    i:=d.GetIconIndex;
    n.ImageIndex:=i;
    n.SelectedIndex:=i;
    n.HasChildren:=hc;
   end;
  for i:=0 to dc-1 do ss[i]:=nil;
end;

end.
