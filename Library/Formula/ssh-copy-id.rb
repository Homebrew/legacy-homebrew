require 'formula'

class SshCopyId < Formula
  url 'http://ftp.heanet.ie/pub/OpenBSD/OpenSSH/portable/openssh-5.5p1.tar.gz'
  version '5.5p1'
  homepage 'http://openssh.org/'
  md5 '88633408f4cb1eb11ec7e2ec58b519eb'

  def install
    bin.install 'contrib/ssh-copy-id'
    man1.install 'contrib/ssh-copy-id.1'
  end
end
