class SshCopyId < Formula
  desc "Add a public key to a remote machine's authorized_keys file"
  homepage "http://www.openssh.com/"
  url "http://ftp.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.8p1.tar.gz"
  mirror "http://ftp3.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.8p1.tar.gz"
  version "6.8p1"
  sha256 "3ff64ce73ee124480b5bf767b9830d7d3c03bbcb6abe716b78f0192c37ce160e"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f25914290d93c4981c3ece66f15896c71752e5601e5424b2a8bff6c15e46121" => :el_capitan
    sha256 "4c89eddf0780ce6d65d9b2c8a5c1c3ddb536953daf4758524c369f6b40fcf593" => :yosemite
    sha256 "36d4f00ce8ea2a61b89b3af35252cfc269010d10b4e6ddfc09d1b74189070184" => :mavericks
    sha256 "5e57c77e0eae4650040b81824063e9672936d80aff16dbc77986e00d38a79e8a" => :mountain_lion
  end

  def install
    bin.install "contrib/ssh-copy-id"
    man1.install "contrib/ssh-copy-id.1"
  end

  test do
    shell_output bin/"ssh-copy-id -h", 1
  end
end
