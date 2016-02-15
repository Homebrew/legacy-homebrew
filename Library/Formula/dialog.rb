class Dialog < Formula
  desc "Display user-friendly dialog boxes from shell scripts"
  homepage "http://invisible-island.net/dialog/"
  url "ftp://invisible-island.net/dialog/dialog-1.2-20150920.tgz"
  mirror "https://fossies.org/linux/misc/dialog-1.2-20150920.tgz"
  sha256 "c4e61ec5768701683dd4b5b2ebd8a31e6289fa6a1f5801e4b481085650698c05"

  bottle do
    cellar :any_skip_relocation
    sha256 "55b3ceefe3e40753bef32aa50eeb017a548fbd686f104bda43fdd9319a4b26f5" => :el_capitan
    sha256 "6fb28b3fb4dad7eb14a3106018d49c0f2e8041b3959be4e1ed2d479fc68fd7eb" => :yosemite
    sha256 "5b4054f6c85a7a166a6b251a8fa6f2ce83d78fbd32d651fe024ed847af461714" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install-full"
  end
end
