class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-1.11.tar.gz"
  sha256 "d0aea772e47463c281007f279a9041252155a2b2349b18adb9055075e141bb7b"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "0f0c343fcb56d2e59f9e233898dfffddb343060411ecfb6e807652b613e141a3" => :el_capitan
    sha256 "8dd9475838739a68605a833343c2ee84734eba3d0fe0055ef0e94def9fae7a12" => :yosemite
    sha256 "601220fb259bf683eeef77ac1f2717d474d858ad6a63b970917949ef1d519f11" => :mavericks
  end

  head do
    url "https://g.blicky.net/ncdu.git"

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
