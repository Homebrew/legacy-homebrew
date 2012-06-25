require 'formula'

class Rlwrap < Formula
  url 'http://utopia.knoware.nl/~hlub/rlwrap/rlwrap-0.37.tar.gz'
  md5 '04cd6e2c257eb5a86b297f2ebf91dbbf'
  homepage 'http://utopia.knoware.nl/~hlub/rlwrap/'

  depends_on 'readline'

  def install
    ENV.append 'LDFLAGS', '-lreadline.6.2'
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
