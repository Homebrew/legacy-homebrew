class SpawnFcgi < Formula
  homepage "http://redmine.lighttpd.net/projects/spawn-fcgi"
  url "http://www.lighttpd.net/download/spawn-fcgi-1.6.4.tar.gz"
  sha256 "ab327462cb99894a3699f874425a421d934f957cb24221f00bb888108d9dd09e"

  option "without-ipv6", "Build without ipv6 support"

  def install
    args = []
    args << "--disable-ipv6" if build.without? "ipv6"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", *args
    system "make", "install"
  end

  test do
    system "spawn-fcgi", "--version"
  end
end
