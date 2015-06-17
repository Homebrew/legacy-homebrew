class Pillar < Formula
  desc "Manage migrations for Cassandra data stores"
  homepage "https://github.com/comeara/pillar"
  url "https://github.com/comeara/pillar/archive/v2.0.1.tar.gz"
  sha256 "d5db7fbf956dae05794ec7b26c1de70aaab1d21fed774d95d16a241e9dd3952e"

  depends_on :java
  depends_on "sbt" => :build

  def install
    system "sbt", "assembly"

    inreplace "src/main/bash/pillar" do |s|
      s.gsub! "/usr/java/default", "`/usr/libexec/java_home`"
      s.gsub! "${PILLAR_ROOT}/lib/pillar.jar", "#{libexec}/pillar-assembly-#{version}.jar"
      s.gsub! "${PILLAR_ROOT}/conf", "#{etc}/pillar-log4j.properties"
    end

    bin.install "src/main/bash/pillar"
    etc.install "src/main/resources/pillar-log4j.properties"
    libexec.install "target/scala-2.10/pillar-assembly-#{version}.jar"
  end

  test do
    assert_match /Missing parameter/, shell_output("#{bin}/pillar 2>&1", 1)
  end
end
