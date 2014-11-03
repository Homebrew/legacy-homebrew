require 'formula'

class Liboping < Formula
  homepage 'http://verplant.org/liboping/'
  url 'http://verplant.org/liboping/files/liboping-1.6.2.tar.bz2'
  sha256 '5f4ab4b127b5a8a79ab771002604bff0e2903622393e5602f336cad258bb73cf'

  bottle do
    revision 1
    sha1 "fced606652325907943e882c5648682de6d1b507" => :yosemite
    sha1 "fec2a87f6c3105dfd2febcc4f332ca936cb74f84" => :mavericks
    sha1 "86996fe738d3912e7b4d20cde064415331e4a41f" => :mountain_lion
  end

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
