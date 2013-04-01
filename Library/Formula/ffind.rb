require 'formula'

class Ffind < Formula
  homepage 'https://github.com/sjl/friendly-find'
  url 'https://github.com/sjl/friendly-find/archive/v0.3.1.tar.gz'
  sha1 'c729a7ab2ae215d37a3e7cc0f16de24be1c965f6'

  conflicts_with 'sleuthkit',
    :because => "both install a 'ffind' executable."

  def install
    bin.install "ffind"
  end

  test do
    system "#{bin}/ffind"
  end
end
