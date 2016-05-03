class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "http://www.opendap.org"
  url "http://www.opendap.org/pub/source/libdap-3.17.0.tar.gz"
  sha256 "7c5c65535f8a6aa20f3cdbe2d552140b8f20de007a8e005db437d7361739fb6d"

  bottle do
    sha256 "1daf95984ed2c1738f6c247efa0f3bb35bb28df71f81d793d850ad9ee7198537" => :yosemite
    sha256 "fd6a64b4eeaba3b4c04b55a8517c776a6b6d3aa1a993135ca380fc254514594e" => :mavericks
    sha256 "7862dbc1a6659c640b4ef9b92693f2a4d1116dedf513a4d7b4c392ba5cfb1287" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "bison"
  depends_on "openssl"

  def install
    # Reported to upstream support@opendap.org 30th Mar 2016
    # Avoids collision with std::__1::array
    inreplace "dds.yy", "part = array;", "part = libdap::Part::array;"

    # NOTE:
    # To future maintainers: if you ever want to build this library as a
    # universal binary, see William Kyngesburye's notes:
    #     http://www.kyngchaos.com/macosx/build/dap
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           # __Always pass the curl prefix!__
           # Otherwise, configure will fall back to pkg-config and on Leopard
           # and Snow Leopard, the libcurl.pc file that ships with the system
           # is seriously broken---too many arch flags. This will be carried
           # over to `dap-config` and from there the contamination will spread.
           "--with-curl=/usr",
           "--with-included-regex"

    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dap-config --version")
  end
end
