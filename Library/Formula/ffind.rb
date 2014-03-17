require 'formula'

class Ffind < Formula
  homepage 'https://github.com/sjl/friendly-find'
  url 'https://github.com/sjl/friendly-find/archive/v0.3.2.tar.gz'
  sha1 'fe4d943642e5bf344e2095122bb49216bcc2e2bd'

  conflicts_with 'sleuthkit',
    :because => "both install a 'ffind' executable."

  def install
    bin.install "ffind"
  end

  test do
    system "#{bin}/ffind"
  end
end
