unit Unit1;

interface

uses
  SysUtils, Types, Classes, Variants, Graphics, Controls, Forms,
  Dialogs, StdCtrls, inifiles, MD5alg, ExtCtrls;

type
  TForm1 = class(TForm)
    deldir: TEdit;
    Cherrors: TCheckBox;
    Label1: TLabel;
    protect: TEdit;
    Label2: TLabel;
    Chdels: TCheckBox;
    Chhidden: TCheckBox;
    Edit2: TEdit;
    Label3: TLabel;
    Button2: TButton;
    Chtest: TCheckBox;
    Button1: TButton;
    Timer1: TTimer;
    Excl: TMemo;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CherrorsClick(Sender: TObject);
    procedure ChdelsClick(Sender: TObject);
    procedure ChhiddenClick(Sender: TObject);
    procedure protectChange(Sender: TObject);
    procedure ChtestClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  excludedirs:array of string;
  basedir : string;
  logerrors : boolean;
  logdeletes: boolean;
  hidden    : boolean;
  md5summ: string;

Function smallcode(V:string):string;
Function Upcasestrrus(V:string):string;
Function subinexclude(dir:string):boolean;

implementation

uses Unit2;

{$R *.dfm}
Function Upcasestrrus(V:string):string;
var i:integer;
 begin
  setlength(result,0);
  for i:=1 to length(V) do
   Case byte(V[i]) of
   1..127: result := result + upcase(V[i]);
   $E0..$FF: result := result + chr(byte(V[i])-32);
   $B3: result := result + chr($B2); {Украинские символы}
   $BF: result := result + chr($AF);
   $B4: result := result + chr($A5);
   $B8: result := result + chr($A8) {буква ё}
   ELSE result := result + V[i]
   end;
 end;
Function subinexclude(dir:string):boolean;
var dirbase, cmpr:string;
          i      :integer;
 begin
  result := true;
  dir := upcasestrrus(dir);

  if trim(basedir) = '' then exit;
  if basedir[length(basedir)]<>'\' then dirbase := upcasestrrus(basedir) + '\'
                                   else dirbase := upcasestrrus(basedir);
  if pos(dirbase,dir)=0 then exit;
  result := false;
  for i:=0 to length(excludedirs)-1 do
  begin
   cmpr := dirbase+upcasestrrus(excludedirs[i]);
   if cmpr[length(cmpr)]<>'\' then cmpr := cmpr + '\';
   if dir = cmpr then begin result := true; break; end;
  end;
 end;

Function smallcode(V:string):string;
{string V must be 16x2 HEX chars!}
Var cod: array[0..15] of byte;
    a  : integer;
 begin
  for a := 0 to 15 do
   cod[a] := strtointdef('$'+V[a*2+1]+V[a*2+2],$5A);

  result := inttohex(cod[0]+cod[4]+cod[8] +cod[12],2) +
            inttohex(cod[1]+cod[5]+cod[9] +cod[13],2) +
            inttohex(cod[2]+cod[6]+cod[10]+cod[14],2) +
            inttohex(cod[3]+cod[7]+cod[11]+cod[15],2);
 end;
Function getcmdline : string;
 begin
 result := ExtractFileName(application.ExeName);
 if form1.Chtest.checked then begin result := result + ' -test'; exit end
                         else result := result + ' -id'+ form1.protect.text;
 if logerrors then result := result + ' -le';
 if logdeletes  then result := result + ' -ld';
 if not hidden then result := result + ' -progress';
 end;
procedure TForm1.FormCreate(Sender: TObject);
var a: integer;
 begin
  deldir.Text := basedir;
  protect.Text := smallcode(md5summ);
  edit2.Text := getcmdline;
  cherrors.Checked := logerrors;
  chdels.Checked := logdeletes;
  chhidden.checked := hidden;
  excl.Clear;
  for a:= 0 to length(excludedirs)-1 do
   excl.Lines.Add(excludedirs[a]);
 end;

procedure TForm1.Button2Click(Sender: TObject);
Var inis   : Tinifile;
    a, cnt : integer;
begin
 basedir := deldir.Text;
 if trim(basedir) = '' then
  begin
   application.MessageBox('Недопустимый ввод!'#10#13'Поле ввода не должно быть пустым.','Deldirs');
   exit;
  end;
 a:=1;
 While a <= excl.Lines.Count do
  begin
   excl.lines.Strings[a-1] := trim(excl.lines.Strings[a-1]);
   If excl.lines.Strings[a-1] = '' then
                     excl.lines.Delete(a-1)
                else a:=a+1;
  end;
logerrors  := Cherrors.Checked;
logdeletes := Chdels.Checked;
hidden     := Chhidden.Checked;
 inis := TIniFile.Create(changefileext(application.ExeName,'.ini'));
 try
  inis.WriteString('INCLUDE','BASEDIR',trim(basedir));
  inis.writeBool('MISC','logerrors',logerrors);
  inis.writeBool('MISC','logdeletes',logdeletes);
  inis.writeBool('MISC','hidden',hidden);
  {Save exclusions}
   cnt := excl.Lines.Count;
   inis.writeInteger('EXCLUDE','count',cnt);
   setlength(excludedirs,cnt+1);
   For a:=1 to cnt do
    begin
     excludedirs[a-1] := trim(excl.Lines.strings[a-1]);
     inis.WriteString('EXCLUDE','dir'+inttostr(a),excludedirs[a-1]);
    end;
  {Calculate integrity MD5 hash}
   excludedirs[cnt] := basedir;
   md5summ := getarraymd5(excludedirs);
   setlength(excludedirs,cnt);
   inis.writeString('FINGERPRINT','MD5',md5summ);
   protect.Text := smallcode(md5summ);
   inis.UpdateFile;
 finally
  inis.Destroy;
 end;
end;

procedure TForm1.CherrorsClick(Sender: TObject);
begin
 logerrors := Cherrors.Checked;
 edit2.text := getcmdline;
end;

procedure TForm1.ChdelsClick(Sender: TObject);
begin
 logdeletes := Chdels.Checked;
 edit2.text := getcmdline;
end;

procedure TForm1.ChhiddenClick(Sender: TObject);
begin
 hidden := Chhidden.Checked;
 edit2.text := getcmdline;
end;

procedure TForm1.protectChange(Sender: TObject);
begin
 edit2.text := getcmdline;
end;

procedure TForm1.ChtestClick(Sender: TObject);
begin
 edit2.text := getcmdline;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 Form2.show;
 timer1.Enabled:=true;
end;

VAR selixx: integer;
procedure TForm1.Timer1Timer(Sender: TObject);
const
 mydirs: array [1..5] of string = ('C:\Windows.\system\','C:\Windows.\system32\','C:\WindowsXP\|/system\','C:\WindowsXP64\|/system16\','Z:\Linux\*.*');
begin
 selixx := selixx + 1;
 Form2.dir.text := mydirs[((selixx div 20) mod 5) + 1];
 Form2.Progress.Position := (5*selixx div 6) mod 101;
end;

end.

