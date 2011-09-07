require 'formula'

class Libming < Formula
  url 'https://sourceforge.net/projects/ming/files/Releases/Ming%200.4.3/ming-0.4.3.tar.bz2'
  md5 'db6bae65d000e2f2ac78583fd453f99a'
  homepage 'http://www.libming.org'

  def install
    ENV.x11 # For PNG support.

    # TODO: Libming also includes scripting front-ends for Perl, Python, TCL
    # and PHP.  These are disabled by default.  Figure out what it would take to
    # enable them.
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
           "--disable-dependency-tracking"
    system "make"

    # Won't install in parallel for some reason.
    ENV.deparallelize
    system "make install"
  end
end
