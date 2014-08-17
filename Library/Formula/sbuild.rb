require 'formula'

class Sbuild < Formula
  homepage 'http://sbuild.org'
  url 'http://sbuild.org/uploads/sbuild/0.7.6/sbuild-0.7.6-dist.zip'
  sha1 'd3c815eea2db0347c2b8a319d52c32a50b03d803'

  def install
    libexec.install Dir['*']
    system "chmod +x #{libexec}/bin/sbuild"
    bin.install_symlink libexec/"bin/sbuild"
  end

  test do
    system "#{bin}/sbuild", "--help"
  end
end
