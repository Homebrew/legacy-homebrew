class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "http://www4.informatik.tu-muenchen.de/~schulz/E/E.html"
  url "http://www4.in.tum.de/~schulz/WORK/E_DOWNLOAD/V_1.8/E.tgz"
  version "1.8"
  sha256 "636a5353046680f9c960d02d942df0a55af2e3941676df76e3356a334f6e842e"

  def install
    system "./configure", "--bindir=#{bin}", "--man-prefix=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/eproof"
  end
end
