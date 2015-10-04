class Ripmime < Formula
  desc "Extract attachments out of MIME encoded email packages"
  homepage "http://www.pldaniels.com/ripmime/"
  url "http://www.pldaniels.com/ripmime/ripmime-1.4.0.10.tar.gz"
  sha256 "896115488a7b7cad3b80f2718695b0c7b7c89fc0d456b09125c37f5a5734406a"

  def install
    system "make", "LIBS=-liconv", "CFLAGS=#{ENV.cflags}"
    bin.install "ripmime"
    man1.install "ripmime.1"
  end
end
