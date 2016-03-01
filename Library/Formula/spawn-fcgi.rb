class SpawnFcgi < Formula
  desc "Spawn fast-CGI processes"
  homepage "https://redmine.lighttpd.net/projects/spawn-fcgi"
  url "https://www.lighttpd.net/download/spawn-fcgi-1.6.4.tar.gz"
  sha256 "ab327462cb99894a3699f874425a421d934f957cb24221f00bb888108d9dd09e"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "4e6f999ebcad8b7ce84473379b6358ec569559f9e4b772d31ef1a5b0e01fc865" => :el_capitan
    sha256 "7473e3e2cd5322b2f09011e2b5119622e145d136cd0a8d4ce7adcb255a13d83b" => :yosemite
    sha256 "a19a14cae6fbacdc5aa1a8132f5d290743ba7385c2d76903dbd172ca07b38680" => :mavericks
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
