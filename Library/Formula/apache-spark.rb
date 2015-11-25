class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=spark/spark-1.5.2/spark-1.5.2-bin-hadoop2.6.tgz"
  version "1.5.2"
  sha256 "409c4b34f196acc5080b893b0579cda000c192fc4cc9336009395b2a559b676e"
  head "https://github.com/apache/spark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6fd02b7fe2272d29a9c49e45513c0a2212961a79cffb7b9d2265a24588ab3c5" => :el_capitan
    sha256 "9ef8bed85bd9b429613d8da241a4a525f44ed88ebb4a0586c2503f9c3058a829" => :yosemite
    sha256 "d682df81d21c79b92f62d1ea736306cc0c0fee47a3a12f4f5473670c2a5935c1" => :mavericks
  end

  def install
    # Rename beeline to distinguish it from hive's beeline
    mv "bin/beeline", "bin/spark-beeline"

    rm_f Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/spark-shell <<<'sc.parallelize(1 to 1000).count()'"
  end
end
