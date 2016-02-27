class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "http://eprover.org"
  url "http://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_1.9/E.tgz"
  version "1.9"
  sha256 "c4365661a6a4519b21b895fafe60c6b39b8acadf77a3c42e4d638027f155376e"

  bottle do
    cellar :any_skip_relocation
    sha256 "c35ff43a6827961b2bd55ff4da7bf5195d94aaee39b897c6072c339496875eb5" => :el_capitan
    sha256 "41838e2bbbecdb85d9b0f9e4dee595a4d4ebc75a7a2aa139ce39f0899c837d2d" => :yosemite
    sha256 "1f3db787cc176deb96d5e40b627b2f105530c8a82bad82718271a3d0a6a1e54b" => :mavericks
  end

  def install
    system "./configure", "--bindir=#{bin}", "--man-prefix=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/eproof"
  end
end
