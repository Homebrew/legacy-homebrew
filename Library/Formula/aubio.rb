require 'formula'

class Aubio < Formula
  homepage 'http://aubio.org/'
  url 'http://aubio.org/pub/aubio-0.3.2.tar.gz'
  sha1 '8ef7ccbf18a4fa6db712a9192acafc9c8d080978'

  depends_on :macos => :lion
  depends_on :python

  depends_on 'pkg-config' => :build
  depends_on :libtool => :build
  depends_on 'swig' => :build

  depends_on 'fftw'
  depends_on 'libsamplerate'
  depends_on 'libsndfile'

  # get rid of -Wno-long-double in configure.  otherwise, breaks with modern xcode.
  # updates for py2.6+ compatibility (with is now a keyword)
  def patches
    DATA
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    For non-homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{python.xy}/site-packages:$PYTHONPATH
    EOS
  end

  def test
    # this will blow up if not everything went right
    system "#{bin}/aubiocut"
  end
end

__END__
diff --git a/configure b/configure
index 71531c9..c4b51a2 100755
--- a/configure
+++ b/configure
@@ -20109,7 +20109,6 @@ fi
   ;;
 *darwin* | *rhapsody* | *macosx*)
     LDFLAGS="$LDFLAGS -lmx"
-    AUBIO_CFLAGS="$AUBIO_CFLAGS -Wno-long-double"
     CPPFLAGS="$CPPFLAGS -I${prefix}/include"
   { echo "$as_me:$LINENO: checking for library containing strerror" >&5
 echo $ECHO_N "checking for library containing strerror... $ECHO_C" >&6; }
diff --git a/python/aubio/bench/onset.py b/python/aubio/bench/onset.py
index f9fbe23..978986c 100644
--- a/python/aubio/bench/onset.py
+++ b/python/aubio/bench/onset.py
@@ -111,7 +111,7 @@ class benchonset(bench):
   	for i in self.vlist:
 			gd.append(i['GD']) 
 			fp.append(i['FP']) 
