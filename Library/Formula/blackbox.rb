class Blackbox < Formula
  homepage "https://github.com/StackExchange/blackbox"
  url "https://github.com/StackExchange/blackbox/archive/v1.20150304.tar.gz"
  version "1.20150304"
  sha256 "62093e2dad03344f677f0bb1243d95da11e5518280a176787b76a86196fbad8b"

  def install
    chmod 0755, Dir["bin/*"]
    libexec.install Dir["*"]

    bins = Dir["#{libexec}/bin/*"].select { |f| File.executable? f }
    bin.write_exec_script bins
  end
  
  test do
    system "#{bin}/blackbox_cat"
  end
  
end
