require 'formula'

class Sbuild < Formula
  homepage 'http://sbuild.org'
  url 'http://sbuild.org/uploads/sbuild/0.7.4/sbuild-0.7.4-dist.zip'
  sha1 '698306c8bad5aa32f42b9df6db30f06dba5ea5be'

  def install
    libexec.install Dir['*']
    system "chmod +x #{libexec}/bin/sbuild"
    bin.install_symlink libexec/"bin/sbuild"
  end

  test do
    system "#{bin}/sbuild", "--help"
  end
end
