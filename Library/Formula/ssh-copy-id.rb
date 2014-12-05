require 'formula'

class SshCopyId < Formula
  homepage 'http://www.openssh.com/'
  url 'http://ftp.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.7p1.tar.gz'
  mirror 'http://ftp3.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.7p1.tar.gz'
  version '6.7p1'
  sha1 '14e5fbed710ade334d65925e080d1aaeb9c85bf6'

  bottle do
    cellar :any
    sha1 "744408742dfae4e3bedd78014bcabc1693ca0d46" => :yosemite
    sha1 "c62e6863235b9cb0dc9c78c04971b8692332f935" => :mavericks
    sha1 "76b719c4c3391344d5aa2d22ded2fcc0db45f2c9" => :mountain_lion
    sha1 "4b679aea29d2ec0e9fd2292cc7ea6b3955747096" => :lion
  end

  def install
    bin.install 'contrib/ssh-copy-id'
    man1.install 'contrib/ssh-copy-id.1'
  end
end
