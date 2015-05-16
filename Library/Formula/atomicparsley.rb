require 'formula'

class Atomicparsley < Formula
  homepage 'http://bitbucket.org/wez/atomicparsley/overview/'
  url 'https://bitbucket.org/dinkypumpkin/atomicparsley/downloads/atomicparsley-0.9.6.tar.bz2'
  sha1 'ab5a4c5c477cd6cdb6e3b5f35dc24fd49e6b6b20'

  head 'https://bitbucket.org/wez/atomicparsley', :using => :hg

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-universal"
    system "make install"
  end
end
