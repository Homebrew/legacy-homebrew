class Vassh < Formula
  desc "Vagrant Host-Guest SSH Command Wrapper/Proxy/Forwarder"
  homepage "https://github.com/x-team/vassh"
  url "https://github.com/x-team/vassh/archive/0.2.tar.gz"
  sha256 "dd9b3a231c2b0c43975ba3cc22e0c45ba55fbbe11a3e4be1bceae86561b35340"

  bottle :unneeded

  def install
    bin.install "vassh.sh", "vasshin", "vassh"
  end

  test do
    system "#{bin}/vassh", "-h"
  end
end
