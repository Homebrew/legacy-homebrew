require 'formula'

class Gettext < Formula
  homepage 'http://www.gnu.org/software/gettext/'
  url 'http://ftpmirror.gnu.org/gettext/gettext-0.18.3.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gettext/gettext-0.18.3.1.tar.gz'
  sha256 '0d8f9a33531b77776b3dc473e7940019ca19bfca5b4c06db6e96065eeb07245d'

  bottle do
    revision 1
    sha1 'b64f8e3cda313fa363769cb1f6ccd2cd872e3c90' => :mavericks
    sha1 '90f266b4c4b9085ccfcfca381d22782f4291a950' => :mountain_lion
    sha1 '3b28675e06ad3ce2b82913d70ae33330e2c06c5c' => :lion
  end

  keg_only "OS X provides the BSD gettext library and some software gets confused if both are in the library path."

  option :universal
  option 'with-examples', 'Keep example files'

  def patches
    unless build.include? 'with-examples'
      # Use a MacPorts patch to disable building examples at all,
      # rather than build them and remove them afterwards.
      {:p0 => ['https://trac.macports.org/export/102008/trunk/dports/devel/gettext/files/patch-gettext-tools-Makefile.in']}
    end
  end

  def install
    ENV.libxml2
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-included-gettext",
                          "--with-included-glib",
                          "--with-included-libcroco",
                          "--with-included-libunistring",
                          "--with-emacs",
                          "--disable-java",
                          "--disable-csharp",
                          # Don't use VCS systems to create these archives
                          "--without-git",
                          "--without-cvs"
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make install"
  end
end
