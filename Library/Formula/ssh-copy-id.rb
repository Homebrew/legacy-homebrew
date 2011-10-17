require 'formula'

class SshCopyId < Formula
  url 'http://ftp.lambdaserver.com/pub/OpenBSD/OpenSSH/portable/openssh-5.9p1.tar.gz'
  version '5.9p1'
  homepage 'http://openssh.org/'
  sha1 'ac4e0055421e9543f0af5da607a72cf5922dcc56'

  def install
    bin.install 'contrib/ssh-copy-id'
    man1.install 'contrib/ssh-copy-id.1'
  end
end
