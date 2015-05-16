require 'formula'

class Sshuttle < Formula
  homepage 'https://github.com/apenwarr/sshuttle'
  url 'https://github.com/apenwarr/sshuttle/archive/sshuttle-0.61.tar.gz'
  sha1 '05551cdc78e866d983470ba4084beb206bacebd8'

  head 'https://github.com/apenwarr/sshuttle.git'

  def install
    # Building the docs requires installing
    # markdown & BeautifulSoup Python modules
    # so we don't.
    libexec.install Dir['*']
    bin.write_exec_script libexec/'sshuttle'
  end
end
