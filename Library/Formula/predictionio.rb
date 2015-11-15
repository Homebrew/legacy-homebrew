class Predictionio < Formula
  desc "Source machine learning server"
  homepage "https://prediction.io/"
  url "http://download.prediction.io/PredictionIO-0.9.5.tar.gz"
  sha256 "6af81c03ac5d74fc331ab2248d2cacc752a6c2a54e0a55d63b57f7f17eae2fb0"

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
