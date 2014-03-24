require 'formula'

class TheSilverSearcher < Formula
  homepage 'https://github.com/ggreer/the_silver_searcher'
  head 'https://github.com/ggreer/the_silver_searcher.git'
  url 'https://github.com/ggreer/the_silver_searcher/archive/0.21.0.tar.gz'
  sha1 '86503dea202a0eca44a4207a97aa89e1d2353979'

  bottle do
    cellar :any
    sha1 "7f7c99a2238b58238ff74afa603a09c88a4b189a" => :mavericks
    sha1 "8c3f0b4d6f22bd18aaed2ab38268fdf99e38d235" => :mountain_lion
    sha1 "2370144c028fe38daef2c38163d9035d06d3adaa" => :lion
  end

  depends_on :automake
  depends_on :autoconf

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'xz'

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

    bash_completion.install 'ag.bashcomp.sh'
  end

  test do
    system "#{bin}/ag", "--version"
  end
end
