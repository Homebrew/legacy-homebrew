require "formula"

class Nodenv < Formula
  homepage "https://github.com/wfarr/nodenv"
  head "https://github.com/wfarr/nodenv.git"
  url "https://github.com/wfarr/nodenv/archive/v0.3.3.tar.gz"
  sha1 "20f0cf2b698925c950de4be1899c615fc509d4b3"

  def install
    prefix.install "bin", "libexec"
  end

  def caveats; <<-EOS.undent
    To enable shims and autocompletion add to your profile:
      if which nodenv > /dev/null; then eval "$(nodenv init -)"; fi
    EOS
  end
end
