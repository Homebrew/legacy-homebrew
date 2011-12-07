require 'formula'

class MoonBuggy < Formula
  url 'http://m.seehuhn.de/programs/moon-buggy-1.0.tar.gz'
  homepage 'http://www.seehuhn.de/pages/moon-buggy'
  md5 '4da97ea40eca686f6f8b164d8b927e38'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    system "moon-buggy"
  end
end
