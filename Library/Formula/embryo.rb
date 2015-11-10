class Embryo < Formula
  desc "Version of the original Small abstract machine"
  homepage "https://docs.enlightenment.org/auto/embryo/embryo_main.html"
  url "https://download.enlightenment.org/releases/embryo-1.7.10.tar.gz"
  sha256 "d6700ba34d7903f53695246ca3edd3fe463ed1acbadd283219ec9678bc4989a0"

  bottle do
    sha1 "8f7302633c71b4cbe0ca77b12a2c9a934c10f9f8" => :yosemite
    sha1 "9edfb2b516c9934858264d3905beb7a0e2aee232" => :mavericks
    sha1 "b2d9d7f7322053097094c4afe1474eec7e19987b" => :mountain_lion
  end

  head do
    url "https://git.enlightenment.org/legacy/embryo.git/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "eina"

  conflicts_with "efl", :because => "both install `embryo_cc` binaries"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
