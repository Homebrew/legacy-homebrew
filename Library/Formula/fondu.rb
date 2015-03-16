class Fondu < Formula
  homepage "http://fondu.sourceforge.net/"
  url "http://fondu.sourceforge.net/fondu_src-060102.tgz"
  sha256 "22bb535d670ebc1766b602d804bebe7e84f907c219734e6a955fcbd414ce5794"

  resource "cminch.ttf" do
    url "http://mirrors.ctan.org/fonts/cm/ps-type1/bakoma/ttf/cminch.ttf"
    sha256 "03aacbe19eac7d117019b6a6bf05197086f9de1a63cb4140ff830c40efebac63"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--exec-prefix=#{prefix}"
    system "make", "install"
    man1.install Dir["*.1"]
  end

  test do
    resource("cminch.ttf").stage do
      system "#{bin}/ufond", "cminch.ttf"
    end
  end
end
