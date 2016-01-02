class Libmxml < Formula
  desc "Mini-XML library"
  homepage "http://www.minixml.org/"
  url "https://www.msweet.org/files/project3/mxml-2.9.tar.gz"
  sha256 "cded54653c584b24c4a78a7fa1b3b4377d49ac4f451ddf170ebbc8161d85ff92"

  head "http://svn.msweet.org/mxml/"

  bottle do
    cellar :any
    sha256 "804da1287c900a1938f8360bf5df961fa85de040ea85fd0ad6490b7f30373af1" => :yosemite
    sha256 "d92c245dcf1edb8c4d218f7506748cced58a5c5a7b7cefb9632ef22958ae7abc" => :mavericks
    sha256 "df203c2e058d9e4d7980c1bfef686a2033f3ad84e3b405ef2d698dbffbdc3919" => :mountain_lion
  end

  depends_on :xcode => :build # for docsetutil

  def install
    system "./configure", "--disable-debug",
                          "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      int testfunc(char *string)
      {
        return string ? string[0] : 0;
      }
    EOS
    assert_match /testfunc/, shell_output("#{bin}/mxmldoc test.c")
  end
end
