require 'formula'

class Libvpx < Formula
  homepage 'http://www.webmproject.org/code/'
  url 'https://webm.googlecode.com/files/libvpx-v1.3.0.tar.bz2'
  sha1 '191b95817aede8c136cc3f3745fb1b8c50e6d5dc'

  bottle do
    sha1 "6c46b6378c782d9cdd345d29caaa536d5bb1b03e" => :mavericks
    sha1 "acdcd36694484ce9c0e6b50a318f9d167ba5e98d" => :mountain_lion
    sha1 "247ef9ee24596e890ed96456070f8f0ec8459cf1" => :lion
  end

  depends_on 'yasm' => :build

  option 'gcov', 'Enable code coverage'
  option 'mem-tracker', 'Enable tracking memory usage'
  option 'visualizer', 'Enable post processing visualizer'

  def install
    args = ["--prefix=#{prefix}",
            "--enable-pic",
            "--disable-examples",
            "--disable-runtime-cpu-detect"]
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
