require 'formula'

class Gettext < Formula
  url 'http://ftp.gnu.org/pub/gnu/gettext/gettext-0.18.1.1.tar.gz'
  md5 '3dd55b952826d2b32f51308f2f91aa89'
  homepage 'http://www.gnu.org/software/gettext/'

  keg_only "OS X provides the BSD gettext library and some software gets confused if both are in the library path."

  def options
  [
    ['--with-examples', 'Keep example files.'],
    ['--universal', 'Build universal binaries.']
  ]
  end


  def patches
    p = {:p0 => ['https://trac.macports.org/export/79617/trunk/dports/devel/gettext/files/stpncpy.patch']}
    
    # Use a MacPorts patch to disable building examples at all
    # rather than build them and remove them afterwards.
    p[:p0] << 'https://trac.macports.org/export/79183/trunk/dports/devel/gettext/files/patch-gettext-tools-Makefile.in' unless ARGV.include? '--with-examples'
    
    return p
  end

  def install
    ENV.libxml2
    ENV.O3 # Issues with LLVM & O4 on Mac Pro 10.6

    ENV.universal_binary if ARGV.build_universal?

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
