require 'formula'

class Flasm < Formula
  url 'http://www.nowrap.de/download/flasm16src.zip'
  version '1.62'
  homepage 'http://www.nowrap.de/flasm.html'
  md5 '28a4586409061b385d1cd27d3f120c0b'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! 'CFLAGS', ENV.cflags
    end

    system "make"
    bin.install "flasm"
  end
end
