require "formula"

class Flac < Formula
  homepage "https://xiph.org/flac/"
  url "http://downloads.xiph.org/releases/flac/flac-1.3.1.tar.xz"
  sha1 "38e17439d11be26207e4af0ff50973815694b26f"

  head do
    url "https://git.xiph.org/flac.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    revision 5
    sha1 "3263a013f0ef3181c4bb94fc0b033784a7bc6b0f" => :yosemite
    sha1 "43efcb1ad0516523a008b5b8fd656083f2b8d827" => :mavericks
    sha1 "df55c22600a8360d0848c2801a009208740189e9" => :mountain_lion
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
