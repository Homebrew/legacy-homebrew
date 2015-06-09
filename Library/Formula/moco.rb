class Moco < Formula
  desc "Stub server with Maven, Gradle, Scala, and shell integration"
  homepage "https://github.com/dreamhead/moco"
  url "http://central.maven.org/maven2/com/github/dreamhead/moco-runner/0.10.1/moco-runner-0.10.1-standalone.jar"
  version "0.10.1"
  sha256 "77996c0c5518beec0179fcdef83c2c606c5704073efc4ab6f9af80fc7756efbe"

  bottle do
    cellar :any
    sha256 "c3ade71eea4010c60bc478e9a89fe888762b46f22855219148ede03bf952d62a" => :yosemite
    sha256 "bd91b8f2dcc6d373a0d4e3a0639582c84c2b783927a1765543e5d333475cf02c" => :mavericks
    sha256 "baf157a25988a5b80e3efeaa265d1f6032c183fa1e6a3fe8c3338e8246573b65" => :mountain_lion
  end

  def install
    libexec.install "moco-runner-0.10.1-standalone.jar"
    bin.write_jar_script libexec/"moco-runner-0.10.1-standalone.jar", "moco"
  end

  test do
    require "net/http"

    (testpath/"config.json").write <<-EOS.undent
      [
        {
          "response" :
          {
              "text" : "Hello, Moco"
          }
        }
    ]
    EOS

    port = 12306
    thread = Thread.new do
      system bin/"moco", "start", "-p", port, "-c", testpath/"config.json"
    end

    # Wait for Moco to start.
    sleep 5

    response = Net::HTTP.get URI "http://localhost:#{port}"
    assert_equal "Hello, Moco", response
    thread.exit
  end
end
