class Pth < Formula
  desc "GNU Portable THreads"
  homepage "https://www.gnu.org/software/pth/"
  url "http://ftpmirror.gnu.org/pth/pth-2.0.7.tar.gz"
  mirror "https://ftp.gnu.org/gnu/pth/pth-2.0.7.tar.gz"
  sha256 "72353660c5a2caafd601b20e12e75d865fd88f6cf1a088b306a3963f0bc77232"

  bottle do
    cellar :any
    revision 1
    sha1 "7453010be4970e6ac7a15becaeab7ce324307c9b" => :yosemite
    sha1 "1b5d53c617906cd9417bb462fd5b8c93da3c3f66" => :mavericks
    sha1 "4c286bdadd1d6f3ad49f6df0012f252bbbd8a512" => :mountain_lion
  end

  def install
    ENV.deparallelize

    # Note: shared library will not be build with --disable-debug, so don't add that flag
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/pth-config", "--all"
  end
end
