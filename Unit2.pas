Unit Unit2;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, vectortypes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, GLWin32Viewer,
    GLCrossPlatform, BaseClasses, GLScene, GLObjects, GLCoordinates,
    GLVectorFileObjects, GLMaterial, GLFILE3DS, Vcl.ComCtrls, vectorgeometry,
    glcontext, OpenGLTokens, GLGeomObjects, Vcl.ExtCtrls, GLGraph, GLSkydome, GLNavigator, CPort;

Type
      TForm1 = Class(TForm)
      GLScene1: TGLScene;
      GLSceneViewer1: TGLSceneViewer;
      GLCamera1: TGLCamera;
      GLLightSource1: TGLLightSource;
      GLDummyCube1: TGLDummyCube;
      FF: TGLFreeForm;
      Panel1: TPanel;
      Label1: TLabel;
      Button1: TButton;
      Button2: TButton;
      Edit1: TEdit;
      Button3: TButton;
      Button4: TButton;
      TrackBar1: TTrackBar;
      Label2: TLabel;
      Label3: TLabel;
      GLXYZGrid1: TGLXYZGrid;
      GLPlane1: TGLPlane;
      Button5: TButton;
      Button6: TButton;
      FileOpenDialog1: TFileOpenDialog;
    GLPlane2: TGLPlane;
    ComPort: TComPort;
    ComDataPacket1: TComDataPacket;
    Button7: TButton;
    MemoLog: TMemo;
    Button8: TButton;
      Procedure Button1Click(Sender: TObject);
      Procedure Button2Click(Sender: TObject);
      Procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState; x,
          y: Integer);
      Procedure GLSceneViewer1MouseWheel(Sender: TObject; Shift: TShiftState;
          WheelDelta: Integer; MousePos: TPoint; Var Handled: Boolean);
      Procedure GLSceneViewer1MouseWheelDown(Sender: TObject; Shift: TShiftState;
          MousePos: TPoint; Var Handled: Boolean);
      Procedure Button3Click(Sender: TObject);
      Procedure Button4Click(Sender: TObject);
      Procedure GLSceneViewer1KeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
      Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
      Procedure TrackBar1Change(Sender: TObject);
      procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
        WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
      procedure FormCreate(Sender: TObject);
      procedure GLSceneViewer1MouseWheelUp(Sender: TObject; Shift: TShiftState;
        MousePos: TPoint; var Handled: Boolean);
      procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
        MousePos: TPoint; var Handled: Boolean);
      procedure Button5Click(Sender: TObject);
      procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComDataPacket1Packet(Sender: TObject; const Str: string);
    procedure Button8Click(Sender: TObject);

    Private
        { Private declarations }
    Public
        { Public declarations }
      Procedure dosyaOku(dosyaAdi: String);
    End;
Var
    Form1: TForm1;
    List: TStringList;
    MX, my: Integer;
    formatim: Tformatsettings; //desimal seperat�r� bulmak i�in
    panx,pany:integer;
    Cam_mer:Taffinevector;

Implementation

{$R *.dfm}

// Procedure ler de�er d�nd�rmezler sadece bir�ey icra edip b�rak�rlar........
// C++ kar��l��� Void dir.

Procedure AddFace(M: TMeshObject; f: TFGVertexNormalTexIndexList; V1, V2, v3: TAffineVector);
Var
    vi, ni, ti: Integer;
    n: TAffineVector;
Begin
    vi := M.Vertices.add(V1);
    M.Vertices.add(V2);
    M.Vertices.add(v3);

    f.vertexIndices.add(vi, vi + 1, vi + 2);
    n := CalcPlaneNormal(V1, V2, v3);

    ni := M.Normals.add(n);
    M.Normals.add(n);
    M.Normals.add(n);

    f.NormalIndices.add(ni, ni, ni);

End;

Procedure TForm1.dosyaOku(dosyaAdi: String);
Var
    I: Integer;
    txtDosyam: TextFile;
    Text: String;
    List2: TStringList;
    MO: TMeshObject;
    FG: TFGVertexNormalTexIndexList;
    yuzeycik: Array[0..2] Of TAffineVector;
    n: Integer;
