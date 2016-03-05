class Exomizer < Formula
  desc "6502 compressor with CBM PET 4032 support."
  homepage "http://hem.bredband.net/magli143/exo/"
  url "http://hem.bredband.net/magli143/exo/exomizer209.zip"
  version "2.0.9"
  sha256 "d2a95d4d168e4007fc396295e2f30a21b58f4648c28d1aadf84e7d497c5c7a34"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fc0744775aff849b63640a9ac89d63309eebf04dc544b2840d219f8331629c5" => :el_capitan
    sha256 "5516edd49987f155735a83ef3a87fd01fb685d30067dcd770d07b07a4ddbbf19" => :yosemite
    sha256 "8fdf034caf568b57fa6e8b2f8adabc47bdd845a300ab3901c0bb6fc9f6556185" => :mavericks
  end

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
