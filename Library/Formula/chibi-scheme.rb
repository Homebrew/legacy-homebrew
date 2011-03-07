require 'formula'

class ChibiScheme <Formula
  url 'http://chibi-scheme.googlecode.com/files/chibi-scheme-0.3.tgz'
  homepage 'http://code.google.com/p/chibi-scheme/'
  md5 '60a18f1b61c4677a2bb4701a0258c7d9'

  def install
    system "make install PREFIX=#{prefix}"
  end
end
