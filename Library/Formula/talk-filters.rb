require 'formula'

class TalkFilters < Formula
  homepage 'http://www.hyperrealm.com/main.php?s=talkfilters'
  url 'http://www.hyperrealm.com/talkfilters/talkfilters-2.3.8.tar.gz'
  sha1 '4aafacfe8842889531ad5a37402b06813c32fc64'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "MKDIR_P=mkdir -p", "install"
  end
end
