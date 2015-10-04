class Jvmtop < Formula
  desc "Console application for monitoring all running JVMs on a machine"
  homepage "https://code.google.com/p/jvmtop/"
  url "https://jvmtop.googlecode.com/files/jvmtop-0.8.0.tar.gz"
  sha256 "f9de8159240b400a51b196520b4c4f0ddbcaa8e587fab1f0a59be8a00dc128c4"

  def install
    rm Dir["*.bat"]
    mv "jvmtop.sh", "jvmtop"
    chmod 0755, "jvmtop"

    libexec.install Dir["*"]

    bin.write_exec_script libexec/"jvmtop"
  end
end
