require 'formula'

class Stlviewer < Formula
  homepage 'https://github.com/vishpat/stlviewer#readme'
  url 'https://github.com/vishpat/stlviewer/archive/0.1.zip'
  sha1 'e2b062a96512e657ab09c2524876bc2601b74cb4'

  def install
    system "./compile.py"
    system "cp ./stlviewer #{prefix}/stlviewer"
    system "ln -s #{prefix}/stlviewer /usr/local/bin/stlviewer"
  end

  test do
    system "stlviewer sample.stl"
  end
end
