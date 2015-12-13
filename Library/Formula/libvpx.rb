class Libvpx < Formula
  desc "VP8 video codec"
  homepage "http://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.5.0.tar.gz"
  sha256 "f199b03b67042e8d94a3ae8bc841fb82b6a8430bdf3965aeeaafe8245bcfa699"
  head "https://chromium.googlesource.com/webm/libvpx", :using => :git

  bottle do
    revision 1
    sha256 "c7f7b9f334d25eca449c2c8898218016eb86e5958d8a1478d28ea496ee4a2f6e" => :el_capitan
    sha256 "822c4963c52d34335c05d10c2600e85af7409418478c36addce495d073251140" => :yosemite
    sha256 "efba3f78c38ac66f52d21d5a6b4274b48586ca6ad689b852bdf996d9d0b5dccd" => :mavericks
  end

  option "with-gcov", "Enable code coverage"
  option "with-mem-tracker", "Enable tracking memory usage"
  option "with-visualizer", "Enable post processing visualizer"
  option "with-examples", "Build examples (vpxdec/vpxenc)"

  deprecated_option "gcov" => "with-gcov"
  deprecated_option "mem-tracker" => "with-mem-tracker"
  deprecated_option "visualizer" => "with-visualizer"

  depends_on "yasm" => :build

  def install
    args = %W[--prefix=#{prefix} --enable-pic --disable-unit-tests]

    args << (build.with?("examples") ? "--enable-examples" : "--disable-examples")
    args << "--enable-gcov" if !ENV.compiler == :clang && build.with?("gcov")
    args << "--enable-mem-tracker" if build.with? "mem-tracker"
    args << "--enable-postproc-visualizer" if build.with? "visualizer"

    # configure misdetects 32-bit 10.6
    # https://code.google.com/p/webm/issues/detail?id=401
    if MacOS.version == "10.6" && Hardware.is_32_bit?
      args << "--target=x86-darwin10-gcc"
    end

    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end
end
