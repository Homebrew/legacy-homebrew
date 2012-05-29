require 'formula'

class SshCopyId < Formula
  homepage 'http://openssh.org/'
  url 'http://ftp.lambdaserver.com/pub/OpenBSD/OpenSSH/portable/openssh-6.0p1.tar.gz'
  version '6.0p1'
  sha1 'f691e53ef83417031a2854b8b1b661c9c08e4422'

  def install
    bin.install 'contrib/ssh-copy-id'
    man1.install 'contrib/ssh-copy-id.1'
  end
end
