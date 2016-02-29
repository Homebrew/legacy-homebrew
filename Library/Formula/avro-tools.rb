class AvroTools < Formula
  desc "Avro command-line tools and utilities"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.8.0/java/avro-tools-1.8.0.jar"
  sha256 "ce3f4478e12296810fdfc1e424acd378fd9ee48b627d98472a2d7ff23852d7b2"

  bottle :unneeded

  def install
    libexec.install "avro-tools-#{version}.jar"
    bin.write_jar_script libexec/"avro-tools-#{version}.jar", "avro-tools"
  end
end
