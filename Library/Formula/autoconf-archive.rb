class AutoconfArchive < Formula
  desc "Collection of over 500 reusable autoconf macros"
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2016.03.20.tar.xz"
  mirror "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2016.03.20.tar.xz"
  sha256 "88fb2efff640eddd28a52ae550ff5561bca3bd2bba09e1d7b0580e719875e437"

  bottle do
    cellar :any_skip_relocation
    sha256 "447b84380eb0b66c000b3dc9f00d33a53e7e956243041fd5069a8239250a533e" => :el_capitan
    sha256 "fd4d4cefa88eefe1b106a095b17e8330629f0d6a4baf8de7e8b1482b68cdab5a" => :yosemite
    sha256 "b4cd6a71e0a0b8c6a0ff31cc6584c359ab0c07200ba3d5960e72d54ade9bc2d7" => :mavericks
  end

  # autoconf-archive is useless without autoconf
  depends_on "autoconf" => :run

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.m4").write <<-EOS.undent
      AC_INIT(myconfig, version-0.1)
      AC_MSG_NOTICE([Hello, world.])

      m4_include([#{share}/aclocal/ax_have_select.m4])

      # from https://www.gnu.org/software/autoconf-archive/ax_have_select.html
      AX_HAVE_SELECT(
        [AX_CONFIG_FEATURE_ENABLE(select)],
        [AX_CONFIG_FEATURE_DISABLE(select)])
      AX_CONFIG_FEATURE(
        [select], [This platform supports select(7)],
        [HAVE_SELECT], [This platform supports select(7).])
    EOS

    system "#{Formula["autoconf"].bin}/autoconf", "test.m4"
  end
end
