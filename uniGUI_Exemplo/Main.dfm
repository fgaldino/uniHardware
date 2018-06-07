object MainForm: TMainForm
  Left = 0
  Top = 0
  ClientHeight = 621
  ClientWidth = 854
  Caption = 'MainForm'
  OnShow = UniFormShow
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  OnAjaxEvent = UniFormAjaxEvent
  OnCreate = UniFormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object UniListBox1: TUniListBox
    Left = 0
    Top = 359
    Width = 854
    Height = 262
    Hint = ''
    Align = alBottom
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 0
    ExplicitTop = 269
    ExplicitWidth = 809
  end
  object lblStatus: TUniLabel
    Left = 639
    Top = 334
    Width = 192
    Height = 19
    Hint = ''
    Caption = 'HardwareServer Offline'
    ParentFont = False
    Font.Height = -16
    Font.Style = [fsBold]
    TabOrder = 1
  end
  object UniPageControl1: TUniPageControl
    Left = 2
    Top = 5
    Width = 625
    Height = 343
    Hint = ''
    ActivePage = UniTabSheet1
    TabOrder = 2
    object UniTabSheet1: TUniTabSheet
      Hint = ''
      Caption = 'FastReports   '
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 289
      ExplicitHeight = 193
      object btnFRImprimirDireto: TUniButton
        Left = 3
        Top = 27
        Width = 241
        Height = 49
        Hint = ''
        Caption = 'Imprimir Direto'
        TabOrder = 0
        OnClick = btnFRImprimirDiretoClick
      end
      object btnFRVisualizar: TUniButton
        Left = 3
        Top = 82
        Width = 241
        Height = 49
        Hint = ''
        Caption = 'Visualizar'
        TabOrder = 1
        OnClick = btnFRVisualizarClick
      end
    end
    object UniTabSheet2: TUniTabSheet
      Hint = ''
      Caption = 'Balan'#231'a             '
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 289
      ExplicitHeight = 193
      object UniGroupBox1: TUniGroupBox
        Left = 23
        Top = 25
        Width = 354
        Height = 203
        Hint = ''
        Caption = 'Balan'#231'a'
        TabOrder = 0
        object UniLabel1: TUniLabel
          Left = 13
          Top = 28
          Width = 34
          Height = 13
          Hint = ''
          Caption = 'Modelo'
          TabOrder = 1
        end
        object UniLabel2: TUniLabel
          Left = 13
          Top = 71
          Width = 47
          Height = 13
          Hint = ''
          Caption = 'Baud rate'
          TabOrder = 2
        end
        object UniLabel3: TUniLabel
          Left = 176
          Top = 71
          Width = 43
          Height = 13
          Hint = ''
          Caption = 'Data Bits'
          TabOrder = 3
        end
        object UniLabel4: TUniLabel
          Left = 13
          Top = 112
          Width = 28
          Height = 13
          Hint = ''
          Caption = 'Parity'
          TabOrder = 4
        end
        object UniLabel5: TUniLabel
          Left = 176
          Top = 112
          Width = 42
          Height = 13
          Hint = ''
          Caption = 'Stop Bits'
          TabOrder = 5
        end
        object cbModelo: TUniComboBox
          Left = 13
          Top = 47
          Width = 145
          Hint = ''
          Text = 'Filizola'
          Items.Strings = (
            'Nenhum'
            'Filizola'
            'Toledo'
            'Toledo2090'
            'Toledo2180'
            'Urano'
            'LucasTec'
            'Magna'
            'Digitron'
            'Magellan'
            'UranoPOP'
            'Lider'
            'Rinnert'
            'Muller'
            'Saturno'
            'AFTS'
            'Generica'
            'Libratek'
            'Micheletti'
            'Alfa')
          TabOrder = 6
          ForceSelection = False
        end
        object cbBaudrate: TUniComboBox
          Left = 13
          Top = 89
          Width = 145
          Hint = ''
          Text = '9600'
          Items.Strings = (
            '110'
            '300'
            '600'
            '1200'
            '2400'
            '4800'
            '9600'
            '14400'
            '19200'
            '38400'
            '56000'
            '57600'
            '')
          TabOrder = 7
          ForceSelection = False
        end
        object cbdatabits: TUniComboBox
          Left = 176
          Top = 89
          Width = 145
          Hint = ''
          Text = '8'
          Items.Strings = (
            '5'
            '6'
            '7'
            '8'
            '')
          TabOrder = 8
          ForceSelection = False
        end
        object cbparity: TUniComboBox
          Left = 13
          Top = 127
          Width = 145
          Hint = ''
          Text = 'none'
          Items.Strings = (
            'none'
            'odd'
            'even'
            'mark'
            'space'
            '')
          TabOrder = 9
          ForceSelection = False
        end
        object cbstopbits: TUniComboBox
          Left = 176
          Top = 127
          Width = 145
          Hint = ''
          Text = 's1'
          Items.Strings = (
            's1'
            's1,5'
            's2'
            ''
            '')
          TabOrder = 10
          ForceSelection = False
        end
        object UniLabel6: TUniLabel
          Left = 176
          Top = 28
          Width = 55
          Height = 13
          Hint = ''
          Caption = 'Porta Serial'
          TabOrder = 11
        end
        object cbPorta: TUniComboBox
          Left = 176
          Top = 47
          Width = 145
          Hint = ''
          Text = 'COM2'
          Items.Strings = (
            'COM1'
            'COM2'
            'COM3'
            'COM4'
            'COM5'
            'COM6'
            'COM7'
            'COM8'
            '')
          TabOrder = 12
          ForceSelection = False
        end
        object UniLabel7: TUniLabel
          Left = 14
          Top = 155
          Width = 60
          Height = 13
          Hint = ''
          Caption = 'Handsharing'
          TabOrder = 13
        end
        object cbhandsharing: TUniComboBox
          Left = 13
          Top = 171
          Width = 145
          Hint = ''
          Text = 'Nenhum'
          Items.Strings = (
            'Nenhum'
            'XON/XOFF'
            'RTS/CTS'
            'DTR/DSR'
            '')
          TabOrder = 14
          ForceSelection = False
        end
      end
      object UniButton4: TUniButton
        Left = 136
        Top = 234
        Width = 241
        Height = 49
        Hint = ''
        Caption = 'Ler Balan'#231'a'
        TabOrder = 1
        OnClick = UniButton4Click
      end
    end
    object UniTabSheet3: TUniTabSheet
      Hint = ''
      Caption = 'Outros               '
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 289
      ExplicitHeight = 193
      object UniButton6: TUniButton
        Left = 8
        Top = 104
        Width = 241
        Height = 49
        Hint = ''
        Caption = 'Salvar Arquivo Dir Local'
        TabOrder = 0
        OnClick = UniButton6Click
      end
      object UniButton1: TUniButton
        Left = 8
        Top = 10
        Width = 241
        Height = 41
        Hint = ''
        Caption = 'Solicita GET'
        TabOrder = 1
        OnClick = UniButton1Click
      end
      object UniButton2: TUniButton
        Left = 8
        Top = 57
        Width = 241
        Height = 41
        Hint = ''
        Caption = 'Solicita POST'
        TabOrder = 2
        OnClick = UniButton2Click
      end
    end
  end
  object tmrVerificaHardwareServer: TUniTimer
    Interval = 5000
    ClientEvent.Strings = (
      'function(sender)'
      '{'
      ' '
      '}')
    OnTimer = tmrVerificaHardwareServerTimer
    Left = 736
    Top = 16
  end
end
