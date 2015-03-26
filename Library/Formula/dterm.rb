class Dterm < Formula
  homepage "http://www.knossos.net.nz/resources/free-software/dterm/"
  url "http://www.knossos.net.nz/downloads/dterm-0.3.tgz"
  sha256 "c12ece81a57296e39f564fe0269dbe34f048f4a47d2bf79b6a6215718091e67f"

  def install
    bin.mkpath
    system "make"
    system "make", "install", "BIN=#{bin}/"
  end

  test do
    system "#{bin}/dterm", "help"
  end
end
