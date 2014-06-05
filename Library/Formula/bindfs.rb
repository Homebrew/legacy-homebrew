require "formula"

class Bindfs < Formula
  homepage "http://bindfs.org/"
  url "http://bindfs.org/downloads/bindfs-1.12.4.tar.gz"
  sha1 "c518fdaf4e22472f0b8140c5a338493c444026b6"

  bottle do
    cellar :any
    sha1 "6709966a00d8bb146b5bd4e75dc37dc38db7bb88" => :mavericks
    sha1 "c04026b339551e371fcd5993a9fb4ce332b45af8" => :mountain_lion
    sha1 "d19667195246207f7b1eb98bae042e54e8dc26ac" => :lion
  end

  head do
    url "https://github.com/mpartel/bindfs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "osxfuse"

  def install
    if build.head?
      system "./autogen.sh", "--disable-debug",
                             "--disable-dependency-tracking",
                             "--prefix=#{prefix}"
    else
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
    end

    system "make install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
