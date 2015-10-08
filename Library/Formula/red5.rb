class Red5 < Formula
  desc "Red5 is an Open Source Flash Server written in Java"
  homepage "https://github.com/Red5/red5-server"
  url "https://github.com/Red5/red5-server/releases/download/v1.0.6-RELEASE/red5-server-1.0.6-RELEASE-server.tar.gz"
  version "1.0.6"
  sha256 "4aee3f312d16e09495e5010cf95bc7b8ed48620163950425a1f147f17aaab5f7"

  depends_on :java => "1.7+"

  def install
    # Remove Windows scripts
    rm Dir["*.bat"]

    (bin/"red5").write_env_script libexec/"red5.sh", Language::Java.java_home_env("1.7+")

    # Move config files into etc
    (etc/"red5").install Dir["conf/*"]
    libexec.install_symlink "#{etc}/red5" => "conf"
    rm_rf Dir["conf"]

    # Move webapps into var
    (var/"red5/webapps").install Dir["webapps/*"]
    libexec.install_symlink "#{var}/red5/webapps" => "webapps"
    rm_rf Dir["webapps"]

    # Install others files
    libexec.install Dir["*"]

    inreplace "#{libexec}/red5.sh" do |s|
      # Configure RED5_HOME
      s.sub!("export RED5_HOME=`pwd`", "export RED5_HOME=#{libexec}")
      s.sub!("# start Red5", "# start Red5\ncd `dirname $0`")
    end
  end

  test do
    pid = fork do
      exec "#{bin}/red5"
    end
    sleep 15

    begin
      assert_match /Red5 - The open source media server/, shell_output("curl localhost:5080")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
