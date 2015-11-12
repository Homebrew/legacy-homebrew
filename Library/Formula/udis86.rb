class Udis86 < Formula
  desc "Minimalistic disassembler library for x86"
  homepage "http://udis86.sourceforge.net"
  url "https://downloads.sourceforge.net/udis86/udis86-1.7.2.tar.gz"
  sha256 "9c52ac626ac6f531e1d6828feaad7e797d0f3cce1e9f34ad4e84627022b3c2f4"

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "install"
  end

  test do
    assert pipe_output("#{bin}/udcli -x", "cd 80").include?("int 0x80")
  end
end
