require 'formula'

class Fish < Formula
  homepage 'http://fishshell.com'
  url 'http://downloads.sourceforge.net/project/fish/fish/1.23.1/fish-1.23.1.tar.bz2'
  sha1 '3a6a5d0cfff348e5f9b1e7cd771865fd1dcd802e'

  head 'git://gitorious.org/fish-shell/fish-shell.git'

  # Indeed, the head build always builds documentation
  depends_on 'doxygen' => :build if build.head?
  depends_on :autoconf if build.head?
  depends_on 'readline'

  skip_clean 'share/doc'

  conflicts_with "fishfish"

  def patches
    p = []

    unless build.head?
      # Reduces the timeout in select_try() from 5s to 10ms.
      # The old timeout would cause fish to frequently freeze for a 5
      # second period.
      p << "http://gitorious.org/fish-shell/fish-shell/commit/6b8e7b16f6d4e11e168e3ce2effe2d8f0a53b184?format=patch"
    end
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}", "--without-xsel"
    system "make install"
  end

  def caveats; <<-EOS.undent
    You will need to add:
      #{HOMEBREW_PREFIX}/bin/fish
    to /etc/shells. Run:
      chsh -s #{HOMEBREW_PREFIX}/bin/fish
    to make fish your default shell.
    EOS
  end
end
