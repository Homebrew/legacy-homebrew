class Spim < Formula
  desc "MIPS32 simulator"
  homepage "http://spimsimulator.sourceforge.net/"
  # No source code tarball exists
  url "http://svn.code.sf.net/p/spimsimulator/code", :revision => 641
  version "9.1.13"

  bottle do
    sha256 "a466feaa7824c5eff4d31c6f2467e9610bc50f5d21d725085ab4fcd8c53f80fc" => :mavericks
    sha256 "eb3063541835046d8423b3c668618171084472b189af0488f8e4161228621149" => :mountain_lion
    sha256 "fce7c9eeb1225e034a3975f7d443a3aaa2210e1ad829e2a357c715c1302321e1" => :lion
  end

  def install
    bin.mkpath
    cd "spim" do
      system "make", "EXCEPTION_DIR=#{share}"
      system "make", "install", "BIN_DIR=#{bin}",
                                "EXCEPTION_DIR=#{share}",
                                "MAN_DIR=#{man1}"
    end
  end
end
