{******************************************************************************}
{                                                                              }
{       FExplorer: Shell extensions per Fattura Elettronica                    }
{       (Preview Panel, Thumbnail Icon, F.E.Viewer)                            }
{                                                                              }
{       Copyright (c) 2021-2022 (Ethea S.r.l.)                                 }
{       Author: Carlo Barazzetta                                               }
{                                                                              }
{       https://github.com/EtheaDev/FExplorer                                  }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{  The Original Code is:                                                       }
{  Delphi Preview Handler  https://github.com/RRUZ/delphi-preview-handler      }
{                                                                              }
{  The Initial Developer of the Original Code is Rodrigo Ruz V.                }
{  Portions created by Rodrigo Ruz V. are Copyright 2011-2021 Rodrigo Ruz V.   }
{  All Rights Reserved.                                                        }
{******************************************************************************}
program FEViewer;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  System.SysUtils,
  dlgSearchText in 'dlgSearchText.pas' {TextSearchDialog},
  dlgReplaceText in 'dlgReplaceText.pas' {TextReplaceDialog},
  FExplorer.ViewerMainForm in 'FExplorer.ViewerMainForm.pas' {frmMain},
  FExplorer.Resources in 'FExplorer.Resources.pas' {dmResources: TDataModule},
  DPageSetup in 'DPageSetup.pas' {PageSetupDlg},
  FExplorer.Splash in 'FExplorer.Splash.pas' {SplashForm},
  dlgConfirmReplace in 'dlgConfirmReplace.pas' {ConfirmReplaceDialog},
  FExplorer.About in 'FExplorer.About.pas' {FrmAbout},
  FExplorer.Misc in 'FExplorer.Misc.pas',
  SynEditOptionsDialog in 'SynEditOptionsDialog.pas' {fmEditorOptionsDialog},
  FExplorer.Settings in 'FExplorer.Settings.pas',
  FExplorer.SettingsForm in 'FExplorer.SettingsForm.pas' {SVGSettingsForm},
  FExplorer.Registry in 'FExplorer.Registry.pas',
  FExplorer.InvoiceToImage in 'FExplorer.InvoiceToImage.pas',
  FExplorer.ThumbnailResources in 'FExplorer.ThumbnailResources.pas' {dmThumbnailResources: TDataModule},
  vmHtmlToPdf in 'vmHtmlToPdf.pas',
  uDragDropUtils in 'uDragDropUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskBar := True;
  Application.Title := Title_FEViewer+'- © 2021-2022 Ethea S.r.l.';
  with TSplashForm.Create(nil) do
  Try
    Show;
    Update;
    Application.HelpFile := '';
  Application.CreateForm(TdmResources, dmResources);
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TPageSetupDlg, PageSetupDlg);
  Hide;
  Finally
    Free;
  End;
  frmMain.Show;
  Application.Run;
end.
