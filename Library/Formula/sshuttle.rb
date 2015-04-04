require 'formula'

class Sshuttle < Formula
  homepage 'https://github.com/sshuttle/sshuttle'
  url 'https://github.com/sshuttle/sshuttle/archive/sshuttle-0.53-macos-bin.tar.gz'
  sha1 '05551cdc78e866d983470ba4084beb206bacebd8'

  head 'https://github.com/sshuttle/sshuttle.git'

  def install
    # Building the docs requires installing
    # markdown & BeautifulSoup Python modules
    # so we don't.
    libexec.install Dir['*']
    bin.write_exec_script libexec/'sshuttle'
  end
end
