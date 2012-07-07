require 'formula'

class Atomicparsley < Formula
  homepage 'http://bitbucket.org/wez/atomicparsley/overview/'
  url 'https://bitbucket.org/wez/atomicparsley/get/0.9.4.tar.bz2'
  sha1 'd38dee8fddf1d554d07a18edb28635c4eb6bedde'

  head 'https://bitbucket.org/wez/atomicparsley', :using => :hg

  depends_on :automake
  depends_on :libtool

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-universal"
    system "make install"
  end
end
