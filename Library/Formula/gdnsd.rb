require "formula"

class Gdnsd < Formula
  homepage "http://gdnsd.org/"
  url "https://github.com/gdnsd/gdnsd/releases/download/v2.1.0/gdnsd-2.1.0.tar.xz"
  sha1 "138c7542005de457e756bf84fd7f727d690efe56"

  bottle do
    sha1 "72e912a4de41afda8ea8b806086c7291c308e72c" => :yosemite
    sha1 "ef4d3d7b6c0a7eab61ac4b2ae1f188a2eaec0e37" => :mavericks
    sha1 "5acbc203b2687aec9c2506906172122a680133f5" => :mountain_lion
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
