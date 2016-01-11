class Lockrun < Formula
  desc "Run cron jobs with overrun protection"
  homepage "http://unixwiz.net/tools/lockrun.html"
  url "http://unixwiz.net/tools/lockrun.c"
  version "1.1.3"
  sha256 "cea2e1e64c57cb3bb9728242c2d30afeb528563e4d75b650e8acae319a2ec547"

  bottle do
    cellar :any
    sha256 "8f2914ed87c42a369b3870b5688720cf0cc7382ae6428452ba32fdf0e422ab57" => :yosemite
    sha256 "c319dba85122ea12d120a7ea3acbdc1c50ee35f2eadb274aa5ec59622b026ca0" => :mavericks
    sha256 "382ed13c3dcbf64143ea6058f593338af2b6449a2cba889d64ac988d08e2b139" => :mountain_lion
  end

  def install
    system "#{ENV.cc} #{ENV.cflags} lockrun.c -o lockrun"
    bin.install "lockrun"
  end
end
