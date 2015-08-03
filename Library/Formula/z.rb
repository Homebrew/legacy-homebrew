class Z < Formula
  desc "Tracks most-used directories to make cd smarter"
  homepage "https://github.com/rupa/z"
  url "https://github.com/rupa/z/archive/v1.8.tar.gz"
  sha256 "8c06cc65a14cd76bc35f1394ea3a8734eade76b2e676b2245aae22acb2485897"

  head "https://github.com/rupa/z.git"

  def install
    (prefix/"etc/profile.d").install "z.sh"
    man1.install "z.1"
  end

  def caveats; <<-EOS.undent
    For Bash or Zsh, put something like this in your $HOME/.bashrc or $HOME/.zshrc:
      . `brew --prefix`/etc/profile.d/z.sh
    EOS
  end
end
