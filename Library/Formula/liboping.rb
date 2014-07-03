require 'formula'

class Liboping < Formula
  homepage 'http://verplant.org/liboping/'
  url 'http://verplant.org/liboping/files/liboping-1.6.2.tar.bz2'
  sha256 '5f4ab4b127b5a8a79ab771002604bff0e2903622393e5602f336cad258bb73cf'

  bottle do
    sha1 "02ef638706e016e6f8f551be3be671a56f59ad42" => :mavericks
    sha1 "0ea3b028984d2f7b0f1b5a54dbda97b222b916e4" => :mountain_lion
    sha1 "d6802770af12ceb30742510c5505eed031dc3850" => :lion
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
