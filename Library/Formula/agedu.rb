class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "http://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20151213.59b0ed3.tar.gz"
  version "20151213"
  sha256 "c24eaa0b0e9f9c3474fa6a4aad7baff3b557a82e7b72276b2a557e37afafb612"

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
