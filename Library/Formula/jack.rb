require 'formula'

class Jack < Formula
  homepage 'http://jackaudio.org'
  url 'http://pkgs.fedoraproject.org/repo/pkgs/jack-audio-connection-kit/jack-1.9.7.tar.bz2/9759670feecbd43eeccf1c0f743ec199/jack-1.9.7.tar.bz2'
  sha1 '0a344fd962666f7c95969da0576ac0228e71b30d'

  depends_on 'celt'
  depends_on 'libsamplerate'

  # default build assumes ppc+i386, changed to i386+x86_64
  def patches
    "https://gist.github.com/raw/636194/a8f5326ea27faed38da6c188045dd166b1eb6af6/jack-1.9.6_homebrew.patch"
  end

  fails_with :clang do
    build 425
    cause 'waf fails to find g++ when compiling with clang'
  end

  def install
    ENV['LINKFLAGS'] = ENV.ldflags
    system "./waf","configure", "--prefix=#{prefix}"
    system "./waf","build"
    system "./waf","install"
  end
end
