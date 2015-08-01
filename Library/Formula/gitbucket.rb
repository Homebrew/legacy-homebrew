class Gitbucket < Formula
  desc "GitHub clone"
  homepage "https://github.com/takezoe/gitbucket"
  url "https://github.com/takezoe/gitbucket/releases/download/3.5/gitbucket.war"
  sha256 "7e07b38f953c5162ef3cfaad224f39da0c1368ab12ba1236266761583a97d804"

  bottle do
    cellar :any
    sha256 "11ec3f54dca6e54515feaae91ed666dce516f0ad5586920934516fb18d38e25f" => :yosemite
    sha256 "e817a050e05128c5c30da71391e044997646e090611ac2bbe53a76ed249e7309" => :mavericks
    sha256 "aa767e27d98c81fe402588f0780d1f58b84b2042c5c2e43b0aa929f6dbfa1969" => :mountain_lion
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
