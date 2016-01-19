class Gcviewer < Formula
  desc "Java garbage collection visualization tool"
  homepage "https://github.com/chewiebug/GCViewer"
  url "https://github.com/chewiebug/GCViewer/archive/1.34.1.tar.gz"
  sha256 "e0e97a94c80be8323772dc8953d463fe8eaf60c3a1c5f212d0b575a3b5c640ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cfdc7b6966867f780f56e603cc9f658d21a8897c196c163fd4c51d8f8f6ee6f" => :el_capitan
    sha256 "acedd8765108ed55adf9b608960f20db5a7aa22e256cd58d74037c201fb8bccd" => :yosemite
    sha256 "8d295ab7282b45a982e4ffbd78dac71e59d9f00d56d6b732b3816c42e572e639" => :mavericks
  end

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
