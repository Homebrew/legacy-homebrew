class AvroTools < Formula
  desc "Avro command-line tools and utilities"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.7.7/java/avro-tools-1.7.7.jar"
  sha256 "ca1658c64d3609e9b7fe62039b3a95993fa18ed3244121c1f71d677ec51ab092"

  bottle :unneeded

  def install
    libexec.install "avro-tools-#{version}.jar"
    bin.write_jar_script libexec/"avro-tools-#{version}.jar", "avro-tools"
  end
end
