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
    revision 4
    sha1 "d58829621a3fd3c300f8b44a9da5396260bc825f" => :mavericks
    sha1 "e69bbea156a3915ada88f9d3169a53821dd3f64b" => :mountain_lion
    sha1 "75003deaf2c9de68c04af8a2e0f9f08f07680e5a" => :lion
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

    ENV["OBJ_FORMAT"] = "macho"

    # adds universal flags to the generated libtool script
    inreplace "libtool" do |s|
      s.gsub! ":$verstring\"", ":$verstring -arch #{Hardware::CPU.arch_32_bit} -arch #{Hardware::CPU.arch_64_bit}\""
    end

    system "make", "install"
  end
end
