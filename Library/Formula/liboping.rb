require 'formula'

class Liboping < Formula
  homepage 'http://noping.cc'
  url 'http://noping.cc/files/liboping-1.8.0.tar.bz2'
  sha256 '1dcb9182c981b31d67522ae24e925563bed57cf950dc681580c4b0abb6a65bdb'

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
