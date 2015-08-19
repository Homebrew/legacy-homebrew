class Nodenv < Formula
  desc "NodeJS version management"
  homepage "https://github.com/wfarr/nodenv"
  head "https://github.com/wfarr/nodenv.git"
  url "https://github.com/wfarr/nodenv/archive/v0.3.3.tar.gz"
  sha256 "50e18fe85e15b9c2e1a81b39279ab46413280b6c78434a63b1942984ff4d65bf"

  def install
    prefix.install "bin", "libexec"
  end

  def caveats; <<-EOS.undent
    To enable shims and autocompletion add to your profile:
      if which nodenv > /dev/null; then eval "$(nodenv init -)"; fi
    EOS
  end
end
