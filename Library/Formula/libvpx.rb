class Libvpx < Formula
  desc "VP8 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.4.0.tar.gz"
  sha256 "eca30ea7fae954286c9fe9de9d377128f36b56ea6b8691427783b20c67bcfc13"

  head "https://chromium.googlesource.com/webm/libvpx", :using => :git

  bottle do
    sha256 "2becb83097f9f8a49bae7ad31007aad8f81d82fd934ca88e740d980b062ddc03" => :el_capitan
    sha256 "bbc6f2c5c306d6b33107d21f14d3526871f291c631c8d61ce4e5ad33376aa7ee" => :yosemite
    sha256 "ec9422796d4695e471a94bb2809f78375bbc9a111fa8f5ef10a382b5500e9c5b" => :mavericks
    sha256 "6aed92389466e1a0cf62b8320262d33c2e5e0c2802b40e2cbd267f270621e77f" => :mountain_lion
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
    # http://code.google.com/p/webm/issues/detail?id=401
    if MacOS.version == "10.6" && Hardware.is_32_bit?
      args << "--target=x86-darwin10-gcc"
    end

    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end
end
