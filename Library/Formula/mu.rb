require 'formula'

class Emacs23Installed < Requirement
  def message; <<-EOS.undent
    Emacs 23 or greater is required to build this software.

    You can install this with Homebrew:
      brew install emacs

    Or you can use any other Emacs distribution
    that provides version 23 or greater.
    EOS
  end
  def satisfied?
    `emacs --version 2>/dev/null` =~ /^GNU Emacs (\d{2})/
    $1.to_i >= 23
  end
  def fatal?
    true
  end
end

class Mu < Formula
  homepage 'http://www.djcbsoftware.nl/code/mu/'
  url 'http://mu0.googlecode.com/files/mu-0.9.8.4.tar.gz'
  sha1 'd586dddcc5b2f73e0bc1c835c199644a65c0f5b5'
  head 'https://github.com/djcb/mu.git'

  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gmime'
  depends_on 'xapian'
  depends_on Emacs23Installed.new

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Fixes configure error using Xapian-1.2.10, where it thinks 1.2.10 < 1.2
  # Patch submitted upstream: https://github.com/djcb/mu/issues/19
  # Fixed in head.  Remove at 0.9.8.5
  def patches
    DATA unless ARGV.build_head?
  end

  def install
    system 'autoreconf', '-ivf' if ARGV.build_head?
    system  "./configure", "--prefix=#{prefix}",
      "--disable-dependency-tracking", "--with-gui=none"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Existing mu users are recommended to run the following after upgrading:

      mu index --rebuild
    EOS
  end
end

__END__
--- a/configure	2012-05-08 04:26:10.000000000 -0700
+++ b/configure	2012-05-11 23:20:57.000000000 -0700
@@ -17640,7 +17640,7 @@
   xapian_version=$($XAPIAN_CONFIG --version | sed -e 's/.* //')
 fi
 case $xapian_version in #(
-  1.[2-9].[0-9]) :
+  1.[2-9].[0-9]*) :
      ;; #(
   *) :
     as_fn_error $? "*** xapian version >= 1.2 needed, but version $xapian_version found." "$LINENO" 5 ;;
