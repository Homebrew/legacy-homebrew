class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "http://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20160302.a05fca7.tar.gz"
  version "20160302"
  sha256 "2de59dab2c79d119faefb0c34fad26ec07e209d739538f2eaac96ed0f5473c5a"

  head "git://git.tartarus.org/simon/agedu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b140250d0f1318a6201c7c9f8fb38db23bd0d5bcbda667c93fe9d4a2bbd13722" => :el_capitan
    sha256 "d87a2e0a8661ddf654a19dde92c03a70dea2b4e9fbca03bc1915367e31dd8d1f" => :yosemite
    sha256 "d003c0fe2435ba2af53bb3e94d87959c634530ffcdcc30a16923974cdb17036d" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "halibut" => :build

  def install
    system "./mkauto.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/agedu", "-s", "."
    assert (testpath/"agedu.dat").exist?
  end
end
