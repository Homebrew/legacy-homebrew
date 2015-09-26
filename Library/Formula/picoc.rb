class Picoc < Formula
  desc "C interpreter for scripting"
  homepage "https://code.google.com/p/picoc/"
  url "https://picoc.googlecode.com/files/picoc-2.1.tar.bz2"
  sha256 "bfed355fab810b337ccfa9e3215679d0b9886c00d9cb5e691f7e7363fd388b7e"

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags} -DUNIX_HOST"
    bin.install "picoc"
  end
end