Begin
    MO := TMeshObject.CreateOwned(FF.MeshObjects);
    MO.Mode := momFaceGroups;
    FG := TFGVertexNormalTexIndexList.CreateOwned(MO.FaceGroups);
    FG.Mode := fgmmTriangles;

    List2 := TStringList.Create;
    //form1.GLFreeForm1:=tGLFreeForm.create(form1);
     /////// gl ba�lang�� i�lemleri              //meshobject de�ilde vertex normal �izerek ?
    // MO := TMeshObject.CreateOwned(form1.GLFreeForm1.MeshObjects) ;
    // MO.Mode := momFaceGroups;
    // FG := TFGVertexNormalTexIndexList.CreateOwned(MO.FaceGroups);
    // FG.Mode := fgmmTriangles;
    n := 0;
    //////dosya i�lmeleri
    AssignFile(txtDosyam, dosyaAdi);
    // Reopen the file in read only mode
    Reset(txtDosyam);
    Readln(txtDosyam, Text);

    While Not Eof(txtDosyam) Do
    Begin
        //ShowMessage(text);
        Readln(txtDosyam, Text);
        List2.Delimiter := ' ';
        List2.DelimitedText := Text;
        If List2[0] <> 'endsolid' Then
        Begin

            Readln(txtDosyam, Text);
            Readln(txtDosyam, Text);
            List2.Delimiter := ' ';
            List2.DelimitedText := Text;
            yuzeycik[0].x := StrToFloat(List2[1]);
            yuzeycik[0].y := StrToFloat(List2[2]);
            yuzeycik[0].z := StrToFloat(List2[3]);
            Readln(txtDosyam, Text);
            List2.Delimiter := ' ';
            List2.DelimitedText := Text;
            yuzeycik[1].x := StrToFloat(List2[1]);
            yuzeycik[1].y := StrToFloat(List2[2]);
            yuzeycik[1].z := StrToFloat(List2[3]);
            Readln(txtDosyam, Text);
            List2.Delimiter := ' ';
            List2.DelimitedText := Text;
            yuzeycik[2].x := StrToFloat(List2[1]);
            yuzeycik[2].y := StrToFloat(List2[2]);
            yuzeycik[2].z := StrToFloat(List2[3]);
            Readln(txtDosyam, Text);
            Readln(txtDosyam, Text);
            AddFace(MO, FG, yuzeycik[0], yuzeycik[1], yuzeycik[2]);
        End;

    End;

    MO.Translate(AffineVectorMake(100*FF.TAG, 0, 0));
    showmessage('FF.Tag = '+floattostr(FF.Tag));
    FF.Tag := FF.Tag + 1;
    FF.Structurechanged;

    CloseFile(txtDosyam);
    GLSceneViewer1.Repaint;
End;

Procedure TForm1.Button1Click(Sender: TObject);
Begin
    dosyaOku('Gear.STL');
End;

Procedure TForm1.Button2Click(Sender: TObject);
Begin
    List := TStringList.Create;
    List.Delimiter := '.';
    List.DelimitedText := Edit1.Text;
    Label1.Caption := inttostr(List.Count);
    formatim:=Tformatsettings.Create;
    Label1.Caption:=label1.Caption+' Desimalsep='+formatim.DecimalSeparator;
    showmessage(' Desimal seperat�r= "'+formatim.DecimalSeparator+' "');
End;

Procedure TForm1.Button3Click(Sender: TObject);
Begin
  GLCamera1.Position.x := 200;
  GLCamera1.Position.y := 200;
  GLCamera1.Position.z := 200;
  GLCamera1.Up.x := 0;
  GLCamera1.Up.y := 0;
  GLCamera1.Up.z := 1;
  glcamera1.TargetObject := gldummycube1;
  glcamera1.TargetObject.Position.X := 0 ;
  glcamera1.TargetObject.Position.Y := 0 ;
  glcamera1.TargetObject.Position.Z := 0 ;

