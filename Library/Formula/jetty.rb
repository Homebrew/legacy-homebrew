class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://www.eclipse.org/jetty/"
  url "http://download.eclipse.org/jetty/9.3.0.v20150612/dist/jetty-distribution-9.3.0.v20150612.tar.gz"
  version "9.3.0.v20150612"
  sha256 "0a06c7ee2997819e5b46302c7b6f0269f0c953f194a30f15912d2e45d2c30a5c"

  bottle do
    cellar :any
    sha256 "124258ef3fc8e1ffc3c17a157ba0fea091b3142b85596b95705e9c76cbc2ebd8" => :yosemite
    sha256 "6e861d3f2233e03f790c846d935d0322171fdf417566d92550093b68f8a3bcf1" => :mavericks
    sha256 "3e808c691ffd66116ecef596871fa6082da3c1964be5402acd651740363b6d6d" => :mountain_lion
  end

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    (libexec+"logs").mkpath

    bin.mkpath
    Dir.glob("#{libexec}/bin/*.sh") do |f|
      scriptname = File.basename(f, ".sh")
      (bin+scriptname).write <<-EOS.undent
        #!/bin/bash
        JETTY_HOME=#{libexec}
        #{f} "$@"
      EOS
      chmod 0755, bin+scriptname
    end
  end

  test do
    pid = fork { system bin/"jetty", "start" }
    sleep 5 # grace time for server start
    begin
      assert_match /Jetty running pid=\d+/, shell_output("#{bin}/jetty check")
      assert_equal "Stopping Jetty: OK\n", shell_output("#{bin}/jetty stop")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
