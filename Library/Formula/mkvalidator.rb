require 'formula'

class Mkvalidator < Formula
  url 'http://downloads.sourceforge.net/project/matroska/mkvalidator/mkvalidator-0.3.7.tar.bz2'
  homepage 'http://www.matroska.org/downloads/mkvalidator.html'
  sha1 '4dada51d23255dffb4176450b410d6326a72d845'

  def install
    ENV.j1 # Otherwise there are races

    # For 64-bit kernels, just use the Snow Leopard SDK.
    inreplace "corec/tools/coremake/gcc_osx_x64.build" do |s|
      s.gsub! /10\.4u?/, "10.6"
    end

    system "./configure"
    system "make -C mkvalidator"
    bindir = `corec/tools/coremake/system_output.sh`.chomp
    bin.install "release/#{bindir}/mkvalidator"
  end
end
