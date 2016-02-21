class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://www.eclipse.org/jetty/"
  url "http://download.eclipse.org/jetty/stable-9/dist/jetty-distribution-9.3.7.v20160115.zip"
  version "9.3.7.v20160115"
  sha256 "15f71a32ae21a37107537df07c15e8f7b5b506e07cc08b80e7799508a5e4a588"

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
