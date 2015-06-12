require 'formula'

class Sshuttle < Formula
  desc "Proxy server that works as a poor man's VPN"
  homepage 'https://github.com/sshuttle/sshuttle'
  url 'https://github.com/sshuttle/sshuttle/archive/sshuttle-0.71.tar.gz'
  sha256 '62f0f8be5497c2d0098238c54e881ac001cd84fce442c2506ab6d37aa2f698f0'

  head 'https://github.com/sshuttle/sshuttle.git'

  def install
    # Building the docs requires installing
    # markdown & BeautifulSoup Python modules
    # so we don't.
    libexec.install Dir['*']
    bin.write_exec_script libexec/'src/sshuttle'
  end
end
