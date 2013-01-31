require 'formula'

class Gettext < Formula
  homepage 'http://www.gnu.org/software/gettext/'
  url 'http://ftpmirror.gnu.org/gettext/gettext-0.18.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gettext/gettext-0.18.2.tar.gz'
  sha256 '516a6370b3b3f46e2fc5a5e222ff5ecd76f3089bc956a7587a6e4f89de17714c'

  keg_only "OS X provides the BSD gettext library and some software gets confused if both are in the library path."

#  bottle do
#    sha1 'd1ad5ad15bfe8fe813ee37e5d6b514fc79924b9a' => :mountainlion
#    sha1 'c75fdb192f1b49c9e7e2039c66e24f60f26bc027' => :lion
#    sha1 'b8958544542fc160b4c74db5d83cb441d12741c7' => :snowleopard
#  end

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
                          "--without-emacs",
                          # Don't use VCS systems to create these archives
                          "--without-git",
                          "--without-cvs"
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make install"
  end
end
