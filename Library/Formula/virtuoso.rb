class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "http://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.1/virtuoso-opensource-7.2.1.tar.gz"
  mirror "https://downloads.sourceforge.net/project/virtuoso/virtuoso/7.2.1/virtuoso-opensource-7.2.1.tar.gz"
  sha256 "8e680173f975266046cdc33b0949c6c3320b82630288aed778524657a32ee094"

  bottle do
    sha256 "21d31984d4134baf0d2061ca3f3d41a4c150077e5de87b48fa1e5d4abd81bee6" => :yosemite
    sha256 "866524f118b51e320accf5fa9c67ef33ccd5cc8631093ab6bce9c3a927cfef72" => :mavericks
    sha256 "be2bebd5c58be3c6f947c801d4f68eefc51ceff1cd4959c279da98e6c12cccf6" => :mountain_lion
  end

  head do
    url "https://github.com/openlink/virtuoso-opensource.git", :branch => "develop/7"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # If gawk isn't found, make fails deep into the process.
  depends_on "gawk" => :build
  depends_on "openssl"

  conflicts_with "unixodbc", :because => "Both install `isql` binaries."

  skip_clean :la

  def install
    ENV.m64 if MacOS.prefer_64_bit?
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    NOTE: the Virtuoso server will start up several times on port 1111
    during the install process.
    EOS
  end

  test do
    system bin/"virtuoso-t", "+checkpoint-only"
  end
end
