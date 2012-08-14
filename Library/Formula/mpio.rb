require 'formula'

class Mpio < Formula
  url 'https://github.com/downloads/frsyuki/mpio/mpio-0.3.7.tar.gz'
  homepage 'https://github.com/frsyuki/mpio'
  md5 '9ef727a197bc97621709f79d9539ed19'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
