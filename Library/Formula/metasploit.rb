require 'formula'

class Metasploit < Formula
  homepage 'http://www.metasploit.com/framework/'
  head 'https://github.com/rapid7/metasploit-framework.git'
  url 'https://github.com/rapid7/metasploit-framework/archive/4.7.2.tar.gz'
  sha1 '6e77d2a3204bd528b1b07db7f49f3d003c87a09e'

  def install
    libexec.install Dir["msf*"]
    libexec.install 'HACKING', 'data', 'documentation', 'external', 'lib',
                    'modules', 'plugins', 'scripts', 'test', 'tools'
    bin.install_symlink Dir["#{libexec}/msf*","#{libexec}/armitage"]
  end
end
