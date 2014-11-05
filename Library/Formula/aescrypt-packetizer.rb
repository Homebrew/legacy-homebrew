require "formula"

class AescryptPacketizer < Formula
  homepage "https://www.aescrypt.com"
  url "https://www.aescrypt.com/download/v3/linux/aescrypt-3.0.9.tgz"
  sha256 "3f3590f9b7e50039611ba9c0cf1cae1b188a44bd39cfc41553db7ec5709c0882"

  bottle do
    cellar :any
    sha1 "9332b85915d37899948db1d69c2703baba61e50e" => :yosemite
    sha1 "a0bff6bff8e0476badc312dabdb6a936f8ed6507" => :mavericks
    sha1 "2b9d8e775d1abf5bdf5ad0ba9a948deb498bdcf2" => :mountain_lion
  end

  head do
    url "https://github.com/paulej/AESCrypt.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on :xcode => :build

  option "with-default-names", "Build with the binaries named as expected upstream"

  def install
    if build.head?
      cd "linux"
      system "autoreconf", "-ivf"
      system "./configure", "prefix=#{prefix}", "--enable-iconv",
              "--disable-gui"
      system "make", "install"
    end

    if build.stable?
      cd "src"
      # https://www.aescrypt.com/mac_aes_crypt.html
      inreplace "Makefile", "#LIBS=-liconv", "LIBS=-liconv"
      system "make", "prefix=#{prefix}"

      bin.install "aescrypt"
      bin.install "aescrypt_keygen"
    end

    # To prevent conflict with our other aescrypt, rename the binaries.
    if build.without? "default-names"
      mv "#{bin}/aescrypt", "#{bin}/paescrypt"
      mv "#{bin}/aescrypt_keygen", "#{bin}/paescrypt_keygen"
    end
  end

  def caveats; <<-EOS.undent
    To avoid conflicting with our other AESCrypt package the binaries
    have been renamed paescrypt and paescrypt_keygen, unless you chose
    to exercise the default-names option.
    EOS
  end

  test do
    path = testpath/"secret.txt"
    original_contents = "What grows when it eats, but dies when it drinks?"
    path.write original_contents

    system bin/"paescrypt", "-e", "-p", "fire", path
    assert File.exist?("#{path}.aes")

    system bin/"paescrypt", "-d", "-p", "fire", "#{path}.aes"
    assert_equal original_contents, path.read
  end
end
