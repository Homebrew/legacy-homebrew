class Nodenv < Formula
  desc "NodeJS version management"
  homepage "https://github.com/wfarr/nodenv"
  head "https://github.com/wfarr/nodenv.git"
  url "https://github.com/wfarr/nodenv/archive/v0.3.4.tar.gz"
  sha256 "6d3946960beed4e69596a5f0519ad4ca7606db4e4ab1b85a3bf4add06d64290b"

  def install
    prefix.install "bin", "libexec"
  end

  def caveats; <<-EOS.undent
    To enable shims and autocompletion add to your profile:
      if which nodenv > /dev/null; then eval "$(nodenv init -)"; fi
    EOS
  end
end
