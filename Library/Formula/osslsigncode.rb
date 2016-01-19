class Osslsigncode < Formula
  desc "Authenticode signing of PE(EXE/SYS/DLL/etc), CAB and MSI files"
  homepage "https://sourceforge.net/projects/osslsigncode/"
  url "https://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.7.1.tar.gz"
  sha256 "f9a8cdb38b9c309326764ebc937cba1523a3a751a7ab05df3ecc99d18ae466c9"

  bottle do
    cellar :any
    sha256 "5f3799537630936f8d7954e9ec28f191fff6e1713f6b209aa94b2b665e5eaf88" => :yosemite
    sha256 "59da5261972c8d26f0238c6ea42f5b247489d41e7ce6525c703675a22e260cfa" => :mavericks
    sha256 "49a6dd76e78c82062041e5025ed1e7d71f1c53b51ef0e314a5e6938a07b6e49d" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "openssl"
  depends_on "libgsf" => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
