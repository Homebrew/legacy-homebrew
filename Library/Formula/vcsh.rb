require 'formula'

class Vcsh < Formula
  homepage 'https://github.com/RichiH/vcsh'
  url 'https://github.com/RichiH/vcsh/archive/v1.20130724-homebrew.tar.gz'
  version '1.20130724'
  sha1 '3cda5c059bbe40fbd55ff8d0d74dd9f327a15da2'

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
