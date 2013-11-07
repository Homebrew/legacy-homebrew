require 'formula'

class Afflib < Formula
  homepage 'https://github.com/simsong/AFFLIBv3'
  url 'https://github.com/simsong/AFFLIBv3/archive/v3.7.3.tar.gz'
  sha1 '530c09f0852d6fb673762b3beafa2097ae4694fa'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'expat' => :optional

  def install
    system "sh bootstrap.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
