unit ddDiff;

interface

type
  IDiffSource=interface
    function LineData(Index:integer):UTF8String;
    function Count:integer;
  end;

  IDiffOutput=interface
    //procedure SetTotalDiffLines?
    procedure RenderLines(const Sources:array of IDiffSource;
      const Indexes:array of integer;Count:integer);
  end;

procedure PerformDiff(const Sources:array of IDiffSource;Output:IDiffOutput);

implementation

procedure PerformDiff(const Sources:array of IDiffSource;Output:IDiffOutput);
const
  qGrowStep=$10;
type
  tkk=record
    f,fk,fx,fy,b,bk,bx,by:integer;
  end;
  pkk=^tkk;
var
  i,j,k,l,lx,dc,EqLinesHead,EqLinesTail:integer;
  ok:boolean;
  s:Utf8String;
  q:array of integer;
  qi,qx,ql,qStart,qStride,qNext,di,dj,
  aa,ax,ay,bb,bx,by,cx,cy,dx,dy:integer;
  kkk:array of tkk;
  kk:pkk;
  ff,fl:array of integer;
  function kx(ii:integer):pkk; //inline
  begin
    if ii<0 then
      Result:=@kkk[(-ii)*2-1]
    else
      Result:=@kkk[ii*2]
  end;
begin
  dc:=Length(Sources);
  //assert dc>1

  EqLinesHead:=0;
  ok:=true;
  while ok do
   begin
    if EqLinesHead<Sources[0].Count then
     begin
      s:=Sources[0].LineData(EqLinesHead);
      i:=1;
      while (i<>dc) and (EqLinesHead<Sources[i].Count) and
        (Sources[i].LineData(EqLinesHead)=s) do inc(i);
      if i=dc then inc(EqLinesHead) else ok:=false;
     end
    else
      ok:=false;
   end;

  EqLinesTail:=0;
  ok:=true;
  while ok do
   begin
    if EqLinesHead+EqLinesTail<Sources[0].Count then
     begin
      s:=Sources[0].LineData(Sources[0].Count-EqLinesTail-1);
      i:=1;
      while (i<>dc) and (EqLinesHead+EqLinesTail<Sources[i].Count) and
        (Sources[i].LineData(Sources[i].Count-EqLinesTail-1)=s) do inc(i);
      if i=dc then inc(EqLinesTail) else ok:=false;
     end
    else
      ok:=false;
   end;

  //TODO: generate hashes?

  qNext:=dc*2;
  qStride:=qNext+1;
  ql:=qGrowStep*qStride;
  SetLength(q,ql);
  qStart:=qStride;
  qi:=qStride;
  qx:=qStride*2;
  aa:=0;
  for i:=0 to dc-1 do
   begin
    j:=Sources[i].Count-EqLinesTail;
    l:=j-EqLinesHead;
    if l>aa then aa:=l;
    q[i*2  ]:=j;//closing entry past last line
    q[i*2+1]:=j+EqLinesTail;
    q[qi+i*2  ]:=EqLinesHead;//start
    q[qi+i*2+1]:=j;
   end;
  q[qNext]:=-1;//closing entry
  q[qi+qNext]:=0;//start entry
  SetLength(kkk,aa*2+5);
  SetLength(ff,dc*2);

  while qi<>qx do
   begin
    //split
    ff[0]:=q[qi];
    ff[1]:=q[qi+1];
    di:=0;
    dj:=1;
    while dj<>dc do
     begin
      cx:=ff[di*2];
      cy:=ff[di*2+1];
      if cx=-1 then
       begin
        cx:=q[qi+di*2];
        cy:=q[qi+di*2+1];
       end;
      dx:=q[qi+dj*2];
      dy:=q[qi+dj*2+1];
      ax:=cy-cx;
      bx:=dy-dx;
      if ax>bx then l:=ax else l:=bx; //assert l<Length(kkk)
      ay:=0;//counter warning
      by:=0;//counter warning

      //trick: on grand dissimmilar length, widen start search diagonals
      //  in an attempt to find common center subsequence near middle faster
      
      i:=((dy-dx)-(cy-cx)+1) div 2;
      if i<cy-cx then i:=0;
      for k:=-i to i do
       begin
        kk:=kx(k);
        j:=cx-1; kk.f:=j; kk.fk:=k; kk.fx:=j; kk.fy:=j;
        j:=cy  ; kk.b:=j; kk.bk:=k; kk.bx:=j; kk.by:=j;
       end;
      k:=i+2;
      while i<>l do
       begin
        kk:=kx(-i-1);
        j:=cx-1; kk.f:=j; kk.fk:=k; kk.fx:=j; kk.fy:=j;
        j:=cy  ; kk.b:=j; kk.bk:=k; kk.bx:=j; kk.by:=j;
        kk:=kx(i+1);
        j:=cx-1; kk.f:=j; kk.fk:=k; kk.fx:=j; kk.fy:=j;
        j:=cy  ; kk.b:=j; kk.bk:=k; kk.bx:=j; kk.by:=j;
        k:=-i;
        while (i<>l) and (k<=i) do
         begin
          kk:=kx(k);
          //forward
          if true then
           begin
            aa:=kx(k+1).f;
            ax:=kx(k-1).f+1;
            if aa<ax then
             begin
              aa:=ax;
              kk.fk:=kx(k-1).fk;
              kk.fx:=kx(k-1).fx;
              kk.fy:=kx(k-1).fy;
             end
            else
             begin
              ax:=aa;
              kk.fk:=kx(k+1).fk;
              kk.fx:=kx(k+1).fx;
              kk.fy:=kx(k+1).fy;
             end;
            bb:=q[qi+di*2]-dx+k;//bb:=cx-dx+k;
            bx:=ax-bb;
            if (ax>=cx) and (bx>=dx) then
             begin
              ay:=cy;
              by:=dy;
              while (ax<ay) and (bx<by) and
                //(FData[di].FContent[ax].Hash=FData[dj].FContent[bx].Hash) do
                (Sources[di].LineData(ax)=Sources[dj].LineData(bx)) do
               begin
                inc(ax);
                inc(bx);
               end;
             end;
            kk.f:=ax;
            if (aa<>ax) and (ax-aa>=kk.fy-kk.fx) then
             begin
              kk.fk:=k;
              kk.fx:=aa;
              kk.fy:=ax;
             end;
           end;
          //backward
          if i<>l then
           begin
            aa:=kx(k-1).b;
            ax:=kx(k+1).b-1;
            if aa>ax then
             begin
              aa:=ax;
              kk.bk:=kx(k+1).bk;
              kk.bx:=kx(k+1).bx;
              kk.by:=kx(k+1).by;
             end
            else
             begin
              ax:=aa;
              kk.bk:=kx(k-1).bk;
              kk.bx:=kx(k-1).bx;
              kk.by:=kx(k-1).by;
             end;
            bb:=q[qi+di*2+1]-dy+k;//bb:=cy-dy+k;
            bx:=ax-bb;
            if (ax<cy) and (bx<dy) then
             begin
              ay:=cx;
              by:=dx;
              while (ax>=ay) and (bx>=by) and
                //(FData[di].FContent[ax].Hash=FData[dj].FContent[bx].Hash) do
                (Sources[di].LineData(ax)=Sources[dj].LineData(bx)) do
               begin
                dec(ax);
                dec(bx);
               end;
             end;
            kk.b:=ax;
            if (aa<>ax) and (aa-ax>kk.by-kk.bx) then
             begin
              kk.bk:=k;
              kk.bx:=ax;
              kk.by:=aa;
             end;
           end;
          //meet in the middle?
          if (kk.f>=kk.b) then
            if (kk.fx<>kk.fy) and (kk.fy-kk.fx>=kk.by-kk.bx) then
             begin
              i:=l;
              bb:=q[qi+di*2]-dx+kk.fk;
              ax:=kk.fx;
              ay:=kk.fy;
              bx:=ax-bb;
              by:=ay-bb;
             end
            else
            if kk.bx<>kk.by then
             begin
              i:=l;
              bb:=q[qi+di*2+1]-dy+kk.bk;
              ax:=kk.bx+1;
              ay:=kk.by+1;
              bx:=ax-bb;
              by:=ay-bb;
             end;
          //next
          if i<>l then inc(k,2);
         end;
        if i<>l then inc(i);
       end;
      //next source
      if k>i then
       begin
        ff[dj*2  ]:=-1;
        ff[dj*2+1]:=-1;

        inc(di);
        if di=dj then
         begin
          di:=0;
          inc(dj);
         end;
       end
      else
       begin
        //assert ay-ax=by-bx
        if (ax<>cx) or (ay<>cy) then
          for j:=0 to dj-1 do
            if ff[j*2]<>ff[j*2+1] then
             begin
              inc(ff[j*2  ],ax-cx);
              dec(ff[j*2+1],cy-ay);
             end;
        ff[dj*2  ]:=bx;
        ff[dj*2+1]:=by;
        inc(dj);
       end;
     end;

    //update fragment stack
    //if (k>i) or (ff[0]=ff[1]) then
    k:=0;
    for i:=0 to dc-1 do if ff[i*2]<ff[i*2+1] then inc(k);
    if k<2 then
     begin
      //nothing found, skip (and invalidate for below)
      for i:=0 to dc-1 do q[qi+i*2+1]:=q[qi+i*2];
      inc(qi,qStride);
     end
    else
     begin
      //top fragment
      //if (ax>q[qi]) and (bx>q[qj]) then
      i:=0;
      while (i<>dc) and ((ff[i*2]=ff[i*2+1]) or (ff[i*2]=q[qi+i*2])) do inc(i);
      if i<>dc then
       begin
        if qx=ql then
         begin
          inc(ql,qGrowStep*qStride);
          SetLength(q,ql);
         end;
        for i:=0 to dc-1 do
         begin
          q[qx+i*2  ]:=q[qi+i*2];
          if ff[i*2]=-1 then
            q[qx+i*2+1]:=q[qi+i*2+1]
          else
            q[qx+i*2+1]:=ff[i*2];
         end;
        if qStart=qi then
          qStart:=qx
        else
         begin
           i:=qStride;
           while (i<>qx) and (q[i+qNext]<>qi) do inc(i,qStride);
           q[i+qNext]:=qx;
         end;
        q[qx+qNext]:=qi;
        inc(qx,qStride);
       end;
      //bottom fragment
      //if (ay<q[qi+1]) and (by<q[qj+1]) then
      i:=0;
      while (i<>dc) and ((ff[i*2]=ff[i*2+1]) or (ff[i*2+1]=q[qi+i*2+1])) do inc(i);
      if i<>dc then
       begin
        if qx=ql then
         begin
          inc(ql,qGrowStep*qStride);
          SetLength(q,ql);
         end;
        for i:=0 to dc-1 do
         begin
          if ff[i*2+1]=-1 then
            q[qx+i*2]:=q[qi+i*2]
          else
            q[qx+i*2]:=ff[i*2+1];
          q[qx+i*2+1]:=q[qi+i*2+1];
         end;
        q[qx+qNext]:=q[qi+qNext];
        q[qi+qNext]:=qx;
        inc(qx,qStride);
       end;
      //equal part
      for i:=0 to dc-1 do
       begin
        q[qi+i*2  ]:=ff[i*2  ];
        q[qi+i*2+1]:=ff[i*2+1];
       end;
      //q[qi+qNext]:=//see above
      inc(qi,qStride);
     end;
   end;

  SetLength(kkk,0);
  //SetLength(ff,dc);
  SetLength(fl,dc);

  if EqLinesHead<>0 then
   begin
    for i:=0 to dc-1 do fl[i]:=0;
    Output.RenderLines(Sources,fl,EqLinesHead);
   end;
  for i:=0 to dc-1 do ff[i]:=EqLinesHead;

  qi:=qStart;
  while qi<>-1 do
   begin
{
    //check vector
    for i:=0 to dc-1 do
      if (ff[i]>q[qi+i*2]) and (q[qi+i*2]<>q[qi+i*2+1]) then
       begin
        aa:=ff[i]-q[qi+i*2];
        for j:=0 to dc-1 do inc(q[qi+j*2],aa);
       end;
}
    //unequal part
    for i:=0 to dc-1 do
     begin
      aa:=q[qi+i*2];
      if {(aa<>q[qi+i*2+1]) and }(ff[i]<aa) then
       begin
        for j:=0 to dc-1 do fl[j]:=-1;
        fl[i]:=ff[i];
        Output.RenderLines(Sources,fl,aa-ff[i]);
        ff[i]:=aa;
       end;
     end;
    //equal part
    aa:=0;
    bb:=0;
    for i:=0 to dc-1 do
     begin
      j:=q[qi+i*2+1]-q[qi+i*2];
      if j<>0 then
       begin
        aa:=aa or (1 shl i);
        bb:=j;
       end;
     end;
    if aa<>0 then
     begin
      for i:=0 to dc-1 do
        if (aa and (1 shl i))=0 then
          fl[i]:=-1
        else
         begin
          fl[i]:=ff[i];
          inc(ff[i],bb);
         end;
      Output.RenderLines(Sources,fl,bb);
     end;
    //next
    qi:=q[qi+qNext];
   end;
{
  //tail //(replaced by q[0] above)
  if EqLinesTail<>0 then
}
end;

end.
