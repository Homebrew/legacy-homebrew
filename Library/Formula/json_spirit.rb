require 'formula'

class JsonSpirit < Formula
  homepage 'http://www.codeproject.com/KB/recipes/JSON_Spirit.aspx'
  url 'https://uwe-arzt.de/files/json_spirit_v4.04.zip'
  sha1 '5e92f0b337c43104faaf23f082d4c6763986bdd1'

  depends_on 'boost'
  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
