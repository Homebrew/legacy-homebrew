class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "http://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.22.tar.gz"
  mirror "https://fossies.org/unix/misc/file-5.22.tar.gz"
  sha256 "c4e3a8e44cb888c5e4b476e738503e37fb9de3b25a38c143e214bfc12109fc0b"
  revision 1

  bottle do
    sha256 "de4b3746d2a43085e5fde903f79f587d203e3bb6b7880554da3fc1c8d48fac18" => :yosemite
    sha256 "70f2cd35ef919c70ca03daecd11ae89b22f05749aeee23d868f0a6a0a97ae4cc" => :mavericks
    sha256 "de694310a07551fc96f7e285085c708b14e4d8e210878541eadd19e892fa5fd6" => :mountain_lion
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
