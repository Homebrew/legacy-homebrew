class Teampostgresql < Formula
  homepage "http://www.teampostgresql.com"
  url "http://cdn.webworks.dk/download/teampostgresql_multiplatform.zip"
  version "1.07"
  sha1 "40ab16402ca8d862ae102a0ad44f84775dbe2a68"

  depends_on :java => "1.7"

  def install
    rm_f Dir["*.bat", "*.sh"]
    prefix.install_metafiles
    lib.install Dir["*"]

    libs = lib/"webapp"/"WEB-INF"/"lib"/"*"
    classes = lib/"webapp"/"WEB-INF"/"classes"
    main = "dbexplorer.TeamPostgreSQL"

    (bin/"teampostgresql").write <<-EOS.undent
      #!/bin/sh
      cd #{lib}
      java -cp #{libs}:#{classes} #{main} "$@"
    EOS
  end

  plist_options :manual => "teampostgresql 8082"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>/usr/bin/java</string>
        <string>-cp</string>
        <string>#{lib}/webapp/WEB-INF/lib/*:#{lib}/webapp/WEB-INF/classes</string>
        <string>dbexplorer.TeamPostgreSQL</string>
        <string>8082</string>
        <string>#{(lib/"webapp").relative_path_from(var)}</string>
      </array>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/teampostgresql.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/teampostgresql.log</string>
      <key>EnvironmentVariables</key>
      <dict>
        <key>LANG</key>
        <string>en_US.UTF-8</string>
      </dict>
    </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    Note: When using launchctl the port will be 8082.
    EOS
  end

  test do
    cmd = [
      "/usr/bin/java",
      "-cp", "#{lib}/webapp/WEB-INF/lib/*:#{lib}/webapp/WEB-INF/classes",
      "dbexplorer.TeamPostgreSQL", "12345",
      (lib/"webapp").relative_path_from(testpath)
    ].join(" ")

    pipe_cmd_in, pipe_cmd_out = IO.pipe
    cmd_pid = Process.spawn(cmd, [:err, :out] => pipe_cmd_out, :pgroup => true)

    success = false

    @exitstatus = :not_done
    Thread.new do
      Process.wait(cmd_pid)
      @exitstatus = $?.exitstatus
    end

    begin
      Timeout.timeout(5) do
        sleep(0.1) while @exitstatus == :not_done
      end
    rescue Timeout::Error
      Process.kill("TERM", -Process.getpgid(cmd_pid))
      pipe_cmd_out.close
      out = pipe_cmd_in.readlines
      success = out.any? { |line| line.include? "TeamPostgreSQL available" }
    end

    assert success
  end
end
