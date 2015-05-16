require 'formula'

class Visitors < Formula
  homepage 'http://www.hping.org/visitors/'
  url 'http://www.hping.org/visitors/visitors-0.7.tar.gz'
  sha1 'cdccdfb82001c7c3dadf68456574cac1a5d941e3'

  bottle do
    cellar :any
    sha1 "928de6f2794afa9e0158067ebf008e6389ef91f0" => :mavericks
    sha1 "74a01b10e5eba82754b52c4db7bf03c5f19470f0" => :mountain_lion
    sha1 "af85dc4e113dfc1d54661d7b762c191dca5f8fb9" => :lion
  end

  def install
    system "make"

    # There is no "make install", so do it manually
    bin.install "visitors"
    man1.install "visitors.1"
  end

  test do
    IO.popen("#{bin}/visitors - -o text 2>&1", "w+") do |pipe|
      pipe.puts 'a:80 1.2.3.4 - - [01/Apr/2014:14:28:00 -0400] "GET /1 HTTP/1.1" 200 9 - -'
      pipe.puts 'a:80 1.2.3.4 - - [01/Apr/2014:14:28:01 -0400] "GET /2 HTTP/1.1" 200 9 - -'
      pipe.close_write
      assert pipe.read.include?("Different pages requested: 2")
    end
  end
end
