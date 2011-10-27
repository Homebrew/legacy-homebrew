require 'formula'

class Gettext < Formula
  url 'http://ftpmirror.gnu.org/gettext/gettext-0.18.1.1.tar.gz'
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
    # Patch to allow building with Xcode 4; safe for any compiler.
    p = {:p0 => ['https://raw.github.com/gist/1318406/e18af95cee4511f7e1255dc789f2b1990b4a56ee/stpncpy.patch']}

    unless ARGV.include? '--with-examples'
      # Use a MacPorts patch to disable building examples at all,
      # rather than build them and remove them afterwards.
      p[:p0] << 'https://raw.github.com/gist/1318408/1a474dda36d2cf1bca28a3e63077aa934c08df8c/patch-gettext-tools-Makefile.in'
    end

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
