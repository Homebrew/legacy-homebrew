class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "http://fishshell.com"
  url "http://fishshell.com/files/2.2.0/fish-2.2.0.tar.gz"
  sha256 "a76339fd14ce2ec229283c53e805faac48c3e99d9e3ede9d82c0554acfc7b77a"

  bottle do
    revision 1
    sha1 "7560818f385831e3d18be1458b1c5e52216f121c" => :yosemite
    sha1 "a158ae57a437e5f8b2fdff88177be13fa6f35502" => :mavericks
    sha1 "8d0aa59ebb4cf446e0f0fdf0f91738ffee7edbae" => :mountain_lion
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "doxygen" => :build
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
    to /etc/shells. Run:
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
