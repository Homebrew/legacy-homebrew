require 'formula'

class Visitors < Formula
  homepage 'http://www.hping.org/visitors/'
  url 'http://www.hping.org/visitors/visitors-0.7.tar.gz'
  sha1 'cdccdfb82001c7c3dadf68456574cac1a5d941e3'

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
