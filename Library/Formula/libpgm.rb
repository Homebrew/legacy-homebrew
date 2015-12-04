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
    sha256 "ae0d1d980f84677fcaa08b1d9f35f1c9d4858e4239598530b7485e9f248def73" => :yosemite
    sha256 "87ac77e422ffd9b72d1070c991064d0a8a9b5eb2d124f5cdd9911590b48bd291" => :mavericks
    sha256 "682fb0731817ab2f01c9247b1579dcd4a5ff8e28a938ddcd7045ee30acc81499" => :mountain_lion
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
