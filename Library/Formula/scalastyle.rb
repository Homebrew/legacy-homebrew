require "formula"

class Scalastyle < Formula
  homepage "http://www.scalastyle.org/command-line.html"
  url "https://oss.sonatype.org/content/repositories/releases/org/scalastyle/scalastyle-batch_2.10/0.5.0/scalastyle-batch_2.10-0.5.0-distribution.zip"
  version "0.5.0"
  sha1 "bf009e0c4d48e5effce5113f5feb3da626ca1248"

  resource "default_config" do
    url "https://raw.githubusercontent.com/scalastyle/scalastyle/e41e5df2cf4b616d06d1f5b8c383ec084fc32012/lib/scalastyle_config.xml"
    sha1 "993c4d665ae75930c262fcd8a13eef0e9604920f"
  end

  def install
    (libexec/"lib").install Dir["lib/*.jar"]
    libexec.install "scalastyle-batch_2.10.jar"

    etc.install resource("default_config")

    (bin/"scalastyle").write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/scalastyle-batch_2.10.jar" --config "#{etc}/scalastyle_config.xml" "$@"
    EOS
  end

  def caveats
    <<-EOS.undent
      A default configuration file is used from "#{etc}/scalastyle_config.xml"
      To override, pass a "--config your_config.xml" argument on the command line.
    EOS
  end

  test do
    system bin/"scalastyle", "--verbose"
  end
end
