class Libmwaw < Formula
  desc "Library for converting legacy Mac document formats"
  homepage "https://sourceforge.net/p/libmwaw/wiki/Home/"
  url "https://downloads.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.7/libmwaw-0.3.7.tar.xz"
  sha256 "057611e871c279a28fcbede78dda11e500b9d5b341ab7064d6dce470f6fee8f9"

  bottle do
    cellar :any
    sha256 "0496f833b2205e5a6c4f84482b9f1ecae59745a6efdcbb2b30f75f5c959a921e" => :el_capitan
    sha256 "5431a412a8cc01b35d23c2743ea6449fa2d7e081c56837fb7d5f8d9db911f4ac" => :yosemite
    sha256 "ac4a80c75b3617b86cc72fecc7db1559edfd5717b1493ccdcd24d676c4e2b987" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "librevenge"

  resource "test_document" do
    url "https://github.com/openpreserve/format-corpus/raw/825c8a5af012a93cf7aac408b0396e03a4575850/office-examples/Old%20Word%20file/NEWSSLID.DOC"
    sha256 "df0af8f2ae441f93eb6552ed2c6da0b1971a0d82995e224b7663b4e64e163d2b"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testpath.install resource("test_document")
    # Test ID on an actual office document
    assert_equal shell_output("#{bin}/mwawFile #{testpath}/NEWSSLID.DOC").chomp,
                 "#{testpath}/NEWSSLID.DOC:Microsoft Word 2.0[pc]"
    # Control case; non-document format should return an empty string
    assert_equal shell_output("#{bin}/mwawFile #{test_fixtures("test.mp3")}").chomp,
                 ""
  end
end
