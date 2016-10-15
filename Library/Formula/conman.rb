class Conman < Formula
  desc "ConMan: The Console Manager"
  homepage "https://github.com/dun/conman"
  url "https://github.com/dun/conman/archive/conman-0.2.7.tar.gz"
  sha256 "bf96dfbb05e1592355bab3afda4fcb4766a57bca8bc98eb1dd5020f24039d39f"

  depends_on :x11 => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/conman", "-V"
    system "#{sbin}/conmand", "-V"

    ENV["DISPLAY"] = "/dev/null"  # set bogus DISPLAY to fake x11 support
    system "#{bin}/conmen", "-V"
  end
end
