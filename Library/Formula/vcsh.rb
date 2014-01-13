require 'formula'

class Vcsh < Formula
  homepage 'https://github.com/RichiH/vcsh'
  url 'https://github.com/RichiH/vcsh/archive/v1.20131214-homebrew.tar.gz'
  version '1.20131214'
  sha1 'ee4d125796608f5148bce8a8dc086358b479a360'

  depends_on 'mr'

  def install
    bin.install 'vcsh'
    man1.install 'vcsh.1'
    zsh_completion.install '_vcsh'
  end

  test do
    system "#{bin}/vcsh"
  end
end
