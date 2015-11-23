class Rrdtool < Formula
  desc "Round Robin Database"
  homepage "https://oss.oetiker.ch/rrdtool/index.en.html"
  url "https://github.com/oetiker/rrdtool-1.x/releases/download/v1.5.4/rrdtool-1.5.4.tar.gz"
  sha256 "3feea3da87c02128a27083f1c7b2cb797ef673e946564c0ce008c1c25a5c3f99"

  bottle do
    sha256 "e434a767377fb30f603947e2a5d934de6b533068c457b8c1e84488942ec0eac1" => :el_capitan
    sha256 "e73f246edc6c23bc4be3185e4f25036e9fbac7bc2cfe4e47caf5edcd46d92c1d" => :yosemite
    sha256 "0ab32d64d87aedad34d331aa4ec8fe02431ce051d6de361de6fd5a0877f00960" => :mavericks
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
