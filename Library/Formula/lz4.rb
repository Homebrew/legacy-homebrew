require "formula"

class Lz4 < Formula
  homepage "http://code.google.com/p/lz4/"
  url "https://dl.dropboxusercontent.com/u/59565338/LZ4/lz4-r114.tar.gz"
  sha1 "7b6c4c3b01edbb60e4c07657c3c41e8b5e95770e"
  version "r114"

  def install
    inreplace "Makefile", /-Wl,-soname=[^ ]+/, ""
    inreplace "Makefile", /\.so/, ".dylib"
    system "make", "install", "PREFIX=#{prefix}"
    rm prefix/"lib/liblz4.dylib.1"
    rm prefix/"lib/liblz4.dylib.1.0.0"
  end

  test do
    input = "testing compression and decompression"
    input_file = testpath/"in"
    input_file.write input
    output_file = testpath/"out"
    system "sh", "-c", "cat #{input_file} | lz4 | lz4 -d > #{output_file}"
    output_file.read == input
  end
end
