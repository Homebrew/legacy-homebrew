require 'formula'

class Q < Formula
  homepage 'https://github.com/harelba/q'
  url 'https://github.com/harelba/q/archive/1.4.0.tar.gz'
  sha1 'e8efe87aa691a7ab57e95f15cf4b2babfbabe945'

  def install
    bin.install 'bin/q'
  end

  test do
    IO.popen("#{bin}/q 'select sum(c1) from -'", "w+") do |pipe|
      1.upto(100) { |i| pipe.puts i }
      pipe.close_write
      assert_equal "5050\n", pipe.read
    end
  end
end

