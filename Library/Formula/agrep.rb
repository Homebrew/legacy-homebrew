require 'formula'

class Agrep < Formula
  url 'ftp://ftp.cs.arizona.edu/agrep/agrep-2.04.tar.Z'
  version '2.04'
  homepage 'http://en.wikipedia.org/wiki/Agrep'
  md5 'abc645404d3926a57c3f5e86a6e89ee9'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
    end

    system "make"

    bin.install "agrep"
    man1.install "agrep.1"
  end
end
