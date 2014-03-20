require 'formula'

class GitCrypt < Formula
  homepage 'http://www.agwa.name/projects/git-crypt/'
  url 'https://github.com/AGWA/git-crypt/archive/0.3.tar.gz'
  sha1 '7ee53e970d8fd085ad23463120b04b4d94a47ef0'

  def install
    system "make"
    bin.install "git-crypt"
  end

  test do
    system "#{bin}/git-crypt"
  end
end
