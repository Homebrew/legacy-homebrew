require "formula"

class AvroTools < Formula
  desc "Avro command-line tools and utilities"
  homepage "http://avro.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=avro/avro-1.7.7/java/avro-tools-1.7.7.jar"
  sha1 "a2c493c897583892b0423f0c9c732c242cd8816d"

  def install
    libexec.install "avro-tools-#{version}.jar"
    bin.write_jar_script libexec/"avro-tools-#{version}.jar", "avro-tools"
  end
end
