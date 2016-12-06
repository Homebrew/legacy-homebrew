require 'formula'

class Sally < Formula
  url 'http://www.mlsec.org/sally/files/sally-0.6.3.tar.gz'
  homepage 'http://www.mlsec.org/sally/index.html'
  md5 '49e8cf24e79afbf755faac9b30baf246'

  depends_on 'libconfig'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
