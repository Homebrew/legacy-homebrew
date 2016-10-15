require "formula"

class SshAskpass < Formula
  homepage "https://github.com/theseal/ssh-askpass/"
  url "https://github.com/theseal/ssh-askpass/archive/v1.0.0.tar.gz"
  sha1 "92f5402e3b1ad3ceab3f07d18797bf3ab48fca80"

  def install
    bin.install "ssh-askpass"
  end

  def caveats; <<-EOF.undent
    In order to use ssh-askpass with ssh you have to link the binary to /usr/libexec:

    sudo ln -s /usr/local/bin/ssh-askpass /usr/libexec/ssh-askpass

    NOTE: When uninstalling ssh-askpass the symlink needs to be removed manually.
    EOF
  end
end
