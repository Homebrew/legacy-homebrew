class WrkTrello < Formula
  desc "Command-line interface to Trello"
  homepage "https://github.com/blangel/wrk"
  url "https://cloud.github.com/downloads/blangel/wrk/wrk-1.0.1.tar.gz"
  sha256 "85aea066c49fd52ad3e30f3399ba1a5e60ec18c10909c5061f68b09d80f5befe"

  bottle :unneeded

  conflicts_with "wrk", :because => "both install `wrk` binaries"

  def script; <<-EOS.undent
    #!/bin/sh
    export WRK_HOME="#{libexec}"
    exec "#{libexec}/bin/wrk" "$@"
    EOS
  end

  def install
    libexec.install Dir["*"]
    (bin/"wrk").write script
  end

  def caveats; <<-EOS.undent
    To get your token go here:
    https://trello.com/1/authorize?key=8d56bbd601877abfd13150a999a840d0&name=Wrk&expiration=never&response_type=token&scope=read,write
    and save it to ~/.wrk/token
    Start `wrk` for more information.
    EOS
  end
end
