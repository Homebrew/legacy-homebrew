class Cppunit < Formula
  desc "Unit testing framework for C++"
  homepage "https://wiki.freedesktop.org/www/Software/cppunit/"
  url "http://dev-www.libreoffice.org/src/cppunit-1.13.2.tar.gz"
  sha256 "3f47d246e3346f2ba4d7c9e882db3ad9ebd3fcbd2e8b732f946e0e3eeb9f429f"

  bottle do
    cellar :any
    revision 1
    sha256 "27730fdd237f61dd3698e422edab55246d657f15fcbb73999d8b35087e3cb3c8" => :el_capitan
    sha256 "235b62030002ef0c7c84c4989ac0ca3401c96929053e0095a605660b30aa9eba" => :yosemite
    sha256 "f66998bbde3f7c3ca32f3a99c35177cd80ff8f6583ec63627d7526455a503214" => :mavericks
    sha256 "0494ee4b157acec4c86c4d26a2c1155e71e11e5dc3a897ae1888a3da4edbb21f" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
