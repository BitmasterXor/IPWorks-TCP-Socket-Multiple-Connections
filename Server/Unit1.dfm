object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Server'
  ClientHeight = 316
  ClientWidth = 626
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object scListView1: TscListView
    Left = 0
    Top = 0
    Width = 625
    Height = 297
    FluentUIOpaque = False
    Columns = <
      item
        AutoSize = True
        Caption = 'IP Address'
      end
      item
        AutoSize = True
        Caption = 'NickName'
      end>
    ExtendedColumnDraw = False
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 0
    ViewStyle = vsReport
    SelectionStyle = scstStyled
    ShowFocusRect = True
    AlternateRow = False
    GridLines = False
    DefaultDraw = False
    SelectionColor = clNone
    SelectionTextColor = clHighlightText
  end
  object scStatusBar1: TscStatusBar
    Left = 0
    Top = 297
    Width = 626
    Height = 19
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Panels = <
      item
        Text = 'Server Status: Offline!'
        Width = 150
      end
      item
        Text = 'Clients Connected [0]'
        Width = 150
      end>
    UseSystemFont = False
    ExplicitLeft = 32
    ExplicitTop = 304
    ExplicitWidth = 0
  end
  object serversocket: TipwTCPServer
    SSLCertStore = 'MY'
    OnDataIn = serversocketDataIn
    OnDisconnected = serversocketDisconnected
    Left = 40
    Top = 32
  end
  object PopupMenu1: TPopupMenu
    Left = 40
    Top = 96
    object S1: TMenuItem
      Caption = 'Send MSG To ALL'
      OnClick = S1Click
    end
    object S2: TMenuItem
      Caption = 'Send MSG To Selected'
      OnClick = S2Click
    end
  end
end
