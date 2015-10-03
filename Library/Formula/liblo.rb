class Liblo < Formula
  desc "Lightweight Open Sound Control implementation"
  homepage "http://liblo.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/liblo/liblo/0.28/liblo-0.28.tar.gz"
  sha256 "da94a9b67b93625354dd89ff7fe31e5297fc9400b6eaf7378c82ee1caf7db909"

  bottle do
    cellar :any
    revision 1
    sha256 "be6b11c3e18ae25490abae43ae12e2fbd87fd8e398b53e817dafd5c3ba494c11" => :el_capitan
    sha1 "4e54400bfd62515b26619c7ed1e281c747467ed5" => :yosemite
    sha1 "c05b222b88ebf22eedb74a41c5a22a6af867d82c" => :mavericks
    sha1 "1245b84f62785f894cdb77aae345fbc9b4c3d974" => :mountain_lion
  end

  head do
    url "git://liblo.git.sourceforge.net/gitroot/liblo/liblo"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "enable-ipv6", "Compile with support for ipv6"
  option :universal

  def install
    ENV.universal_binary if build.universal?

    args = %W[--disable-debug
              --disable-dependency-tracking
              --prefix=#{prefix}]

    args << "--enable-ipv6" if build.include? "enable-ipv6"

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end
end
