class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "http://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.23.tar.gz"
  mirror "https://fossies.org/unix/misc/file-5.23.tar.gz"
  sha256 "2c8ab3ff143e2cdfb5ecee381752f80a79e0b4cfe9ca4cc6e1c3e5ec15e6157c"

  bottle do
    sha256 "59bb0f198492cab776647823b467b60a25c851fe5f03c06de15dfec008c38827" => :yosemite
    sha256 "073b5db84f8b641c0e6d2f8ff8caca751e42e8cfc0c31d60ec42863e3afd4ea4" => :mavericks
    sha256 "a613459fd15e1a648ecc9179e398ee1de76ea56d72fcfc902fd441683b1ea8b3" => :mountain_lion
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
