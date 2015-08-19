class Rrdtool < Formula
  desc "Round Robin Database"
  homepage "https://oss.oetiker.ch/rrdtool/index.en.html"
  url "https://oss.oetiker.ch/rrdtool/pub/rrdtool-1.5.3.tar.gz"
  sha256 "79e7b2f5cf74843e89fe4d08925f955268fd21736cbea03e54ae83320fc6129f"

  bottle do
    sha256 "dfa037b903c0fd8206c6f3e99ed05ca2d2543419895f7f0e081fabece5b6616f" => :yosemite
    sha256 "1d7526bbb9a963d0f7c146b7fc538c4289998fe8f047713bcac2aaed6e906551" => :mavericks
    sha256 "2ec6be27efb28a6a493f4dda63291c9f464976161627e8135c5a80c89ac8aed9" => :mountain_lion
  end

  head do
    url "https://github.com/oetiker/rrdtool-1.x.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "pango"
  depends_on "lua" => :optional

  env :userpaths # For perl, ruby

  # Ha-ha, but sleeping is annoying when running configure a lot
  patch :DATA

  def install
    ENV.libxml2

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-tcl
      --with-tcllib=/usr/lib
      --disable-perl-site-install
      --disable-ruby-site-install
    ]

    system "./bootstrap" if build.head?
    system "./configure", *args

    # Needed to build proper Ruby bundle
    ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}"

    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}", "install"
    prefix.install "bindings/ruby/test.rb"
  end

  test do
    system "#{bin}/rrdtool", "create", "temperature.rrd", "--step", "300",
      "DS:temp:GAUGE:600:-273:5000", "RRA:AVERAGE:0.5:1:1200",
      "RRA:MIN:0.5:12:2400", "RRA:MAX:0.5:12:2400", "RRA:AVERAGE:0.5:12:2400"
    system "#{bin}/rrdtool", "dump", "temperature.rrd"
  end
end

__END__
diff --git a/configure b/configure
index 266754d..d21ab33 100755
--- a/configure
+++ b/configure
@@ -23868,18 +23868,6 @@ $as_echo_n "checking in... " >&6; }
 { $as_echo "$as_me:${as_lineno-$LINENO}: result: and out again" >&5
 $as_echo "and out again" >&6; }

-echo $ECHO_N "ordering CD from http://tobi.oetiker.ch/wish $ECHO_C" 1>&6
-sleep 1
-echo $ECHO_N ".$ECHO_C" 1>&6
-sleep 1
-echo $ECHO_N ".$ECHO_C" 1>&6
-sleep 1
-echo $ECHO_N ".$ECHO_C" 1>&6
-sleep 1
-echo $ECHO_N ".$ECHO_C" 1>&6
-sleep 1
-{ $as_echo "$as_me:${as_lineno-$LINENO}: result:  just kidding ;-)" >&5
-$as_echo " just kidding ;-)" >&6; }
 echo
 echo "----------------------------------------------------------------"
 echo "Config is DONE!"