-		d.append(Gnuplot.Data(fp, gd, with='linespoints', 
+		d.append(Gnuplot.Data(fp, gd, with_='linespoints', 
 			title="%s %s" % (plottitle,i['mode']) ))
 
 	def plotplotroc(self,d,outplot=0,extension='ps'):
@@ -147,7 +147,7 @@ class benchonset(bench):
 		for i in self.vlist:
 			x.append(i['prec']) 
 			y.append(i['recl']) 
-		d.append(Gnuplot.Data(x, y, with='linespoints', 
+		d.append(Gnuplot.Data(x, y, with_='linespoints', 
 			title="%s %s" % (plottitle,i['mode']) ))
 
 	def plotplotpr(self,d,outplot=0,extension='ps'):
@@ -172,7 +172,7 @@ class benchonset(bench):
 		for i in self.vlist:
 			x.append(i['thres']) 
 			y.append(i['dist']) 
-		d.append(Gnuplot.Data(x, y, with='linespoints', 
+		d.append(Gnuplot.Data(x, y, with_='linespoints', 
 			title="%s %s" % (plottitle,i['mode']) ))
 
 	def plotplotfmeas(self,d,outplot="",extension='ps', title="F-measure"):
@@ -205,7 +205,7 @@ class benchonset(bench):
 		for i in self.vlist:
 			x.append(i[var]) 
 			y.append(i['dist']) 
-		d.append(Gnuplot.Data(x, y, with='linespoints', 
+		d.append(Gnuplot.Data(x, y, with_='linespoints', 
 			title="%s %s" % (plottitle,i['mode']) ))
 	
 	def plotplotfmeasvar(self,d,var,outplot="",extension='ps', title="F-measure"):
@@ -244,7 +244,7 @@ class benchonset(bench):
 		total = v['Torig']
 		for i in range(len(per)): per[i] /= total/100.
 
-		d.append(Gnuplot.Data(val, per, with='fsteps', 
+		d.append(Gnuplot.Data(val, per, with_='fsteps', 
 			title="%s %s" % (plottitle,v['mode']) ))
 		#d.append('mean=%f,sigma=%f,eps(x) title \"\"'% (mean,smean))
 		#d.append('mean=%f,sigma=%f,eps(x) title \"\"'% (amean,samean))
@@ -275,7 +275,7 @@ class benchonset(bench):
 		total = v['Torig']
 		for i in range(len(per)): per[i] /= total/100.
 
-		d.append(Gnuplot.Data(val, per, with='fsteps', 
+		d.append(Gnuplot.Data(val, per, with_='fsteps', 
 			title="%s %s" % (plottitle,v['mode']) ))
 		#d.append('mean=%f,sigma=%f,eps(x) title \"\"'% (mean,smean))
 		#d.append('mean=%f,sigma=%f,eps(x) title \"\"'% (amean,samean))
diff --git a/python/aubio/gnuplot.py b/python/aubio/gnuplot.py
index a01afeb..2424131 100644
--- a/python/aubio/gnuplot.py
+++ b/python/aubio/gnuplot.py
@@ -155,7 +155,7 @@ def make_audio_plot(time,data,maxpoints=10000):
   """ create gnuplot plot from an audio file """
   import Gnuplot, Gnuplot.funcutils
   x,y = downsample_audio(time,data,maxpoints=maxpoints)
-  return Gnuplot.Data(x,y,with='lines')
+  return Gnuplot.Data(x,y,with_='lines')
 
 def make_audio_envelope(time,data,maxpoints=10000):
   """ create gnuplot plot from an audio file """
@@ -165,7 +165,7 @@ def make_audio_envelope(time,data,maxpoints=10000):
   x = [i.mean() for i in numarray.array(time).resize(len(time)/bufsize,bufsize)] 
   y = [i.mean() for i in numarray.array(data).resize(len(time)/bufsize,bufsize)] 
   x,y = downsample_audio(x,y,maxpoints=maxpoints)
-  return Gnuplot.Data(x,y,with='lines')
+  return Gnuplot.Data(x,y,with_='lines')
 
 def gnuplot_addargs(parser):
   """ add common gnuplot argument to OptParser object """
diff --git a/python/aubio/plot/keyboard.py b/python/aubio/plot/keyboard.py
index 8fe57d9..2c637a8 100755
--- a/python/aubio/plot/keyboard.py
+++ b/python/aubio/plot/keyboard.py
@@ -30,8 +30,8 @@ def draw_keyboard(firstnote = 21, lastnote = 108, y0 = 0, y1 = 1):
   yb      = [y0+(y1-y0)*2/3. for i in range(len(xb))]
   ybdelta = [(y1-y0)*1/3. for i in range(len(xb))]
 
-  whites  = Gnuplot.Data(xw,yw,xwdelta,ywdelta,with = 'boxxyerrorbars')
-  blacks  = Gnuplot.Data(xb,yb,xbdelta,ybdelta,with = 'boxxyerrorbars fill solid')
+  whites  = Gnuplot.Data(xw,yw,xwdelta,ywdelta,with_= 'boxxyerrorbars')
+  blacks  = Gnuplot.Data(xb,yb,xbdelta,ybdelta,with_= 'boxxyerrorbars fill solid')
 
   return blacks,whites
 
diff --git a/python/aubio/task/beat.py b/python/aubio/task/beat.py
index cc25250..b1d9e49 100644
--- a/python/aubio/task/beat.py
+++ b/python/aubio/task/beat.py
@@ -247,7 +247,7 @@ class taskbeat(taskonset):
 
 	def plot(self,oplots,results):
 		import Gnuplot
-		oplots.append(Gnuplot.Data(results,with='linespoints',title="auto"))
+		oplots.append(Gnuplot.Data(results,with_='linespoints',title="auto"))
 
 	def plotplot(self,wplot,oplots,outplot=None,extension=None,xsize=1.,ysize=1.,spectro=False):
 		import Gnuplot
@@ -258,5 +258,5 @@ class taskbeat(taskonset):
 		#f = make_audio_plot(time,data)
 
 		g = gnuplot_create(outplot=outplot, extension=extension)
-		oplots = [Gnuplot.Data(self.gettruth(),with='linespoints',title="orig")] + oplots
+		oplots = [Gnuplot.Data(self.gettruth(),with_='linespoints',title="orig")] + oplots
 		g.plot(*oplots)
diff --git a/python/aubio/task/notes.py b/python/aubio/task/notes.py
index a729f94..bba44fb 100644
--- a/python/aubio/task/notes.py
+++ b/python/aubio/task/notes.py
@@ -95,15 +95,15 @@ class tasknotes(task):
 		import numarray
 		import Gnuplot
 
-		oplots.append(Gnuplot.Data(now,freq,with='lines',
+		oplots.append(Gnuplot.Data(now,freq,with_='lines',
 			title=self.params.pitchmode))
-		oplots.append(Gnuplot.Data(now,ifreq,with='lines',
+		oplots.append(Gnuplot.Data(now,ifreq,with_='lines',
 			title=self.params.pitchmode))
 
 		temponsets = []
 		for i in onset:
 			temponsets.append(i*1000)
-		oplots.append(Gnuplot.Data(now,temponsets,with='impulses',
+		oplots.append(Gnuplot.Data(now,temponsets,with_='impulses',
 			title=self.params.pitchmode))
 
 	def plotplot(self,wplot,oplots,outplot=None,multiplot = 0):
@@ -117,10 +117,10 @@ class tasknotes(task):
 		# check if ground truth exists
 		#timet,pitcht = self.gettruth()
 		#if timet and pitcht:
-		#	oplots = [Gnuplot.Data(timet,pitcht,with='lines',
+		#	oplots = [Gnuplot.Data(timet,pitcht,with_='lines',
 		#		title='ground truth')] + oplots
 
-		t = Gnuplot.Data(0,0,with='impulses') 
+		t = Gnuplot.Data(0,0,with_='impulses') 
 
 		g = gnuplot_init(outplot)
 		g('set title \'%s\'' % (re.sub('.*/','',self.input)))
diff --git a/python/aubio/task/onset.py b/python/aubio/task/onset.py
index 20a1282..bb48d59 100644
--- a/python/aubio/task/onset.py
+++ b/python/aubio/task/onset.py
@@ -103,7 +103,7 @@ class taskonset(task):
 		self.maxofunc = max(ofunc)
 		# onset detection function 
 		downtime = numarray.arange(len(ofunc))*self.params.step
-		oplot.append(Gnuplot.Data(downtime,ofunc,with='lines',title=self.params.onsetmode))
+		oplot.append(Gnuplot.Data(downtime,ofunc,with_='lines',title=self.params.onsetmode))
 
 		# detected onsets
 		if not nplot:
@@ -114,8 +114,8 @@ class taskonset(task):
 			#x1 = numarray.array(onsets)*self.params.step
 			#y1 = self.maxofunc*numarray.ones(len(onsets))
 			if x1:
-				oplot.append(Gnuplot.Data(x1,y1,with='impulses'))
-				wplot.append(Gnuplot.Data(x1,y1p,with='impulses'))
+				oplot.append(Gnuplot.Data(x1,y1,with_='impulses'))
+				wplot.append(Gnuplot.Data(x1,y1p,with_='impulses'))
 
 		oplots.append((oplot,self.params.onsetmode,self.maxofunc))
 
@@ -128,7 +128,7 @@ class taskonset(task):
 			t_onsets = aubio.txtfile.read_datafile(datafile)
 			x2 = numarray.array(t_onsets).resize(len(t_onsets))
 			y2 = self.maxofunc*numarray.ones(len(t_onsets))
-			wplot.append(Gnuplot.Data(x2,y2,with='impulses'))
+			wplot.append(Gnuplot.Data(x2,y2,with_='impulses'))
 			
 			tol = 0.050 
 
diff --git a/python/aubio/task/pitch.py b/python/aubio/task/pitch.py
index d8ea1e2..a531a62 100644
--- a/python/aubio/task/pitch.py
+++ b/python/aubio/task/pitch.py
@@ -156,7 +156,7 @@ class taskpitch(task):
 
 		time = [ (i+self.params.pitchdelay)*self.params.step for i in range(len(pitch)) ]
 		pitch = [aubio_freqtomidi(i) for i in pitch]
-		oplots.append(Gnuplot.Data(time,pitch,with='lines',
+		oplots.append(Gnuplot.Data(time,pitch,with_='lines',
 			title=self.params.pitchmode))
 		titles.append(self.params.pitchmode)
 
@@ -170,7 +170,7 @@ class taskpitch(task):
 		if truth:
 			timet,pitcht = self.gettruth()
 			if timet and pitcht:
-				oplots = [Gnuplot.Data(timet,pitcht,with='lines',
+				oplots = [Gnuplot.Data(timet,pitcht,with_='lines',
 					title='ground truth')] + oplots
 
 		g = gnuplot_create(outplot=outplot, extension=extension)
