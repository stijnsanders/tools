unit ddDict;

interface

{$D-}
{$L-}

type
  TStringDictionaryNodeData=record
    //dictionary data
    Next,Index,Length,Count:cardinal;
  end;
  PStringDictionaryNodeData=^TStringDictionaryNodeData;

  TStringDictionary=class(TObject)
  private
    FNodes:array of TStringDictionaryNodeData;
    FStrings:array of UTF8String;
    FNodesSize,FNodesIndex,FStringsSize,FStringsIndex:cardinal;
    function GetStr(Idx:cardinal):UTF8String;
    function AddString(const x:UTF8String):cardinal;
  public
    constructor Create;
    destructor Destroy; override;
    function StrIdx(const x:UTF8String):cardinal;//int64?
  end;

implementation

const
  StringDictionaryNodesGrowSize=$100;
  StringDictionaryStringsGrowSize=$400;

{ TStringDictionary }

constructor TStringDictionary.Create;
begin
  inherited Create;
  FNodesSize:=StringDictionaryNodesGrowSize;
  FNodesIndex:=1;
  SetLength(FNodes,FNodesSize shl 8);
  FStringsSize:=StringDictionaryStringsGrowSize;
  FStringsIndex:=1;
  SetLength(FStrings,FStringsSize);
  //ZeroMemory(@FNodes[0]...
end;

destructor TStringDictionary.Destroy;
begin
  SetLength(FNodes,0);
  inherited;
end;

function TStringDictionary.StrIdx(const x: Utf8String): cardinal;
var
  i,l,p:cardinal;
  n,m:PStringDictionaryNodeData;
  y:UTF8String;
begin
  l:=Length(x)+1;//assert xx:UTF8String :: xx[Length(xx)+1]=#0
  if l=1 then Result:=0 else
   begin
    i:=1;
    p:={0 or }byte(x[i]);
    n:=@FNodes[p];
    Result:=0;
    while Result=0 do
      if n.Index=0 then
       begin
        //add
        n.Index:=AddString(x);
        n.Length:=l;
        Result:=n.Index;
       end
      else
       begin
        y:=FStrings[n.Index];//assert reference-counted strings
        while (i<>l) and (i<>n.Length) and (x[i]=y[i]) do inc(i);
        if (i=l) and (i=n.Length) then
          if x[i]=y[i] then
           begin
            //inc(n.Count);
            Result:=n.Index;
           end
          else
           begin
            //store on node
            n.Index:=AddString(x);
            //n.Length:=//already l since (i=l) and (i=n.Length)
            Result:=n.Index;
           end
        else
        if (i=n.Length) and (n.Next<>0) then
         begin
          p:=(n.Next shl 8) or byte(x[i]);
          n:=@FNodes[p];
         end
        else
         begin
          //split
          if FNodesIndex=FNodesSize then //grow
           begin
            inc(FNodesSize,StringDictionaryNodesGrowSize);
            SetLength(FNodes,FNodesSize shl 8);
            //ZeroMemory(?
            n:=@FNodes[p];//restore pointer n
           end;
          p:=(FNodesIndex shl 8) or byte(y[i]);
          m:=@FNodes[p];
          m.Next:=n.Next;
          m.Index:=n.Index;
          m.Length:=n.Length;
          m:=@FNodes[p or byte(x[i])];
          m.Index:=AddString(x);
          m.Length:=l;
          if l<n.Length then n.Index:=m.Index;
          n.Next:=FNodesIndex;
          n.Length:=i;
          inc(FNodesIndex);
          Result:=m.Index;
         end;
       end;
   end;
end;

function TStringDictionary.GetStr(Idx: cardinal): UTF8String;
begin
  if Idx>FStringsIndex then
    Result:='' //raise?
  else
    Result:=FStrings[Idx];
end;

function TStringDictionary.AddString(const x: UTF8String): cardinal;
begin
  if FStringsIndex=FStringsSize then //grow
   begin
    inc(FStringsSize,StringDictionaryStringsGrowSize);
    SetLength(FStrings,FStringsSize);
   end;
  FStrings[FStringsIndex]:=x;
  Result:=FStringsIndex;
  inc(FStringsIndex);
end;

end.
