class AutoconfArchive < Formula
  desc "Collection of over 500 reusable autoconf macros"
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2015.09.25.tar.xz"
  mirror "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2015.09.25.tar.xz"
  sha256 "7c0467a5dbd2340153bca5a477bd92fbc951d9ee3cbed92f16f6bf08ac0c350a"

  bottle do
    cellar :any_skip_relocation
    sha256 "c006f30a366c500c6b3aa3737853c68b1191b71b99e4f3ab55603563fe27a131" => :el_capitan
    sha256 "927856f2edfaacbea2b6bd8223f0c5ebc8ae5316ed8da76436af70afadc0fa7d" => :yosemite
    sha256 "d60dff8a8be2ac5424cc1a95e424479bba1edd7a1a5101cad62d9a284971f509" => :mavericks
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
