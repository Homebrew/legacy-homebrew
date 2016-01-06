class Gcviewer < Formula
  desc "Java garbage collection visualization tool"
  homepage "https://github.com/chewiebug/GCViewer"
  url "https://github.com/chewiebug/GCViewer/archive/1.34.1.tar.gz"
  sha256 "e0e97a94c80be8323772dc8953d463fe8eaf60c3a1c5f212d0b575a3b5c640ba"

  depends_on :java
  depends_on "maven" => :build

  def install
    ENV.java_cache
    system "mvn", "-Dmaven.surefire.debug=-Duser.language=en", "clean", "install"
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"target/gcviewer-1.34.1.jar", "gcviewer"
  end

  test do
    assert(File.exist?(libexec/"target/gcviewer-#{version}.jar"))
  end
end
