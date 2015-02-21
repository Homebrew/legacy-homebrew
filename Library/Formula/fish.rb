class Fish < Formula
  homepage "http://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/archive/2.1.2.tar.gz"
  sha1 "fd40ed8de7497bf1578f50df6674b2d0464395fe"

  bottle do
    sha1 "4fadd805fc166fd1692e7159339ded169577d195" => :yosemite
    sha1 "1feab6ebb28ba6acf7290a5054a04d3d81f3ef1f" => :mavericks
    sha1 "6e3d623a17b6b0b566a8c466574ff32cfffaa3ea" => :mountain_lion
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false
  end

  # This pair of dependencies should be revisited upon fish's next release.
  # (they're normally only necessary for HEAD builds)
  depends_on "autoconf" => :build
  depends_on "doxygen" => :build

  skip_clean "share/doc"

  def install
    # As described above, needing autoconf on a release is temporary; once
    # fish has another major release, we can probably restore the
    # `if build.head?` statement modifier.
    system "autoconf"
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
