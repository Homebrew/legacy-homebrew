require 'formula'

class Re2 < Formula
  homepage 'https://code.google.com/p/re2/'
  head 'https://re2.googlecode.com/hg'
  url 'https://re2.googlecode.com/files/re2-20131024.tgz'
  sha1 '90a356fb205c5004cc4f08e45e02994b898b592a'

  def patch
    if MacOS.version >= :mavericks
      [
        "https://gist.github.com/ipfans/7821015/raw/e32a604c6cb23b091de9f8139e7cd503dad08147/re2-mavericks"
      ]
    end

  def install
    if MacOS.version >= :mavericks
      ENV.append "CXXFLAGS", "-std=c++11 -DUSE_CXX0X"
    end
    system "make", "install", "prefix=#{prefix}"
  end
end
