class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/activemq/5.11.2/apache-activemq-5.11.2-bin.tar.gz"
  sha256 "db475dffe3004a619f437347258ff07a60bce60c38dc05edca8d03ede5a64418"

  depends_on :java => "1.6+"

  def install
    rm_rf Dir["bin/linux-x86-*"]
    libexec.install Dir["*"]
    (bin/"activemq").write_env_script libexec/"bin/activemq", Language::Java.java_home_env("1.6+")
    (bin/"activemq-admin").write_env_script libexec/"bin/activemq-admin", Language::Java.java_home_env("1.6+")
  end

  test do
    system "#{bin}/activemq-admin", "browse", "-h"
  end
end
