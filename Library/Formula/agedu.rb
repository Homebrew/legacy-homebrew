class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "http://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20160302.a05fca7.tar.gz"
  version "20160302"
  sha256 "2de59dab2c79d119faefb0c34fad26ec07e209d739538f2eaac96ed0f5473c5a"

  head "git://git.tartarus.org/simon/agedu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb9bb1e8c51a69f1ce4d857db94407b4b18fe1030009b53ee780a2af1cebf593" => :el_capitan
    sha256 "66cfeff80d76e872869e51c49dbd2d73ffcf9a3b84b8c89797d19ba139294399" => :yosemite
    sha256 "fd35fb9e4eccd3c34074c59b8352353d955339a5eb5e992632f7c4c122ada290" => :mavericks
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
