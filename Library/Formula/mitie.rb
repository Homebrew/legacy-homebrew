class Mitie < Formula
  homepage "https://github.com/mit-nlp/MITIE/"
  url "https://github.com/mit-nlp/MITIE/archive/v0.4.tar.gz"
  sha256 "3902c9a6332354fb23f1cbdc4ef9631fa1477b69e37e4b7822d3c18a8bbefdc9"

  head "https://github.com/mit-nlp/MITIE.git"

  bottle do
    cellar :any
    sha1 "5340adc68370e4aec0114080e143e779595fed37" => :yosemite
    sha1 "d0fb785080028ad13aec010e990a82efcfce8c57" => :mavericks
    sha1 "54b250080d42b7da77b3c92d67d32431be180dfd" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  option "without-models", "Don't download the v0.2 models (~415MB)"

  resource "models-english" do
    url "https://downloads.sourceforge.net/project/mitie/binaries/MITIE-models-v0.2.tar.bz2"
    sha256 "dc073eaef980e65d68d18c7193d94b9b727beb254a0c2978f39918f158d91b31"
  end

  def install
    if build.with? "models"
      (share/"MITIE-models").install resource("models-english")
    end

    inreplace "mitielib/makefile" do |s|
      s.gsub!(/libmitie.so/, "libmitie.dylib")
    end
    system "make", "mitielib"
    system "make"

    include.install Dir["mitielib/include/*"]
    lib.install "mitielib/libmitie.dylib", "mitielib/libmitie.a"
    (lib/"python2.7/site-packages").install "mitielib/mitie.py"
    (share/"mitie").install "examples", "sample_text.txt",
      "sample_text.reference-output", "sample_text.reference-output-relations"
    bin.install "ner_example", "ner_stream", "relation_extraction_example"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lmitie",
           share/"mitie/examples/C/ner/ner_example.c",
           "-o", testpath/"ner_example"
    system "./ner_example", share/"MITIE-models/english/ner_model.dat",
           share/"mitie/sample_text.txt"
  end
end
