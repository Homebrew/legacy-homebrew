
class CernNdiff < Formula
  desc "Numerical diff tool"
  # Note: ndiff is a sub-project of Mad-X at the moment..
  homepage "http://cern.ch/mad"
  url "http://svn.cern.ch/guest/madx/tags/5.02.08/madX/tools/numdiff"
  version "5.02.08"
  head "http://svn.cern.ch/guest/madx/trunk/madX/tools/numdiff"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
