program deldirs;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  MD5alg in 'MD5alg.PAS',
  Unit2 in 'Unit2.pas' {Form2},
  inifiles, sysutils;

{$R *.res}
{������� ��� � �����, �������� ����� �� ������
 ������� �����������
> � ��� ����� �������, ������ ����� ��� ������ ������ �����
<sam> �� ������ �������� �������� ����� ���� c:\temp
<sam> � ��� �������� � ���� �����
<sam> � ��� ��������� �����
<sam> �����, ����� �� �����
> �.�. ���� ���������� �� ���������� ...
<sam> ���
<sam> ���� �:\temp
<sam> �:\temp\1
<sam> �:\temp\2
> �� ������ ��������
<sam> �:\temp\3
<sam> ������ ��� ����� 3
> � ��� � �������� ����� ���� ��� �������� ���� ������������� ����� � ������ ...
<sam> ������ ������ ��������� ��� ������ �����
<sam> ��� ����� ���� ���� ��������������
> �� �� ����� ...
<sam> �� � ���� �������� �� ����� ������ ����
> ��� ���� � ������� � 98-� ����� ���������
<sam> ��� ��
<sam> ����� ���������
<sam> � ������� ������
<sam> %)
> �� �����, ��� ��������� ��� �� ����� ������� ;)
> ���.. ��� ��������� ����� ������ ��� ������ ...
<sam> ���� %))
<sam> ���� � ����� ���� ���������
<sam> �� ��� ��
<sam> %))
<sam> ��� �� �����
> �� .. �� ���� :)))
> ����� �� �� ��������� ...
<sam> ���� �������
<sam> ��� ��� ���� ��� �����
> ��� ����� ���������� ������ ���������� � ��������� �����?
<sam> �� �� �������
<sam> ����� ���� �������
> ��, � ��� � �������
> �� ���� � ���-�� �������� ����� ������ �� ���������
<sam> �� �� ��� ������ �����
<sam> %)
<sam> �� ����� ��� ��������
> ������� ���, ������ ����� ������� � ���� CRC � ��� �� �������, � ������������� ��� ����� �����
<sam> ��� ������
> ���� ���� ���������, ������� ����� ������������ � ��������� ������ � ������ �������� � ��������.
<sam> �� ��� ��� ���� �����}
// Options
// -errlog
// -id <ident>
// -showprogress
//
// Options in file
// id
// idcrc
// �������� ��������
// �������� ������
Var inis   : Tinifile;
    a, cnt : integer;
    idcode : string ='';
    normal : boolean = false;
    showsettings : boolean;
    plogerrors   : boolean = false;
    plogdeletes  : boolean = false;
    phidden      : boolean = true;
    testmode     : boolean = false;
{==============  Logging Procedures  ========================}
Var Flerr, Fldel : textfile;
Procedure InitLogs;
 begin
  If plogerrors or testmode then
   begin
    Assignfile(Flerr,changefileext(application.ExeName,'.err'));
    rewrite(Flerr);
    Writeln(Flerr,'������ �������� ',datetostr(now),', ',timetostr(now));
   end;
  If plogdeletes or testmode then
   begin
    Assignfile(Fldel,changefileext(application.ExeName,'.log'));
    rewrite(Fldel);
    Writeln(Fldel,'������ �������� ',datetostr(now),', ',timetostr(now));
    Writeln(Fldel,'������� ��� �������� ',Basedir);
   end;
 end;
Procedure errorLog(msg:string);
 begin
  If not(plogerrors  or testmode) then exit;
  Writeln(Flerr,timetostr(now),': ',msg);
 end;
Procedure deletesLog(msg:string);
 begin
  If not(plogdeletes or testmode) then exit;
  Writeln(Fldel,timetostr(now),': ',msg);
 end;
Procedure FinalizeLogs;
 begin
  If plogdeletes or testmode then closefile(Fldel);
  If plogerrors  or testmode then closefile(Flerr);
 end;
{ ===========================================================}
Function delfile(f:string):integer;
 begin
  deleteslog('�������� ����� '+f);
  //  DeleteFile(const FileName: string): Boolean;
  result := 0;
  if result <> 0 then errorlog('���������� ������� '+f);
 end;
//VAR last: Tdatetime;
Function delsubdirs(sdir:string;pr1,pr2:integer):integer; // sDir = 'z:\bla\bla\bla\'
var sr: TSearchRec;
list: array of string;
listcnt, i, pri1, pri2: integer;
 begin
  result := 0;
  if subinexclude(sdir) then
    begin
     result:=-1;
     deletesLog('������������� '+sdir+' ��������� �� ��������.');
     exit;
    end;
  deleteslog('���������� � �������� '+sdir);
 if trim(sdir) = '' then exit;
  listcnt:=0;
  setlength(list,listcnt);
 if sdir[length(sdir)]<>'\' then sdir := sdir + '\';
 if Findfirst(sdir+'*.*',faAnyFile,sr) = 0 then
   begin
   While Findnext(sr) = 0 do
    begin
    if sr.name = '..' then continue;
     if (sr.Attr and fadirectory) <> 0 then
      begin
       inc(listcnt); //Collecting DIR Names
       setlength(list,listcnt);
       list[listcnt-1]:=sdir+sr.name+'\';
      end
     else
      begin
       if delfile(sdir+sr.name) <> 0 then result := -1;
      end;
    end;
   end;
 findclose(sr);
 For i:=0 to listcnt - 1 do
  begin
  If pr1 = pr2 then
   begin
    pri1:=pr1;
    pri2:=pr1;
   end
   else
   begin
    pri1 := pr1 + ((pr2-pr1)*i) div listcnt;
    pri2 := pr1 + ((pr2-pr1)*(i+1)) div listcnt;
   end;
   if delsubdirs(list[i],pri1,pri2) = 0 then
      begin
      {Delete empty directory}
       deleteslog('�������� ������ ����� '+list[i]);
      {logerrors('�� ������� ������� ����� '+list[i])}
      end
     else result := -1;
   if not phidden then {Form2 is Created!}
       begin
        Form2.dir.Text:=list[i];
        Form2.Progress.Position := pri2;
