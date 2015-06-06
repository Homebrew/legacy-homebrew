class Dieharder < Formula
  desc "Random number test suite"
  homepage "https://www.phy.duke.edu/~rgb/General/dieharder.php"
  url "https://www.phy.duke.edu/~rgb/General/dieharder/dieharder-3.31.1.tgz"
  sha256 "6cff0ff8394c553549ac7433359ccfc955fb26794260314620dfa5e4cd4b727f"

  bottle do
    cellar :any
    sha256 "eedc7b04f6ddc096cc23c6b6ce26ae8a5db9cd9ae45502531ecc8cbc250c5c41" => :yosemite
    sha256 "03d42010b8b85a99d40805a36a82e2f686ea5ceb967b3928f0d0ce3bff5b0f49" => :mavericks
    sha256 "0bc0056b317b8acb54157625ddfa60a4338a342a4af1a945f19cccbeb7d67c74" => :mountain_lion
  end

  depends_on "gsl"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-shared"
    system "make", "install"
  end

  test do
    system "#{bin}/dieharder", "-o", "-t", "10"
  end
end
