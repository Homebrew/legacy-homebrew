require 'formula'

class Colpack < Formula
  url 'http://www.cscapes.org/download/ColPack/ColPack-1.0.0.tar.gz'
  homepage 'http://www.cscapes.org/coloringpage/software.htm'
  md5 '82804e0d23d668bdcd80a15d5e523546'

  def install
    # handwritten makefile assumes Linux, so change it to support OS X
    # also override PWD variable so Utilities/makefile execs properly
    inreplace "makefile" do |s|
      s.gsub! ".so", ".dylib"
      s.gsub! "-soname,", "-install_name,#{prefix}/build/lib/"
      s.gsub! "\$\(PWD\)", ".."
    end
    system "make"
    prefix.install Dir['build']
  end
end
