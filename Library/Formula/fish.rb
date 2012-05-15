require 'formula'

class Fish < Formula
  url 'http://downloads.sourceforge.net/project/fish/fish/1.23.1/fish-1.23.1.tar.bz2'
  homepage 'http://fishshell.com'
  md5 'ead6b7c6cdb21f35a3d4aa1d5fa596f1'

  head 'git://gitorious.org/fish-shell/fish-shell.git'

  # Indeed, the head build always builds documentation
  depends_on 'doxygen' => :build if ARGV.build_head?
  depends_on 'autoconf' => :build if MacOS.xcode_version.to_f >= 4.3 and ARGV.build_head?
  depends_on 'readline'
  skip_clean 'share/doc'

  def patches
    p = []

    unless ARGV.build_head?
      # Reduces the timeout in select_try() from 5s to 10ms.
      # The old timeout would cause fish to frequently freeze for a 5
      # second period.
      p << "http://gitorious.org/fish-shell/fish-shell/commit/6b8e7b16f6d4e11e168e3ce2effe2d8f0a53b184.patch?format=diff"
    end
  end

  def install
    system "autoconf" if ARGV.build_head?
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
