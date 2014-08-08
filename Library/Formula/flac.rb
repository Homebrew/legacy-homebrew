require "formula"

class Flac < Formula
  homepage "http://xiph.org/flac/"
  url "http://downloads.xiph.org/releases/flac/flac-1.3.0.tar.xz"
  sha1 "a136e5748f8fb1e6c524c75000a765fc63bb7b1b"

  head do
    url "git://git.xiph.org/flac.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    revision 3
    sha1 "a7d96ca264c372d8fcd80b08abdbf753b91811d3" => :mavericks
    sha1 "e4c63b4639f276bf479673b768788001aa919ffc" => :mountain_lion
    sha1 "845dbcb2e3b7779528a814472cc7ec011ea58905" => :lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libogg" => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary if build.universal?

    ENV.append "CFLAGS", "-std=gnu89"

    system "./autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-sse
      --enable-static
    ]

    args << "--without-ogg" if build.without? "libogg"

    system "./configure", *args

    ENV["OBJ_FORMAT"]="macho"

    # adds universal flags to the generated libtool script
    inreplace "libtool" do |s|
      s.gsub! ":$verstring\"", ":$verstring -arch #{Hardware::CPU.arch_32_bit} -arch #{Hardware::CPU.arch_64_bit}\""
    end

    system "make install"
  end
end
