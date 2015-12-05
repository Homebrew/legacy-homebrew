class Knock < Formula
  desc "Port-knock server"
  homepage "http://www.zeroflux.org/projects/knock"
  url "http://www.zeroflux.org/proj/knock/files/knock-0.7.tar.gz"
  sha256 "9938479c321066424f74c61f6bee46dfd355a828263dc89561a1ece3f56578a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "030dc0a7c3ea623eb3d8e11374f744ad79f8aee8b7b75210f1a183b4d6d978de" => :el_capitan
    sha256 "aac645d3c392386d99cb19200465a439639c8d3e7f8eac7021dbb677939cf155" => :yosemite
    sha256 "eb180c87d84707199ef6279a4709d76630a2089b331fb9ebc6c2bf58389fc921" => :mavericks
    sha256 "3a60938c215acb144bff30f63eba43c79c471c090f8dd05171365396b64faf12" => :mountain_lion
  end

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
