class Luyten < Formula
  homepage "https://deathmarine.github.io/Luyten/"
  desc "An Open Source Java Decompiler Gui for Procyon"
  url "https://github.com/deathmarine/Luyten/releases/download/v0.4.4/luyten-0.4.4.jar", :using => :nounzip
  sha256 "73d57db704952b5331b3bb2132e1a31a2b56df443a32b0fef336473428a0dcb1"

  head do
    url "https://github.com/deathmarine/Luyten.git"
    depends_on "maven" => :build
  end

  depends_on :java => "1.7+"

  def install
    if build.head?
      version = `mvn org.apache.maven.plugins:maven-help-plugin:evaluate -Dexpression=project.version | grep -v '\\['`.chomp
      system "mvn", "clean", "package"
      libexec.install "target/luyten-#{version}.jar"
    else
      libexec.install "luyten-#{version}.jar"
    end
    bin.write_jar_script libexec/"luyten-#{version}.jar", "luyten"
  end

  test do
    io = IO.popen("luyten")
    sleep 5
    Process.kill("SIGINT", io.pid)
    Process.wait(io.pid)
    io.read !~ /Exception/
  end
end
