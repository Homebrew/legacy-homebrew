require 'formula'

class JsonSpirit < Formula
  homepage 'http://www.codeproject.com/KB/recipes/JSON_Spirit.aspx'
  url 'https://uwe-arzt.de/files/json_spirit_v4.04.zip'
  md5 '0729870198528a28c21c5ee588d032a4'

  depends_on 'boost'
  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
