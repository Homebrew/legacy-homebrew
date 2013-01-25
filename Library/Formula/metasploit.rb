require 'formula'

class Metasploit < Formula
  homepage 'http://www.metasploit.com/framework/'
  url 'https://github.com/rapid7/metasploit-framework/archive/2013010902.tar.gz'
  version '4.5.0-2013010902'
  sha1 '2bcde6e6209e428fb18195c381597d462b00acf5'

  head 'https://github.com/rapid7/metasploit-framework.git'

  def install
    libexec.install Dir["msf*"]
    libexec.install 'armitage', 'HACKING', 'data', 'documentation',
                    'external', 'lib', 'modules', 'plugins',
                    'scripts', 'test', 'tools'
    bin.install_symlink Dir["#{libexec}/msf*","#{libexec}/armitage"]
  end
end
