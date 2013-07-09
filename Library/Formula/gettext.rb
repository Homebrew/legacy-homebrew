require 'formula'

class Gettext < Formula
  homepage 'http://www.gnu.org/software/gettext/'
  url 'http://ftpmirror.gnu.org/gettext/gettext-0.18.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gettext/gettext-0.18.3.tar.gz'
  sha256 '36f3c1043df803565d4977c1efbd41e1ec0f0301acf5f057984406c34cb9f948'

  bottle do
    sha1 '79adee5b9ef6a3411d609afca2887a363f1d0958' => :mountain_lion
    sha1 '8386ce4774898214f4f778edf5832b8fb8dde16a' => :lion
    sha1 'cb4fc21bfbe71b0df276e2d02e584d15a0f2af0d' => :snow_leopard
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
                          # Don't use VCS systems to create these archives
                          "--without-git",
                          "--without-cvs"
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make install"
  end
end
