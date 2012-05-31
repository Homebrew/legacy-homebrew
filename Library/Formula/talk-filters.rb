require 'formula'

class TalkFilters < Formula
  homepage 'http://www.hyperrealm.com/main.php?s=talkfilters'
  url 'http://www.hyperrealm.com/talkfilters/talkfilters-2.3.8.tar.gz'
  md5 'c11c6863a1c246a8d49a80a1168b54c8'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "MKDIR_P=mkdir -p", "install"
  end
end
