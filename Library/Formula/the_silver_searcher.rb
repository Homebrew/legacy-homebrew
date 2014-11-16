require "formula"

class TheSilverSearcher < Formula
  homepage "https://github.com/ggreer/the_silver_searcher"
  head "https://github.com/ggreer/the_silver_searcher.git"
  url "https://github.com/ggreer/the_silver_searcher/archive/0.26.0.tar.gz"
  sha1 "5d57d5fa4c5b4f837d652ab179fe2afc4e2564de"

  bottle do
    cellar :any
    sha1 "89bb95b4ac34c363c9405690f8f8975bb079fb32" => :yosemite
    sha1 "61649a8cc2a8fc8fe70916429f8c19fa9dbcd613" => :mavericks
    sha1 "705830c70b6fbb6b96db11d6ab7a76d66ee68cb9" => :mountain_lion
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
