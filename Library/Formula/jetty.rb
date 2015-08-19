class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://www.eclipse.org/jetty/"
  url "http://download.eclipse.org/jetty/9.3.2.v20150730/dist/jetty-distribution-9.3.2.v20150730.tar.gz"
  version "9.3.2.v20150730"
  sha256 "c9d51e6e09c710cd084adb694149acfa93b90ba6a979cbaccc41e191bc4c14da"

  bottle do
    cellar :any
    sha256 "b85569259442f3ba6e4cceab1ad1ae51ef3e2a43253b02251ec3e0a584e1dfd6" => :yosemite
    sha256 "bb5f2e2d895543f7d79b3ffec46804d7316822cf2107c61671c39e1b51a54aac" => :mavericks
    sha256 "0226ed8ffb51ad60afb85752a0ec0347df9f9a8d2387510e03f276dac579344f" => :mountain_lion
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
    pid = fork { exec bin/"jetty", "start" }
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
