class Fakesmtp < Formula
  desc "Dummy SMTP server with GUI for testing emails in applications easily"
  homepage "https://nilhcem.github.io/FakeSMTP/"
  url "https://github.com/Nilhcem/FakeSMTP/archive/v2.0.tar.gz"
  sha256 "8cb623f32b55f814af43b731432eb14da80d95cb13059c79423265037cda9dfb"

  depends_on :java
  depends_on "maven" => :build

  def install
    ENV.java_cache
    system "mvn", "package", "-Dmaven.test.skip=true"
    libexec.install "target/fakeSMTP-#{version}.jar"
    bin.write_jar_script libexec/"fakeSMTP-#{version}.jar", "fakesmtp"
  end

  test do
    require "net/smtp"

    pid = fork do
      exec bin/"fakesmtp", "-b", "-s", "-p2025"
    end
    sleep 1

    begin
      mail_text = <<-EOS.undent
        From: <from@example.org>
        To: <to@example.org>
        EOS

      Net::SMTP.start("localhost", 2025) do |smtp|
        assert smtp.send_message mail_text, "from@example.org", "to@example.org"
      end
    rescue => error
      assert !error, error.to_s
    end

    Process.kill "SIGKILL", pid
    Process.wait pid
  end
end
