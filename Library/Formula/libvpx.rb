require 'formula'

class Libvpx < Formula
  homepage 'http://www.webmproject.org/code/'
  url 'https://webm.googlecode.com/files/libvpx-v1.3.0.tar.bz2'
  sha1 '191b95817aede8c136cc3f3745fb1b8c50e6d5dc'

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

    # see http://code.google.com/p/webm/issues/detail?id=401
    # Configure misdetects 32-bit 10.6.
    # Determine if the computer runs Darwin 9, 10, or 11 using uname -r.
    osver = %x[uname -r | cut -d. -f1].chomp
    if MacOS.prefer_64_bit? then
      args << "--target=x86_64-darwin#{osver}-gcc"
    else
      args << "--target=x86-darwin#{osver}-gcc"
    end

    mkdir 'macbuild' do
      system "../configure", *args
      system "make install"
    end
  end
end