End;

Procedure TForm1.Button4Click(Sender: TObject);
Begin
    If GLCamera1.CameraStyle = csPerspective Then
    Begin
        GLCamera1.CameraStyle := csOrthogonal;
        GLCamera1.Focallength := 0.3; // focal length ?????????
        GLCamera1.Position.x := 200;
        GLCamera1.Position.y := 200;
        GLCamera1.Position.z := 200;
        GLCamera1.Up.x := 0;
        GLCamera1.Up.y := 0;
        GLCamera1.Up.z := 1;
    End
    Else
    Begin
        GLCamera1.CameraStyle := csPerspective;
        GLCamera1.Focallength := 50;
        GLCamera1.Position.x := 200;
        GLCamera1.Position.y := 200;
        GLCamera1.Position.z := 200;
        GLCamera1.Up.x := 0;
        GLCamera1.Up.y := 0;
        GLCamera1.Up.z := 1;
    End;
End;

procedure TForm1.Button5Click(Sender: TObject);
begin

//glcamera1.ZoomAll(glscene1.);

showmessage('Zoom all oldu');
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  if FileOpenDialog1.Execute then
  Exit;

end;

procedure TForm1.Button7Click(Sender: TObject);
begin
 ComPort.ShowSetupDialog;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
   try
    ComPort.Open;
    if ComPort.Connected then
    begin
      MemoLog.Text := MemoLog.Text + '(' + ComPort.Port + ') �leti�im Ba�ar�l�...';
      MemoLog.Lines.Add('');
    end
    else
    begin
      MemoLog.Text := MemoLog.Text + '(' + ComPort.Port + ') �leti�im Ba�ar�s�z';
    end;
  Except
    on E: Exception do
    begin
      MemoLog.Text := MemoLog.Text + 'ERROR-> ' + E.Message;
    end
  end
end;

procedure TForm1.ComDataPacket1Packet(Sender: TObject; const Str: string);
var
mt:TMatrix4f;
qa:TQuaternion;
begin
MemoLog.Lines.Add(Str);

//
//burada str yi al slit et ve rpy i g�nder
// QuaternionFromRollPitchYaw(const r, p, y : Single) : TQuaternion; //kullan�labilir belki
qua

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
EXIT;
cam_mer.X := 0;
cam_mer.Y := 0;
cam_mer.Z := 0;
end;

Procedure TForm1.FormKeyDown(Sender: TObject; Var Key: Word;
    Shift: TShiftState);
Begin
    If Key = VK_ESCAPE Then
        ShowMessage('ESCAPE e  bast�n');
End;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  //zooom
var
  zoomvector : TAffineVector;
  zoomratio : double;  // for orthogonal zoom
begin
  if glcamera1.CameraStyle=csPerspective then
  begin
    zoomvector.X := (glcamera1.Position.X - glcamera1.TargetObject.Position.X);
    zoomvector.Y := (glcamera1.Position.Y - glcamera1.TargetObject.Position.Y);
    zoomvector.Z := (glcamera1.Position.Z - glcamera1.TargetObject.Position.Z);
    scalevector(zoomvector,wheeldelta/2400);
    glcamera1.Position.X := zoomvector.X + glcamera1.Position.X ;
    glcamera1.Position.Y := zoomvector.Y + glcamera1.Position.Y;
    glcamera1.Position.Z := zoomvector.Z + glcamera1.Position.Z;
    Label1.Caption := 'zoom uzunluk := ' + floattostr(vectorlength(zoomvector));
  end
  else if glcamera1.CameraStyle = csOrthogonal then
  begin
    zoomvector.X := (glcamera1.Position.X - glcamera1.TargetObject.Position.X);
    zoomvector.Y := (glcamera1.Position.Y - glcamera1.TargetObject.Position.Y);
    zoomvector.Z := (glcamera1.Position.Z - glcamera1.TargetObject.Position.Z);
    zoomratio :=  ((vectorlength(zoomvector)+wheeldelta/6)/vectorlength(zoomvector));
    zoomvector.x :=     zoomvector.x * zoomratio;
    zoomvector.y :=     zoomvector.y * zoomratio;
    zoomvector.z :=     zoomvector.z * zoomratio;
    glcamera1.Position.X := zoomvector.X + glcamera1.TargetObject.Position.X ;
    glcamera1.Position.Y := zoomvector.Y + glcamera1.TargetObject.Position.Y;
    glcamera1.Position.Z := zoomvector.Z + glcamera1.TargetObject.Position.Z;
    Label1.Caption := 'zoom uzunluk := ' + floattostr(vectorlength(zoomvector));
    glcamera1.FocalLength := glcamera1.FocalLength * zoomratio;
  end;

