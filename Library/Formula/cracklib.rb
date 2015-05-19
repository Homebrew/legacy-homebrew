require "formula"

class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "http://cracklib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cracklib/cracklib/2.9.2/cracklib-2.9.2.tar.gz"
  sha1 "a780211a87a284297aa473fe2b50584b842a0e98"

  bottle do
    sha1 "51805becd70c9f2d62c40ab28b5e4a2d041b8b24" => :yosemite
    sha1 "418f78244ce9b7d8ab16bd5869d353981ce9afe7" => :mavericks
    sha1 "eb566f302ca1118f26a9e88aa537bbcf76c088d0" => :mountain_lion
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
  end
end
