class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "http://www.opendap.org"
  url "http://www.opendap.org/pub/source/libdap-3.12.1.tar.gz"
  sha256 "10926129fefa9cb7050a7e501f3dc5c75b63709196b2c9e1e158b28b2dc098f2"
  revision 1

  bottle do
    sha256 "1daf95984ed2c1738f6c247efa0f3bb35bb28df71f81d793d850ad9ee7198537" => :yosemite
    sha256 "fd6a64b4eeaba3b4c04b55a8517c776a6b6d3aa1a993135ca380fc254514594e" => :mavericks
    sha256 "7862dbc1a6659c640b4ef9b92693f2a4d1116dedf513a4d7b4c392ba5cfb1287" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libxml2"

  def install
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
end
