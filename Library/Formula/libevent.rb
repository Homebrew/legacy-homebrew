require 'formula'

class Libevent < Formula
  homepage 'http://www.monkey.org/~provos/libevent/'
  url 'https://github.com/downloads/libevent/libevent/libevent-2.0.17-stable.tar.gz'
  sha1 'cea3af2d4bd688784f270ac2ecae8ea6aaaa463f'

  head 'git://levent.git.sourceforge.net/gitroot/levent/levent'

  fails_with_llvm "Undefined symbol '_current_base' reported during linking.", :build => 2326

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    ENV.j1
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
