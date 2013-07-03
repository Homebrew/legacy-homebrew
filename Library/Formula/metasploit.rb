require 'formula'

class Metasploit < Formula
  homepage 'http://www.metasploit.com/framework/'
  head 'https://github.com/rapid7/metasploit-framework.git'
  url 'https://github.com/rapid7/metasploit-framework/archive/2013021301.tar.gz'
  version '4.5.0-2013021301'
  sha1 '63934228ec316ca6c2313b151eab6e3bd91f5508'

  def install
    libexec.install Dir["msf*"]
    libexec.install 'armitage', 'HACKING', 'data', 'documentation',
                    'external', 'lib', 'modules', 'plugins',
                    'scripts', 'test', 'tools'
    bin.install_symlink Dir["#{libexec}/msf*","#{libexec}/armitage"]
  end
end