end;

procedure TForm1.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
//  label1.Caption := 'Mx ' + floattostr()   //BURAYA WHEEL UP YAPTI�INDA MOUSE POZ UNU LABELDE YAZDIRCAKTIM
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    ComDataPacket1.ComPort := ComPort;
    ComDataPacket1.StartString := #13;
    ComDataPacket1.StopString := #13;
    ComDataPacket1.onPacket := ComDataPacket1Packet;
end;

Procedure TForm1.GLSceneViewer1KeyDown(Sender: TObject; Var Key: Word;
    Shift: TShiftState);
Begin

    //  if Key=ssctrl then
    //  begin
    //  Key:=0;
    //  Label1.Caption:='';
    //  end
    //  else
    //  begin
    //  Label1.Caption:='CTRL';
    //  end;

End;

Procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState; x,
    y: Integer);
var
camcen,target,arbitraryZ,camLeftRightnorm,camUpDownnorm,buffer : TAffineVector;
zoomefect: double;
Begin
  zoomefect := 1; // zoomefect katsay�s� kamera sa�-sol bir piksellik hareketine kar�� hedefin ka� birim hareket edece�idir
  camcen.X := glcamera1.Position.X;
  camcen.Y := glcamera1.Position.Y;
  camcen.Z := glcamera1.Position.Z;
  arbitraryZ.X := glcamera1.Position.X;
  arbitraryZ.Y := glcamera1.Position.Y;
  arbitraryZ.Z := glcamera1.Position.Z-1;
  target.X := glcamera1.TargetObject.Position.X;
  target.Y := glcamera1.TargetObject.Position.Y;
  target.Z := 0;
  camleftrightnorm := CalcPlaneNormal(camcen, target, arbitraryZ);
  camUpDownnorm.X := camcen.X + camleftrightnorm.X;       // camupdownnorm buffer olarak kullan�l�yor
  camUpDownnorm.Y := camcen.Y + camleftrightnorm.Y;
  camUpDownnorm.Z := camcen.Z + camleftrightnorm.Z;
  camUpDownnorm := CalcPlaneNormal(camcen,camUpDownnorm,target);

  //glplane1 i kameraya s�rekli y�neltme
  glplane1.Position := glcamera1.TargetObject.Position ;
  buffer := vectornormalize(affinevectormake(glcamera1.Position.X-glcamera1.TargetObject.Position.X,glcamera1.Position.Y-glcamera1.TargetObject.Position.Y,glcamera1.Position.Z-glcamera1.TargetObject.Position.Z));
  glplane1.Direction.x := buffer.x ;
  glplane1.Direction.y := buffer.y ;
  glplane1.Direction.z := buffer.z ;
  glplane1.Up.X := camUpDownnorm.X ;
  glplane1.Up.Y := camUpDownnorm.Y ;
  glplane1.Up.Z := camUpDownnorm.Z ;

    If (ssmiddle In Shift) and (ssright in shift) Then  //ROTATE
    Begin

        GLCamera1.Movearoundtarget(my - y, MX - x);
        //     Label1.Caption:='x '+inttostr(my - y)+' y '+inttostr(mx - x) ;
        Label1.Caption := 'x ' + inttostr(y) + ' y ' + inttostr(x);
     End
     else if (ssmiddle in shift) then  //PAN
     Begin

        // TO DO L�ST
        // Z i�inde brim vekt�r hesapla  -Yap�ld�
        // zoom efec olay�n� i�in i�ine kat
        if glcamera1.Up.Z=1 then
        begin
          if glcamera1.CameraStyle = csperspective then
          begin
            glcamera1.Position.X := glcamera1.Position.X - camleftrightnorm.X*(mx - x);
            glcamera1.Position.Y := glcamera1.Position.Y - camleftrightnorm.Y*(mx - x);
            glcamera1.Position.Z := glcamera1.Position.Z + camUpDownnorm.Z*(my - y);
            glcamera1.TargetObject.Position.X := (glcamera1.TargetObject.Position.X -  camleftrightnorm.X*(mx - x)*zoomefect) ;
            glcamera1.TargetObject.Position.Y := (glcamera1.TargetObject.Position.Y -  camleftrightnorm.Y*(mx - x)*zoomefect);
            glcamera1.TargetObject.Position.Z := (glcamera1.TargetObject.Position.Z +  camUpDownnorm.Z*(my - y)*zoomefect);
           label2.Caption:=inttostr(panx-trackbar1.Position);
          end
          else if glcamera1.CameraStyle = csorthogonal then
          begin
            scalevector(camleftrightnorm,(mx - x)/2);
            scalevector(camUpDownnorm,(my - y)/2);
            glcamera1.Position.X := glcamera1.Position.X - camleftrightnorm.X - camUpDownnorm.X ;
            glcamera1.Position.Y := glcamera1.Position.Y - camleftrightnorm.Y - camUpDownnorm.Y ;
            glcamera1.Position.Z := glcamera1.Position.Z + camleftrightnorm.Z + camUpDownnorm.Z ;
            glcamera1.TargetObject.Position.X := glcamera1.TargetObject.Position.X - camleftrightnorm.X - camUpDownnorm.X ;
            glcamera1.TargetObject.Position.Y := glcamera1.TargetObject.Position.Y - camleftrightnorm.Y - camUpDownnorm.Y ;
            glcamera1.TargetObject.Position.Z := glcamera1.TargetObject.Position.Z + camleftrightnorm.z + camUpDownnorm.z ;
          end;
      end;
    End;
    MX := x;
    my := y;
    label2.Caption :='Kamera Poz= X ' + floattostr(glcamera1.Position.X) + ' Y ' + floattostr(glcamera1.Position.Y) + ' Z ' + floattostr(glcamera1.Position.Z)  ;
    label3.Caption :='Hedef  Poz= X ' + floattostr(glcamera1.TargetObject.Position.X) + ' Y ' + floattostr(glcamera1.TargetObject.Position.Y) + ' Z ' + floattostr(glcamera1.TargetObject.Position.Z);
End;

Procedure TForm1.GLSceneViewer1MouseWheel(Sender: TObject; Shift: TShiftState;
    WheelDelta: Integer; MousePos: TPoint; Var Handled: Boolean);
Begin
    Label1.Caption := 'Mouse delta ' + inttostr(WheelDelta);
End;

Procedure TForm1.GLSceneViewer1MouseWheelDown(Sender: TObject;
    Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);
Begin
    EXIT;
    Label1.Caption := 'Mouse X ' + inttostr(MousePos.x);
End;

procedure TForm1.GLSceneViewer1MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  label1.Caption := 'mouse wheel up !!!';
end;

Procedure TForm1.TrackBar1Change(Sender: TObject);
var
  camcen,target,arbitraryZ,camLeftRightnorm : TAffineVector;
  zoomefect: double;
Begin
EXIT;
//    GLCamera1.Position.x := GLCamera1.Position.x + TrackBar1.Position;
//    GLCamera1.Position.y := GLCamera1.Position.y + TrackBar1.Position;
//    GLCamera1.Position.z := GLCamera1.Position.z + TrackBar1.Position;
End;

End.

