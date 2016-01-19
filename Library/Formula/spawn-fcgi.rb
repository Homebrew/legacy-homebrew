class SpawnFcgi < Formula
  desc "Spawn fast-CGI processes"
  homepage "https://redmine.lighttpd.net/projects/spawn-fcgi"
  url "http://www.lighttpd.net/download/spawn-fcgi-1.6.4.tar.gz"
  sha256 "ab327462cb99894a3699f874425a421d934f957cb24221f00bb888108d9dd09e"

  bottle do
    cellar :any
    sha256 "78c371675767d0a7ccc8b61142b5210bc985eff71f5e7fdb75f095266d4333a9" => :yosemite
    sha256 "88fa451fef81b0db9540d23a1b13e57c6edeb108c9a414f649b2d78a4d02b228" => :mavericks
    sha256 "4f846ff99c7b9726d92a5dabe7164005cdbc08c5bd483f08c7b047b10dfd6bba" => :mountain_lion
  end

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
