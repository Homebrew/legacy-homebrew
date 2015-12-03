class I2p < Formula
  desc "An anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://dl.dropboxusercontent.com/u/18621288/I2P/0.9.23/i2pinstall_0.9.23.jar"
  sha256 "843a8059830b009d10c47cc7c85e260ad88f7c3c16e289bbf80c0eb178318823"

  depends_on :java => "1.6+"

  def install
    (buildpath/"path.conf").write "INSTALL_PATH=#{libexec}"

    system "java", "-jar", "i2pinstall_#{version}.jar", "-options", "path.conf"

    wrapper_name = "i2psvc-macosx-universal-#{MacOS.prefer_64_bit? ? 64 : 32}"
    libexec.install_symlink libexec/wrapper_name => "i2psvc"
    bin.write_exec_script Dir["#{libexec}/{eepget,i2prouter}"]
    man1.install Dir["#{libexec}/man/*"]
  end

  test do
    wrapper_pid = fork do
      exec "#{bin}/i2prouter console"
    end
    router_pid = 0
    sleep 5

    begin
      status = shell_output("#{bin}/i2prouter status")
      assert_match(/I2P Service is running/, status)
      /PID:(\d+)/ =~ status
      router_pid = Regexp.last_match(1)
    ensure
      Process.kill("SIGINT", router_pid.to_i) unless router_pid.nil?
      Process.kill("SIGINT", wrapper_pid)
      Process.wait(wrapper_pid)
    end
  end
end
