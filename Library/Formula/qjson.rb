require 'formula'

class Qjson < Formula
  homepage 'http://qjson.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/qjson/qjson/0.8.1/qjson-0.8.1.tar.bz2'
  sha1 '197ccfd533f17bcf40428e68a82e6622047ed4ab'

  bottle do
    sha1 "9eb8055dad625eaa891174a238dc0eb1fff512b3" => :mavericks
    sha1 "8fa1ef5afd2fdc3014ab8fead413c28b4f089e86" => :mountain_lion
    sha1 "be53c5f7623ea12749bae405766a33231b940abf" => :lion
  end

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
