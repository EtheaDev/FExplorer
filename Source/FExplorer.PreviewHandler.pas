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
{                                                                              }
{  The Initial Developer of the Original Code is Rodrigo Ruz V.                }
{  Portions created by Rodrigo Ruz V. are Copyright 2011-2021 Rodrigo Ruz V.   }
{  All Rights Reserved.                                                        }
{******************************************************************************}
unit FExplorer.PreviewHandler;

interface

uses
  Classes,
  Controls,
  StdCtrls,
  SysUtils,
  uCommonPreviewHandler,
  uStreamPreviewHandler,
  uPreviewHandler;

  type
    TFEPreviewHandler = class(TBasePreviewHandler)
  public
    constructor Create(AParent: TWinControl); override;
  end;

const
  MyFE_PreviewHandlerGUID_64: TGUID = '{5ec7f7fc-518f-4364-b3e4-07de856df0a1}';
  MyFE_PreviewHandlerGUID_32: TGUID = '{917480ec-2eaf-4819-a4bd-e70df8f349f2}';

implementation

Uses
  uLogExcept,
  SynEdit,
  Windows,
  Forms,
  uMisc;
type
  TWinControlClass = class(TWinControl);

constructor TFEPreviewHandler.Create(AParent: TWinControl);
begin
  TLogPreview.Add('TFEPreviewHandler.Create');
  inherited Create(AParent);
  TLogPreview.Add('TFEPreviewHandler Done');
end;

end.
