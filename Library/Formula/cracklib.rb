class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "http://cracklib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cracklib/cracklib/2.9.5/cracklib-2.9.5.tar.gz"
  sha256 "59ab0138bc8cf90cccb8509b6969a024d5e58d2d02bcbdccbb9ba9b88be3fa33"

  bottle do
    sha1 "51805becd70c9f2d62c40ab28b5e4a2d041b8b24" => :yosemite
    sha1 "418f78244ce9b7d8ab16bd5869d353981ce9afe7" => :mavericks
    sha1 "eb566f302ca1118f26a9e88aa537bbcf76c088d0" => :mountain_lion
  end

  resource "cracklib-words" do
    url "https://downloads.sourceforge.net/project/cracklib/cracklib-words/2008-05-07/cracklib-words-20080507.gz"
    sha256 "e0c7f452c1fd80d551ae4a7d1afa7fa19cbf47c2d6d5dafc1255c1e76502cb71"
  end

  depends_on "gettext"

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--without-python",
                          "--with-default-dict=#{HOMEBREW_PREFIX}/share/cracklib-words"
    system "make", "install"

    resource("cracklib-words").stage do |r|
      share.install "cracklib-words-#{r.version}" => "cracklib-words"
    end
  end

  def post_install
    system "#{bin}/cracklib-packer < #{share}/cracklib-words"
  end

  test do
    assert_match /password: it is based on a dictionary word/, pipe_output("#{bin}/cracklib-check", "password", 0)
  end
end
