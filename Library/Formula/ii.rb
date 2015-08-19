class Ii < Formula
  desc "Minimalist IRC client"
  homepage "http://tools.suckless.org/ii"
  url "http://dl.suckless.org/tools/ii-1.7.tar.gz"
  sha256 "3a72ac6606d5560b625c062c71f135820e2214fed098e6d624fc40632dc7cc9c"

  bottle do
    cellar :any
    sha1 "de99aa533e552f3d95d3139c0a933b5cdf2eb207" => :mavericks
    sha1 "1a22188f373828e5738fcd1dfc981402384321df" => :mountain_lion
    sha1 "9f66c3d6465cb6b2c20a913926398b84ba4d2bb2" => :lion
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
