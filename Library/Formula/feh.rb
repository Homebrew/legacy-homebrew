require 'formula'

class Feh <Formula
  url 'http://feh.finalrewind.org/feh-1.11.2.tar.bz2'
  homepage 'http://freshmeat.net/projects/feh'
  md5 '3b2354d78a882ce02b429bbe053467a2'

  depends_on 'giblib' => :build

  def install
    ENV.append "LDFLAGS", "-L/usr/X11/lib"
    ENV.append "CFLAGS", "-I/usr/X11/include"

    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
