require 'formula'

class Sbuild < Formula
  homepage 'http://sbuild.tototec.de/sbuild/projects/sbuild/wiki'
  url 'http://sbuild.tototec.de/sbuild/attachments/download/57/sbuild-0.4.0-dist.zip'
  sha1 'f206a97c810d925f2bd06bc463c55d5cd7483ca5'

  def install
    libexec.install Dir['*']
    system "chmod +x #{libexec}/bin/sbuild"
    bin.install_symlink libexec/"bin/sbuild"
  end

  test do
    system "#{bin}/sbuild", "--help"
  end
end
