class Eet < Formula
  desc "Library for writing arbitrary chunks of data to a file using compression"
  homepage "https://docs.enlightenment.org/auto/eet/eet_main.html"
  url "https://download.enlightenment.org/releases/eet-1.7.10.tar.gz"
  sha256 "c424821eb8ba09884d3011207b1ecec826bc45a36969cd4978b78f298daae1ee"

  bottle do
    cellar :any
    sha1 "73d9599c2ab8fa5067ff4fc4fddacbeb19b825c4" => :yosemite
    sha1 "36315f8d5bc59d56c6082e76e8dd2a9bfaec3735" => :mavericks
    sha1 "dcc57b32e7225fe86c83a5bfaade296d828b9ba0" => :mountain_lion
  end

  head do
    url "https://git.enlightenment.org/legacy/eet.git/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "eina"
  depends_on "jpeg"
  depends_on "lzlib"
  depends_on "openssl"

  conflicts_with "efl", :because => "both install `eet` binaries"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
