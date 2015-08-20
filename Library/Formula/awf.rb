class Awf < Formula
  desc "awf (A Widget Factory) is a theme preview application for gtk2 and gtk3"
  homepage "https://github.com/valr/awf"
  url "https://github.com/valr/awf/archive/v1.3.0.tar.gz"
  sha256 "911ded8a307beecbb8ee1dab489fa7b1aa9d7965cb34bd938482220505814fa4"
  head "https://github.com/valr/awf.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtk+3"

  def install
    inreplace "src/awf.c", "/usr/share/themes", "#{HOMEBREW_PREFIX}/share/themes"
    system "./autogen.sh"
    rm "README.md" # let's not have two copies of README
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert (bin/"awf-gtk2").exist?
    assert (bin/"awf-gtk3").exist?
  end
end
