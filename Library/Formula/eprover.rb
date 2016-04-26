class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "http://eprover.org"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_1.9/E.tgz"
  version "1.9"
  sha256 "c4365661a6a4519b21b895fafe60c6b39b8acadf77a3c42e4d638027f155376e"

  bottle do
    cellar :any_skip_relocation
    sha256 "396ff4a7c412a5aa773f4df990611e27bd7d7ad5e4b297f9da3afa29cc2271ba" => :el_capitan
    sha256 "f698ea516f874623f22a6a87335b0881b0014e8bd1811f213b81a2bdd32f6f14" => :yosemite
    sha256 "0a5a1d15a59ec5921c3416de25df8e9fd518604e761396df3612bd587cdc00cf" => :mavericks
  end

  def install
    system "./configure", "--bindir=#{bin}", "--man-prefix=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/eproof"
  end
end
