require "formula"

class TheSilverSearcher < Formula
  homepage "https://github.com/ggreer/the_silver_searcher"
  head "https://github.com/ggreer/the_silver_searcher.git"
  url "https://github.com/ggreer/the_silver_searcher/archive/0.27.0.tar.gz"
  sha1 "3d2e85b5d3cb9fd1caccfaee9d8e5d140271b2fd"

  bottle do
    cellar :any
    sha1 "451b8f2db79d5f49cb2fafc0951cfc9033de921e" => :yosemite
    sha1 "f2243c0b86be0041fcd7ec66b0ff4a85e433676d" => :mavericks
    sha1 "f46f96252d7569c9b2e7e860643c9fbe18b16517" => :mountain_lion
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
