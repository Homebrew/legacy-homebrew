require 'formula'

class Camellia < Formula
  url 'http://downloads.sourceforge.net/project/camellia/Unix_Linux%20Distribution/v2.7.0/CamelliaLib-2.7.0.tar.gz'
  homepage 'http://camellia.sourceforge.net/'
  md5 '9dcfccb1d88193a963d18403f0e8474f'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
