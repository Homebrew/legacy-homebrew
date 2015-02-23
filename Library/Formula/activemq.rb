class Activemq < Formula
  homepage "http://activemq.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=/activemq/5.11.1/apache-activemq-5.11.1-bin.tar.gz"
  sha1 "db4310f037af4a430abfdddf18c2df4082a34340"

  depends_on :java => "1.6+"

  def install
    rm_rf Dir["bin/linux-x86-*"] unless OS.linux?

    prefix.install_metafiles
    libexec.install Dir["*"]

    bin.write_exec_script libexec/"bin/activemq"
    bin.write_exec_script libexec/"bin/activemq-admin"
  end

  test do
    ENV["JAVA_HOME"] = `/usr/libexec/java_home`.chomp
    system "#{bin}/activemq-admin", "browse", "-h"
  end
end
