class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "http://www.opendap.org"
  url "https://github.com/OPENDAP/libdap4/archive/version-3.17.1.tar.gz"
  sha256 "b9ee8e8dcc1a93a5c2d2e3a6fee39a3dc05c82e0e44151f8df3fc7c0f6363885"
  head "https://github.com/OPENDAP/libdap4.git"

  bottle do
    sha256 "1daf95984ed2c1738f6c247efa0f3bb35bb28df71f81d793d850ad9ee7198537" => :yosemite
    sha256 "fd6a64b4eeaba3b4c04b55a8517c776a6b6d3aa1a993135ca380fc254514594e" => :mavericks
    sha256 "7862dbc1a6659c640b4ef9b92693f2a4d1116dedf513a4d7b4c392ba5cfb1287" => :mountain_lion
  end

  option "without-test", "Skip build-time tests (Not recommended)"

  depends_on "pkg-config" => :build
  depends_on "bison" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "libxml2"
  depends_on "openssl"

  needs :cxx11 if MacOS.version < :mavericks

  def install
    # NOTE:
    # To future maintainers: if you ever want to build this library as a
    # universal binary, see William Kyngesburye's notes:
    #     http://www.kyngchaos.com/macosx/build/dap

    # Otherwise, "make check" fails
    ENV.cxx11 if MacOS.version < :mavericks

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-debug
      --with-included-regex
    ]

    # Let's try removing this for OS X > 10.6; old note follows:
    # __Always pass the curl prefix!__
    # Otherwise, configure will fall back to pkg-config and on Leopard
    # and Snow Leopard, the libcurl.pc file that ships with the system
    # is seriously broken---too many arch flags. This will be carried
    # over to `dap-config` and from there the contamination will spread.
    args << "--with-curl=/usr" if MacOS.version <= :snow_leopard

    system "autoreconf", "-fvi"
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dap-config --version")
  end
end
