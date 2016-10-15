require "formula"

class Chbspasswd < Formula
  homepage "http://chleggett.github.io/chbspasswd"
  url "https://github.com/chleggett/chbspasswd/releases/download/v0.1.1/chbspasswd-0.1.1.tar.gz"
  sha1 "d911c7ce97b2724fa30f6b092ba7bedec2461aa7"

  def install

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/chbspasswd", "-w 2", "-s .,1", "-b d,1", "-a s,1"
  end
end
