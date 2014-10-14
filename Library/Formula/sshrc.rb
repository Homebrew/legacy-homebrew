require "formula"

class Sshrc < Formula
  homepage "https://github.com/Russell91/sshrc"
  url "https://github.com/Russell91/sshrc/archive/0.4.tar.gz"
  sha1 "9e9426323d6b2cb118275b2d5836510dbd87a75a"

  def install
    bin.install "sshrc"
  end

  test do
    ENV["HOME"] = testpath
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
