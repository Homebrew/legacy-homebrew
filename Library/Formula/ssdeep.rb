require "formula"

class Ssdeep < Formula
  homepage "http://ssdeep.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ssdeep/ssdeep-2.11.1/ssdeep-2.11.1.tar.gz"
  sha256 "a632ac30fca29ad5627e1bf5fae05d9a8873e6606314922479259531e0c19608"

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
