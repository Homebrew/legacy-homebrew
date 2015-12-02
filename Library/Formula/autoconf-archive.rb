class AutoconfArchive < Formula
  desc "Collection of over 500 reusable autoconf macros"
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2015.02.24.tar.xz"
  mirror "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2015.02.24.tar.xz"
  sha256 "69715bdd078f552ca85e498a94543e11cb8bcdf0359e659b84d84d19372b0dc5"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "cdef16863febf3b58e3faee528b1646d6214f9f00febb92d3de1c8f0ef8cffc4" => :el_capitan
    sha256 "137af13ba528ab8d6360c98294354990a88ade4b008c8f6b17effa2c6c50fbeb" => :yosemite
    sha256 "0529c2360f87d1a357eee395f226f20257057eed909876b42028f9cd53aee51b" => :mavericks
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
