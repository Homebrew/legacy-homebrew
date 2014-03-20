require 'formula'

class SshCopyId < Formula
  homepage 'http://www.openssh.com/'
  url 'http://ftp.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.6p1.tar.gz'
  mirror 'http://ftp3.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.6p1.tar.gz'
  version '6.6p1'
  sha1 'b850fd1af704942d9b3c2eff7ef6b3a59b6a6b6e'

  def install
    bin.install 'contrib/ssh-copy-id'
    man1.install 'contrib/ssh-copy-id.1'
  end
end
