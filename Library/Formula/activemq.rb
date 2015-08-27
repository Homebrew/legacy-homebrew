class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/activemq/5.12.0/apache-activemq-5.12.0-bin.tar.gz"
  sha256 "b14bbeef71800365cd4278465f5bfb31757f56ebd5206f3e01ae353041c5a297"

  depends_on :java => "1.6+"

  def install
    rm_rf Dir["bin/linux-x86-*"]
    libexec.install Dir["*"]
    (bin/"activemq").write_env_script libexec/"bin/activemq", Language::Java.java_home_env("1.6+")
  end

  test do
    ENV["ACTIVEMQ_PIDFILE"] = testpath/"activemq.pid"
    pid = fork do
      exec "#{bin}/activemq start"
    end
    sleep 5

    begin
      assert_match /ActiveMQ is running/, shell_output("#{bin}/activemq status")
    ensure
      system "#{bin}/activemq", "stop"
      Process.wait(pid)
    end
  end
end
