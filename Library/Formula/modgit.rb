class Modgit < Formula
  desc "Tool for git repo deploy with filters. Used for magento development."
  homepage "https://github.com/jreinke/modgit"
  url "https://github.com/jreinke/modgit/archive/v1.0.1.tar.gz"
  sha256 "3df1ccddaacf386a32be0fe5b6333438f17876bc6a4851d9bc22a68a73ae314d"

  bottle :unneeded

  def install
    bin.install "modgit"
  end

  test do
    system "#{bin}/modgit"
  end
end
