class Blucat < Formula
  desc "netcat for Bluetooth"
  homepage "http://blucat.sourceforge.net/blucat/"
  url "http://blucat.sourceforge.net/blucat/wp-content/uploads/blucat-aa3e02.zip"
  sha256 "6dcd6bf538a06c2f29d21a9e94d859d91667a7014244462bffca9767bba5307d"
  version "0.9"

  depends_on "ant" => :build
  depends_on :java => "1.6"

  def install
    system "ant"
    libexec.install "blucat"
    libexec.install "lib"
    libexec.install "build"
    bin.write_exec_script libexec/"blucat"
  end

  test do
    system "#{bin}/blucat", "doctor"
  end
end
