class Sratom < Formula
  desc "Library for serializing LV2 atoms to/from RDF"
  homepage "http://drobilla.net/software/sratom/"
  url "http://download.drobilla.net/sratom-0.4.6.tar.bz2"
  sha256 "a4b9beaeaedc4f651beb15cd1cfedff905b0726a9010548483475ad97d941220"

  bottle do
    cellar :any
    sha256 "9023b8427d0e4068c7ca9e9a66a18545c51af3e30fcf9566db74aacceff18d2b" => :yosemite
    sha256 "9720a29b9fc95760edc5d96a36d89fee9a44403e0ce1cbe76fbf4a805c8c9571" => :mavericks
    sha256 "4b2acde2a46119ac0d6ae10a0d161b5f644e507296f44defc036ab311d93cf27" => :mountain_lion
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