//         last:=now; {4E-6 ~ 1/3 sec}
//         While Now < (last + 4E-6) do  {Delay!}
        application.ProcessMessages;
       end;
  end;
 setlength(list,0);
 if result <>0 then deleteslog('�������� '+sdir+' �� ������������ �.�. ������� �� ����.');
 end;
{ =================== MAIN PROCEDURE ========================================}

Procedure InitiateDeleting;
Var dirtodel : string;
sr: TSearchRec;
list: array of string;
listcnt, i: integer;
begin
dirtodel := basedir;
listcnt:=0;
setlength(list,listcnt);
if trim(dirtodel) = '' then exit;
 if dirtodel[length(dirtodel)]<>'\' then dirtodel := dirtodel + '\';
 if Findfirst(dirtodel+'*.*',faAnyFile,sr) = 0 then
   begin
  While Findnext(sr) = 0 do
    begin
     if sr.name = '..' then continue;
     if (sr.Attr and fadirectory) <> 0 then
      begin
       inc(listcnt); //Collecting DIR Names
       setlength(list,listcnt);
       list[listcnt-1]:=dirtodel+sr.Name+'\';
      end
     else
      if (sr.Attr and not faanyfile) = 0 then
      delfile(dirtodel+sr.Name);
    end;
   end;
 findclose(sr);
 {Post deleting SUBDIRS from list}
 For i:=0 to listcnt - 1 do
 begin
  if delsubdirs(list[i],(100*(i)) div listcnt,(100*(i+1)) div listcnt) = 0 then
      begin
       {Delete empty directory}
       deleteslog('�������� ������ ����� '+list[i]);
      end;
  if not phidden then {Form2 is Created!}
   begin
    Form2.dir.Text:=list[i];
    Form2.Progress.Position := (100*(i+1)) div listcnt;
//     last:=now; {4E-6 ~ 1/3 sec}
//     While Now < (last + 8E-6) do  {Delay!}
     application.ProcessMessages;
   end;
 end;
 setlength(list,0);
end;

begin
Application.Initialize;
If paramcount = 0 then begin showsettings := true; Phidden := false; end
                  else showsettings := false;

for a := 1 to ParamCount do
  begin
    if LowerCase(copy(ParamStr(a),1,3)) = '-id' then
       idcode := copy(ParamStr(a),4,12)
     else
    if LowerCase(ParamStr(a)) = '-le' then
       plogerrors := true
     else
    if LowerCase(ParamStr(a)) = '-test' then
       testmode := true
     else
    if LowerCase(ParamStr(a)) = '-ld' then
       plogdeletes := true
     else
    if LowerCase(ParamStr(a)) = '-progress' then
       phidden := false;
  end;

 inis := TIniFile.Create(changefileext(application.ExeName,'.ini'));
 try
  basedir := trim(inis.ReadString('INCLUDE','BASEDIR',''));
  if basedir = '' then showsettings := true;
  logerrors := inis.ReadBool('MISC','logerrors',false);
  logdeletes:= inis.ReadBool('MISC','logdeletes',false);
  hidden    := inis.ReadBool('MISC','hidden',false);
  {Read exclusions}
   cnt := inis.ReadInteger('EXCLUDE','count',0);
   setlength(excludedirs,cnt+1);
   For a:=1 to cnt do
    excludedirs[a-1] := inis.ReadString('EXCLUDE','dir'+inttostr(a),'');
   {Check integrity}
   excludedirs[cnt] := basedir;
   md5summ := getarraymd5(excludedirs);
   setlength(excludedirs,cnt);
   normal := inis.ReadString('FINGERPRINT','MD5','') = md5summ;
 finally
  inis.Destroy;
 end;
 if not normal then application.MessageBox('��������� �������� ��� �����������.','DelDirs');
 if showsettings then
  begin
   Application.CreateForm(TForm1, Form1);
   Application.CreateForm(TForm2, Form2);
   form1.show;
   Application.Run;{���� ���������� ��������}
  {������� ���� � �����������}
  end
  ELSE
  begin
// ��������� ����������, ��������� ��� ���������� ����������.
 if (idcode <> '') and (idcode <> smallcode(md5summ)) then
   begin
    application.MessageBox('�������� �������� ���.','DelDirs');
    exit; {����� �� ���������}
   end;
{���������� ������ ���������}
 if not phidden then {���� ��������� ����� - ���������� ����� ���������}
  begin
   Application.CreateForm(TForm2, Form2);
   Form2.dir.Text:='My Dir!';
   Form2.Show;
   application.ProcessMessages;
  end;
 initlogs; {������ ������� �����, ���� �����}
 InitiateDeleting;
//  application.MessageBox('����� ������ ���� ������� �������.','DelDirs');
 finalizelogs {����� ������� ����� ���� ��� ���� �������};
 end;

end.
