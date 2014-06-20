require "formula"

class TheSilverSearcher < Formula
  homepage "https://github.com/ggreer/the_silver_searcher"
  head "https://github.com/ggreer/the_silver_searcher.git"
  url "https://github.com/ggreer/the_silver_searcher/archive/0.22.0.tar.gz"
  sha1 "6908ef26405270f483476513d3016599507a92e6"

  bottle do
    cellar :any
    sha1 "469556aacffcf3d45db93577412f8c60e526d518" => :mavericks
    sha1 "19da98294cf6ad9b6fc4d520156ef0fce1467a8c" => :mountain_lion
    sha1 "5736914f8a4fa2720919539e8ed0d48fce8f03e6" => :lion
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
