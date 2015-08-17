class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "http://www.fresse.org/dateutils/"
  url "https://bitbucket.org/hroptatyr/dateutils/downloads/dateutils-0.3.3.tar.xz"
  mirror "https://github.com/hroptatyr/dateutils/releases/download/v0.3.3/dateutils-0.3.3.tar.xz"
  sha256 "3eb0b1dbf4519c86bc890a12c78cc85eae2cc10c20ff894a90ed55140efeee7a"

  bottle do
    cellar :any
    sha1 "bcacbd417ff8109bd9bd73aaa0397e7738cda974" => :yosemite
    sha1 "aea972b1c122db46172d6e37fbfd3fd015fa7bdc" => :mavericks
    sha1 "628ce464741daf92af6dd31d8c93bb012324ae87" => :mountain_lion
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
