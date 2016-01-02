class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "http://fishshell.com"
  url "http://fishshell.com/files/2.2.0/fish-2.2.0.tar.gz"
  sha256 "a76339fd14ce2ec229283c53e805faac48c3e99d9e3ede9d82c0554acfc7b77a"

  bottle do
    sha256 "9280e5816611c7cfcdaae77eeb840f93637c102dd2a6f16c00ab68394f4e4cb3" => :el_capitan
    sha256 "da78a022f31317da5d6be21e6090a6c3424565ee7296b0d8ddd6adae2d6737ec" => :yosemite
    sha256 "ecb9981625135e46ef4b89fbe08014f7fa1ba9754ca8bcd83afd43996ab7a90d" => :mavericks
    sha256 "1a87c0e5f9dcecefd1f7e68975ed49308d4ab6a81f70e81b3aecae1b827ea261" => :mountain_lion
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "doxygen" => :build
    depends_on "pcre2"
  end

  def install
    system "autoconf" if build.head?
    # In Homebrew's 'superenv' sed's path will be incompatible, so
    # the correct path is passed into configure here.
    system "./configure", "--prefix=#{prefix}", "SED=/usr/bin/sed"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    You will need to add:
      #{HOMEBREW_PREFIX}/bin/fish
    to /etc/shells.

    Then run:
      chsh -s #{HOMEBREW_PREFIX}/bin/fish
    to make fish your default shell.

    If you are upgrading from an older version of fish, you should now run:
      killall fishd
    to terminate the outdated fish daemon.
    EOS
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
