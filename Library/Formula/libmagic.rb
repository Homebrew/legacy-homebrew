require 'formula'

class Libmagic < Formula
  homepage 'http://www.darwinsys.com/file/'
  url 'ftp://ftp.astron.com/pub/file/file-5.21.tar.gz'
  mirror 'http://fossies.org/unix/misc/file-5.21.tar.gz'
  sha1 '9836603b75dde99664364b0e7a8b5492461ac0fe'

  bottle do
    sha1 "48f5a8481f904c30569972982ca9b1a582fe64c2" => :yosemite
    sha1 "f0070fd9530f58bae35bb46d08cc8ac9b81a4397" => :mavericks
    sha1 "1d3122c63a3cc529722b92d6e9280b329d98f6af" => :mountain_lion
  end

  option :universal

  depends_on :python => :optional

  # Patch applied upstream, should be in 5.22
  # See http://bugs.gw.com/view.php?id=230
  patch do
    url "https://github.com/file/file/commit/f79e16aebe701fdb8e821c3c1f3504568d0c10f5.diff"
    sha1 "7dcbf309bf013c11a6c5367bab8834050d762bd5"
  end

  def install
    ENV.universal_binary if build.universal?

    # Clean up "src/magic.h" as per http://bugs.gw.com/view.php?id=330
    rm "src/magic.h"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5"
    system "make install"

    cd "python" do
      system "python", "setup.py", "install", "--prefix=#{prefix}"
    end

    # Don't dupe this system utility
    rm bin/"file"
    rm man1/"file.1"
  end
end
