require 'formula'

class Gettext < Formula
  homepage 'http://www.gnu.org/software/gettext/'
  url 'http://ftpmirror.gnu.org/gettext/gettext-0.18.1.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gettext/gettext-0.18.1.1.tar.gz'
  md5 '3dd55b952826d2b32f51308f2f91aa89'

  keg_only "OS X provides the BSD gettext library and some software gets confused if both are in the library path."

  bottle do
    sha1 'd1ad5ad15bfe8fe813ee37e5d6b514fc79924b9a' => :mountainlion
    sha1 'c75fdb192f1b49c9e7e2039c66e24f60f26bc027' => :lion
    sha1 'b8958544542fc160b4c74db5d83cb441d12741c7' => :snowleopard
  end

  option :universal
  option 'with-examples', 'Keep example files'

  def patches
    # Patch to allow building with Xcode 4; safe for any compiler.
    p = {:p0 => ['https://trac.macports.org/export/79617/trunk/dports/devel/gettext/files/stpncpy.patch']}

    unless build.include? 'with-examples'
      # Use a MacPorts patch to disable building examples at all,
      # rather than build them and remove them afterwards.
      p[:p0] << 'https://trac.macports.org/export/79183/trunk/dports/devel/gettext/files/patch-gettext-tools-Makefile.in'
    end

    return p
  end

  def install
    ENV.libxml2
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--without-included-gettext",
                          "--without-included-glib",
                          "--without-included-libcroco",
                          "--without-included-libxml",
                          "--without-emacs",
                          # Don't use VCS systems to create these archives
                          "--without-git",
                          "--without-cvs"
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make install"
  end
end
