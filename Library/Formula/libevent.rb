require 'formula'

class Libevent < Formula
  homepage 'http://www.monkey.org/~provos/libevent/'
  url 'https://github.com/downloads/libevent/libevent/libevent-2.0.18-stable.tar.gz'
  sha1 '2a2cc87ce1945f43dfa5a5f9575fef3d14a8f57a'

  head 'git://levent.git.sourceforge.net/gitroot/levent/levent'

  fails_with :llvm do
    build 2326
    cause "Undefined symbol '_current_base' reported during linking."
  end

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
