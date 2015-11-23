class Pidof < Formula
  desc "Display the PID number for a given process name"
  homepage "http://www.nightproductions.net/cli.htm"
  url "http://www.nightproductions.net/downloads/pidof_source.tar.gz"
  sha256 "2a2cd618c7b9130e1a1d9be0210e786b85cbc9849c9b6f0cad9cbde31541e1b8"
  version "0.1.4"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "d02c826db5564d7750c0e309a771b164f7764250507955d0b87d09837c3c2ba6" => :el_capitan
    sha1 "2425268aa94521fbdf20f4ba16b80706a4c737ab" => :mavericks
    sha1 "80a7d45bd8695dbf1594f7626f754038d73551c6" => :mountain_lion
    sha1 "d09a05256afed09c300fd8c908f2559c05f91bce" => :lion
  end

  def install
    system "make", "all", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    man1.install gzip("pidof.1")
    bin.install "pidof"
  end
end
