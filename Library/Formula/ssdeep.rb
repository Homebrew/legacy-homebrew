require "formula"

class Ssdeep < Formula
  homepage "http://ssdeep.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ssdeep/ssdeep-2.12/ssdeep-2.12.tar.gz"
  sha256 "89049e87adfd16b51bd8601d01cf02251df7513c4e0eb12576541bcb2e1e4bde"

  bottle do
    cellar :any
    sha1 "1dc13c01d70502db11780b8a4328d51cbc9be858" => :mavericks
    sha1 "9c4a868d8e17d2cd0decae8588763640e751cb2a" => :mountain_lion
    sha1 "63eee02b93120277a27adc08620a2c24fe467850" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
