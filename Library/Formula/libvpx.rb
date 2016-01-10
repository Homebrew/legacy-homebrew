class Libvpx < Formula
  desc "VP8 video codec"
  homepage "http://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.5.0.tar.gz"
  sha256 "f199b03b67042e8d94a3ae8bc841fb82b6a8430bdf3965aeeaafe8245bcfa699"
  head "https://chromium.googlesource.com/webm/libvpx", :using => :git

  bottle do
    sha256 "662f6f2cb3fab1a9fa74ecd100a9266d86d10a60e179a11b0c80594f4bd7e347" => :el_capitan
    sha256 "0209b85c32d4c08e23db9afa56bd4c9c0535ebbd1af1f36488b6e34ec1d6e8a1" => :yosemite
    sha256 "423d1ecee05d00a68d04e390d368c0a03f1597a28d02793cdad3c1219abf4a03" => :mavericks
  end

  option "with-gcov", "Enable code coverage"
  option "with-visualizer", "Enable post processing visualizer"
  option "with-examples", "Build examples (vpxdec/vpxenc)"

  deprecated_option "gcov" => "with-gcov"
  deprecated_option "visualizer" => "with-visualizer"

  depends_on "yasm" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-pic
      --disable-unit-tests
    ]

    args << (build.with?("examples") ? "--enable-examples" : "--disable-examples")
    args << "--enable-gcov" if !ENV.compiler == :clang && build.with?("gcov")
    args << "--enable-postproc" << "--enable-postproc-visualizer" if build.with? "visualizer"

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
