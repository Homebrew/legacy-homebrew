class Dterm < Formula
  desc "Terminal emulator for use with xterm and friends"
  homepage "http://www.knossos.net.nz/resources/free-software/dterm/"
  url "http://www.knossos.net.nz/downloads/dterm-0.3.tgz"
  sha256 "c12ece81a57296e39f564fe0269dbe34f048f4a47d2bf79b6a6215718091e67f"

  bottle do
    cellar :any_skip_relocation
    sha256 "65fbe5c0965c619cf0ecd9f71d08628935950ad51d61230b01e3c222c208520d" => :el_capitan
    sha256 "021c79b8bd9eaf005e30fb2291c6ca7210ff37bdcf9ba6762fb53b81a21f1cf1" => :yosemite
    sha256 "485ec99b145bdc2de1e066efc947e14007d5f4d9e421aefad31db399bab29e76" => :mavericks
    sha256 "7eef65a8c4e22d8c1918b9ad38bc2feae87c1a4cec3671a5c5227648288dd319" => :mountain_lion
  end

  def install
    bin.mkpath
    system "make"
    system "make", "install", "BIN=#{bin}/"
  end

  test do
    system "#{bin}/dterm", "help"
  end
end
