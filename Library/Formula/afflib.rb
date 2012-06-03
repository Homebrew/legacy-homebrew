require 'formula'

class Afflib < Formula
  url 'https://github.com/downloads/simsong/AFFLIBv3/afflib-3.7.1.tar.gz'
  homepage 'http://afflib.org'
  md5 'c6751d461aaf6acf9d15303cde539e44'

  depends_on 'expat' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
