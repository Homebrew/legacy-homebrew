class Sshuttle < Formula
  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://github.com/sshuttle/sshuttle/archive/sshuttle-0.72.tar.gz"
  sha256 "3ea217fa98e3887b0fb2229eb65b9548a4beea1947ed5949501e5ceec360ba19"
  head "https://github.com/sshuttle/sshuttle.git"

  bottle :unneeded

  def install
    # Building the docs requires installing
    # markdown & BeautifulSoup Python modules
    # so we don't.
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"src/sshuttle"
  end
end
