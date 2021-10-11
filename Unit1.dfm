object Form1: TForm1
  Left = 215
  Top = 120
  HorzScrollBar.Visible = False
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'DelDirs'
  ClientHeight = 250
  ClientWidth = 714
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00CCC0
    000CCCC0000000000CCCC7777CCCCCCC0000CCCC00000000CCCC7777CCCCCCCC
    C0000CCCCCCCCCCCCCC7777CCCCC0CCCCC0000CCCCCCCCCCCC7777CCCCC700CC
    C00CCCC0000000000CCCC77CCC77000C0000CCCC00000000CCCC7777C7770000
    00000CCCC000000CCCC777777777C000C00000CCCC0000CCCC77777C777CCC00
    CC00000CCCCCCCCCC77777CC77CCCCC0CCC000CCCCC00CCCCC777CCC7CCCCCCC
    CCCC0CCCCCCCCCCCCCC7CCCCCCCCCCCC0CCCCCCCCCCCCCCCCCCCCCC7CCC70CCC
    00CCCCCCCC0CC0CCCCCCCC77CC7700CC000CCCCCC000000CCCCCC777CC7700CC
    0000CCCC00000000CCCC7777CC7700CC0000C0CCC000000CCC7C7777CC7700CC
    0000C0CCC000000CCC7C7777CC7700CC0000CCCC00000000CCCC7777CC7700CC
    000CCCCCC000000CCCCCC777CC7700CC00CCCCCCCC0CC0CCCCCCCC77CC770CCC
    0CCCCCCCCCCCCCCCCCCCCCC7CCC7CCCCCCCC0CCCCCCCCCCCCCC7CCCCCCCCCCC0
    CCC000CCCCC00CCCCC777CCC7CCCCC00CC00000CCCCCCCCCC77777CC77CCC000
    C00000CCCC0000CCCC77777C777C000000000CCCC000000CCCC777777777000C
    0000CCCC00000000CCCC7777C77700CCC00CCCC0000000000CCCC77CCC770CCC
    CC0000CCCCCCCCCCCC7777CCCCC7CCCCC0000CCCCCCCCCCCCCC7777CCCCCCCCC
    0000CCCC00000000CCCC7777CCCCCCC0000CCCC0000000000CCCC7777CCC0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = True
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 48
    Width = 89
    Height = 16
    AutoSize = False
    Caption = #1050#1086#1076' '#1079#1072#1087#1091#1089#1082#1072':'
  end
  object Label2: TLabel
    Left = 5
    Top = 16
    Width = 148
    Height = 16
    Alignment = taRightJustify
    Caption = #1055#1072#1087#1082#1072' '#1076#1083#1103' '#1086#1073#1088#1072#1073#1086#1090#1082#1080':'
  end
  object Label3: TLabel
    Left = 8
    Top = 224
    Width = 63
    Height = 16
    Caption = #1050#1086#1084#1072#1085#1076#1072':'
  end
  object Label4: TLabel
    Left = 296
    Top = 48
    Width = 388
    Height = 16
    Caption = #1048#1089#1082#1083#1102#1095#1077#1085#1080#1103' ('#1086#1090#1085#1086#1089#1080#1090#1077#1083#1100#1085#1086' '#1086#1073#1088#1072#1073#1072#1090#1099#1074#1072#1077#1084#1086#1075#1086' '#1082#1072#1090#1072#1083#1086#1075#1072')'
  end
  object deldir: TEdit
    Left = 168
    Top = 8
    Width = 537
    Height = 24
    TabOrder = 0
    Text = 'D:\Temp'
  end
  object Cherrors: TCheckBox
    Left = 8
    Top = 71
    Width = 149
    Height = 21
    Caption = #1087#1088#1086#1090#1086#1082#1086#1083' '#1086#1096#1080#1073#1086#1082
    Checked = True
    State = cbChecked
    TabOrder = 1
    OnClick = CherrorsClick
  end
  object protect: TEdit
    Left = 104
    Top = 40
    Width = 177
    Height = 28
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = 17
    Font.Name = 'Terminal'
    Font.Pitch = fpFixed
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    Text = 'F3D421E3'
    OnChange = protectChange
  end
  object Chdels: TCheckBox
    Left = 8
    Top = 101
    Width = 177
    Height = 21
    Hint = 
      #1042#1077#1089#1090#1080' '#1083#1086#1075' '#1091#1076#1072#1083#1103#1077#1084#1099#1093' '#1092#1072#1081#1083#1086#1074'. '#1050#1072#1078#1076#1099#1081' '#1079#1072#1087#1091#1089#1082' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1083#1086#1075' '#1086#1095#1080#1097#1072#1077#1090#1089 +
      #1103'.'
    Caption = #1087#1088#1086#1090#1086#1082#1086#1083' '#1076#1077#1081#1089#1090#1074#1080#1081
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = ChdelsClick
  end
  object Chhidden: TCheckBox
    Left = 8
    Top = 130
    Width = 149
    Height = 21
    Caption = #1089#1082#1088#1099#1090#1100' '#1079#1072#1087#1091#1089#1082
    Checked = True
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 5
    OnClick = ChhiddenClick
  end
  object Edit2: TEdit
    Left = 88
    Top = 216
    Width = 617
    Height = 24
    TabOrder = 7
  end
  object Button2: TButton
    Left = 176
    Top = 152
    Width = 105
    Height = 25
    Caption = 'Save'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Chtest: TCheckBox
    Left = 8
    Top = 160
    Width = 149
    Height = 21
    Caption = #1090#1077#1089#1090#1086#1074#1099#1081' '#1088#1077#1078#1080#1084
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnClick = ChtestClick
  end
  object Button1: TButton
    Left = 232
    Top = 96
    Width = 41
    Height = 33
    Caption = 'X'
    TabOrder = 8
    OnClick = Button1Click
  end
  object Excl: TMemo
    Left = 296
    Top = 72
    Width = 409
    Height = 137
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Pitch = fpVariable
    Font.Style = []
    Lines.Strings = (
      'IDE2LPT')
    ParentFont = False
    TabOrder = 9
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 176
    Top = 72
  end
end
