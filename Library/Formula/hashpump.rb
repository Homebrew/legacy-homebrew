require "formula"

class Hashpump < Formula
  homepage "https://github.com/bwall/HashPump"
  url "https://github.com/bwall/HashPump/archive/v1.0.2.tar.gz"
  sha1 "5496ee37298c65b4c72139a039e78e4ff3a060b2"

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
