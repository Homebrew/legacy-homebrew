class AutoconfArchive < Formula
  desc "Collection of over 500 reusable autoconf macros"
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2015.02.24.tar.xz"
  mirror "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2015.02.24.tar.xz"
  sha256 "69715bdd078f552ca85e498a94543e11cb8bcdf0359e659b84d84d19372b0dc5"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "80cb808f4363f2322d64b26b889cdb94989c76950f2d04d25e229d34129edc11" => :el_capitan
    sha256 "e624e553fc32244c54188a9e397d03265478482f28942eb8b3af0d3c78810046" => :yosemite
    sha256 "661fc895512c91c0b2afd4c906b9c96f8f471b4b10884be893342f396183a8db" => :mavericks
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

      # from http://www.gnu.org/software/autoconf-archive/ax_have_select.html
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
