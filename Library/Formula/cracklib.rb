class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "http://cracklib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cracklib/cracklib/2.9.5/cracklib-2.9.5.tar.gz"
  sha256 "59ab0138bc8cf90cccb8509b6969a024d5e58d2d02bcbdccbb9ba9b88be3fa33"

  bottle do
    cellar :any
    sha256 "1ba8ee5699bf4dde9e728d3138af3b7bd5d6811065cdd2ad9c398dffbd38c30d" => :el_capitan
    sha256 "cdc073935379e4c2e14a5e98c7d16a4a6303d2682b9d77ed8addee555bdd9354" => :yosemite
    sha256 "c974bd4f5515644268c6f9ff13bb392508d6148bc22be8f5fc2da3afe1fa6c89" => :mavericks
    sha256 "3fe3f4737cee1d27465100119dc9f194a985cc8ec1f4a55cecb45d7669c04484" => :mountain_lion
  end

  depends_on "gettext"

  resource "cracklib-words" do
    url "https://downloads.sourceforge.net/project/cracklib/cracklib-words/2008-05-07/cracklib-words-20080507.gz"
    sha256 "e0c7f452c1fd80d551ae4a7d1afa7fa19cbf47c2d6d5dafc1255c1e76502cb71"
  end

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
