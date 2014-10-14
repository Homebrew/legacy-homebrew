require 'formula'

class Libvpx < Formula
  homepage 'http://www.webmproject.org/code/'
  url 'https://webm.googlecode.com/files/libvpx-v1.3.0.tar.bz2'
  sha1 '191b95817aede8c136cc3f3745fb1b8c50e6d5dc'
  revision 1

  head "https://chromium.googlesource.com/webm/libvpx", :using => :git

  bottle do
    sha1 "b1686149e88d18545bc41ba1d9a581a081f215f7" => :mavericks
    sha1 "bb16fa011de3155d93e4d403e9d95c58d62b828e" => :mountain_lion
    sha1 "b2567fb8f49b2b57bbd3b5472f7f5eea9dfd8f0f" => :lion
  end

  depends_on 'yasm' => :build

  option 'gcov', 'Enable code coverage'
  option 'mem-tracker', 'Enable tracking memory usage'
  option 'visualizer', 'Enable post processing visualizer'
  option "with-examples", "Build examples (vpxdec/vpxenc)"

  def install
    args = ["--prefix=#{prefix}", "--enable-pic", "--disable-unit-tests"]
    args << (build.with?("examples") ? "--enable-examples" : "--disable-examples")
    args << "--enable-gcov" if build.include? "gcov" and not ENV.compiler == :clang
    args << "--enable-mem-tracker" if build.include? "mem-tracker"
    args << "--enable-postproc-visualizer" if build.include? "visualizer"

    ENV.append "CXXFLAGS", "-DGTEST_USE_OWN_TR1_TUPLE=1" # Mavericks uses libc++ which doesn't supply <TR1/tuple>

    # configure misdetects 32-bit 10.6
    # http://code.google.com/p/webm/issues/detail?id=401
    if MacOS.version == "10.6" && Hardware.is_32_bit?
      args << "--target=x86-darwin10-gcc"
    end

    mkdir 'macbuild' do
      system "../configure", *args
      system "make install"
    end
  end
end
