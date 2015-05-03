class Ncdu < Formula
  homepage "http://dev.yorhel.nl/ncdu"
  url "http://dev.yorhel.nl/download/ncdu-1.11.tar.gz"
  sha256 "d0aea772e47463c281007f279a9041252155a2b2349b18adb9055075e141bb7b"

  head do
    url "git://g.blicky.net/ncdu.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncdu -v")
  end
end
