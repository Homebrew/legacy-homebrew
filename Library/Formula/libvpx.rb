class Libvpx < Formula
  desc "VP8 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.4.0.tar.gz"
  sha256 "eca30ea7fae954286c9fe9de9d377128f36b56ea6b8691427783b20c67bcfc13"

  head "https://chromium.googlesource.com/webm/libvpx", :using => :git

  bottle do
    revision 1
    sha256 "c7f7b9f334d25eca449c2c8898218016eb86e5958d8a1478d28ea496ee4a2f6e" => :el_capitan
    sha256 "822c4963c52d34335c05d10c2600e85af7409418478c36addce495d073251140" => :yosemite
    sha256 "efba3f78c38ac66f52d21d5a6b4274b48586ca6ad689b852bdf996d9d0b5dccd" => :mavericks
  end

  depends_on "yasm" => :build

  option "gcov", "Enable code coverage"
  option "mem-tracker", "Enable tracking memory usage"
  option "visualizer", "Enable post processing visualizer"
  option "with-examples", "Build examples (vpxdec/vpxenc)"

  def install
    args = ["--prefix=#{prefix}", "--enable-pic", "--disable-unit-tests"]
    args << (build.with?("examples") ? "--enable-examples" : "--disable-examples")
    args << "--enable-gcov" if build.include? "gcov" and not ENV.compiler == :clang
    args << "--enable-mem-tracker" if build.include? "mem-tracker"
    args << "--enable-postproc-visualizer" if build.include? "visualizer"

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
