require 'formula'

class EnblendEnfuse < Formula
  homepage 'http://enblend.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/enblend/enblend-enfuse/enblend-enfuse-4.1/enblend-enfuse-4.1.1.tar.gz'
  sha1 'bc18fca3033b031d603b22678b2e680a0ffae1b6'

  option 'disable-gpu', 'Build with GPU support'

  depends_on :libpng
  depends_on :x11 => :optional
  depends_on 'boost'
  depends_on 'gsl'
  depends_on 'jpeg'
  depends_on 'lcms2'
  depends_on 'libtiff'
  depends_on 'homebrew/science/libvigra'
  depends_on 'openexr' => :optional

  def patches
    # builds against the multithreaded boost system library
    DATA
  end

  def install

    args = [ "--disable-debug",
             "--disable-dependency-tracking",
             "--prefix=#{prefix}" ]

    args << "--without-x" unless build.with? 'x11'

    if build.include? 'disable-gpu'
      enable_gpu = "no"
    else
      enable_gpu = "yes"
    end

    args << "--enable-gpu-support=#{enable_gpu}"
    
    system "./configure", *args
    system "make install"
  end

  test do
    system "#{libexec}/enblend", \
      "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png", \
      "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png"

    system "#{libexec}/enfuse", \
      "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png", \
      "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png"
  end

end

__END__
diff --git a/configure.orig b/configure
index 98699f5..70e286b 100755
--- a/configure.orig
+++ b/configure
@@ -8279,7 +8279,7 @@ fi
 
 
 
-LIBS="-lboost_system $LIBS"
+LIBS="-lboost_system-mt $LIBS"
 { $as_echo "$as_me:${as_lineno-$LINENO}: checking for new Boost system library" >&5
 $as_echo_n "checking for new Boost system library... " >&6; }
 cat confdefs.h - <<_ACEOF >conftest.$ac_ext
