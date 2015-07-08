require 'formula'

class Qjson < Formula
  desc "Map JSON to QVariant objects"
  homepage 'http://qjson.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/qjson/qjson/0.8.1/qjson-0.8.1.tar.bz2'
  sha1 '197ccfd533f17bcf40428e68a82e6622047ed4ab'

  bottle do
    revision 1
    sha1 "22ac2eb6b1345cc6a7a61223be8dae6c90493f66" => :yosemite
    sha1 "2c037b5df8551e2c63341a60609c5b97ab7c4b05" => :mavericks
    sha1 "b34c75bb1e7fc1a7535b71a26b0736c10cef9f59" => :mountain_lion
  end

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
