class Hexedit < Formula
  homepage "http://rigaux.org/hexedit.html"
  url "http://rigaux.org/hexedit-1.2.13.src.tgz"
  sha256 "6a126da30a77f5c0b08038aa7a881d910e3b65d13767fb54c58c983963b88dd7"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/hexedit -h 2>&1", 1)
  end
end
