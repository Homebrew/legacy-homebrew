require "formula"

class Nodenv < Formula
  homepage "https://github.com/wfarr/nodenv"
  url "https://github.com/wfarr/nodenv/archive/v0.3.3.tar.gz"
  sha1 "20f0cf2b698925c950de4be1899c615fc509d4b3"

  head "https://github.com/wfarr/nodenv.git"

  def install
    prefix.install Dir['*']
  end

  def caveats; <<-EOS.undent
    To enable shims and autocompletion add to your profile:
      if which nodenv > /dev/null; then eval "$(nodenv init -)"; fi
    EOS
  end

end
