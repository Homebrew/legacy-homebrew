class Exomizer < Formula
  desc     "Exomizer is a program that compresses files in a way that tries to be as efficient as possible but still allows them to be decompressed in environments where CPU speed and RAM are limited. For some popular 8-bit computers using 6502 compatible CPUs it can also generate executable files that decompress themselves in memory when run."
  homepage "http://hem.bredband.net/magli143/exo/"
  url      "http://hem.bredband.net/magli143/exo/exomizer209.zip"
  version  "2.0.9"
  sha256   "d2a95d4d168e4007fc396295e2f30a21b58f4648c28d1aadf84e7d497c5c7a34"

  def install
    cd 'src' do
      system 'make'
      bin.install %w[b2membuf exobasic exomizer exoraw]
    end
  end
end
