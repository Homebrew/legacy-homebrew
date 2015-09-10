class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://github.com/ggreer/the_silver_searcher"
  url "https://github.com/ggreer/the_silver_searcher/archive/0.31.0.tar.gz"
  sha256 "61bc827f4557d8108e91cdfc9ba31632e2568b26884c92426417f58135b37da8"
  head "https://github.com/ggreer/the_silver_searcher.git"

  bottle do
    cellar :any
    sha256 "2083010fedc92dddfe1806bd505b37f67de334780a3351aa0f336f0a45f037c7" => :yosemite
    sha256 "7ec1a769eea33db96c16614beebcb184d775d682803870d0ec894a3dddb86db3" => :mavericks
    sha256 "2c771c3cd0f3189b4943ca0a57a1d96a082e3d418cfaaf8390d6f4a7fe8d781e" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "xz"

  def install
    # Stable tarball does not include pre-generated configure script
    system "aclocal", "-I #{HOMEBREW_PREFIX}/share/aclocal"
    system "autoconf"
    system "autoheader"
    system "automake", "--add-missing"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    bash_completion.install "ag.bashcomp.sh"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/ag", "Hello World!", testpath
  end
end
