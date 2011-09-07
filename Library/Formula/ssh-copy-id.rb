require 'formula'

class SshCopyId < Formula
  url 'http://ftp.lambdaserver.com/pub/OpenBSD/OpenSSH/portable/openssh-5.8p2.tar.gz'
  version '5.8p2'
  homepage 'http://openssh.org/'
  sha1 '64798328d310e4f06c9f01228107520adbc8b3e5'

  def install
    bin.install 'contrib/ssh-copy-id'
    man1.install 'contrib/ssh-copy-id.1'
  end
end
