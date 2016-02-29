class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://fishshell.com/files/2.2.0/fish-2.2.0.tar.gz"
  sha256 "a76339fd14ce2ec229283c53e805faac48c3e99d9e3ede9d82c0554acfc7b77a"

  bottle do
    revision 1
    sha256 "bae2a0bf4fb942e18acc911c4169588f6982e717513ad85a8e07c7484af44408" => :el_capitan
    sha256 "6be5af9624adf408cddf9000f86c133e3e33613c10d9e1af94c9e36dd6df9826" => :yosemite
    sha256 "6b215dbab60ed14d1fe6766d92aaf55e9e3172192af5f5ee6cf1cdfda48ac4ff" => :mavericks
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
