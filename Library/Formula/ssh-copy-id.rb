require 'formula'

class SshCopyId < Formula
  homepage 'http://openssh.org/'
  url 'http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.3p1.tar.gz'
  mirror 'http://ftp.spline.de/pub/OpenBSD/OpenSSH/portable/openssh-6.3p1.tar.gz'
  version '6.3p1'
  sha256 'aea575ededd3ebd45c05d42d0a87af22c79131a847ea440c54e3fdd223f5a420'

  def install
    bin.install 'contrib/ssh-copy-id'
    man1.install 'contrib/ssh-copy-id.1'
  end
end
