class Jetty < Formula
  homepage "https://www.eclipse.org/jetty/"
  url "http://download.eclipse.org/jetty/9.2.11.v20150529/dist/jetty-distribution-9.2.11.v20150529.tar.gz"
  version "9.2.11.v20150529"
  sha256 "2dd7d03d49c44d25a0a852f6f40a8ea5548edd7f1ca33eb7e98386450c4d3ab5"

  bottle do
    cellar :any
    sha256 "a0bf10e7229deaff9ccf17164354598ba6727033a1cdbbce7290270943d61e96" => :yosemite
    sha256 "894ab6e7b99475b31e10b4a9cf7806f20b7162439bf5d9706087ad785834ef7a" => :mavericks
    sha256 "cf81c0b658885c2d1199d3f063536b4c2489a456718d5e4b30d4693640e23cab" => :mountain_lion
  end

  depends_on :java => "1.7+"

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
