class Knock < Formula
  homepage "http://www.zeroflux.org/projects/knock"
  url "http://www.zeroflux.org/proj/knock/files/knock-0.7.tar.gz"
  sha1 "186a687c9db11733cf23a7423884a863873ebb27"

  head do
    url "https://github.com/jvinet/knock.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-fi" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/knock", "localhost", "123:tcp"
  end
end
