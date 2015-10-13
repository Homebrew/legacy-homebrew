class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://www.eclipse.org/jetty/"
  url "http://download.eclipse.org/jetty/9.3.3.v20150827/dist/jetty-distribution-9.3.3.v20150827.tar.gz"
  version "9.3.3.v20150827"
  sha256 "decd6788232646f9a2980c15aa076ecbd919e61867913d056ddb3251ac31415c"

  bottle do
    cellar :any
    sha256 "4f66cc3ed3fac42f14c0a965d40dae6d6f775101dae0be0bf82e4716536f9c82" => :el_capitan
    sha256 "97e4698a2591db0b78f8bb053306c657c93fee5397c2ccc2ea001eaca706ac96" => :yosemite
    sha256 "a66366f2f8f81478ec0cb411882b3981e9a17b7dbf9c33913ebe2e367c97499f" => :mavericks
    sha256 "7ca2c2b16e01a3d480785cef44cfabe6b5611e2ede5a2935389b4ecd4c03dee1" => :mountain_lion
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
