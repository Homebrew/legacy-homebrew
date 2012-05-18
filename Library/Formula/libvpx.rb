require 'formula'

class Libvpx < Formula
  homepage 'http://www.webmproject.org/code/'
  url 'http://webm.googlecode.com/files/libvpx-v1.1.0.tar.bz2'
  sha1 '356af5f770c50cd021c60863203d8f30164f6021'

  depends_on 'yasm' => :build

  def options
    [
      ['--gcov', 'Enable code coverage'],
      ['--mem-tracker', 'Enable tracking memory usage'],
      ['--visualizer', 'Enable post processing visualizer']
    ]
  end

  def install
    args = ["--prefix=#{prefix}",
            "--enable-pic",
            "--enable-vp8",
            "--disable-debug",
            "--disable-examples",
            "--disable-runtime-cpu-detect"]
    args << "--enable-gcov" if ARGV.include? "--gcov" and not ENV.compiler == :clang
    args << "--enable-mem-tracker" if ARGV.include? "--mem-tracker"
    args << "--enable-postproc-visualizer" if ARGV.include? "--visualizer"

    mkdir 'macbuild' do
      system "../configure", *args
      system "make install"
    end
  end
end
