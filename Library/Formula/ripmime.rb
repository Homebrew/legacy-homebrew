require 'formula'

class Ripmime < Formula
  desc "Extract attachments out of MIME encoded email packages"
  homepage 'http://www.pldaniels.com/ripmime/'
  url 'http://www.pldaniels.com/ripmime/ripmime-1.4.0.10.tar.gz'
  sha1 '296f657f2f664b713751178fb589d5c64dc7b6ae'

  def install
    system "make", "LIBS=-liconv", "CFLAGS=#{ENV.cflags}"
    bin.install "ripmime"
    man1.install "ripmime.1"
  end
end
