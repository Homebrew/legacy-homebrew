class Predictionio < Formula
  desc "Source machine learning server"
  homepage "https://prediction.io/"
  url "http://download.prediction.io/PredictionIO-0.9.2.tar.gz"
  sha256 "e4da196a1d67f545d6667f8368a7c6a64ff5c6de5135b085a12e9251b6076991"

  bottle :unneeded

  depends_on "elasticsearch"
  depends_on "hadoop"
  depends_on "hbase"
  depends_on "apache-spark"
  depends_on :java => "1.7+"

  def install
    rm_f Dir["bin/*.bat"]

    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/pio"

    inreplace libexec/"conf/pio-env.sh" do |s|
      s.gsub! /#\s*ES_CONF_DIR=.+$/, "ES_CONF_DIR=#{Formula["elasticsearch"].opt_prefix}/config"
      s.gsub! /SPARK_HOME=.+$/, "SPARK_HOME=#{Formula["apache-spark"].opt_prefix}"
    end
  end
end
