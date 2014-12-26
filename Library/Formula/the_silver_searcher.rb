class TheSilverSearcher < Formula
  homepage "https://github.com/ggreer/the_silver_searcher"
  head "https://github.com/ggreer/the_silver_searcher.git"
  url "https://github.com/ggreer/the_silver_searcher/archive/0.28.0.tar.gz"
  sha1 "95ef49e671db12ee56c883fe8f6e7b0a0ce18b81"

  bottle do
    cellar :any
    sha1 "b4e0e52e77832392ee1c3d81dd4da1ea80b61438" => :yosemite
    sha1 "4012d3528d1a14016de75fcb51cbf7982279eaba" => :mavericks
    sha1 "bae086726850153caa7566f8fe1ebf239faeb46b" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "xz"

  # Edit bash completion script to not require bash-completion
  # The `have ag` test is redundant in any case, since the script will only
  # be installed if Ag itself is installed. See:
  # https://github.com/ggreer/the_silver_searcher/issues/208
  # https://github.com/Homebrew/homebrew/issues/27418
  patch do
    url "https://github.com/thomasf/the_silver_searcher/commit/867dff8631bc80d760268f653265e4d3caf44f16.diff"
    sha1 "09502c60a11658d9a08a6825e78defad96318bd9"
  end

  def install
    # Stable tarball does not include pre-generated configure script
    system "aclocal -I #{HOMEBREW_PREFIX}/share/aclocal"
    system "autoconf"
    system "autoheader"
    system "automake --add-missing"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"

    bash_completion.install "ag.bashcomp.sh"
  end

  test do
    system "#{bin}/ag", "--version"
  end
end
