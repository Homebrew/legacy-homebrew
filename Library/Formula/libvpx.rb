require 'formula'

class Libvpx < Formula
  url 'http://webm.googlecode.com/files/libvpx-v0.9.7-p1.tar.bz2'
  sha1 'dacfefaf3363f781de43858f09cdd0b0d469e6fc'
  homepage 'http://www.webmproject.org/code/'
  version '0.9.7-p1'

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
