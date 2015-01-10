class Libmxml < Formula
  homepage "http://www.minixml.org/"
  url "https://www.msweet.org/files/project3/mxml-2.9.tar.gz"
  sha1 "a3d9c1f8cf8c7f85d76bb6954af1888d55f926f0"

  head "http://svn.msweet.org/mxml/"

  bottle do
    cellar :any
    revision 1
    sha1 "16c98f2cbfc50c2764876f62e86ff07aa3915ab4" => :yosemite
    sha1 "9e1d0dc2ade33ffa09dec9f0fa6ac382fffce659" => :mavericks
    sha1 "af0671b9ac604a6e8725785079a1eebab66a975a" => :mountain_lion
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
