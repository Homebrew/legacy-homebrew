class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "http://www.fresse.org/dateutils/"
  url "https://bitbucket.org/hroptatyr/dateutils/downloads/dateutils-0.3.3.tar.xz"
  mirror "https://github.com/hroptatyr/dateutils/releases/download/v0.3.3/dateutils-0.3.3.tar.xz"
  sha256 "3eb0b1dbf4519c86bc890a12c78cc85eae2cc10c20ff894a90ed55140efeee7a"

  bottle do
    sha256 "c74ecda07d3a64ca6d7df955952b63eb5666a6fbb3292ba60effa57bba44e98b" => :yosemite
    sha256 "ae5de247bc72823fc9568c8592ba44850388883068b702ed3ef81e1439c2e4f5" => :mavericks
    sha256 "1d1f07a896893e1b2440067835c8de442b423a0fbaec66630740024bb790f1ef" => :mountain_lion
  end

  head do
    url "https://github.com/hroptatyr/dateutils.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "2012-03-01-00", shell_output("#{bin}/dconv 2012-03-04 -f \"%Y-%m-%c-%w\"").strip
  end
end
