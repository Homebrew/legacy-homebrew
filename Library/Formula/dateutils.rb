class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "http://www.fresse.org/dateutils/"
  url "https://bitbucket.org/hroptatyr/dateutils/downloads/dateutils-0.2.5.tar.xz"
  sha256 "7ecf1f92e1282f4975031f63148b5c778ce70b404a30846fb6bc5de64d3f3211"

  bottle do
    cellar :any
    sha1 "bcacbd417ff8109bd9bd73aaa0397e7738cda974" => :yosemite
    sha1 "aea972b1c122db46172d6e37fbfd3fd015fa7bdc" => :mavericks
    sha1 "628ce464741daf92af6dd31d8c93bb012324ae87" => :mountain_lion
  end

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
