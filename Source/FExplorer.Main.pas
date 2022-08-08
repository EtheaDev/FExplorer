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
{  The Original Code is Main.pas.                                              }
{                                                                              }
{  The Initial Developer of the Original Code is Rodrigo Ruz V.                }
{  Portions created by Rodrigo Ruz V. are Copyright 2011-2021 Rodrigo Ruz V.   }
{  All Rights Reserved.                                                        }
{******************************************************************************}
unit FExplorer.Main;

interface

implementation

uses
  System.Generics.Collections,
  System.Classes,
  SynEditHighlighter,
  uPreviewHandler,
  SynHighlighterXML,
  FExplorer.ThumbnailHandler,
  FExplorer.PreviewHandler;

initialization
  {$IFDEF WIN64}
  TFEPreviewHandler.RegisterPreview(MyFE_PreviewHandlerGUID_64,
    'SVG.PreviewHandler', 'Delphi F.E. Preview Handler 64bit');
  {$ELSE}
  TFEPreviewHandler.RegisterPreview(MyFE_PreviewHandlerGUID_32,
    'SVG.PreviewHandler', 'Delphi F.E. Preview Handler 32bit');
  {$ENDIF}

  {$IFDEF WIN64}
  TFEThumbnailProvider.RegisterThumbnailProvider(MyFE_ThumbnailProviderGUID,
    'SVG.ThumbnailProvider', 'Delphi F.E. Thumbnail Provider 64bit');
  {$ELSE}
  TFEThumbnailProvider.RegisterThumbnailProvider(MyFE_ThumbnailProviderGUID,
    'SVG.ThumbnailProvider', 'Delphi F.E. Thumbnail Provider 32bit');
  {$ENDIF}

end.

