class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "http://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.25.tar.gz"
  mirror "https://fossies.org/unix/misc/file-5.25.tar.gz"
  sha256 "3735381563f69fb4239470b8c51b876a80425348b8285a7cded8b61d6b890eca"

  bottle do
    sha256 "dcc196fd6609ba1ed5fdd3949959c82a827ccf7762b861993e8f11c26b1eb015" => :el_capitan
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
