require "formula"

class SpringLoaded < Formula
  desc "Java agent to enable class reloading in a running JVM"
  homepage "https://github.com/spring-projects/spring-loaded"
  url "https://repo.spring.io/simple/libs-release-local/org/springframework/springloaded/1.2.3.RELEASE/springloaded-1.2.3.RELEASE.jar"
  sha1 "adb44a1feaae2d717b534fec52210f1838de4aed"
  version "1.2.3"

  def install
    (share/"java").install "springloaded-#{version}.RELEASE.jar" => "springloaded.jar"
  end

  test do
    system "java", "-javaagent:#{share}/java/springloaded.jar", "-version"
  end
end
