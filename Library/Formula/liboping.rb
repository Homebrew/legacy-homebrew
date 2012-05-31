require 'formula'

class Liboping < Formula
  homepage 'http://verplant.org/liboping/'
  url 'http://verplant.org/liboping/files/liboping-1.6.2.tar.bz2'
  sha256 '5f4ab4b127b5a8a79ab771002604bff0e2903622393e5602f336cad258bb73cf'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    "Run oping and noping sudo'ed in order to avoid the 'Operation not permitted'"
  end
end
