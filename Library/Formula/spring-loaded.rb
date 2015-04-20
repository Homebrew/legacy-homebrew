require "formula"

class SpringLoaded < Formula
  homepage "https://github.com/spring-projects/spring-loaded"
  url "http://search.maven.org/remotecontent?filepath=org/springframework/springloaded/1.2.0.RELEASE/springloaded-1.2.0.RELEASE.jar"
  sha1 "dd02aa7d9fa802f59bd4bd485e18d55ef5c74bba"
  version "1.2.0"

  def install
    (share/"java").install "springloaded-#{version}.RELEASE.jar" => "springloaded.jar"
  end

  test do
    system "java", "-javaagent:#{share}/java/springloaded.jar", "-version"
  end
end
