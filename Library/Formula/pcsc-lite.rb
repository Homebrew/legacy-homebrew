class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.alioth.debian.org"
  url "https://alioth.debian.org/frs/download.php/file/4138/pcsc-lite-1.8.14.tar.bz2"
  sha256 "b91f97806042315a41f005e69529cb968621f73f2ddfbd1380111a175b02334e"
  revision 1

  bottle do
    sha256 "a5262d5c606a27f28e0b77a5c3dbec63953d61f312df7ce13221c8f3beca1138" => :el_capitan
    sha256 "11283901f721da3c928dea443801ddf009370a6145b9abea3c413e60ce84e6a3" => :yosemite
    sha256 "77fe5fbded50874ceed1fde57c9478faaae50042ef4a0086d8c92297e1d8655c" => :mavericks
  end

  keg_only :provided_by_osx,
    "pcsc-lite interferes with detection of OS X's PCSC.framework."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
