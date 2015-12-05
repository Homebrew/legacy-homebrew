class Visitors < Formula
  desc "eb server log analyzer"
  homepage "http://www.hping.org/visitors/"
  url "http://www.hping.org/visitors/visitors-0.7.tar.gz"
  sha256 "d2149e33ffe96b1f52b0587cff65973b0bc0b24ec43cdf072a782c1bd52148ab"

  bottle do
    cellar :any
    sha256 "fd3a509f025daac959cac9f3e4cb6d6d3b5fdf5983182f44602f10eb7920b1c3" => :mavericks
    sha256 "338234df5fe8c3487bd412adb5ab87dbca45825a0e53f38dd97927eacdd7b93f" => :mountain_lion
    sha256 "33a3eeddc20a421ae83a51b223e2ad4f801374a40bb7cf2947d5635cc08393ec" => :lion
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
