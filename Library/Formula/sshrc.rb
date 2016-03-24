class Sshrc < Formula
  desc "Bring your .bashrc, .vimrc, etc. with you when you SSH"
  homepage "https://github.com/Russell91/sshrc"
  url "https://github.com/Russell91/sshrc/archive/0.5.tar.gz"
  sha256 "4592df6fc2987adbbce84dbe305d9b769f7177a545122295629ce2fb61ecbba3"

  head "https://github.com/Russell91/sshrc.git"

  bottle :unneeded

  def install
    bin.install "sshrc"
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
