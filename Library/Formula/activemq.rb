class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/activemq/5.13.2/apache-activemq-5.13.2-bin.tar.gz"
  sha256 "be178babf4a22f8774480ab30705030b944f880e8c133ef2eee324ee90b72f6f"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    rm_rf Dir["bin/linux-x86-*"]
    libexec.install Dir["*"]
    (bin/"activemq").write_env_script libexec/"bin/activemq", Language::Java.java_home_env("1.6+")
  end

  test do
    system "#{bin}/activemq", "browse", "-h"
  end
end
