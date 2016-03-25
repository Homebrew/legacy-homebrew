class Sratom < Formula
  desc "Library for serializing LV2 atoms to/from RDF"
  homepage "https://drobilla.net/software/sratom/"
  url "https://download.drobilla.net/sratom-0.4.6.tar.bz2"
  sha256 "a4b9beaeaedc4f651beb15cd1cfedff905b0726a9010548483475ad97d941220"

  bottle do
    cellar :any
    revision 1
    sha256 "55a2eb57141d5fa5589206b94113a873df38e298c32b18e135ab689ad209b188" => :el_capitan
    sha256 "91f3cd1331e6502639eb51755e60581372aaf34944dd4ba4f8884724aae40e1e" => :yosemite
    sha256 "035d8d79e3ab88f3ae991690d0f1ede056237a3666022436af7355d739b9a635" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
