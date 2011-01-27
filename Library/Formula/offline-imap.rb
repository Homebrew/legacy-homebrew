require 'formula'

class OfflineImap < Formula
  url "http://github.com/downloads/rue/offlineimap/offlineimap-6.2.0.tar.gz"
  homepage "http://github.com/rue/offlineimap"
  md5 "919ad6f71b8437ad0a08a5fdeae9cb67"

  def install
    libexec.install 'bin/offlineimap' => 'offlineimap.py'
    libexec.install 'offlineimap'
    bin.mkpath
    ln_s libexec+'offlineimap.py', bin+'offlineimap'
  end
end
