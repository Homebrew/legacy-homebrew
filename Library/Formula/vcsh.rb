require 'formula'

class Vcsh < Formula
  homepage 'https://github.com/RichiH/vcsh'
  url 'https://github.com/RichiH/vcsh/archive/v1.3-homebrew.tar.gz'
  version '1.3'
  sha1 'bb26ef4c74b2ab23d3cc5bfde294e7188fe89ffb'

  depends_on 'mr'

  def install
    bin.install 'vcsh'
    man1.install 'vcsh.1'
  end

  test do
    system "#{bin}/vcsh"
  end
end
