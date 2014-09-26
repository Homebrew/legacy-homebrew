require "formula"

class Fish < Formula
  homepage "http://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/2.1.1/fish-2.1.1.tar.gz"
  sha1 "8f97f39b92ea7dfef1f464b18e304045bf37546d"

  head do
    url "https://github.com/fish-shell/fish-shell.git"

    depends_on :autoconf
    # Indeed, the head build always builds documentation
    depends_on "doxygen" => :build
  end

  skip_clean "share/doc"

  def install
    system "autoconf" if build.head?
    # In Homebrew's 'superenv' sed's path will be incompatible, so
    # the correct path is passed into configure here.
    system "./configure", "--prefix=#{prefix}", "SED=/usr/bin/sed"
    system "make", "install"
  end

  def post_install
    system "pkill fishd || true"
  end

  test do
    system "#{bin}/fish", "-c", "echo"
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
