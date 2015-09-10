class MsmtpOffline < Formula
  desc "msmtp wrapper which queues email sent when offline."
  homepage "https://github.com/venkytv/msmtp-offline/"
  url "https://github.com/venkytv/msmtp-offline/archive/v1.0.tar.gz"
  sha256 "bc46754c74990da82f904a8b628d94e6e02d327bc515572f8c492adc40082041"
  head "https://github.com/venkytv/msmtp-offline.git"

  depends_on "msmtp"

  patch do
    url "https://patch-diff.githubusercontent.com/raw/venkytv/msmtp-offline/pull/1.patch"
    sha256 "8fccdd97bf180eb4bccc3c6e7efe0e9e2b1e91371183c79924524e982d8271f5"
  end

  def install
    bin.install "msmtp-offline"
    bin.install "msmtp-queue"
  end

  test do
    (testpath/"log").mkpath
    (testpath/".msmtp-offline.queue").mkpath
    mail = <<-EOS.undent
      From: test@example.com
      To: demo@example.com
      Subject: test

      This is a test mail.
    EOS
    pipe_output("#{bin}/msmtp-offline +forcequeue -oi", mail)
    assert_match /\n\tTo: demo@example.com\n/, shell_output("#{bin}/msmtp-queue -l")
  end
end
