class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://github.com/ggreer/the_silver_searcher"
  url "https://github.com/ggreer/the_silver_searcher/archive/0.31.0.tar.gz"
  sha256 "61bc827f4557d8108e91cdfc9ba31632e2568b26884c92426417f58135b37da8"
  head "https://github.com/ggreer/the_silver_searcher.git"

  bottle do
    cellar :any
    sha256 "0967f4da9270f64c0dc389044976fa57a5ca77e8ae4b133db774b9b64f86a3f1" => :el_capitan
    sha256 "90ffccb93ee6a8f4df645b8ac65b2aaf909f17af235fa625e9cad91091f84176" => :yosemite
    sha256 "647d83eeb4b8372ef42c5565beaeb1282ac2c7e75330768aac642bbdc36cd68d" => :mavericks
    sha256 "023a995816ae0fe7e04321d7773bbedfe71dbdc52889b96f9867c6c71850c16c" => :mountain_lion
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
