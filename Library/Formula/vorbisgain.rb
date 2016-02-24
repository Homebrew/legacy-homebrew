class Vorbisgain < Formula
  desc "Add Replay Gain volume tags to Ogg Vorbis files"
  homepage "https://sjeng.org/vorbisgain.html"
  url "https://sjeng.org/ftp/vorbis/vorbisgain-0.37.tar.gz"
  sha256 "dd6db051cad972bcac25d47b4a9e40e217bb548a1f16328eddbb4e66613530ec"

  bottle do
    cellar :any
    sha256 "00f7047e5d884dbf22ed036154961b41d4ad6ae8295c55043929b008ae82a9f7" => :el_capitan
    sha256 "a1315eaaaf667f7486deb2b899c422e3cc9caa8f9e771221dca12b0ecc085dc7" => :yosemite
    sha256 "7bff88a3512ff2d28846b89b89f1cfd130e5934f1f6301d36e66ccc26b896281" => :mavericks
  end

  depends_on "libvorbis"
  depends_on "libogg"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
