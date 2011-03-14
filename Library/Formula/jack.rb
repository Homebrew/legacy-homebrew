require 'formula'

class Jack < Formula
  url 'http://www.grame.fr/~letz/jack-1.9.6.tar.bz2'
  homepage 'http://jackaudio.org'
  md5 'fcd4bdb44f51d71c9e19bc1d0e887902'

  depends_on 'celt'
  depends_on 'libsamplerate'

  def patches
    # default build assumes ppc+i386, changed to i386+x86_64
    "https://gist.github.com/raw/636194/jack-1.9.6_homebrew.patch"
  end

  def install
    ENV['LINKFLAGS'] = ENV['LDFLAGS']
    system "./waf","configure","--prefix=#{prefix}"
    system "./waf","build"
    system "./waf","install"
  end
end
