object FrmAbout: TFrmAbout
  Left = 651
  Top = 323
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  ClientHeight = 312
  ClientWidth = 436
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    436
    312)
  TextHeight = 13
  object TitleLabel: TLabel
    Left = 190
    Top = 8
    Width = 187
    Height = 41
    AutoSize = False
    Caption = 'Anteprima Fattura Elettronica'
    WordWrap = True
  end
  object LabelVersion: TLabel
    Left = 394
    Top = 64
    Width = 41
    Height = 13
    Alignment = taRightJustify
    Caption = 'Versione'
  end
  object SVGIconImage1: TSVGIconImage
    Left = 383
    Top = 8
    Width = 52
    Height = 49
    AutoSize = False
    SVGText = 
      '<?xml version="1.0" encoding="UTF-8"?>'#13#10'<svg width="210mm" heigh' +
      't="210mm" version="1.1" viewBox="0 0 210 210" xmlns="http://www.' +
      'w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns' +
      ':dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.' +
      'org/1999/02/22-rdf-syntax-ns#">'#13#10' <metadata>'#13#10'  <rdf:RDF>'#13#10'   <c' +
      'c:Work rdf:about="">'#13#10'    <dc:format>image/svg+xml</dc:format>'#13#10 +
      '    <dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImag' +
      'e"/>'#13#10'    <dc:title/>'#13#10'   </cc:Work>'#13#10'  </rdf:RDF>'#13#10' </metadata>' +
      #13#10' <g>'#13#10'  <g>'#13#10'   <path d="m205 194.35v3.4394c0 5.54-4.46 10-10 ' +
      '10h-180c-5.54 0-10-4.46-10-10v-3.4394z" opacity=".4"/>'#13#10'   <path' +
      ' d="m15 5 145 1.9e-6 45 45v145c0 5.54-4.46 10-10 10h-180c-5.54 0' +
      '-10-4.46-10-10v-180c0-5.54 4.46-10 10-10z" fill="#607d8b"/>'#13#10'   ' +
      '<path d="m205 52.5c-12.913-0.0125-22.087 0.03402-35 0-8.1511-0.0' +
      '6177-10.038-5.8043-9.9994-9.9522v-3.2079l44.999 10.66z" fill="#4' +
      'd646f"/>'#13#10'   <path d="m205 50c-12.913-0.0125-22.087 0.03402-35 0' +
      '-8.1511-0.06177-10.038-5.8522-10-10v-35z" fill="#b1d1e0"/>'#13#10'   <' +
      'path d="m15 5 145 1.9e-6v3h-145c-5.1455 0.1499-8.1294 3.7699-10 ' +
      '7 0-5.54 4.46-10 10-10z" fill="#708a96"/>'#13#10'   <path d="m5 150.82' +
      'h200v4h-200zm0-80.817h200v12h-200z" fill="#b1d1e0" opacity=".5"/' +
      '>'#13#10'   <path d="m135.56 168.5h18.183v5.3769h-12.35v4.389c0.55733-' +
      '0.15199 1.1146-0.266 1.672-0.342 0.56999-0.0886 1.159-0.133 1.76' +
      '7-0.133 3.458 0 6.1496 0.86764 8.0749 2.603 1.9253 1.7226 2.888 ' +
      '4.1293 2.888 7.2199 0 3.0653-1.0513 5.4656-3.154 7.2009-2.0899 1' +
      '.7353-4.9969 2.603-8.7209 2.603-1.6086 0-3.2046-0.15832-4.7879-0' +
      '.475-1.5706-0.30399-3.135-0.77266-4.6929-1.406v-5.7569c1.5453 0.' +
      '88666 3.0083 1.5517 4.3889 1.995 1.3933 0.4433 2.7043 0.66496 3.' +
      '9329 0.66496 1.7733 0 3.1666-0.43066 4.18-1.292 1.026-0.87399 1.' +
      '539-2.052 1.539-3.534 0-1.4946-0.51298-2.6726-1.539-3.5339-1.013' +
      '3-0.86132-2.4066-1.292-4.18-1.292-1.0513 0-2.1723 0.13934-3.3629' +
      ' 0.418-1.1907 0.26599-2.47 0.68399-3.838 1.254zm-16.872 6.0229-8' +
      '.0179 11.875h8.0179zm-1.216-6.0229h8.1319v17.898h4.0469v5.3009h-' +
      '4.0469v5.1679h-6.9159v-5.1679h-12.578v-6.2699zm-23.921 21.014h6.' +
      '8399v5.7949l-4.6929 6.5286h-4.8741l1.7684-6.5286 0.98776-3.5733z' +
      'm-12.92-7.9419c1.9126 0.49399 3.363 1.3553 4.3509 2.584 1.0006 1' +
      '.216 1.501 2.7676 1.501 4.6549 0 2.812-1.0767 4.9526-3.23 6.4219' +
      '-2.1533 1.4567-5.2946 2.185-9.4239 2.185-1.4566 0-2.9196-0.12039' +
      '-4.3889-0.361-1.4566-0.22799-2.9006-0.57631-4.3319-1.045v-5.6429' +
      'c1.368 0.68401 2.7233 1.2033 4.0659 1.558 1.3553 0.34199 2.6853 ' +
      '0.51298 3.9899 0.51298 1.938 0 3.4199-0.33565 4.4459-1.007 1.038' +
      '6-0.67132 1.558-1.634 1.558-2.888 0-1.292-0.53198-2.2673-1.596-2' +
      '.926-1.0513-0.67132-2.6093-1.007-4.6739-1.007h-2.926v-4.7119h3.0' +
      '78c1.8366 0 3.2046-0.28498 4.1039-0.85498 0.89932-0.58268 1.349-' +
      '1.463 1.349-2.641 0-1.0893-0.43698-1.9316-1.311-2.527-0.87399-0.' +
      '59532-2.109-0.893-3.705-0.893-1.178 0-2.3686 0.133-3.572 0.39901' +
      '-1.2033 0.266-2.4003 0.65865-3.5909 1.178v-5.3579c1.444-0.40533 ' +
      '2.8753-0.70932 4.2939-0.91198 1.4186-0.20267 2.812-0.304 4.1799-' +
      '0.304 3.686 0 6.4409 0.60797 8.2649 1.824 1.8366 1.2033 2.755 3.' +
      '021 2.755 5.4529 0 1.6593-0.437 3.021-1.311 4.0849-0.87399 1.051' +
      '3-2.166 1.7923-3.8759 2.223zm-33.991 9.9179h12.483v5.3769h-20.61' +
      '5v-5.3769l10.355-9.1389c0.92466-0.83599 1.6086-1.653 2.052-2.451' +
      ' 0.44333-0.798 0.66499-1.6276 0.66499-2.489 0-1.33-0.44966-2.400' +
      '3-1.349-3.211-0.88665-0.81063-2.071-1.216-3.553-1.216-1.14 0-2.3' +
      '876 0.24701-3.7429 0.74101-1.3553 0.48133-2.8056 1.2033-4.3509 2' +
      '.166v-6.2319c1.6466-0.54467 3.2743-0.95634 4.8829-1.235 1.6086-0' +
      '.29133 3.1856-0.43699 4.7309-0.43699 3.3946 0 6.0292 0.74732 7.9' +
      '039 2.242 1.8873 1.4946 2.831 3.5783 2.831 6.2509 0 1.5453-0.398' +
      '99 2.9893-1.197 4.3319-0.79799 1.33-2.4763 3.1159-5.0349 5.3579z' +
      'm-33.725 0.32299h6.4599v-18.335l-6.6309 1.368v-4.9779l6.5929-1.3' +
      '68h6.9539v23.313h6.4599v5.0539h-19.836zm167.92-2.5116c0.61522 1.' +
      '9362 1.5652 3.4109 2.8499 4.4242 1.2847 0.99522 2.9585 1.4928 5.' +
      '0214 1.4928 0.56094 0 1.1671-0.0452 1.8186-0.13577 0.66952-0.108' +
      '48 1.339-0.25333 2.0086-0.43427 0.6695-0.18096 1.33-0.38906 1.98' +
      '14-0.62429 0.65141-0.25334 1.2576-0.5157 1.8186-0.78713v6.0256c-' +
      '1.4476 0.63333-2.8681 1.0948-4.2614 1.3843-1.3933 0.30762-2.8409' +
      ' 0.46144-4.3428 0.46144-3.8904 0-7.057-0.99522-9.4999-2.9857-2.4' +
      '247-1.9904-4.0442-4.9309-4.8585-8.8213h-3.7185v-4.18h3.23c-0.036' +
      '3-0.34379-0.0544-0.65142-0.0544-0.92284v-0.89569c0-0.41619 9e-3 ' +
      '-0.84143 0.0271-1.2757 0.018-0.43429 0.0451-0.87762 0.0814-1.33h' +
      '-3.2842v-4.1799h3.9899c0.47046-1.9 1.149-3.6009 2.0357-5.1028 0.' +
      '90476-1.5019 1.9724-2.7685 3.2028-3.7999 1.2485-1.0314 2.6509-1.' +
      '8186 4.2071-2.3614 1.5562-0.56095 3.248-0.84142 5.0756-0.84142 0' +
      '.77809 0 1.5109 0.018 2.1986 0.0543s1.3571 0.10848 2.0085 0.2171' +
      '6c0.65143 0.0906 1.2938 0.21717 1.9271 0.37999 0.65143 0.16286 1' +
      '.33 0.37096 2.0357 0.62429v6.5142c-1.4114-0.68762-2.7776-1.1762-' +
      '4.0985-1.4657-1.3028-0.2895-2.4971-0.43426-3.5828-0.43426-2.0085' +
      ' 0-3.6642 0.56095-4.9671 1.6828-1.2847 1.1038-2.2347 2.6147-2.85' +
      ' 4.5328h9.8256v4.18h-10.721c-0.0363 0.36191-0.0544 0.71477-0.054' +
      '4 1.0586v2.1171c0 0.37998 0.018 0.79615 0.0544 1.2485h10.721v4.1' +
      '799z" fill="#4d646f" stroke-width=".36769"/>'#13#10'  </g>'#13#10'  <path d=' +
      '"m135.56 164.92h18.183v5.3769h-12.35v4.389q0.83598-0.22801 1.672' +
      '-0.342 0.85499-0.13299 1.767-0.13299 5.1869 0 8.0749 2.603 2.888' +
      ' 2.5839 2.888 7.2199 0 4.5979-3.154 7.2009-3.1349 2.603-8.7209 2' +
      '.603-2.413 0-4.7879-0.47499-2.356-0.45601-4.6929-1.406v-5.7569q2' +
      '.318 1.33 4.3889 1.995 2.09 0.66498 3.9329 0.66498 2.66 0 4.18-1' +
      '.292 1.539-1.311 1.539-3.534 0-2.242-1.539-3.534-1.52-1.292-4.18' +
      '-1.292-1.577 0-3.3629 0.41801-1.786 0.399-3.838 1.254zm-16.872 6' +
      '.0229-8.0179 11.875h8.0179zm-1.216-6.0229h8.1319v17.898h4.0469v5' +
      '.3009h-4.0469v5.1679h-6.9159v-5.1679h-12.578v-6.2699zm-23.921 21' +
      '.014h6.8399v5.7949l-4.6929 7.0869h-4.0469l1.9-7.0869zm-12.92-7.9' +
      '419q2.869 0.74099 4.3509 2.584 1.501 1.824 1.501 4.6549 0 4.2179' +
      '-3.23 6.4219-3.2299 2.185-9.4239 2.185-2.185 0-4.3889-0.361-2.18' +
      '5-0.34199-4.3319-1.045v-5.6429q2.052 1.026 4.0659 1.558 2.033 0.' +
      '51297 3.9899 0.51297 2.907 0 4.4459-1.007 1.558-1.007 1.558-2.88' +
      '8 0-1.938-1.596-2.926-1.577-1.007-4.6739-1.007h-2.926v-4.7119h3.' +
      '078q2.755 0 4.1039-0.85499 1.349-0.87397 1.349-2.641 0-1.634-1.3' +
      '11-2.527-1.311-0.89297-3.705-0.89297-1.767 0-3.572 0.39898-1.805' +
      ' 0.399-3.5909 1.178v-5.3579q2.166-0.608 4.2939-0.91201 2.128-0.3' +
      '0398 4.1799-0.30398 5.5289 0 8.2649 1.824 2.755 1.805 2.755 5.45' +
      '29 0 2.489-1.311 4.085-1.311 1.577-3.8759 2.223zm-33.991 9.9179h' +
      '12.483v5.3769h-20.615v-5.3769l10.355-9.1389q1.387-1.254 2.052-2.' +
      '451 0.66499-1.197 0.66499-2.489 0-1.995-1.349-3.211-1.33-1.216-3' +
      '.553-1.216-1.71 0-3.7429 0.74099-2.033 0.722-4.3509 2.166v-6.231' +
      '9q2.47-0.81699 4.8829-1.235 2.413-0.43699 4.7309-0.43699 5.0919 ' +
      '0 7.9039 2.242 2.831 2.242 2.831 6.2509 0 2.318-1.197 4.3319-1.1' +
      '97 1.995-5.0349 5.3579zm-33.725 0.32299h6.4599v-18.335l-6.6309 1' +
      '.368v-4.9779l6.5929-1.368h6.9539v23.313h6.4599v5.0539h-19.836zm1' +
      '67.92-2.5116q0.92281 2.9042 2.8499 4.4242 1.9271 1.4928 5.0214 1' +
      '.4928 0.84141 0 1.8186-0.13577 1.0043-0.16284 2.0086-0.43428 1.0' +
      '043-0.27143 1.9814-0.62428 0.97714-0.37998 1.8186-0.78713v6.0256' +
      'q-2.1714 0.94998-4.2614 1.3843-2.09 0.46141-4.3428 0.46141-5.835' +
      '6 0-9.4999-2.9857-3.6371-2.9856-4.8585-8.8213h-3.7185v-4.18h3.23' +
      'q-0.0544-0.5157-0.0544-0.92285 0-0.43427 0-0.89569 0-0.62429 0.0' +
      '271-1.2757 0.027-0.65142 0.0814-1.33h-3.2842v-4.1799h3.9899q0.70' +
      '57-2.85 2.0357-5.1028 1.3571-2.2528 3.2028-3.8 1.8728-1.5471 4.2' +
      '071-2.3614 2.3342-0.84142 5.0756-0.84142 1.1671 0 2.1986 0.0543 ' +
      '1.0314 0.0544 2.0085 0.21715 0.97714 0.13576 1.9271 0.37999 0.97' +
      '714 0.24429 2.0357 0.62429v6.5142q-2.1171-1.0314-4.0985-1.4657-1' +
      '.9542-0.43428-3.5828-0.43428-3.0128 0-4.9671 1.6828-1.9271 1.655' +
      '7-2.85 4.5328h9.8256v4.18h-10.721q-0.0544 0.54284-0.0544 1.0585 ' +
      '0 0.48855 0 1.0043 0 0.54284 0 1.1128 0 0.57 0.0544 1.2486h10.72' +
      '1v4.1799z" fill="#fff" stroke-width=".36769"/>'#13#10'  <g>'#13#10'   <path ' +
      'd="m155 127h18v12h-18zm0-27h18v12h-18zm-117 27h92v12h-92zm0-27h9' +
      '2v12h-92z" fill="#4d646f"/>'#13#10'   <path d="m155 124h18v12h-18zm0-2' +
      '7h18v12h-18zm-117 27h92v12h-92zm0-27h92v12h-92z" fill="#fff"/>'#13#10 +
      '   <path d="m123.26 53.554 30.81 0.55943v8.4502h-30.81zm-35.078-' +
      '11.143c19.096-45.754 24.131-13.154 24.131 20.153h-10.57v-27.494l' +
      '-8.2056 19.439h-11.122l-7.7366-19.34v27.395h-10.599v-22.633c0-22' +
      '.845 9.8387-31.039 24.102 2.4801zm-43.714-1.9746 15.042 22.127h-' +
      '15.588l-8.2703-12.517-8.862 12.517h-14.95l15.042-22.127z" fill="' +
      '#4d646f" stroke-width=".3665"/>'#13#10'  </g>'#13#10'  <path d="m123.26 16.1' +
      '74h11.18v34.904h19.63v8.4502h-30.81zm-59.18 0h14.229l9.8731 23.2' +
      '02 9.9311-23.202h14.2v43.354h-10.57v-31.71l-9.9892 23.376h-7.085' +
      '4l-9.9892-23.376v31.71h-10.599zm-21.692 21.227 15.042 22.127h-11' +
      '.644l-10.134-14.81-10.047 14.81h-11.702l15.042-22.127-14.461-21.' +
      '227h11.673l9.4956 13.967 9.4665-13.967h11.732z" fill="#fff" stro' +
      'ke-width=".3665"/>'#13#10' </g>'#13#10'</svg>'#13#10
  end
  object SVGIconImage2: TSVGIconImage
    Left = 9
    Top = 3
    Width = 175
    Height = 53
    AutoSize = False
    SVGText = 
      '<?xml version="1.0" encoding="UTF-8"?>'#13#10'<svg version="1.1" viewB' +
      'ox="0 0 1500 500" xmlns="http://www.w3.org/2000/svg">'#13#10' <path d=' +
      '"m 29.959524,376.13727c-0.76451-0.65379-6.0819-10.147-9.7722-17.' +
      '448-12.307-24.347-18.221-44.831-19.118-66.237-0.86096-20.522 6.3' +
      '28-41.535 20.128-58.833 16.357-20.505 41.513-34.639 70.082-39.37' +
      '6 7.1343-1.183 11.248-1.5176 20.132-1.637 4.6266-0.0622 8.4572-0' +
      '.15828 8.5124-0.21351 0.0553-0.0552-0.1747-1.3857-0.51098-2.9567' +
      '-0.53126-2.4817-0.61063-3.5816-0.60524-8.387 7e-3 -6.2771 0.3420' +
      '2-8.2278 2.2667-13.199 1.2078-3.1196 1.6207-3.5926 3.0344-3.4764' +
      'l1.0134 0.0833 3.0432 5.9258c5.5025 10.714 10.216 17.563 17.574 ' +
      '25.534 1.6238 1.7589 1.9119 1.962 2.7833 1.962 0.64759 0 1.1636-' +
      '0.19159 1.5461-0.57405l0.57407-0.57406-0.70016-2.8365c-3.6152-14' +
      '.647-2.2014-26.711 4.2573-36.329 2.2951-3.4176 3.1823-4.3009 4.3' +
      '2-4.3009 1.0179 0 1.6943 0.50473 1.8776 1.4011 0.0644 0.31581 0.' +
      '43375 2.2334 0.82046 4.2614 1.8272 9.5824 5.785 20.44 10.921 29.' +
      '961 4.0554 7.5178 7.9975 13.592 16.45 25.346 7.444 10.352 8.7704' +
      ' 12.251 10.854 15.539 7.0094 11.059 9.6667 18.641 9.6451 27.522-' +
      '0.0113 4.6803-0.5214 7.6596-2.0764 12.127-1.0191 2.9278-3.5089 8' +
      '.1077-4.1546 8.6438-0.22033 0.18285-0.85331 0.29518-1.4066 0.249' +
      '57l-1.006-0.083-5.5398-11.061c-6.3211-12.621-9.0304-17.596-10.14' +
      '8-18.633-0.59271-0.54997-1.0452-0.72432-1.8808-0.72432-0.98261 0' +
      '-1.2426 0.14785-2.432 1.3827-2.3867 2.4779-3.8608 6.6791-3.3356 ' +
      '9.5062 0.36987 1.991 0.51832 2.2984 3.5294 7.309 10.68 17.771 14' +
      '.324 32.016 11.222 43.858-1.5491 5.9143-5.8604 11.878-11.474 15.' +
      '87-2.5304 1.7998-3.3379 1.9794-4.2996 0.95558l-0.61494-0.65449 0' +
      '.50117-3.2302c0.65217-4.2032 0.66424-10.016 0.0271-13.035-2.4378' +
      '-11.55-11.258-23.668-24.147-33.174-8.0866-5.9645-17.017-10.226-2' +
      '5.81-12.315-7.9227-1.8827-19.198-2.0312-28.97-0.38191-19.669 3.3' +
      '199-36.586 14.363-48.172 31.447-7.7223 11.386-13.611 25.896-16.1' +
      '91 39.9-1.2558 6.8129-1.5873 10.664-1.5873 18.436 0 7.276 0.3376' +
      '8 11.622 1.3195 16.984 0.78891 4.3082 0.78674 4.7164-0.02831 5.3' +
      '574-0.87842 0.69101-1.7289 0.72922-2.4526 0.11033z" fill="#9c9b9' +
      'b" stroke="#7a7a7a" stroke-width="2"/>'#13#10' <path d="m 209.67,498.7' +
      '6727c-49.73-2.4409-94.499-24.132-120.6-58.433-10.493-13.787-18.0' +
      '28-29.405-21.983-45.562-3.3018-13.493-4.5368-30.212-3.0544-41.34' +
      '9 1.7015-12.783 6.6481-26.898 12.468-35.579 8.5726-12.788 21.628' +
      '-21.916 34.982-24.461 4.1317-0.78725 7.7046-1.0841 8.5095-0.7069' +
      '2 1.0166 0.47634 1.258 1.5346 0.68668 3.0122-1.5375 3.9774-2.547' +
      ' 7.1288-3.1404 9.8039-4.627 20.86 4.2672 41.937 23.959 56.779 22' +
      '.585 17.022 55.759 22.871 85.69 15.111 27.034-7.0098 47.752-24.1' +
      '84 54.636-45.288 2.0096-6.1608 2.3807-8.6319 2.3739-15.805-6e-3 ' +
      '-5.7157-0.0603-6.4431-0.71715-9.5114-0.3912-1.8272-1.3184-5.205-' +
      '2.0606-7.506-5.4327-16.845-15.016-33.609-30.696-53.696-19.119-24' +
      '.493-33.999-44.335-46.613-62.154-41.496-58.622-60.928-99.326-60.' +
      '937-127.64-7e-3 -22.885 12.471-38.088 38.327-46.7 21.684-7.2219 ' +
      '54.628-9.6274 97.438-7.1147 17.919 1.0517 47.601 3.8904 48.503 4' +
      '.6385 1.0235 0.84942 0.94317 2.8249-0.13282 3.266-0.24024 0.0984' +
      '29-2.57 0.58531-5.1774 1.0818-19.711 3.7538-32.714 9.5741-41.244' +
      ' 18.462-4.7938 4.9944-7.7248 10.472-9.1962 17.186-3.8243 17.452 ' +
      '4.0794 41.758 24.368 74.935 8.5349 13.957 18.359 28.39 37.103 54' +
      '.509 4.7815 6.6632 11.436 15.967 14.786 20.675 3.3509 4.7077 7.3' +
      '44 10.159 8.8736 12.115 8.5163 10.888 17.588 24.64 23.713 35.95 ' +
      '17.538 32.378 24.604 63.991 21.134 94.548-0.21386 1.8831-0.5746 ' +
      '5.1422-0.80164 7.2427-2.2681 20.983-9.8142 43.451-21.318 63.471-' +
      '14.952 26.022-36.383 47.977-61.367 62.865-30.6 18.235-70.426 27.' +
      '724-108.51 25.855z" fill="#3ba08b" stroke="#227b69" stroke-width' +
      '="2"/>'#13#10' <path d="m 565.03665,411.47 21.235-52.192h153.98v52.192' +
      'zm246.04-227.41h-42.872v-52.192h137.93v52.192h-42.872v227.41h-52' +
      '.192zm123.03-52.192h52.192v279.6h-52.192zm141.66 0h52.192v279.6h' +
      '-52.192zm80.152 227.41h137.93v52.192h-137.93zm242.67-61.512h-76.' +
      '773v-52.192h55.547l-25.015-61.512h-30.532v-52.192h61.512l113.7 2' +
      '79.6h-52.192zm-393.66-52.192h52.192v52.192h-52.192zm150.99 0h137' +
      '.93v52.192h-137.93zm-523.44 0h107.76v52.192h-128.97zm25.015-61.5' +
      '12 21.235-52.192h61.512v52.192zm498.42-52.192h137.93v52.192h-137' +
      '.93z" fill="#3ba08b" stroke="#227b69" stroke-width="4"/>'#13#10'</svg>' +
      #13#10
  end
  object Panel1: TPanel
    Left = 0
    Top = 261
    Width = 436
    Height = 51
    Align = alBottom
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 0
    object btnOK: TStyledButton
      Left = 351
      Top = 16
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'CHIUDI'
      Default = True
      TabOrder = 2
      OnClick = btnOKClick
    end
    object btnIssues: TStyledButton
      Left = 8
      Top = 16
      Width = 125
      Height = 25
      Caption = 'Segnala problema...'
      ImageIndex = 0
      TabOrder = 0
      OnClick = btnIssuesClick
    end
    object btnCheckUpdates: TStyledButton
      Left = 139
      Top = 16
      Width = 125
      Height = 25
      Caption = 'Verifica aggiornamenti'
      ImageIndex = 3
      TabOrder = 1
      Visible = False
      OnClick = btnCheckUpdatesClick
    end
  end
  object MemoCopyRights: TMemo
    Left = 8
    Top = 89
    Width = 427
    Height = 109
    Anchors = [akLeft, akTop, akBottom]
    Color = clBtnFace
    Lines.Strings = (
      'Autori:'
      'Carlo Barazzetta & Andrea Magni'
      'https://github.com/EtheaDev/FExplorer'
      'Copyright '#169' 2021-2023 all rights reserved.'
      ''
      'Librerie di terze parti di Ethea:'
      'SVGIconImageList'
      'https://github.com/EtheaDev/SVGIconImageList/'
      ''
      'StyledComponents'
      'https://github.com/EtheaDev/StyledComponents'
      ''
      'PKCS7Extractor'
      'https://github.com/DelphiClubItalia/PKCS7Extractor'
      'Copyright '#169' 2018 Delphi Club Italia - LGPL v3'
      'Original authors:'
      '  Christian Cristofori - github@christiancristofori.it'
      '  Giancarlo Oneglio - giancarlo.oneglio@gmail.com'
      ''
      'OpenSLL Library: Cryptography and SSL/TLS Toolkit'
      'Copyright '#169' 1998-2018 The OpenSSL Project.  All rights reserved.'
      ''
      'Delphi Preview Handler'
      'https://github.com/RRUZ/delphi-preview-handler'
      'The Initial Developer of the Original Code is Rodrigo Ruz V.'
      
        'Portions created by Rodrigo Ruz V. are Copyright '#169' 2011-2023 Rod' +
        'rigo Ruz V.'
      ''
      'Librerie di terze parti utilizzate'
      'SynEdit http://synedit.svn.sourceforge.net/viewvc/synedit/'
      'all rights reserved.'
      ''
      'Synopse/SynPDF https://github.com/synopse/SynPDF'
      'Copyright '#169' Synopse: all right reserved.'
      ''
      'HtmlToPdf https://github.com/MuzioValerio/HtmlToPdf'
      'Copyright '#169' Muzio Valerio.'
      ''
      
        'Image32 Library - http://www.angusj.com/delphi/image32/Docs/_Bod' +
        'y.htm'
      'Copyright '#169'2019-2023 Angus Johnson.'
      ''
      
        '- StyleSheet FatturaPA in South-Tyrol - https://github.com/provb' +
        'z/fatturapa-xsl-'
      'southtyrol'
      'Copyright '#169'2017 Ferdinand Tavernini'
      ''
      'HTMLViewer - https://github.com/BerndGabriel/HtmlViewer'
      'Copyright (c) 1995 - 2008 by L. David Baldwin'
      'Copyright (c) 1995 - 2023 by Anders Melander (DitherUnit.pas)'
      'Copyright (c) 1995 - 2023 by Ron Collins (HtmlGif1.pas)'
      'Copyright (c) 2008 - 2009 by Sebastian Zierer (Delphi 2009 Port)'
      'Copyright (c) 2008 - 2010 by Arvid Winkelsdorf (Fixes)'
      'Copyright (c) 2009 - 2023 by HtmlViewer Team')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object LinkLabel1: TLinkLabel
    Left = 8
    Top = 62
    Width = 214
    Height = 19
    Caption = 
      '<a href="https://github.com/EtheaDev/FExplorer">https://github.c' +
      'om/EtheaDev/FExplorer</a>'
    TabOrder = 2
    UseVisualStyle = True
    OnLinkClick = LinkLabel1LinkClick
  end
  object panelLibrary: TGroupBox
    Left = 8
    Top = 204
    Width = 427
    Height = 55
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'OpenSSL Library Info'
    TabOrder = 3
    object OpenSSLlabelLocation: TLabel
      Left = 96
      Top = 17
      Width = 12
      Height = 13
      Caption = '...'
    end
    object OpenSSLlabelVersion: TLabel
      Left = 96
      Top = 34
      Width = 12
      Height = 13
      Caption = '...'
    end
    object labelLocationL: TLabel
      Left = 8
      Top = 17
      Width = 77
      Height = 13
      Caption = 'Library location:'
    end
    object labelVersionL: TLabel
      Left = 8
      Top = 34
      Width = 75
      Height = 13
      Caption = 'Library version:'
    end
  end
end
