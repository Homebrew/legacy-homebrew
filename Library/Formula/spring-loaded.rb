require "formula"

class SpringLoaded < Formula
  homepage "https://github.com/spring-projects/spring-loaded"
  url "http://dist.springframework.org/snapshot/SPRING-LOADED/springloaded-1.1.5.RELEASE.jar"
  sha1 "abde10d9955f27d4a3141005c177012668565846"
  version "1.1.5"

  def install
    (share/"java").install "springloaded-1.1.5.RELEASE.jar" => "springloaded.jar"
  end

  test do
    system "java", "-javaagent:#{share}/java/springloaded.jar", "-version"
  end
end
