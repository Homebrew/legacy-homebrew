require "formula"

class Sshrc < Formula
  desc "Bring your .bashrc, .vimrc, etc. with you when you SSH"
  homepage "https://github.com/Russell91/sshrc"
  url "https://github.com/Russell91/sshrc/archive/0.5.tar.gz"
  sha1 "4fe9509437d01da74be76215d920734484ca0b7b"

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
