unit Unit2;

interface

uses
  SysUtils, Types, Classes, Variants, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    dir: TEdit;
    Progress: TProgressBar;
    Bevel1: TBevel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormShow(Sender: TObject);
begin
bevel1.Width := label1.Width;

end;

end.

