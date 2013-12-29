require 'formula'

class Crash < Formula
  homepage 'http://www.crashub.org/'
  url 'https://crsh.googlecode.com/files/crash-1.2.8.tar.gz'
  sha1 '12290cd227b20eae07674f8cf0d43ee58732e34b'

  def install
    libexec.install Dir['crash/*']
    bin.install_symlink "#{libexec}/bin/crash.sh"
  end
end
