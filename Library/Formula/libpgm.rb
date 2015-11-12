class Libpgm < Formula
  desc "Implements the PGM reliable multicast protocol"
  homepage "https://code.google.com/p/openpgm/"
  url "https://openpgm.googlecode.com/files/libpgm-5.2.122%7Edfsg.tar.gz"
  sha256 "e296f714d7057e3cdb87f4e29b1aecb3b201b9fcb60aa19ed4eec29524f08bd8"
  version "5.2.122"

  bottle do
    cellar :any
    revision 1
    sha256 "24765bd6efa0aa65a333e3d5bb5a48159875b81cae8ca99c479fbda4133f49b9" => :el_capitan
    sha1 "6e6e3733c7d612a7632e602191f06698ab8e57a3" => :yosemite
    sha1 "0c0e8cd6d5ac936c9f4c40cc0b83e1ddc2398d6d" => :mavericks
    sha1 "c68362f62ee7796ed3fbea2f6d93480fd7f6564d" => :mountain_lion
  end

  option :universal

  def install
    cd "openpgm/pgm" do
      ENV.universal_binary if build.universal?
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end
end
