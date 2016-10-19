require 'formula'

class Orthrus < Formula
  url 'http://orthrus.googlecode.com/files/orthrus-0.8.0.tar.bz2'
  homepage 'http://code.google.com/p/orthrus/'
  md5 'd3f599096075932af630f7749bc571c0'

  depends_on 'scons' => :build

  def install
    system "scons"
    lib.install Dir['*.dylib']
    bin.install ['ortcalc', 'ortpasswd']
  end
end
