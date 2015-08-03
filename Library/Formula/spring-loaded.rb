class SpringLoaded < Formula
  desc "Java agent to enable class reloading in a running JVM"
  homepage "https://github.com/spring-projects/spring-loaded"
  url "https://repo.spring.io/simple/libs-release-local/org/springframework/springloaded/1.2.3.RELEASE/springloaded-1.2.3.RELEASE.jar"
  sha256 "c90c406c36ce077a9f76e05859d397aad7d0f427c6c395c6749cbdef697ba43f"
  version "1.2.3"

  def install
    (share/"java").install "springloaded-#{version}.RELEASE.jar" => "springloaded.jar"
  end

  test do
    system "java", "-javaagent:#{share}/java/springloaded.jar", "-version"
  end
end
