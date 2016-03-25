class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://www.eclipse.org/jetty/"
  url "http://download.eclipse.org/jetty/9.3.8.v20160314/dist/jetty-distribution-9.3.8.v20160314.tar.gz"
  version "9.3.8.v20160314"
  sha256 "fc4136c0abf8f86d99de1b11b3d2323bffda0d538a0f654bf741f5e84ea992bf"

  bottle :unneeded

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
    ENV["JETTY_BASE"] = testpath
    cp_r Dir[libexec/"*"], testpath
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
