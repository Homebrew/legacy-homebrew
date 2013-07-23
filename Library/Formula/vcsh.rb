require 'formula'

class Vcsh < Formula
  homepage 'https://github.com/RichiH/vcsh'
  url 'https://github.com/RichiH/vcsh/archive/v1.20130723-homebrew.tar.gz'
  version '1.20130723'
  sha1 '7c170a45c6241f04bd1ee5974c6112c937db25a2'

  depends_on 'mr'

  def install
    bin.install 'vcsh'
    man1.install 'vcsh.1'
  end

  test do
    system "#{bin}/vcsh"
  end
end
