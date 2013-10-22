require 'formula'

class Sbuild < Formula
  homepage 'http://sbuild.tototec.de/sbuild/projects/sbuild/wiki'
  url 'http://sbuild.tototec.de/sbuild/attachments/download/75/sbuild-0.6.0-dist.zip'
  sha1 '21a75d6ff08d56d470da047d73a96ebddc8eee49'

  def install
    libexec.install Dir['*']
    system "chmod +x #{libexec}/bin/sbuild"
    bin.install_symlink libexec/"bin/sbuild"
  end

  test do
    system "#{bin}/sbuild", "--help"
  end
end
