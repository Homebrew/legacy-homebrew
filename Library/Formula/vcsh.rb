require 'formula'

class Vcsh < Formula
  homepage 'https://github.com/RichiH/vcsh'
  url 'https://github.com/RichiH/vcsh/archive/v1.20130829-homebrew.tar.gz'
  version '1.20130829'
  sha1 '68be053bf19c77d1fc71e70e71bc0c182f8ca5c9'

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
