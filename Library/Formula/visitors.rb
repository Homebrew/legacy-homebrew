class Visitors < Formula
  desc "eb server log analyzer"
  homepage "http://www.hping.org/visitors/"
  url "http://www.hping.org/visitors/visitors-0.7.tar.gz"
  sha256 "d2149e33ffe96b1f52b0587cff65973b0bc0b24ec43cdf072a782c1bd52148ab"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "60d139c48a4d3c8b457462530893ff11c681e512cf707ba6819a783eb17d3c4c" => :el_capitan
    sha256 "2d0a3e1a40e08ae6b4892731b0cd1f3a495e8eba42476630b7863fc057e85df3" => :yosemite
    sha256 "c94f334e326f511b486e4b63b5e62ee7a59121ea5d790a8e5854ff4b57abb5e6" => :mavericks
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
      assert_match(/Different pages requested: 2/, pipe.read)
    end
  end
end
