require 'formula'

class Lockrun < Formula
  # The repo doesn't have any releases to use the master.
  # Repo probably updates infrequently anyway.
  # If the sha1 fails, new sha1 has to be calculated.

  homepage "https://github.com/pushcx/lockrun"
  url "https://github.com/pushcx/lockrun/archive/master.tar.gz"
  version "20130802"
  sha1 "a064a4ba4e33b6137544f0e91ee17e3f54bd28ea"

  head do
    url 'https://github.com/pushcx/lockrun.git', :branch => 'master'
  end

  def install
    system "#{ENV.cc} #{ENV.cflags} lockrun.c -o lockrun"
    bin.install "lockrun"
  end
end
