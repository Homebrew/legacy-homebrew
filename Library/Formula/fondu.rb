class Fondu < Formula
  desc "Tools to convert between different font formats"
  homepage "http://fondu.sourceforge.net/"
  url "http://fondu.sourceforge.net/fondu_src-060102.tgz"
  sha256 "22bb535d670ebc1766b602d804bebe7e84f907c219734e6a955fcbd414ce5794"

  bottle do
    cellar :any
    sha256 "509d451aa0ccd0d1c2ee24627d61545bbd40bde5bb86d22d5071f0c773a1b829" => :yosemite
    sha256 "cd0be5e8461204a313cda11a243451d94f196f14bc7969ddeaa257ca672c0345" => :mavericks
    sha256 "0f31a728e0e74b6cefb369fa804572a2e6cb00756074183a931fe51e44edfc23" => :mountain_lion
  end

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
