object MainForm: TMainForm
  Left = 182
  Top = 181
  Width = 911
  Height = 508
  Caption = #1064#1080#1092#1088#1086#1074#1072#1085#1080#1077' IDEA'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object OriginalText: TLabel
    Left = 88
    Top = 32
    Width = 196
    Height = 29
    Caption = #1048#1089#1093#1086#1076#1085#1099#1081' '#1090#1077#1082#1089#1090' :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Result: TLabel
    Left = 560
    Top = 32
    Width = 325
    Height = 24
    Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object EnterKey: TLabel
    Left = 384
    Top = 80
    Width = 131
    Height = 24
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1082#1083#1102#1095':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object MainText: TMemo
    Left = 16
    Top = 64
    Width = 321
    Height = 361
    Lines.Strings = (
      '')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object ResultText: TMemo
    Left = 552
    Top = 64
    Width = 337
    Height = 353
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object StartStep: TButton
    Left = 344
    Top = 216
    Width = 201
    Height = 57
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1064#1072#1075
    TabOrder = 2
    Visible = False
    OnClick = StartStepClick
  end
  object StartAll: TButton
    Left = 344
    Top = 296
    Width = 201
    Height = 65
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1087#1086#1083#1085#1086#1089#1090#1100#1102
    TabOrder = 3
    Visible = False
    OnClick = StartAllClick
  end
  object KeyEdit: TEdit
    Left = 360
    Top = 112
    Width = 177
    Height = 21
    TabOrder = 4
  end
  object OpenDialog: TOpenDialog
    Left = 8
  end
  object SaveDialog: TSaveDialog
    Left = 40
  end
  object MainMenu: TMainMenu
    Left = 80
    object Actions: TMenuItem
      Caption = #1044#1077#1081#1089#1090#1074#1080#1103' '#1089' '#1092#1072#1081#1083#1086#1084
      object OpenFile: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083
        OnClick = OpenFileClick
      end
      object SaveFile: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1060#1072#1081#1083
      end
    end
    object CloseProgram: TMenuItem
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1087#1088#1086#1075#1088#1072#1084#1084#1091
      OnClick = CloseProgramClick
    end
  end
end
