class SshCopyId < Formula
  desc "Add a public key to a remote machine's authorized_keys file"
  homepage "http://www.openssh.com/"
  url "http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.1p1.tar.gz"
  mirror "https://www.mirrorservice.org/pub/OpenBSD/OpenSSH/portable/openssh-7.1p1.tar.gz"
  version "7.1p1"
  sha256 "fc0a6d2d1d063d5c66dffd952493d0cda256cad204f681de0f84ef85b2ad8428"

  bottle :unneeded

  def install
    bin.install "contrib/ssh-copy-id"
    man1.install "contrib/ssh-copy-id.1"
  end

  test do
    output = shell_output("#{bin}/ssh-copy-id -h 2>&1", 1)
    assert_match /identity_file/, output
  end
end
