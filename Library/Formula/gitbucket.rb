class Gitbucket < Formula
  desc "GitHub clone"
  homepage "https://github.com/takezoe/gitbucket"
  url "https://github.com/takezoe/gitbucket/releases/download/3.6/gitbucket.war"
  sha256 "bec6de463157d679d3887b940642f8e51661c4b98289b42abce9b9115dc82d4e"

  bottle do
    cellar :any
    sha256 "4c996c9acce91bcf66ad53ec2b1f2f323c094a6985451c6b22a13f94f189cdb3" => :yosemite
    sha256 "7ab8add459500bba14c2d0f9a75622c395a62bfd46e3dc578199aa4e104c492d" => :mavericks
    sha256 "ba77f720b0a392b498760c821a62cc0842d8d09cd2bb4bc7edee0587fc86dd5e" => :mountain_lion
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
