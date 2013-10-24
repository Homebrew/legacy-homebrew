require 'formula'

class SshCopyId < Formula
  homepage 'http://openssh.org/'
  url 'http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.2p2.tar.gz'
  mirror 'http://ftp.spline.de/pub/OpenBSD/OpenSSH/portable/openssh-6.2p2.tar.gz'
  version '6.2p2'
  sha256 '7f29b9d2ad672ae0f9e1dcbff871fc5c2e60a194e90c766432e32161b842313b'

  def install
    bin.install 'contrib/ssh-copy-id'
    man1.install 'contrib/ssh-copy-id.1'
  end
end
