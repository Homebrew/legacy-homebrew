require "formula"
require 'net/http'

class Moco < Formula
  homepage "https://github.com/dreamhead/moco"
  url "http://central.maven.org/maven2/com/github/dreamhead/moco-runner/0.9.2/moco-runner-0.9.2-standalone.jar"
  sha1 "a21445d7b275c48874ed7756477ade74de299e17"

  def install
    libexec.install "moco-runner-0.9.2-standalone.jar"
    bin.write_jar_script libexec/"moco-runner-0.9.2-standalone.jar", "moco"
  end

  test do
    port=12306
    (testpath/'config.json').write <<-TEST_SCRIPT.undent
      [
        {
          "response" :
          {
              "text" : "Hello, Moco"
          }
        }
    ]
    TEST_SCRIPT
    startMoco=Thread.new do
      system(bin/"moco","start","-p", port,"-c",(testpath/'config.json'))
    end
    sleep 5 #wait moco start
    actualResponse=Net::HTTP.get(URI('http://localhost:'+port.to_s))
    if(actualResponse!='Hello, Moco')
      onoe "Error! The response is not right."
    end
    startMoco.exit
  end
end
