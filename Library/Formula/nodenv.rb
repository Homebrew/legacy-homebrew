require "formula"

class Nodenv < Formula
  homepage "https://github.com/OiNutter/nodenv"
  head "https://github.com/OiNutter/nodenv.git"
  url "https://github.com/OiNutter/nodenv/archive/v0.2.0.tar.gz"
  sha1 "ce66e6a546ad92b166c4133796df11cd9fbbbd5f"

  def install
    prefix.install "bin", "libexec"
  end

  def caveats; <<-EOS.undent
    To enable shims and autocompletion add to your profile:
      if which nodenv > /dev/null; then eval "$(nodenv init -)"; fi
    EOS
  end
end
