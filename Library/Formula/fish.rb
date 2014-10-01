require "formula"

class Fish < Formula
  homepage "http://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/2.1.1/fish-2.1.1.tar.gz"
  sha1 "8f97f39b92ea7dfef1f464b18e304045bf37546d"

  bottle do
    sha1 "61736de475346ff8aba971429d217b827730bc65" => :mavericks
    sha1 "1d8d3f5656a4a9ec53d22b908581109eecfc9769" => :mountain_lion
    sha1 "56535dfe5f9a6c4bad0b7d8e9571ab00e5a2f772" => :lion
  end

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
