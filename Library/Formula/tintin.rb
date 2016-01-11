class Tintin < Formula
  desc "MUD client"
  homepage "http://tintin.sf.net"
  url "https://downloads.sourceforge.net/project/tintin/TinTin%2B%2B%20Source%20Code/2.01.0/tintin-2.01.0.tar.gz"
  sha256 "e0e35463a97ee5b33ef0b29b2c57fa8276c4e76328cb19c98a6ea92c603a9c76"

  depends_on "pcre"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "CFLAGS=#{ENV.cflags}",
                     "INCS=#{ENV.cppflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
    end
  end
end
