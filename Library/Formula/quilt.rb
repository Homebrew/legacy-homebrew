class Quilt < Formula
  desc "Work with series of patches"
  homepage "https://savannah.nongnu.org/projects/quilt"
  url "http://download.savannah.gnu.org/releases/quilt/quilt-0.64.tar.gz"
  sha256 "c4bfd3282214a288e8d3e921ae4d52e73e24c4fead72b5446752adee99a7affd"

  head "http://git.savannah.gnu.org/r/quilt.git"

  bottle do
    sha256 "3348a942b8d359521bc238fd0bfacce702fa4b1eb244eae7c431d716056e8992" => :yosemite
    sha256 "b4460abfc441043b55961c20583d5c309ce11f50e1e9bfc5de6d0f1d01410107" => :mavericks
    sha256 "feb310eca4228414e672e482369ee281e4bba9187cf373a6b27bd7db697da436" => :mountain_lion
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
