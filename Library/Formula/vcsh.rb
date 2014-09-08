require 'formula'

class Vcsh < Formula
  homepage 'https://github.com/RichiH/vcsh'
  url 'https://github.com/RichiH/vcsh/archive/v1.20131229-homebrew.tar.gz'
  version '1.20131229'
  sha1 'e8e19f433e81f396179b58edf45797de7a7a630a'

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
