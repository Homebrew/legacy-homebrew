require 'formula'

class Rrdtool < Formula
  url 'http://oss.oetiker.ch/rrdtool/pub/rrdtool-1.4.4.tar.gz'
  homepage 'http://oss.oetiker.ch/rrdtool/index.en.html'
  md5 '93ad2fc2e9ddcd7d99c611fe30284a54'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'intltool'
  depends_on 'expat'
  depends_on 'pango'

  # Can use lua if it is found, but don't force users to install
  depends_on 'lua' => :optional if ARGV.include? "--lua"

  # Ha-ha, but sleeping is annoying when running configure a lot
  def patches; DATA; end

  def options
    [["--lua", "Compile with lua support."]]
  end

  def install
    ENV.libxml2
    ENV.x11

    which_perl = `/usr/bin/which perl`.chomp
    which_ruby = `/usr/bin/which ruby`.chomp

    opoo "Using system Ruby. RRD module will be installed to /Library/Ruby/..." if which_ruby == "/usr/bin/ruby"
    opoo "Using system Perl. RRD module will be installed to /Library/Perl/..." if which_perl == "/usr/bin/perl"

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--enable-perl-site-install" if which_perl == "/usr/bin/perl"
    args << "--enable-ruby-site-install" if which_ruby == "/usr/bin/ruby"

    system "./configure", *args

    # Needed to build proper Ruby bundle
    ENV["ARCHFLAGS"] = MacOS.prefer_64_bit? ? "-arch x86_64" : "-arch i386"

    system "make install"
    prefix.install "bindings/ruby/test.rb"
  end

  def test
    system "ruby", prefix+"test.rb"
    system "open test.png"
    puts "You may want to `rm test.{rrd,png}`"
  end
end

__END__
diff --git a/configure b/configure
index 7487ad2..e7b85c1 100755
--- a/configure
+++ b/configure
@@ -31663,18 +31663,6 @@ $as_echo_n "checking in... " >&6; }
 { $as_echo "$as_me:$LINENO: result: and out again" >&5
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
-{ $as_echo "$as_me:$LINENO: result:  just kidding ;-)" >&5
-$as_echo " just kidding ;-)" >&6; }
 echo
 echo "----------------------------------------------------------------"
 echo "Config is DONE!"
