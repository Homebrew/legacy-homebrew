class Sshtrix < Formula
  desc "SSH login cracker"
  homepage "http://www.nullsecurity.net/tools/cracker.html"
  url "https://github.com/nullsecuritynet/tools/raw/master/cracker/sshtrix/release/sshtrix-0.0.2.tar.gz"
  sha256 "dc90a8b2fbb62689d1b59333413b56a370a0715c38bf0792f517ed6f9763f5df"

  bottle do
    cellar :any
    sha256 "2fd9c4a2d64419d0e3599b17ea244911420276ecd8c0f4ded909730413121ec0" => :yosemite
    sha256 "91023afd20f82c8d93497c460344fb00a718343fa52e1ad48299b876c8699be1" => :mavericks
    sha256 "c4c325be267741bdc3ba858f21834b8666f734463c28b28e2ad652bbee154b95" => :mountain_lion
  end

  depends_on "libssh"

  def install
    bin.mkpath
    system "make", "sshtrix", "CC=#{ENV.cc}"
    system "make", "DISTDIR=#{prefix}", "install"
  end

  test do
    system "#{bin}/sshtrix", "-V"
    system "#{bin}/sshtrix", "-O"
  end
end
