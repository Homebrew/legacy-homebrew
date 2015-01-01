class Dateutils < Formula
  homepage "http://www.fresse.org/dateutils/"
  url "https://bitbucket.org/hroptatyr/dateutils/downloads/dateutils-0.2.5.tar.xz"
  sha1 "47f2ba469daff7586d47473f54a77848b724ba45"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "2012-03-01-00", shell_output("#{bin}/dconv 2012-03-04 -f \"%Y-%m-%c-%w\"").strip
  end
end
