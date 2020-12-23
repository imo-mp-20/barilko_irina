unit frmAboutUnit;

{$mode objfpc} {$H+}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls;

type

  { TfrmAbout }

  TfrmAbout = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    PageControl: TPageControl;
    tsAbout: TTabSheet;
    ImageAbout: TImage;
    Label8: TLabel;
    Label10: TLabel;
    Bevel2: TBevel;
    Label13: TLabel;
    Label12: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.lfm}

procedure TfrmAbout.FormCreate(Sender: TObject);
// При создании формы
begin
  ImageAbout.Picture.Icon := Application.Icon;
end;

procedure TfrmAbout.PageControlChange(Sender: TObject);
begin
  Caption := 'Раскрой - ' + PageControl.ActivePage.Caption;
end;

procedure TfrmAbout.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Close;
end;

end.
