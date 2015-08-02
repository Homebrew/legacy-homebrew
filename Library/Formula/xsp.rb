class Xsp < Formula
  desc "Mono's ASP.NET hosting server"
  homepage "https://github.com/mono/xsp"
  url "https://github.com/mono/xsp/archive/3.0.11.tar.gz"
  sha256 "290e302a03396c5cff7eb53dae008e9f79dd00aca15ad1e62865907220483baa"

  bottle do
    cellar :any
    sha256 "3be0887c819a5823d226b26142b99fc9ceeab6e58a6c1252c84e152ee0f37d04" => :yosemite
    sha256 "ac6eaec05b4544e8a2eae419cadaa1cf6fbde53b37c3e19a71e8eca6fd2eae5c" => :mavericks
    sha256 "306cae75d2ae3ff1096b586835a19050e2e7f54532ec7c2140ef29dfd5a5cb03" => :mountain_lion
  end

  depends_on "mono"
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "xsp", "--help"
  end
end
