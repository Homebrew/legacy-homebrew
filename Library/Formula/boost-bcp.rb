require "formula"

class BoostBcp < Formula
  homepage "http://www.boost.org/doc/tools/bcp/"
  url "https://downloads.sourceforge.net/project/boost/boost/1.57.0/boost_1_57_0.tar.bz2"
  sha1 "e151557ae47afd1b43dc3fac46f8b04a8fe51c12"

  head "http://svn.boost.org/svn/boost/trunk/"

  depends_on "boost-build" => :build

  def install
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end
end
