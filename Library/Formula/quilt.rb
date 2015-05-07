class Quilt < Formula
  homepage "https://savannah.nongnu.org/projects/quilt"
  url "http://download.savannah.gnu.org/releases/quilt/quilt-0.64.tar.gz"
  sha256 "c4bfd3282214a288e8d3e921ae4d52e73e24c4fead72b5446752adee99a7affd"

  head "http://git.savannah.gnu.org/r/quilt.git"

  bottle do
    revision 1
    sha1 "035ec6126a3b82e8ea86cf1804bf1da650f48cd4" => :yosemite
    sha1 "369aee1a032fb132b1177aa6b51254e8d1751d5a" => :mavericks
    sha1 "5e323ed88f03a34f4d290a2341fc09cc6c63c1c1" => :mountain_lion
  end

  depends_on "gnu-sed"
  depends_on "coreutils"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-sed=#{HOMEBREW_PREFIX}/bin/gsed",
                          "--without-getopt"
    system "make"
    system "make", "install"
    (share/"emacs/site-lisp").install "lib/quilt.el"
  end

  test do
    mkdir "patches"
    (testpath/"test.txt").write "Hello, World!"
    system "#{bin}/quilt", "new", "test.patch"
    system "#{bin}/quilt", "add", "test.txt"
    rm "test.txt"
    (testpath/"test.txt").write "Hi!"
    system "#{bin}/quilt", "refresh"
    assert_match /-Hello, World!/, File.read("patches/test.patch")
    assert_match /\+Hi!/, File.read("patches/test.patch")
  end
end
