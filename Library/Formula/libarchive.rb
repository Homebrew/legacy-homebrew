class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "http://www.libarchive.org"
  url "http://www.libarchive.org/downloads/libarchive-3.1.2.tar.gz"
  mirror "https://github.com/libarchive/libarchive/archive/v3.1.2.tar.gz"
  sha256 "eb87eacd8fe49e8d90c8fdc189813023ccc319c5e752b01fb6ad0cc7b2c53d5e"

  depends_on "xz" => :optional

  bottle do
    cellar :any
    revision 1
    sha256 "a73405a0d1395f88af0999215bb0cc342b09113f6270375c7b9fe0bbad870c57" => :el_capitan
    sha1 "4457352669eb58cd60610f5f4b2429808facdff8" => :yosemite
    sha1 "708da02bb7015579b48d06174f776f781befc052" => :mavericks
    sha1 "886851569f64d0d90970af31ed526c2e387dd3d3" => :mountain_lion
  end

  keg_only :provided_by_osx

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
