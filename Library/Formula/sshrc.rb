class Sshrc < Formula
  desc "Bring your .bashrc, .vimrc, etc. with you when you SSH"
  homepage "https://github.com/Russell91/sshrc"
  url "https://github.com/Russell91/sshrc/archive/0.6.tar.gz"
  sha256 "3ef0da05883921632b6faed391672080bfffc7efd238be4d128ef1b23c62949b"

  head "https://github.com/Russell91/sshrc.git"

  bottle :unneeded

  def install
    bin.install %w[sshrc moshrc]
  end

  test do
    touch testpath/".sshrc"
    (testpath/"ssh").write <<-EOS.undent
      #!/bin/sh
      true
    EOS
    chmod 0755, testpath/"ssh"
    ENV.prepend_path "PATH", testpath
    system "sshrc"
  end
end
