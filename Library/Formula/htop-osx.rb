require 'formula'

class HtopOsx < Formula
  url 'https://github.com/max-horvath/htop-osx/tarball/0.8.2.1-2012-04-18'
  homepage 'https://github.com/max-horvath/htop-osx'
  md5 'c1e91e6afe98ec124dab12f420c855da'

  depends_on "automake" => :build if MacOS.xcode_version.to_f >= 4.3

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install", "DEFAULT_INCLUDES='-iquote .'"
  end
end
