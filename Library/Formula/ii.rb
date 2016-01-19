class Ii < Formula
  desc "Minimalist IRC client"
  homepage "http://tools.suckless.org/ii"
  url "http://dl.suckless.org/tools/ii-1.7.tar.gz"
  sha256 "3a72ac6606d5560b625c062c71f135820e2214fed098e6d624fc40632dc7cc9c"

  bottle do
    cellar :any
    sha256 "47979e50757886d87bf0c76d859753f5c327f455fb92fa6c58c88fd41a2fcbf6" => :mavericks
    sha256 "312b5a5d399face7fb7cbc7c0e269a6346c4382c5340a7154a21483548b0c36b" => :mountain_lion
    sha256 "863d660d2338446d16825b73fdb61c35ab0976b1a47441da516d09c691bc575f" => :lion
  end

  head "http://git.suckless.org/ii", :using => :git

  def install
    inreplace "config.mk" do |s|
      s.gsub! "/usr/local", prefix
      s.gsub! "cc", ENV.cc
    end
    system "make", "install"
  end
end
