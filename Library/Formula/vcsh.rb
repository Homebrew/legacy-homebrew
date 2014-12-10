require 'formula'

class Vcsh < Formula
  homepage 'https://github.com/RichiH/vcsh'
  url 'https://github.com/RichiH/vcsh/archive/v1.20141026-manpage-static.tar.gz'
  version '1.20141026'
  sha1 '9e4fac6d354fca4bda32cab8fa7f0fffe4ddd110'

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
