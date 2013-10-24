require 'formula'

class Fish < Formula
  homepage 'http://fishshell.com'
  url 'https://github.com/fish-shell/fish-shell/archive/2.1.0.tar.gz`'
  sha1 '24fdd9ce9c253ae76d16bad0e6b178c28d6c8b7c'

  head do
    url 'https://github.com/fish-shell/fish-shell.git'

    # Indeed, the head build always builds documentation
    depends_on 'doxygen' => :build
  end

  depends_on :autoconf

  skip_clean 'share/doc'

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "fish", "-c", "echo"
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
