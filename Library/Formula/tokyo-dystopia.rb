require 'formula'

class TokyoDystopia < Formula
  homepage 'http://fallabs.com/tokyodystopia/'
  url 'http://fallabs.com/tokyodystopia/tokyodystopia-0.9.15.tar.gz'
  md5 '12024f8444fea8dd1bc2cc435f104856'

  depends_on 'tokyo-cabinet'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
