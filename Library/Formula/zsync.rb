class Zsync < Formula
  desc "File transfer program"
  homepage "http://zsync.moria.org.uk/"
  url "http://zsync.moria.org.uk/download/zsync-0.6.2.tar.bz2"
  sha256 "0b9d53433387aa4f04634a6c63a5efa8203070f2298af72a705f9be3dda65af2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    touch "#{testpath}/foo"
    system "#{bin}/zsyncmake", "foo"
    sha1 = "da39a3ee5e6b4b0d3255bfef95601890afd80709"
    File.read("#{testpath}/foo.zsync") =~ /^SHA-1: #{sha1}$/
  end
end
