class Pkt2flow < Formula
  desc "Classify packets into flows"
  homepage "https://github.com/caesar0301/pkt2flow"
  url "https://github.com/caesar0301/pkt2flow/archive/v1.2.tar.gz"
  sha256 "deb4c5dc2fd11c45e338e9d0c0127df03257040127c49016e40aaf491e5674a6"

  depends_on "scons" => :build

  def install
    scons
    bin.install "pkt2flow"
  end

  test do
    system "pkt2flow"
  end
end
