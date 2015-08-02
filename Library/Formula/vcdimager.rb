class Vcdimager < Formula
  desc "(Super) video CD authoring solution"
  homepage "https://www.gnu.org/software/vcdimager/"
  url "http://ftpmirror.gnu.org/vcdimager/vcdimager-0.7.24.tar.gz"
  mirror "https://ftp.gnu.org/gnu/vcdimager/vcdimager-0.7.24.tar.gz"
  sha256 "075d7a67353ff3004745da781435698b6bc4a053838d0d4a3ce0516d7d974694"

  bottle do
    cellar :any
    sha256 "0c30fb683f0fba64520275fd8a4be12a80ebb210806954768245e3a1d77971cb" => :yosemite
    sha256 "d2f4c9b849dd63c9ec44dcd32746ed9474e5807a53dbf8c1596b2ca722bed35b" => :mavericks
    sha256 "baec582f1f6bb2c3e6fa761acd30f7e86f19c8ad7572917df418834fe1041b96" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libcdio"
  depends_on "popt"

  def install
    ENV.libxml2

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"vcdimager", "--help"
  end
end
