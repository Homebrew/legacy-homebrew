class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "http://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20151213.59b0ed3.tar.gz"
  version "20151213"
  sha256 "c24eaa0b0e9f9c3474fa6a4aad7baff3b557a82e7b72276b2a557e37afafb612"

  head "git://git.tartarus.org/simon/agedu.git"

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
