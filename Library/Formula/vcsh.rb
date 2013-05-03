require 'formula'

class Vcsh < Formula
  homepage 'https://github.com/RichiH/vcsh'
  url 'https://github.com/RichiH/vcsh/archive/v1.2-homebrew.tar.gz'
  version '1.2'
  sha1 '1114b6069b0ef2ca7606287664f4f0175829e968'

  depends_on 'mr'

  def install
    bin.install 'vcsh'
    man1.install 'vcsh.1'
  end

  test do
    system "#{bin}/vcsh"
  end
end
