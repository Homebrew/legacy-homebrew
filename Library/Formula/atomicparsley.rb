require 'formula'

class Atomicparsley < Formula
  homepage 'http://bitbucket.org/wez/atomicparsley/overview/'
  url 'https://bitbucket.org/dinkypumpkin/atomicparsley/downloads/atomicparsley-0.9.5.tar.bz2'
  sha1 'ffdf42179f83b344670bd7d7b6cfd829e1a1ea6a'

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
