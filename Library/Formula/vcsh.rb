require 'formula'

class Vcsh < Formula
  homepage 'https://github.com/RichiH/vcsh'
  url 'https://github.com/RichiH/vcsh/archive/v1.1-homebrew.tar.gz'
  version '1.1'
  sha1 '2e51f6930528f668536478958205092a595b81c9'

  depends_on 'mr'

  def install
    bin.install 'vcsh'
    man1.install 'vcsh.1'
  end

  test do
    system "#{bin}/vcsh"
  end
end
