class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "http://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.25.tar.gz"
  mirror "https://fossies.org/unix/misc/file-5.25.tar.gz"
  sha256 "3735381563f69fb4239470b8c51b876a80425348b8285a7cded8b61d6b890eca"

  bottle do
    sha256 "d3a6cdd08087e9b489335a0a8356e2e2fbff451f6a0e6a235fb9e85ad47db7d3" => :el_capitan
    sha256 "e036124db97064c7dba5641c48b427f6932c66caebb5b4f708fe1f7651750483" => :yosemite
    sha256 "11d5a175b69618acfb80aa5832f66afe57c7bb23b9487785ab8512eeedce860e" => :mavericks
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
