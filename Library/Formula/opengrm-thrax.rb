require "formula"

class OpengrmThrax < Formula
  homepage "http://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "http://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.1.0.tar.gz"
  sha1 "d804df8a565f9d20fc72d4b0b10d492b75561ca1"

  depends_on "openfst"

  resource "export2" do
    url "http://openfst.cs.nyu.edu/twiki/pub/Contrib/ThraxContrib/export2.tgz"
    sha1 "3de5811cbb72933f62ccceb578697e9904256fac"
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    resource("export2").stage do
        # an example from CSLU class on text normalization
        Dir.chdir("grammars/number_names") do
                   system "thraxmakedep", "numbers_en_us.grm"
                   system "make"
                   system "thraxrandom-generator",
                          "--far=numbers_en_us.far",
                          "--rule=CARDINAL_NUMBER_NAME"
        end
     end
  end
end
