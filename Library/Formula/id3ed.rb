class Id3ed < Formula
  homepage "http://code.fluffytapeworm.com/projects/id3ed"
  url "http://code.fluffytapeworm.com/projects/id3ed/id3ed-1.10.4.tar.gz"
  sha1 "b699e645fcea2fa42658886621eb10531d24008a"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--bindir=#{bin}/",
                          "--mandir=#{man1}"
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    system "#{bin}/id3ed", "-r", "-q", test_fixtures("test.mp3")
  end
end
