require 'formula'

class Cclive <Formula
  url 'http://cclive.googlecode.com/files/cclive-0.6.2.tar.bz2'
  homepage 'http://code.google.com/p/cclive/'
  md5 '14b90b281191421c9b109c7b231718a5'

  depends_on 'pkg-config'
  depends_on 'quvi'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end