require "formula"

class Mitie < Formula
  homepage "https://github.com/mit-nlp/MITIE/"
  url "https://github.com/mit-nlp/MITIE/archive/v0.3.tar.gz"
  sha1 "05ea37283bd75487db469b68b0e2ecdea991c05e"

  bottle do
    cellar :any
    sha1 "5340adc68370e4aec0114080e143e779595fed37" => :yosemite
    sha1 "d0fb785080028ad13aec010e990a82efcfce8c57" => :mavericks
    sha1 "54b250080d42b7da77b3c92d67d32431be180dfd" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "models-english" do
    url "http://sourceforge.net/projects/mitie/files/binaries/MITIE-models-v0.2.tar.bz2"
    sha1 "a193e0a133926b5355b4e840ddd7f5112d785999"
  end

  def install
    (share+"MITIE-models").install resource("models-english")
    inreplace "mitielib/makefile" do |s|
      s.gsub! /libmitie.so/, "libmitie.dylib"
    end
    system "make", "mitielib"
    system "make"
    lib.install "mitielib/libmitie.dylib", "mitielib/libmitie.a"
    (lib+'python2.7/site-packages').install "mitielib/mitie.py"
    (share+"mitie").install "examples", "sample_text.txt",
      "sample_text.reference-output", "sample_text.reference-output-relations"
    bin.install "ner_example", "ner_stream", "relation_extraction_example"
  end

  test do
    system "#{bin}/ner_example", "#{share}/MITIE-models/english/ner_model.dat", "#{share}/mitie/sample_text.txt"
  end

end
