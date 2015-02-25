class Lemur < Formula
  homepage "http://www.lemurproject.org/lemur.php"
  url "https://github.com/fsqcds/lemur-4.11.git"

  def install
    ENV.deparallelize
    ENV.no_optimization
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/BuildDocMgr"
    system "#{bin}/BuildIndex"
    system "#{bin}/BuildPropIndex"
    system "#{bin}/EstimateDirPrior"
    system "#{bin}/GenL2Norm"
    system "#{bin}/GenerateQueryModel"
    system "#{bin}/GenerateSmoothSupport"
    system "#{bin}/IndriBuildIndex"
    system "#{bin}/IndriDaemon"
    system "#{bin}/IndriRunQuery"
    system "#{bin}/ModifyFields"
    system "#{bin}/PDictManager"
    system "#{bin}/ParseInQueryOp"
    system "#{bin}/ParseQuery"
    system "#{bin}/ParseToFile"
    system "#{bin}/QueryClarity"
    system "#{bin}/QueryModelEval"
    system "#{bin}/RelFBEval"
    system "#{bin}/RetEval"
    system "#{bin}/RetQueryClarity"
    system "#{bin}/StructQueryEval"
    system "#{bin}/TwoStageRetEval"
    system "#{bin}/XlingRetEval"
    system "#{bin}/dumpDoc"
    system "#{bin}/dumpTerm"
    system "#{bin}/dumpindex"
    system "#{bin}/harvestlinks"
    system "#{bin}/makeprior"
    system "#{bin}/pagerank"
  end
end
