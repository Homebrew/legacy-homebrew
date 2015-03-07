class Libmagic < Formula
  homepage "http://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.22.tar.gz"
  mirror "https://fossies.org/unix/misc/file-5.22.tar.gz"
  sha1 "20fa06592291555f2b478ea2fb70b53e9e8d1f7c"

  bottle do
    sha1 "2a725b5f45d5c534ac59cfee87fde8b09e7f764f" => :yosemite
    sha1 "2e493cfb219635780b4cf01a05c23dc60a6806cb" => :mavericks
    sha1 "f626fc50838bc8d3be6e57a79e6f977b2d7c64c2" => :mountain_lion
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
