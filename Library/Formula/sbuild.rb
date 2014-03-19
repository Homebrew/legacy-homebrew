require 'formula'

class Sbuild < Formula
  homepage 'http://sbuild.org'
  url 'http://sbuild.org/uploads/sbuild/0.7.3/sbuild-0.7.3-dist.zip'
  sha1 'd41d88ddfccbe6745d7520af40cdf44257ad710c'

  def install
    libexec.install Dir['*']
    system "chmod +x #{libexec}/bin/sbuild"
    bin.install_symlink libexec/"bin/sbuild"
  end

  test do
    system "#{bin}/sbuild", "--help"
  end
end
