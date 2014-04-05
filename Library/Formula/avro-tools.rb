require "formula"

class AvroTools < Formula
  homepage "http://avro.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=avro/avro-1.7.6/java/avro-tools-1.7.6.jar"
  sha1 "56ebab491e9dce5b1812c3867a8385cd636bb90a"

  def install
    libexec.install "avro-tools-#{version}.jar"
    bin.write_jar_script libexec/"avro-tools-#{version}.jar", "avro-tools"
  end
end
