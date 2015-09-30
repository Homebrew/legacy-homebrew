class Gdnsd < Formula
  desc "Authoritative-only DNS server"
  homepage "http://gdnsd.org/"
  url "https://github.com/gdnsd/gdnsd/releases/download/v2.2.1/gdnsd-2.2.1.tar.xz"
  sha256 "dd78ff355704b2da9dd064efb0cb78b16b58020843d07dc0403684b2afe2d4c0"

  bottle do
    sha256 "2e07ada030282cd7a8b28640fc7deceaad15edd378516fafc8487a0a99c958a3" => :el_capitan
    sha256 "c8b85594959295e68360b588463d78a83dc71bda6fed83b48891dac40d66fbb8" => :yosemite
    sha256 "6fc53b0eb48f03d7480e99db211df0d0c32aba347d695c61e403ab5581db31a0" => :mavericks
  end

  head do
    url "https://github.com/gdnsd/gdnsd.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libev"
  depends_on "ragel"
  depends_on "libunwind-headers" => :recommended

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-rundir=#{var}/run",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--without-urcu"
    system "make", "install"
  end

  test do
    (testpath/"config").write("options => { listen => [ 127.0.0.1 ] }")
    system "#{sbin}/gdnsd", "-c", testpath, "checkconf"
  end
end
