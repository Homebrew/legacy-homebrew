require 'formula'

class SshCopyId < Formula
  homepage 'http://www.openssh.com/'
  url 'http://ftp.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.5p1.tar.gz'
  mirror 'http://ftp3.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.5p1.tar.gz'
  version '6.5p1'
  sha1 '3363a72b4fee91b29cf2024ff633c17f6cd2f86d'

  def install
    bin.install 'contrib/ssh-copy-id'
    man1.install 'contrib/ssh-copy-id.1'
  end
end
