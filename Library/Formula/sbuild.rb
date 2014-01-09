require 'formula'

class Sbuild < Formula
  homepage 'http://sbuild.tototec.de/sbuild/projects/sbuild/wiki'
  url 'http://sbuild.tototec.de/sbuild/attachments/download/87/sbuild-0.7.1-dist.zip'
  sha1 'b18c1e21f6bd5ef5b1d9733b171a1558e72ed017'

  def install
    libexec.install Dir['*']
    system "chmod +x #{libexec}/bin/sbuild"
    bin.install_symlink libexec/"bin/sbuild"
  end

  test do
    system "#{bin}/sbuild", "--help"
  end
end
