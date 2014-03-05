// QRCODE reader Copyright 2011 Lazar Laszlo
// http://www.webqr.com

var gCtx = null;
var gCanvas = null;
var imageData = null;
var c=0;
var stype=0;
var gUM=false;
var webkit=false;
var moz=false;
var v=null;

var camhtml='<object id="iembedflash" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="640" height="480"> '+
  		'<param name="movie" value="assets/camcanvas.swf" />'+
  		'<param name="quality" value="high" />'+
		'<param name="allowScriptAccess" value="always" />'+
  		'<embed  allowScriptAccess="always"  id="embedflash" src="assets/camcanvas.swf" quality="high" width="640" height="480" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" mayscript="true"  />'+
    '</object>';

var vidhtml = '<div class="overlay"></div><video id="v" autoplay></video>';

function dragenter(e) {
  e.stopPropagation();
  e.preventDefault();
}

function dragover(e) {
  e.stopPropagation();
  e.preventDefault();
}
function drop(e) {
  e.stopPropagation();
  e.preventDefault();

  var dt = e.dataTransfer;
  var files = dt.files;
  if(files.length>0)
  {
	handleFiles(files);
  }
  else
  if(dt.getData('URL'))
  {
	qrcode.decode(dt.getData('URL'));
  }
}

function handleFiles(f)
{
	var o=[];

	for(var i =0;i<f.length;i++)
	{
        var reader = new FileReader();
        reader.onload = (function(theFile) {
        return function(e) {
            gCtx.clearRect(0, 0, gCanvas.width, gCanvas.height);

			qrcode.decode(e.target.result);
        };
        })(f[i]);
        reader.readAsDataURL(f[i]);
    }
}

function initCanvas(ww,hh)
{
    gCanvas = document.getElementById("qr-canvas");
    var w = ww;
    var h = hh;
    gCanvas.style.width = w + "px";
    gCanvas.style.height = h + "px";
    gCanvas.width = w;
    gCanvas.height = h;
    gCtx = gCanvas.getContext("2d");
    gCtx.clearRect(0, 0, w, h);
    imageData = gCtx.getImageData( 0,0,640,480);
}

function passLine(stringPixels) {

    var coll = stringPixels.split("-");

    for(var i=0;i<320;i++) {
        var intVal = parseInt(coll[i]);
        r = (intVal >> 16) & 0xff;
        g = (intVal >> 8) & 0xff;
        b = (intVal ) & 0xff;
        imageData.data[c+0]=r;
        imageData.data[c+1]=g;
        imageData.data[c+2]=b;
        imageData.data[c+3]=255;
        c+=4;
    }

    if(c>=320*240*4) {
        c=0;
        gCtx.putImageData(imageData, 0,0);
        try{
            qrcode.decode();
        }
        catch(e){
            console.log(e);
            setTimeout(captureToCanvas, 500);
        };
    }
}

function captureToCanvas() {
    if(stype!=1)
        return;
    if(gUM)
    {
        try{
            gCtx.drawImage(v,0,0);
            try{
                qrcode.decode();
            }
            catch(e){
                console.log(e);
                setTimeout(captureToCanvas, 500);
            };
        }
        catch(e){
                console.log(e);
                setTimeout(captureToCanvas, 500);
        };
    }
    else
    {
        flash = document.getElementById("embedflash");
        try{
            flash.ccCapture();
        }
        catch(e)
        {
            console.log(e);
            setTimeout(captureToCanvas, 1000);
        }
    }
}

function htmlEntities(str) {
    return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

function read(a)
{
    var html= htmlEntities(a);
    $(".overlay").css("border-color","#7ED321");
    document.getElementById("result").innerHTML=html;
    $("#result").css("background-image","none");
    v = document.getElementById("v");
    v.pause();
    window.currentStream.stop();
    window.currentStream = null;
}

function isCanvasSupported(){
  var elem = document.createElement('canvas');
  return !!(elem.getContext && elem.getContext('2d'));
}
function success(stream) {
    if(webkit)
        v.src = window.webkitURL.createObjectURL(stream);
    else
    if(moz)
    {
        v.mozSrcObject = stream;
        v.play();
    }
    else
        v.src = stream;
    gUM=true;
    setTimeout(captureToCanvas, 500);
    window.currentStream = stream;
}

function error(error) {
    gUM=false;
    return;
}

function load()
{
	if(isCanvasSupported() && window.File && window.FileReader)
	{
		initCanvas(640,480);
		qrcode.callback = read;
	}
}

function setwebcam()
{
	$("#result").css( "display", "inline-block");
    $(".helptext").css( "display", "block");
    if(stype==1)
    {
        setTimeout(captureToCanvas, 2500);
        return;
    }
    var n=navigator;
    if(n.getUserMedia)
    {
        document.getElementById("outdiv").innerHTML = vidhtml;
        v=document.getElementById("v");
        n.getUserMedia({video: true, audio: false}, success, error);
    }
    else
    if(n.webkitGetUserMedia)
    {
        document.getElementById("outdiv").innerHTML = vidhtml;
        v=document.getElementById("v");
        webkit=true;
        n.webkitGetUserMedia({video: true, audio: false}, success, error);
    }
    else
    if(n.mozGetUserMedia)
    {
        document.getElementById("outdiv").innerHTML = vidhtml;
        v=document.getElementById("v");
        moz=true;
        n.mozGetUserMedia({video: true, audio: false}, success, error);

    }
    else
        document.getElementById("outdiv").innerHTML = camhtml;

    stype=1;
    setTimeout(captureToCanvas, 500);
}
