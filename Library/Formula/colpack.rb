require 'formula'

class Colpack < Formula
  url 'http://www.cscapes.org/download/ColPack/ColPack-1.0.4.tar.gz'
  homepage 'http://www.cscapes.org/coloringpage/software.htm'
  md5 '0595cc882b0232be773ec29e7de24fc1'

  def install
    inreplace "makefile" do |s|
      s.gsub! ".so", ".dylib"
      s.gsub! "-soname,", "-install_name,#{prefix}/build/lib/"
      s.gsub! "\$\(PWD\)", ".."
      s.gsub! ".exe", ""
    end
    system "make"
    prefix.install Dir['build/include','build/lib']
    bin.install('ColPack')
  end
end
