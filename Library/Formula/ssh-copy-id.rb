class SshCopyId < Formula
  homepage "http://www.openssh.com/"
  url "http://ftp.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.7p1.tar.gz"
  mirror "http://ftp3.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.7p1.tar.gz"
  version "6.7p1"
  sha1 "14e5fbed710ade334d65925e080d1aaeb9c85bf6"

  bottle do
    cellar :any
    sha1 "5e9e5c5e53951435d1a6b408401301fbba2e6ee4" => :yosemite
    sha1 "4ea46c7153cf26546b9d794cf9b63722c191faec" => :mavericks
    sha1 "409ea4f6ba8a6f6d6fce94d33d6c8a59091ab89b" => :mountain_lion
  end

  def install
    bin.install "contrib/ssh-copy-id"
    man1.install "contrib/ssh-copy-id.1"
  end

  test do
    shell_output bin/"ssh-copy-id -h", 1
  end
end
