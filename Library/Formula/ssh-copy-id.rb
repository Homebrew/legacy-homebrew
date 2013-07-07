require 'formula'

class SshCopyId < Formula
  homepage 'http://openssh.org/'
  url 'http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.2p1.tar.gz'
  mirror 'http://ftp.spline.de/pub/OpenBSD/OpenSSH/portable/openssh-6.2p1.tar.gz'
  version '6.2p1'
  sha256 '58690267d7455f444e87c2f8cd9be91fc686ffc0c02d1ebd0be2ab68149f7160'

  def install
    bin.install 'contrib/ssh-copy-id'
    man1.install 'contrib/ssh-copy-id.1'
  end
end
