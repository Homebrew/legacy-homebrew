class Quilt < Formula
  desc "Work with series of patches"
  homepage "https://savannah.nongnu.org/projects/quilt"
  url "http://download.savannah.gnu.org/releases/quilt/quilt-0.64.tar.gz"
  sha256 "c4bfd3282214a288e8d3e921ae4d52e73e24c4fead72b5446752adee99a7affd"

  head "http://git.savannah.gnu.org/r/quilt.git"

  bottle do
    revision 1
    sha256 "8f4e75281279df9d503c160a83dda1611483bada421115ec2c5af82ec0a3b9b2" => :yosemite
    sha256 "1d69453caf8f13e9ecd5a3310e872b3fdd562bd89b6b6335ce9874f613b59ff2" => :mavericks
    sha256 "452546bfd83c8ace6c95764a19c86d6d2eecdddcd3a289135a5a50648ecd494d" => :mountain_lion
  end

  depends_on "gnu-sed"
  depends_on "coreutils"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-sed=#{HOMEBREW_PREFIX}/bin/gsed",
                          "--without-getopt"
    system "make"
    system "make", "install", "emacsdir=#{share}/emacs/site-lisp/quilt"
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
