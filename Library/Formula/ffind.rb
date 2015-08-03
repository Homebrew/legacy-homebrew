class Ffind < Formula
  desc "Friendlier find"
  homepage "https://github.com/sjl/friendly-find"
  url "https://github.com/sjl/friendly-find/archive/v0.3.2.tar.gz"
  sha256 "4fe9b5fb4d64cc3a006b1496cf0a825a2494706c413778b77bbcf0fb9cfbbf80"

  conflicts_with "sleuthkit",
    :because => "both install a 'ffind' executable."

  def install
    bin.install "ffind"
  end

  test do
    system "#{bin}/ffind"
  end
end
