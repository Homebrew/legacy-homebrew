class Pv < Formula
  homepage "http://www.ivarch.com/programs/pv.shtml"
  url "http://www.ivarch.com/programs/sources/pv-1.5.7.tar.bz2"
  sha1 "173d87d11d02a524037228f6495c46cad3214b7d"

  bottle do
    revision 1
    sha1 "0c77b97448d2705d9e9f5a63ceafa42e483a21d9" => :yosemite
    sha1 "a49bcc1abe924b622d06fb15eb01141d0c252f40" => :mavericks
    sha1 "1441d97ae226d2cb3e3519ae714cf47940d6595a" => :mountain_lion
  end

  depends_on "gettext"

  fails_with :llvm do
    build 2334
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip
  end
end
