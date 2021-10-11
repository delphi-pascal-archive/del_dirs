program deldirs;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  MD5alg in 'MD5alg.PAS',
  Unit2 in 'Unit2.pas' {Form2},
  inifiles, sysutils;

{$R *.res}
{удалять все в папке, исключая папки по списку
 включая подкаталоги
> а как папки задаешь, полным путем или только именем папки
<sam> ну скажем задается верхнаяя папка типа c:\temp
<sam> и что оставить в этой папке
<sam> а все остальное нафик
<sam> файлы, папки не важна
> т.е. если оставляешь то оставляешь ...
<sam> ага
<sam> типа с:\temp
<sam> с:\temp\1
<sam> с:\temp\2
> ну ващета несложно
<sam> с:\temp\3
<sam> удаляю все кроме 3
> а еще ж проблемы могут быть при удалении типа блокированных папок и файлов ...
<sam> прожка пбудет запускать при старте винды
<sam> там точно нету ничо блокированного
> ну не скажи ...
<sam> ну в этом каталоге де будет килять нету
> это если с батника в 98-й винде запускать
<sam> под ХП
<sam> будет запускать
<sam> с правами админа
<sam> %)
> ну ладна, это останется уже на твоей совести ;)
> ухх.. как поудаляет такая прожка все подряд ...
<sam> отож %))
<sam> тока ж якось нада проверить
<sam> на чом то
<sam> %))
<sam> или на комто
> да .. на себе :)))
> лучше уж на виртуалке ...
<sam> тоже вариант
<sam> как раз есть под винду
> как будет задаваться список исключений и начальная папка?
<sam> ну як удобней
<sam> давай типа конфига
> да, я так и подумал
> но надо ж как-то защитить такой конфиг от изменений
<sam> ну то вже силами винды
<sam> %)
<sam> на скока это возможно
> значить вот, защиту можно сделать в виде CRC в том же конфиге, а редактировать его через прогу
<sam> тож карашо
> плюс типа пассворда, который будет передаваться в командную строку и должен совпасть с конфигом.
<sam> ну это вже ваще будет}
// Options
// -errlog
// -id <ident>
// -showprogress
//
// Options in file
// id
// idcrc
// протокол удалений
// протокол ошибок
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
    Writeln(Flerr,'Запуск удаления ',datetostr(now),', ',timetostr(now));
   end;
  If plogdeletes or testmode then
   begin
    Assignfile(Fldel,changefileext(application.ExeName,'.log'));
    rewrite(Fldel);
    Writeln(Fldel,'Запуск удаления ',datetostr(now),', ',timetostr(now));
    Writeln(Fldel,'Каталог для удаления ',Basedir);
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
  deleteslog('Удаление файла '+f);
  //  DeleteFile(const FileName: string): Boolean;
  result := 0;
  if result <> 0 then errorlog('Невозможно удалить '+f);
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
     deletesLog('Поддиректория '+sdir+' исключена из удаления.');
     exit;
    end;
  deleteslog('Подготовка к удалению '+sdir);
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
       deleteslog('Удаление пустой папки '+list[i]);
      {logerrors('Не удается удалить папку '+list[i])}
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
 if result <>0 then deleteslog('Удаление '+sdir+' не производится т.к. каталог не пуст.');
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
       deleteslog('Удаление пустой папки '+list[i]);
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
 if not normal then application.MessageBox('Настройки нарушены или отсутствуют.','DelDirs');
 if showsettings then
  begin
   Application.CreateForm(TForm1, Form1);
   Application.CreateForm(TForm2, Form2);
   form1.show;
   Application.Run;{Даем приложению работать}
  {открыть окно с настройками}
  end
  ELSE
  begin
// Настройки нормальные, проверяем код переданный приложению.
 if (idcode <> '') and (idcode <> smallcode(md5summ)) then
   begin
    application.MessageBox('Неверный защитный код.','DelDirs');
    exit; {Выход из программы}
   end;
{Нормальная работа программы}
 if not phidden then {Если нескрытый режим - показываем форму прогресса}
  begin
   Application.CreateForm(TForm2, Form2);
   Form2.dir.Text:='My Dir!';
   Form2.Show;
   application.ProcessMessages;
  end;
 initlogs; {Начало ведения логов, если нужно}
 InitiateDeleting;
//  application.MessageBox('Здесь должен быть рабочий процесс.','DelDirs');
 finalizelogs {Конец ведения логов если они были открыты};
 end;

end.
