require 'formula'

class Sbuild < Formula
  homepage 'http://sbuild.tototec.de/sbuild/projects/sbuild/wiki'
  url 'http://sbuild.tototec.de/sbuild/attachments/download/82/sbuild-0.7.0-dist.zip'
  sha1 '02e593136d5c24269ea9243e88ee7701cb50b120'

  def install
    libexec.install Dir['*']
    system "chmod +x #{libexec}/bin/sbuild"
    bin.install_symlink libexec/"bin/sbuild"
  end

  test do
    system "#{bin}/sbuild", "--help"
  end
end
