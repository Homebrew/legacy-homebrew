class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "http://www.libarchive.org"
  url "http://www.libarchive.org/downloads/libarchive-3.1.2.tar.gz"
  mirror "https://github.com/libarchive/libarchive/archive/v3.1.2.tar.gz"
  sha256 "eb87eacd8fe49e8d90c8fdc189813023ccc319c5e752b01fb6ad0cc7b2c53d5e"

  bottle do
    cellar :any
    revision 1
    sha256 "a73405a0d1395f88af0999215bb0cc342b09113f6270375c7b9fe0bbad870c57" => :el_capitan
    sha256 "daf4fb57f9b01c4a0d3ac33ec5fcc59e133ce3b08e01caa6ffaa2e098ae1adad" => :yosemite
    sha256 "2f640bcaaa7ea8f090b9d163bb0cabba69e3efb62ec5ca5547ccfc5980935f9e" => :mavericks
    sha256 "a0da458477e1e080db4c7dc75326dd28fc40b2d9ba158d39089c079de4fefbdf" => :mountain_lion
  end

  keg_only :provided_by_osx

  depends_on "xz" => :optional

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--without-lzo2",
                          "--without-nettle",
                          "--without-xml2"
    system "make", "install"
  end

  test do
    (testpath/"test").write("test")
    system bin/"bsdtar", "-czvf", "test.tar.gz", "test"
    assert_match /test/, shell_output("#{bin}/bsdtar -xOzf test.tar.gz")
  end
end
