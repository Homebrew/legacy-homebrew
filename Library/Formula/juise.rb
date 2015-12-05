class Juise < Formula
  desc "JUNOS user interface scripting environment"
  homepage "https://github.com/Juniper/juise/wiki"
  url "https://github.com/Juniper/juise/releases/download/0.6.1/juise-0.6.1.tar.gz"
  sha256 "5985f2b19d017a52de2a77b0246afed86d2b9227acd277113468407db11cd146"

  bottle do
    sha256 "da6dcf67dee23e98befee63f93796490a877229679e77befa25246da59756822" => :mavericks
    sha256 "abcd4d9e493d030922978364f95b7e91c38f99e661c9fa118a666c282abe3758" => :mountain_lion
    sha256 "076b551d5489dd55636e7c5945b593ad75219416c95bd61656cc7cfd45ea2e8f" => :lion
  end

  head do
    url "https://github.com/Juniper/juise.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libtool" => :build
  depends_on "libslax"
  depends_on "libssh2"
  depends_on "pcre"
  depends_on "sqlite"

  def install
    system "sh ./bin/setup.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libssh2-prefix=#{HOMEBREW_PREFIX}",
                          "--with-sqlite3-prefix=#{Formula["sqlite"].opt_prefix}",
                          "--enable-libedit"
    system "make", "install"
  end
end
