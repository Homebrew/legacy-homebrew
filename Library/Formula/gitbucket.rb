class Gitbucket < Formula
  desc "GitHub clone"
  homepage "https://github.com/takezoe/gitbucket"
  url "https://github.com/takezoe/gitbucket/releases/download/3.4/gitbucket.war"
  sha256 "a43f8a5d92381e9508a7c85ab3e4954f6038465edc7d370c083b121f0dc08ad6"

  bottle do
    cellar :any
    sha256 "e6c36e1cbadf79ba6ee7bf4d4e0686baa4ab8cd842b74743cc485336a1537944" => :yosemite
    sha256 "a6f8da25fb5267ceabaa039986f2f8c0a19bde3b80cde3adf5e49fe68e32412f" => :mavericks
    sha256 "10c67abed55b1dd97e0db921e0ed9dfa5d9cd4e5bfed98e542101686ba589685" => :mountain_lion
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
