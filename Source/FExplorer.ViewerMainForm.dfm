object frmMain: TfrmMain
  Left = 250
  Top = 217
  Caption = 'Visualizzatore Fattura Elettronica'
  ClientHeight = 590
  ClientWidth = 944
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  ShowHint = True
  OnAfterMonitorDpiChanged = FormAfterMonitorDpiChanged
  OnBeforeMonitorDpiChanged = FormBeforeMonitorDpiChanged
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    944
    590)
  TextHeight = 15
  object RightSplitter: TSplitter
    Left = 688
    Top = 36
    Width = 6
    Height = 535
    Align = alRight
    AutoSnap = False
    MinSize = 240
    ExplicitLeft = 741
    ExplicitTop = 61
    ExplicitHeight = 500
  end
  object ClientPanel: TPanel
    Left = 44
    Top = 36
    Width = 644
    Height = 535
    Align = alClient
    TabOrder = 5
    object PageControl: TPageControl
      Left = 1
      Top = 1
      Width = 642
      Height = 533
      Align = alClient
      Images = VirtualImageList
      TabOrder = 0
      OnChange = PageControlChange
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 571
    Width = 944
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Width = 80
      end
      item
        Alignment = taCenter
        Width = 40
      end
      item
        Alignment = taCenter
        Width = 80
      end
      item
        Width = 100
      end
      item
        Width = 80
      end
      item
        Width = 80
      end>
  end
  object ImagePanel: TPanel
    Left = 694
    Top = 36
    Width = 250
    Height = 535
    Align = alRight
    BevelOuter = bvNone
    Color = clWhite
    DoubleBuffered = False
    ParentBackground = False
    ParentDoubleBuffered = False
    TabOrder = 0
    StyleElements = []
    object StatusSplitter: TSplitter
      Left = 0
      Top = 489
      Width = 250
      Height = 4
      Cursor = crVSplit
      Align = alBottom
      AutoSnap = False
      ExplicitLeft = 1
      ExplicitTop = 487
      ExplicitWidth = 248
    end
    object SVGIconImage: TSVGIconImage
      Left = 0
      Top = 172
      Width = 250
      Height = 317
      AutoSize = False
      Align = alClient
      OnMouseMove = SVGIconImageMouseMove
    end
    object panelPreview: TPanel
      Left = 0
      Top = 24
      Width = 250
      Height = 40
      Align = alTop
      ParentBackground = False
      ShowCaption = False
      TabOrder = 0
      object BackgroundGrayScaleLabel: TLabel
        Left = 10
        Top = 6
        Width = 63
        Height = 39
        AutoSize = False
        Caption = 'Luce %:'
        WordWrap = True
      end
      object BackgroundTrackBar: TTrackBar
        AlignWithMargins = True
        Left = 81
        Top = 4
        Width = 165
        Height = 32
        Margins.Left = 80
        Align = alClient
        Max = 255
        Frequency = 10
        Position = 117
        TabOrder = 0
        TabStop = False
        OnChange = BackgroundTrackBarChange
      end
    end
    object FlowPanel: TFlowPanel
      AlignWithMargins = True
      Left = 3
      Top = 67
      Width = 244
      Height = 102
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object SVGIconImage16: TSVGIconImage
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 24
        Height = 24
        Hint = '16x16'
        AutoSize = False
      end
      object SVGIconImage32: TSVGIconImage
        AlignWithMargins = True
        Left = 33
        Top = 3
        Width = 36
        Height = 36
        Hint = '32x32'
        AutoSize = False
      end
      object SVGIconImage48: TSVGIconImage
        AlignWithMargins = True
        Left = 75
        Top = 3
        Width = 48
        Height = 48
        Hint = '48x48'
        AutoSize = False
      end
      object SVGIconImage96: TSVGIconImage
        AlignWithMargins = True
        Left = 129
        Top = 3
        Width = 96
        Height = 96
        Hint = '96x96'
        AutoSize = False
      end
    end
    object ImagePreviewPanel: TPanel
      Left = 0
      Top = 0
      Width = 250
      Height = 24
      Align = alTop
      Caption = 'ANTEPRIMA ICONA'
      ParentBackground = False
      TabOrder = 3
    end
    object StatusPanel: TPanel
      Left = 0
      Top = 493
      Width = 250
      Height = 42
      Align = alBottom
      ParentBackground = False
      TabOrder = 2
      object StatusImage: TSVGIconImage
        Left = 1
        Top = 1
        Width = 32
        Height = 40
        AutoSize = False
        ImageList = VirtualImageList
        ImageIndex = 39
        Align = alLeft
      end
      object StatusStaticText: TStaticText
        AlignWithMargins = True
        Left = 36
        Top = 4
        Width = 4
        Height = 4
        Align = alClient
        Alignment = taCenter
        TabOrder = 0
      end
    end
  end
  object SV: TSplitView
    Left = 0
    Top = 36
    Width = 160
    Height = 535
    CloseStyle = svcCompact
    Color = clHighlight
    CompactWidth = 44
    DisplayMode = svmOverlay
    OpenedWidth = 160
    ParentDoubleBuffered = True
    Placement = svpLeft
    TabOrder = 1
    OnClosed = SVClosed
    OnClosing = SVClosing
    OnOpened = SVOpened
    OnOpening = SVOpening
    object catMenuItems: TCategoryButtons
      Left = 0
      Top = 0
      Width = 160
      Height = 535
      Align = alClient
      BackgroundGradientDirection = gdVertical
      BorderStyle = bsNone
      ButtonFlow = cbfVertical
      ButtonHeight = 36
      ButtonWidth = 36
      ButtonOptions = [boFullSize, boShowCaptions, boBoldCaptions, boCaptionOnlyBorder]
      Categories = <
        item
          Caption = 'File'
          Color = clNone
          Collapsed = False
          Items = <
            item
              Action = acNewFile
            end
            item
              Action = acOpenFile
            end
            item
              Action = OpenRecentAction
            end
            item
              Action = acClose
            end
            item
              Action = acCloseAll
            end
            item
              Action = acSave
            end
            item
              Action = acSaveAll
            end
            item
              Action = actnSaveAs
            end
            item
              Action = acSaveHTMLFile
            end
            item
              Action = acSavePDFFile
            end>
        end
        item
          Caption = 'Testo'
          Color = clNone
          Collapsed = False
          Items = <
            item
              Action = actnFormatXML
            end
            item
              Action = acEditSelectAll
            end
            item
              Action = acEditUndo
            end
            item
              Action = acEditCut
            end
            item
              Action = acEditCopy
            end
            item
              Action = acEditPaste
            end
            item
              Action = acSearch
            end
            item
              Action = acSearchAgain
            end
            item
              Action = acReplace
            end>
        end
        item
          Caption = 'Stampa'
          Color = clNone
          Collapsed = False
          Items = <
            item
              Action = actnPrint
            end
            item
              Action = actnPrintPreview
            end>
        end>
      Color = clBtnFace
      DoubleBuffered = True
      HotButtonColor = 12500670
      Images = VirtualImageList
      ParentDoubleBuffered = False
      RegularButtonColor = clNone
      SelectedButtonColor = clNone
      TabOrder = 0
      OnGetHint = catMenuItemsGetHint
      OnMouseLeave = catMenuItemsMouseLeave
      OnMouseMove = catMenuItemsMouseMove
    end
  end
  object panlTop: TPanel
    Left = 0
    Top = 0
    Width = 944
    Height = 36
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 2
    object lblTitle: TLabel
      AlignWithMargins = True
      Left = 40
      Top = 3
      Width = 170
      Height = 15
      Align = alLeft
      Caption = 'Visualizzatore Fattura Elettronica'
      Layout = tlCenter
    end
    object SettingsToolBar: TToolBar
      AlignWithMargins = True
      Left = 741
      Top = 3
      Width = 200
      Height = 30
      Align = alRight
      AutoSize = True
      ButtonHeight = 32
      ButtonWidth = 32
      Color = clYellow
      DrawingStyle = dsGradient
      GradientEndColor = clBtnFace
      GradientStartColor = clBtnFace
      Images = VirtualImageList
      ParentColor = False
      TabOrder = 0
      Transparent = True
      object ColorSettingsToolButton: TToolButton
        Left = 0
        Top = 0
        Action = actnColorSettings
      end
      object EditOptionsToolButton: TToolButton
        Left = 32
        Top = 0
        Action = actnEditOptions
      end
      object PageSetupToolButton: TToolButton
        Left = 64
        Top = 0
        Action = actnPageSetup
      end
      object PrinterSetupToolButton: TToolButton
        Left = 96
        Top = 0
        Action = actnPrinterSetup
      end
      object SepToolButton: TToolButton
        Left = 128
        Top = 0
        Width = 8
        ImageName = 'Informazioni'
        Style = tbsSeparator
      end
      object AboutToolButton: TToolButton
        Left = 136
        Top = 0
        Action = acAbout
      end
      object QuitToolButton: TToolButton
        Left = 168
        Top = 0
        Action = acQuit
        ImageName = 'Exit'
      end
    end
    object MenuButtonToolbar: TToolBar
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 31
      Height = 30
      Align = alLeft
      AutoSize = True
      ButtonHeight = 32
      ButtonWidth = 32
      Color = clYellow
      DrawingStyle = dsGradient
      GradientEndColor = clBtnFace
      GradientStartColor = clBtnFace
      Images = VirtualImageList
      ParentColor = False
      TabOrder = 1
      Transparent = True
      object MenuToolButton: TToolButton
        AlignWithMargins = True
        Left = 0
        Top = 0
        Action = actMenu
        AutoSize = True
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 
      'File Fattura Elettronica (*.xml;*.p7m)|*.xml;*.p7m|Fogli di Stil' +
      'e (*.xsl)|*.xsl'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 300
    Top = 196
  end
  object ActionList: TActionList
    Images = VirtualImageList
    OnExecute = ActionListExecute
    OnUpdate = ActionListUpdate
    Left = 308
    Top = 108
    object acNewFile: TAction
      Category = 'File'
      Caption = 'Nuovo ...'
      Hint = 'Nuovo File'
      ImageIndex = 2
      ImageName = 'New'
      OnExecute = acNewFileExecute
    end
    object acOpenFile: TAction
      Category = 'File'
      Caption = 'Apri ...'
      Hint = 'Apri File Fattura Elettronica ...'
      ImageIndex = 1
      ImageName = 'Open'
      OnExecute = acOpenFileExecute
    end
    object acEditCut: TEditCut
      Category = 'Edit'
      Caption = '&Taglia'
      Enabled = False
      Hint = 'Taglia il testo selezionato'
      ImageIndex = 10
      ImageName = 'Cut'
      ShortCut = 16472
      OnExecute = acEditCutExecute
      OnUpdate = actionForFileUpdate
    end
    object acSearch: TAction
      Category = 'Edit'
      Caption = 'Cerca ...'
      Hint = 'Cerca nel testo...'
      ImageIndex = 6
      ImageName = 'Search'
      ShortCut = 16454
      OnExecute = acSearchExecute
      OnUpdate = acSearchUpdate
    end
    object acSearchAgain: TAction
      Category = 'Edit'
      Caption = 'Ripeti ricerca'
      Hint = 'Ripeti l'#39'ultima ricerca'
      ImageIndex = 7
      ImageName = 'Search-repeat'
      ShortCut = 114
      OnExecute = acSearchAgainExecute
      OnUpdate = acSearchAgainUpdate
    end
    object acClose: TAction
      Category = 'File'
      Caption = 'Chiudi'
      Hint = 'Chiudi il File'
      ImageIndex = 3
      ImageName = 'Close'
      ShortCut = 16499
      OnExecute = acCloseExecute
      OnUpdate = actnEditingUpdate
    end
    object acEditCopy: TEditCopy
      Category = 'Edit'
      Caption = '&Copia'
      Enabled = False
      Hint = 'Copia la selezione'
      ImageIndex = 8
      ImageName = 'Copy'
      ShortCut = 16451
      OnExecute = acEditCopyExecute
      OnUpdate = acEditCopyUpdate
    end
    object acEditPaste: TEditPaste
      Category = 'Edit'
      Caption = '&Incolla'
      Enabled = False
      Hint = 'Incolla il contenuto copiato'
      ImageIndex = 9
      ImageName = 'Paste'
      ShortCut = 16470
      OnExecute = acEditPasteExecute
      OnUpdate = actionForFileUpdate
    end
    object acEditSelectAll: TEditSelectAll
      Category = 'Edit'
      Caption = 'Selezion&a Tutto'
      Hint = 'Seleziona intero documento'
      ImageIndex = 18
      ImageName = 'Select-all'
      ShortCut = 16449
      OnExecute = acEditSelectAllExecute
      OnUpdate = actionForFileUpdate
    end
    object acEditUndo: TEditUndo
      Category = 'Edit'
      Caption = '&Annulla'
      Hint = 'Annulla l'#39'ultima azione'
      ImageIndex = 11
      ImageName = 'Undo'
      ShortCut = 16474
      OnExecute = acEditUndoExecute
      OnUpdate = acEditUndoUpdate
    end
    object acSave: TAction
      Category = 'File'
      Caption = '&Salva'
      Hint = 'Salva il File'
      ImageIndex = 12
      ImageName = 'Save'
      ShortCut = 16467
      OnExecute = acSaveExecute
      OnUpdate = acSaveUpdate
    end
    object acReplace: TAction
      Category = 'Edit'
      Caption = 'Sostituisci ...'
      Hint = 'Cerca e Sostituisci'
      ImageIndex = 20
      ImageName = 'replace'
      ShortCut = 16466
      OnExecute = acReplaceExecute
      OnUpdate = acReplaceUpdate
    end
    object acQuit: TAction
      Category = 'File'
      Caption = 'Esci'
      Hint = 'Esci dall'#39'applicazione'
      ImageIndex = 22
      ImageName = 'exit'
      ShortCut = 16465
      OnExecute = acQuitExecute
    end
    object acAbout: TAction
      Category = 'Help'
      Caption = 'Info ...'
      Hint = 'Informazioni su Visualizzatore Fattura Elettronica'
      ImageIndex = 23
      ImageName = 'about'
      OnExecute = acAboutExecute
    end
    object acCloseAll: TAction
      Category = 'File'
      Caption = 'Chiudi tutto'
      Hint = 'Chiudi tutti i file aperti'
      ImageIndex = 4
      ImageName = 'Close-all'
      OnExecute = acCloseAllExecute
      OnUpdate = acCloseAllUpdate
    end
    object acSaveAll: TAction
      Category = 'File'
      Caption = 'Salva Tutto'
      Hint = 'Salva tutti i file aperti'
      ImageIndex = 13
      ImageName = 'Save-all'
      OnExecute = acSaveAllExecute
      OnUpdate = acSaveAllUpdate
    end
    object actnPrint: TAction
      Category = 'File'
      Caption = 'Stampa il file ...'
      Hint = 'Stampa il file su stampante'
      ImageIndex = 15
      ImageName = 'Print'
      OnExecute = actnPrintExecute
      OnUpdate = actnEditingUpdate
    end
    object actnPrinterSetup: TAction
      Category = 'Settings'
      Caption = 'Setup Stampante ...'
      Hint = 'Setup della Stampante'
      ImageIndex = 17
      ImageName = 'Print-settings'
      OnExecute = actnPrinterSetupExecute
    end
    object actnPrintPreview: TAction
      Category = 'File'
      Caption = 'Anteprima di stampa'
      Hint = 'Anteprima di stampa'
      ImageIndex = 16
      ImageName = 'print-preview'
      OnExecute = actnPrintPreviewExecute
      OnUpdate = actnEditingUpdate
    end
    object actnPageSetup: TAction
      Category = 'Settings'
      Caption = 'Impostazione Pagina ...'
      Hint = 'Impostazione Pagina della stampa'
      ImageIndex = 30
      ImageName = 'view_details'
      OnExecute = actnPageSetupExecute
      OnUpdate = actnEditingUpdate
    end
    object actnEditOptions: TAction
      Category = 'Edit'
      Caption = 'Impostazioni visualizzatore ...'
      Hint = 'Editor Options'
      ImageIndex = 44
      ImageName = 'Support'
      OnExecute = actnEditOptionsExecute
    end
    object actnEnlargeFont: TAction
      Category = 'Settings'
      Caption = 'Font +'
      Hint = 'Aumenta il Font'
      ImageIndex = 26
      ImageName = 'plus'
      OnExecute = actnFontExecute
    end
    object actnReduceFont: TAction
      Category = 'Settings'
      Caption = 'Font -'
      Hint = 'Riduci il Font'
      ImageIndex = 25
      ImageName = 'Minus'
      OnExecute = actnFontExecute
    end
    object actnSaveAs: TAction
      Category = 'File'
      Caption = 'Salva come ...'
      Hint = 'Salva il file con altro nome'
      ImageIndex = 14
      ImageName = 'Save-as'
      OnExecute = actnSaveAsExecute
      OnUpdate = actnEditingUpdate
    end
    object actnColorSettings: TAction
      Category = 'Settings'
      Caption = 'Impostazione visualizzatore'
      Hint = 'Impostazioni del visualizzatore (colori, font, temi)'
      ImageIndex = 28
      ImageName = 'preferences-desktop'
      OnExecute = actnColorSettingsExecute
      OnUpdate = actnColorSettingsUpdate
    end
    object actnFormatXML: TAction
      Category = 'Edit'
      Caption = 'Riformatta il testo'
      Hint = 'Riformatta il testo'
      ImageIndex = 19
      ImageName = 'Reformat'
      ShortCut = 16468
      OnExecute = actnFormatXMLExecute
      OnUpdate = actionForFileUpdate
    end
    object actMenu: TAction
      Caption = 'Collassa'
      Hint = 'Collassa'
      ImageIndex = 24
      ImageName = 'menu'
      OnExecute = actMenuExecute
    end
    object OpenRecentAction: TAction
      Category = 'File'
      Caption = 'Apri file recenti ...'
      Hint = 'Apri un file aperto precedentemente'
      ImageIndex = 5
      ImageName = 'Close-all-folder'
      OnExecute = OpenRecentActionExecute
    end
    object acZoomIn: TAction
      Category = 'HTMLViewer'
      Caption = 'Zoom +'
      ImageIndex = 26
      ImageName = 'plus'
      OnExecute = acZoomExecute
    end
    object acZoomOut: TAction
      Category = 'HTMLViewer'
      Caption = 'Zoom -'
      ImageIndex = 25
      ImageName = 'Minus'
      OnExecute = acZoomExecute
    end
    object acSaveHTMLFile: TAction
      Category = 'HTMLViewer'
      Caption = 'Salva in HTML...'
      Hint = 'Salva la fattura in un file HTML...'
      ImageIndex = 51
      ImageName = 'save_html'
      OnExecute = acSaveHTMLFileExecute
    end
    object acSavePDFFile: TAction
      Category = 'HTMLViewer'
      Caption = 'Salva in PDF...'
      Hint = 'Salva la fattura in un file PDF...'
      ImageIndex = 52
      ImageName = 'save_pdf'
      OnExecute = acSavePDFFileExecute
    end
  end
  object SaveDialog: TSaveDialog
    Filter = 
      'File Fattura Elettronica (*.xml;*.p7m)|*.xml;*.p7m|Fogli di Stil' +
      'e (*.xsl)|*.xsl'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 300
    Top = 264
  end
  object popEditor: TPopupMenu
    Images = VirtualImageList
    Left = 456
    Top = 152
    object CloseMenuItem: TMenuItem
      Action = acClose
    end
    object SaveMenuItem: TMenuItem
      Action = acSave
    end
    object CloseAll1: TMenuItem
      Action = acCloseAll
    end
    object Sep1MenuItem: TMenuItem
      Caption = '-'
    end
    object Reformattext1: TMenuItem
      Action = actnFormatXML
    end
    object SelectAllMenuItem: TMenuItem
      Action = acEditSelectAll
    end
    object CopyMenuItem: TMenuItem
      Action = acEditCopy
    end
    object CutMenuItem: TMenuItem
      Action = acEditCut
    end
    object PasteMenuItem: TMenuItem
      Action = acEditPaste
    end
    object Sep2MenuItem: TMenuItem
      Caption = '-'
    end
    object SearchMenuItem: TMenuItem
      Action = acSearch
    end
    object ReplaceMenuItem: TMenuItem
      Action = acReplace
      ImageName = 'Replace'
    end
    object N1: TMenuItem
      Caption = '-'
    end
  end
  object PrinterSetupDialog: TPrinterSetupDialog
    Left = 657
    Top = 261
  end
  object PrintDialog: TPrintDialog
    Left = 656
    Top = 313
  end
  object SynEditPrint: TSynEditPrint
    Copies = 1
    Header.FrameTypes = [ftBox, ftShaded]
    Header.DefaultFont.Charset = DEFAULT_CHARSET
    Header.DefaultFont.Color = clBlack
    Header.DefaultFont.Height = -13
    Header.DefaultFont.Name = 'Arial'
    Header.DefaultFont.Style = []
    Footer.FrameTypes = [ftBox, ftShaded]
    Footer.DefaultFont.Charset = DEFAULT_CHARSET
    Footer.DefaultFont.Color = clBlack
    Footer.DefaultFont.Height = -13
    Footer.DefaultFont.Name = 'Arial'
    Footer.DefaultFont.Style = []
    Margins.UnitSystem = usCM
    Margins.Left = 1.500000000000000000
    Margins.Right = 1.500000000000000000
    Margins.Top = 2.000000000000000000
    Margins.Bottom = 2.000000000000000000
    Margins.Header = 1.500000000000000000
    Margins.Footer = 1.500000000000000000
    Margins.LeftHFTextIndent = 0.200000000000000000
    Margins.RightHFTextIndent = 0.200000000000000000
    Margins.HFInternalMargin = 0.050000000000000000
    Margins.MirrorMargins = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Colors = True
    TabWidth = 8
    Color = clWhite
    Left = 656
    Top = 208
  end
  object SynEditSearch: TSynEditSearch
    Left = 204
    Top = 192
  end
  object VirtualImageList: TVirtualImageList
    Images = <
      item
        CollectionIndex = 0
        CollectionName = 'Style'
        Name = 'Style'
      end
      item
        CollectionIndex = 1
        CollectionName = 'Open'
        Name = 'Open'
      end
      item
        CollectionIndex = 2
        CollectionName = 'New'
        Name = 'New'
      end
      item
        CollectionIndex = 3
        CollectionName = 'Close'
        Name = 'Close'
      end
      item
        CollectionIndex = 4
        CollectionName = 'Close-all'
        Name = 'Close-all'
      end
      item
        CollectionIndex = 5
        CollectionName = 'Close-all-folder'
        Name = 'Close-all-folder'
      end
      item
        CollectionIndex = 6
        CollectionName = 'Search'
        Name = 'Search'
      end
      item
        CollectionIndex = 7
        CollectionName = 'Search-repeat'
        Name = 'Search-repeat'
      end
      item
        CollectionIndex = 8
        CollectionName = 'Copy'
        Name = 'Copy'
      end
      item
        CollectionIndex = 9
        CollectionName = 'Paste'
        Name = 'Paste'
      end
      item
        CollectionIndex = 10
        CollectionName = 'Cut'
        Name = 'Cut'
      end
      item
        CollectionIndex = 11
        CollectionName = 'Undo'
        Name = 'Undo'
      end
      item
        CollectionIndex = 12
        CollectionName = 'Save'
        Name = 'Save'
      end
      item
        CollectionIndex = 13
        CollectionName = 'Save-all'
        Name = 'Save-all'
      end
      item
        CollectionIndex = 14
        CollectionName = 'Save-as'
        Name = 'Save-as'
      end
      item
        CollectionIndex = 15
        CollectionName = 'Print'
        Name = 'Print'
      end
      item
        CollectionIndex = 16
        CollectionName = 'Print-preview'
        Name = 'Print-preview'
      end
      item
        CollectionIndex = 17
        CollectionName = 'Print-settings'
        Name = 'Print-settings'
      end
      item
        CollectionIndex = 18
        CollectionName = 'Select-all'
        Name = 'Select-all'
      end
      item
        CollectionIndex = 19
        CollectionName = 'Reformat'
        Name = 'Reformat'
      end
      item
        CollectionIndex = 20
        CollectionName = 'Replace'
        Name = 'Replace'
      end
      item
        CollectionIndex = 21
        CollectionName = 'Settings'
        Name = 'Settings'
      end
      item
        CollectionIndex = 22
        CollectionName = 'Exit'
        Name = 'Exit'
      end
      item
        CollectionIndex = 23
        CollectionName = 'about'
        Name = 'about'
      end
      item
        CollectionIndex = 24
        CollectionName = 'menu'
        Name = 'menu'
      end
      item
        CollectionIndex = 25
        CollectionName = 'Minus'
        Name = 'Minus'
      end
      item
        CollectionIndex = 26
        CollectionName = 'plus'
        Name = 'plus'
      end
      item
        CollectionIndex = 27
        CollectionName = 'back'
        Name = 'back'
      end
      item
        CollectionIndex = 28
        CollectionName = 'preferences-desktop'
        Name = 'preferences-desktop'
      end
      item
        CollectionIndex = 29
        CollectionName = 'preferences-desktop-color'
        Name = 'preferences-desktop-color'
      end
      item
        CollectionIndex = 30
        CollectionName = 'view_details'
        Name = 'view_details'
      end
      item
        CollectionIndex = 31
        CollectionName = 'left'
        Name = 'left'
      end
      item
        CollectionIndex = 32
        CollectionName = 'right'
        Name = 'right'
      end
      item
        CollectionIndex = 33
        CollectionName = 'binoculars'
        Name = 'binoculars'
      end
      item
        CollectionIndex = 34
        CollectionName = 'whole-page'
        Name = 'whole-page'
      end
      item
        CollectionIndex = 35
        CollectionName = 'page-width'
        Name = 'page-width'
      end
      item
        CollectionIndex = 36
        CollectionName = 'svg-logo'
        Name = 'svg-logo'
      end
      item
        CollectionIndex = 37
        CollectionName = 'svg-logo-gray'
        Name = 'svg-logo-gray'
      end
      item
        CollectionIndex = 38
        CollectionName = 'export'
        Name = 'export'
      end
      item
        CollectionIndex = 46
        CollectionName = 'error'
        Name = 'error'
      end
      item
        CollectionIndex = 47
        CollectionName = 'info'
        Name = 'info'
      end
      item
        CollectionIndex = 48
        CollectionName = 'attachment'
        Name = 'attachment'
      end
      item
        CollectionIndex = 49
        CollectionName = 'fattura-elettronica'
        Name = 'fattura-elettronica'
      end
      item
        CollectionIndex = 50
        CollectionName = 'fattura-elettronica-gray'
        Name = 'fattura-elettronica-gray'
      end
      item
        CollectionIndex = 41
        CollectionName = 'Support'
        Name = 'Support'
      end
      item
        CollectionIndex = 51
        CollectionName = 'xml'
        Name = 'xml'
      end
      item
        CollectionIndex = 52
        CollectionName = 'xsl'
        Name = 'xsl'
      end
      item
        CollectionIndex = 53
        CollectionName = 'xml-gray'
        Name = 'xml-gray'
      end
      item
        CollectionIndex = 54
        CollectionName = 'xsl-gray'
        Name = 'xsl-gray'
      end
      item
        CollectionIndex = 55
        CollectionName = 'file'
        Name = 'file'
      end
      item
        CollectionIndex = 56
        CollectionName = 'file-gray'
        Name = 'file-gray'
      end
      item
        CollectionIndex = 57
        CollectionName = 'save_html'
        Name = 'save_html'
      end
      item
        CollectionIndex = 58
        CollectionName = 'save_pdf'
        Name = 'save_pdf'
      end
      item
        CollectionIndex = 59
        CollectionName = 'save_xml'
        Name = 'save_xml'
      end>
    ImageCollection = dmResources.SVGIconImageCollection
    Width = 24
    Height = 24
    Left = 448
    Top = 304
  end
  object RecentPopupMenu: TPopupMenu
    OnPopup = RecentPopupMenuPopup
    Left = 456
    Top = 216
  end
  object PopHTMLViewer: TPopupMenu
    Images = VirtualImageList
    Left = 528
    Top = 152
    object Zoom1: TMenuItem
      Action = acZoomIn
    end
    object Zoom2: TMenuItem
      Action = acZoomOut
    end
    object SaveHTMLfile1: TMenuItem
      Action = acSaveHTMLFile
    end
    object SavePDFfile1: TMenuItem
      Action = acSavePDFFile
    end
    object PopHTMLSep: TMenuItem
      Caption = '-'
    end
    object Chiudi1: TMenuItem
      Action = acClose
    end
    object Chiuditutto1: TMenuItem
      Action = acCloseAll
    end
  end
end
