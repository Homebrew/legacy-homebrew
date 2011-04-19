require 'formula'

class Fish < Formula
  url 'http://downloads.sourceforge.net/project/fish/fish/1.23.1/fish-1.23.1.tar.bz2'
  homepage 'http://fishshell.org/'
  md5 'ead6b7c6cdb21f35a3d4aa1d5fa596f1'

  depends_on 'readline'
  skip_clean 'share/doc'

  def patches
    # Reduces the timeout in select_try() from 5s to 10ms.
    # The old timeout would cause fish to frequently freeze for a 5
    # second period.
    "http://gitorious.org/fish-shell/fish-shell/commit/6b8e7b16f6d4e11e168e3ce2effe2d8f0a53b184.patch?format=diff"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--without-xsel"
    system "make install"
  end

  def caveats
    "You will need to add #{HOMEBREW_PREFIX}/bin/fish to /etc/shells\n"+
    "Run `chsh -s #{HOMEBREW_PREFIX}/bin/fish' to make fish your default shell."
  end
end
