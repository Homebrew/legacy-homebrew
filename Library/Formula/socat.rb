require 'formula'

class Socat <Formula
  url 'http://www.dest-unreach.org/socat/download/socat-1.7.1.2.tar.bz2'
  homepage 'http://www.dest-unreach.org/socat/'
  md5 '9c0c5e83ce665f38d4d3aababad275eb'

  def install
    ENV.enable_warnings # -wall causes build to fail
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
