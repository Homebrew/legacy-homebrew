require 'formula'

class Q < Formula
  homepage 'https://github.com/harelba/q'
  url 'https://github.com/harelba/q/archive/1.2.0.tar.gz'
  sha1 '5c83cb62a9b24f92fe32ef6a137f83191641ff79'

  def install
    bin.install 'q'
  end

  test do
    IO.popen("#{bin}/q 'select sum(c1) from -'", "w+") do |pipe|
      1.upto(100) { |i| pipe.puts i }
      pipe.close_write
      assert_equal "5050\n", pipe.read
    end
  end
end

