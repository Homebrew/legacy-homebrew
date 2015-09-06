class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "http://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.24.tar.gz"
  mirror "https://fossies.org/unix/misc/file-5.24.tar.gz"
  sha256 "802cb3de2e49e88ef97cdcb52cd507a0f25458112752e398445cea102bc750ce"

  bottle do
    sha256 "f9a510cd36875ef1ea6d30b96906740a12fda0e372a8f24698eb0aaf5ad15adc" => :yosemite
    sha256 "ff4cd0c366a025d03e31d33d283c4c9ea011099b2d46aad67d03752c21e719d5" => :mavericks
    sha256 "9db86a8978fb0782582e816374e4d11dd7acd609eb88260e197b07e01cdb0031" => :mountain_lion
  end

  option :universal

  depends_on :python => :optional

  def install
    ENV.universal_binary if build.universal?

    # Clean up "src/magic.h" as per http://bugs.gw.com/view.php?id=330
    rm "src/magic.h"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5",
                          "--enable-static"
    system "make", "install"
    (share+"misc/magic").install Dir["magic/Magdir/*"]

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
