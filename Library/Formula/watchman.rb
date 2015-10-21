class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v3.9.0.tar.gz"
  sha256 "1739cd2d6846cc688b12911c37406fae5601d76c0d11f3da957c2b7273941221"
  head "https://github.com/facebook/watchman.git"

  bottle do
    sha256 "79b88631ecdecf188a229b8fb153f0676abd81f2baccad35707f8204f4157bf1" => :el_capitan
    sha256 "55d25168e5c8bc45aab03770075adb477f70ed816e06fd617c77475a39f335ac" => :yosemite
    sha256 "eddac57652f6ef7b37026673ccdacc9524397b645f0d4f7eb7b442ff22b03c69" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre"
    system "make"
    system "make", "install"
  end

  test do
    list = shell_output("#{bin}/watchman -v")
    if list.index(version).nil?
      raise "expected to see #{version} in the version output"
    end
  end
end
