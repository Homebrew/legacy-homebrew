class Gitbucket < Formula
  desc "GitHub clone"
  homepage "https://github.com/takezoe/gitbucket"
  url "https://github.com/takezoe/gitbucket/releases/download/3.5/gitbucket.war"
  sha256 "7e07b38f953c5162ef3cfaad224f39da0c1368ab12ba1236266761583a97d804"

  bottle do
    cellar :any
    sha256 "5607d41d7a351c243fa23898f15bb8b91cce6044069d3e0a994467cfc3ebb859" => :yosemite
    sha256 "1ebcb9865318411a998fbd9299952762f746d3408ab44eb1d1fe113b324496f2" => :mavericks
    sha256 "df163b51ed70f10f1809ed26e3cbe40c16057c056fd2641cfde70a23a6666290" => :mountain_lion
  end

  head do
    url "https://github.com/takezoe/gitbucket.git"
    depends_on :ant => :build
  end

  def install
    if build.head?
      system "ant"
      libexec.install "war/target/gitbucket.war", "."
    else
      libexec.install "gitbucket.war"
    end
  end

  plist_options :manual => "java -jar #{HOMEBREW_PREFIX}/opt/gitbucket/libexec/gitbucket.war"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>gitbucket</string>
        <key>ProgramArguments</key>
        <array>
          <string>/usr/bin/java</string>
          <string>-Dmail.smtp.starttls.enable=true</string>
          <string>-jar</string>
          <string>#{opt_libexec}/gitbucket.war</string>
          <string>--host=127.0.0.1</string>
          <string>--port=8080</string>
        </array>
        <key>RunAtLoad</key>
       <true/>
      </dict>
    </plist>
  EOS
  end

  def caveats; <<-EOS.undent
    Note: When using launchctl the port will be 8080.
    EOS
  end

  test do
    io = IO.popen("java -jar #{libexec}/gitbucket.war")
    sleep 12
    Process.kill("SIGINT", io.pid)
    Process.wait(io.pid)
    io.read !~ /Exception/
  end
end
