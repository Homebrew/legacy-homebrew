class Vcdimager < Formula
  homepage "https://www.gnu.org/software/vcdimager/"
  url "http://ftpmirror.gnu.org/vcdimager/vcdimager-0.7.24.tar.gz"
  mirror "https://ftp.gnu.org/gnu/vcdimager/vcdimager-0.7.24.tar.gz"
  sha256 "075d7a67353ff3004745da781435698b6bc4a053838d0d4a3ce0516d7d974694"

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
