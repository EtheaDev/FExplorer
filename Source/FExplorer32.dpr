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
library FExplorer32;
uses
  ComServ,
  FExplorer.Main in 'FExplorer.Main.pas',
  FExplorer.Misc in 'FExplorer.Misc.pas',
  FExplorer.Registry in 'FExplorer.Registry.pas',
  uLogExcept in 'uLogExcept.pas',
  uStreamPreviewHandler in 'uStreamPreviewHandler.pas',
  uCommonPreviewHandler in 'uCommonPreviewHandler.pas',
  uPreviewHandler in 'uPreviewHandler.pas',
  uPreviewContainer in 'uPreviewContainer.pas' {PreviewContainer},
  FExplorer.PreviewHandler in 'FExplorer.PreviewHandler.pas',
  FExplorer.PreviewHandlerRegister in 'FExplorer.PreviewHandlerRegister.pas',
  FExplorer.ThumbnailHandler in 'FExplorer.ThumbnailHandler.pas',
  FExplorer.ThumbnailHandlerRegister in 'FExplorer.ThumbnailHandlerRegister.pas',
  FExplorer.ContextMenuHandler in 'FExplorer.ContextMenuHandler.pas',
  FExplorer.PreviewForm in 'FExplorer.PreviewForm.pas' {FrmPreview},
  FExplorer.SettingsForm in 'FExplorer.SettingsForm.pas' {SVGSettingsForm},
  FExplorer.Settings in 'FExplorer.Settings.pas',
  FExplorer.Resources in 'FExplorer.Resources.pas' {dmResources: TDataModule},
  FExplorer.ThumbnailResources in 'FExplorer.ThumbnailResources.pas' {dmThumbnailResources: TDataModule},
  dlgSearchText in 'dlgSearchText.pas' {TextSearchDialog},
  FExplorer.About in 'FExplorer.About.pas' {FrmAbout},
  BegaHtmlPrintPreviewForm in '..\Ext\HTMLViewer\Source\BegaHtmlPrintPreviewForm.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer,
  DllInstall;

  {$R *.res}

begin
end.
