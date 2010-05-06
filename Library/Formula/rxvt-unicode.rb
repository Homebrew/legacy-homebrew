require 'formula'

class RxvtUnicode < Formula
  url 'http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.07.tar.bz2'
  homepage 'http://software.schmorp.de/pkg/rxvt-unicode.html'
  md5 '49bb52c99e002bf85eb41d8385d903b5'

  aka :urxvt

  def patches
    # Add 256 color support
    {:p1 => "doc/urxvt-8.2-256color.patch"}
  end

  def install
    system "./configure",
           "--prefix=#{prefix}",
           "--disable-afterimage",
           "--disable-perl",
           "--enable-256-color",
           "--with-term=rxvt-256color",
           "--disable-dependency-tracking"
    system "make"

    # `make` won't work unless we rename this
    system "mv INSTALL README.install"

    system "make install"
  end
  
  def caveats
    "This software runs under X11."
  end
end
