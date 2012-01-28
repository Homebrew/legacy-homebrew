require 'formula'

class Libvpx < Formula
  url 'http://webm.googlecode.com/files/libvpx-v1.0.0.tar.bz2'
  sha256 '07cedb0a19a44e6d81d75f52eea864f59ef10c6c725cb860431bec6641eafe21'
  homepage 'http://www.webmproject.org/code/'

  depends_on 'yasm' => :build

  def options
    [
      ['--gcov', 'Enable code coverage'],
      ['--mem-tracker', 'Enable tracking memory usage'],
      ['--postproc','Enable post processing'],
      ['--visualizer', 'Enable post processing visualizer']
    ]
  end

  def install
    macbuild = Pathname.pwd+'macbuild'
    mkdir macbuild
    Dir.chdir macbuild
    args = ["--prefix=#{prefix}",
            "--enable-pic",
            "--enable-vp8"]
    args << "--enable-gcov" if ARGV.include? "--gcov"
    args << "--enable-mem-tracker" if ARGV.include? "--mem-tracker"
    args << "--enable-postproc" if ARGV.include? "--postproc"
    args << "--enable-postproc-visualizer" if ARGV.include? "--visualizer"
    # Configure detects 32-bit CPUs incorrectly.
    args << "--target=generic-gnu" unless MacOS.prefer_64_bit?
    system "../configure", *args
    system "make"
    system "make install"
  end
end
