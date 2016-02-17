class Blackbox < Formula
  desc "Safely store secrets in Git/Mercurial/Subversion"
  homepage "https://github.com/StackExchange/blackbox"
  url "https://github.com/StackExchange/blackbox/archive/v1.20160122.tar.gz"
  sha256 "ac5de1d74fdbe88604b34949f3949e53cb72e55e148e46b8c2be98806c888a10"

  bottle :unneeded

  depends_on :gpg

  def install
    libexec.install Dir["bin/*"]
    bin.write_exec_script Dir[libexec/"*"].select { |f| File.executable? f }
  end

  test do
    system "git", "init"
    system "#{bin}/blackbox_initialize", "yes"
  end
end
