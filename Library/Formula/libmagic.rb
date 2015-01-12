class Libmagic < Formula
  homepage "http://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.22.tar.gz"
  mirror "https://fossies.org/unix/misc/file-5.22.tar.gz"
  sha1 "20fa06592291555f2b478ea2fb70b53e9e8d1f7c"

  bottle do
    revision 2
    sha1 "ecfd27c64c9e35bb4411931ec6638b350de353a3" => :yosemite
    sha1 "1b39fac95723524d2f413ee9239cc57ae8404d5d" => :mavericks
    sha1 "df255124f0a0460480380bc3c0d7ec4cc99896b3" => :mountain_lion
  end

  option :universal

  depends_on :python => :optional

  def install
    ENV.universal_binary if build.universal?

    # Clean up "src/magic.h" as per http://bugs.gw.com/view.php?id=330
    rm "src/magic.h"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5"
    system "make", "install"

    if build.with? "python"
      cd "python" do
        system "python", *Language::Python.setup_install_args(prefix)
      end
    end

    # Don't dupe this system utility
    rm bin/"file"
    rm man1/"file.1"
  end
end
