class Moco < Formula
  desc "Stub server with Maven, Gradle, Scala, and shell integration"
  homepage "https://github.com/dreamhead/moco"
  url "http://central.maven.org/maven2/com/github/dreamhead/moco-runner/0.9.2/moco-runner-0.9.2-standalone.jar"
  version "0.9.2"
  sha256 "ab663f52315e39d3291ee3ff447a0503977a1d6cf8b6efc9905c86386577d251"

  def install
    libexec.install "moco-runner-0.9.2-standalone.jar"
    bin.write_jar_script libexec/"moco-runner-0.9.2-standalone.jar", "moco"
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
