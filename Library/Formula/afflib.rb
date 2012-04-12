require 'formula'

class Afflib < Formula
  url 'https://github.com/downloads/simsong/AFFLIBv3/afflib-3.7.0.tar.gz'
  homepage 'http://afflib.org'
  md5 '36a6b5e0cebd70e26bae4bc218dbbace'

  depends_on 'expat' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
