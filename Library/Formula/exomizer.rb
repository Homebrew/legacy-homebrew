class Exomizer < Formula
  desc "6502 compressor with CBM PET 4032 support."
  homepage "http://hem.bredband.net/magli143/exo/"
  url "http://hem.bredband.net/magli143/exo/exomizer209.zip"
  version "2.0.9"
  sha256 "d2a95d4d168e4007fc396295e2f30a21b58f4648c28d1aadf84e7d497c5c7a34"

  def install
    cd "src" do
      system "make"
      bin.install %w[b2membuf exobasic exomizer exoraw]
    end
  end

  test do
    output = shell_output(bin/"exomizer -v")
    assert_match version.to_s, output
  end
end
