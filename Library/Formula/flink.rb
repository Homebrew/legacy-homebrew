class Flink < Formula
  desc "Platform for scalable batch and stream data processing"
  homepage "https://flink.apache.org"
  head "https://github.com/apache/flink.git"
  url "https://www.apache.org/dyn/closer.cgi?path=flink/flink-0.9.0/flink-0.9.0-bin-hadoop2.tgz"
  version "0.9.0"
  sha256 "1edf33d154b863dd108ba618ed3b7dce3fce6c116b45368aef164b47779b65f9"

  def install
    rm_f Dir["bin/*.cmd"]
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
  end
end
