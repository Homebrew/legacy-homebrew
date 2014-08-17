require "formula"

class Hashpump < Formula
  homepage "https://github.com/bwall/HashPump"
  url "https://github.com/bwall/HashPump/archive/v1.1.0.tar.gz"
  sha1 "610582b0e4c86bbcbe5620d4a3ad48e9c3046817"

  def install
    bin.mkpath
    system "make", "INSTALLLOCATION=#{bin}",
                   "CXX=#{ENV.cxx}",
                   "install"
  end

  test do
    output = `#{bin}/hashpump -s '6d5f807e23db210bc254a28be2d6759a0f5f5d99' \\
      -d 'count=10&lat=37.351&user_id=1&long=-119.827&waffle=eggo' \\
      -a '&waffle=liege' -k 14`
    assert output.include? "0e41270260895979317fff3898ab85668953aaa2"
    assert output.include? "&waffle=liege"
    assert_equal 0, $?.exitstatus
  end
end
