class Eet < Formula
  desc "Library for writing arbitrary chunks of data to a file using compression"
  homepage "https://docs.enlightenment.org/auto/eet/eet_main.html"
  url "https://download.enlightenment.org/releases/eet-1.7.10.tar.gz"
  sha256 "c424821eb8ba09884d3011207b1ecec826bc45a36969cd4978b78f298daae1ee"

  bottle do
    cellar :any
    sha256 "4abc83f57045bac2a616e9fad2ac2682cc0dc02349aee61eb3be476927b0a234" => :yosemite
    sha256 "13ed7b21488a38091719103a5f10eb525ed0dc2f7488a86e380ee6e1b06833ae" => :mavericks
    sha256 "461aa471fb79395d1a9288eb923f6ab5039230291c605203dd86455c66c13a14" => :mountain_lion
  end

  conflicts_with "efl", :because => "efl aggregates formerly distinct libs, one of which is eet"

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

  test do
    cp "#{pkgshare}/examples/eet-basic.c", testpath
    eina = Formula["eina"]
    system ENV.cc, "-o", "eet-basic", "eet-basic.c",
        "-I#{include}/eet-1",
        "-I#{eina.include}/eina-1",
        "-I#{eina.include}/eina-1/eina",
        "-L#{lib}",
        "-leet"
    system "./eet-basic"
  end
end
