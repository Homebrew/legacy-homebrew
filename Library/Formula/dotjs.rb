require 'formula'

class Dotjs <Formula
  url 'https://github.com/defunkt/dotjs/tarball/d25ad00ff6b03956e9dc328355c36e9b8e8130c5'
  head 'git://github.com/defunkt/dotjs.git'
  homepage 'http://chriswanstrath.com/dotjs/'
  md5 '1fdedd902540bbd1914b33e9b0e723f9'

  def install
    system "open", "-a", "Google Chrome"
    cp "builds/dotjs.crx", "/tmp/dotjs.crx"
    system "open", "/tmp/dotjs.crx"

    bin.install "bin/djsd"

    plist_path = File.expand_path "~/Library/LaunchAgents/com.github.dotjs.plist"
    mkdir_p File.dirname(plist_path)
    cp "com.github.dotjs.plist", plist_path
    system "launchctl", "load", "-w", plist_path
  end
end
