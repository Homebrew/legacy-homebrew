class Fcgiwrap < Formula
  desc "CGI support for Nginx"
  homepage "https://www.nginx.com/resources/wiki/start/topics/examples/fcgiwrap/"
  url "https://github.com/gnosek/fcgiwrap/archive/1.1.0.tar.gz"
  sha256 "4c7de0db2634c38297d5fcef61ab4a3e21856dd7247d49c33d9b19542bd1c61f"

  bottle do
    cellar :any
    sha256 "c0a70c3cc726788dfac52d8b23c79c1a4ef31a8c7e1418ac335cfe182b94f05d" => :el_capitan
    sha256 "ea03eeafcd71e07c2e608bc974a00cf642b253de24eb7bd587155c89db2fffad" => :yosemite
    sha256 "15a4dc62dba901bdc25f8d898674069b8cad09b3d2c00458900f31c143305a4e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "fcgi"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
