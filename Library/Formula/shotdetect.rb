require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Shotdetect < Formula
  homepage 'https://github.com/johmathe/Shotdetect'
  head 'https://github.com/johmathe/Shotdetect.git'
  version '1.0 (2012.11.04)'


  depends_on 'cmake' => :build
  depends_on 'ffmpeg'
  depends_on 'libxml2'
  depends_on 'libxslt'

  depends_on 'gd'


  def install
    ENV.j1  # if your formula's build system can't parallelize
      args = std_cmake_args.concat %W[
      -DUSE_WXWIDGETS:BOOL=OFF
    ]

    system "cmake", ".", *args
    system "make shotdetect-cmd" # if this fails, try separate make/make install steps
    system "mv shotdetect-cmd shotdetect"
    bin.install('shotdetect')
  end
end
