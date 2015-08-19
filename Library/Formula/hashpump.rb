class Hashpump < Formula
  desc "Tool to exploit hash length extension attack"
  homepage "https://github.com/bwall/HashPump"
  url "https://github.com/bwall/HashPump/archive/v1.2.0.tar.gz"
  sha256 "d002e24541c6604e5243e5325ef152e65f9fcd00168a9fa7a06ad130e28b811b"

  bottle do
    cellar :any
    revision 1
    sha256 "8b33f44272b46174184639f3a6044f47151756039068343262d3e2cbe4a26a7c" => :yosemite
    sha256 "667650946f6e697657832f9f906f3a548bc55991e2422f8cbbbe7c793434111f" => :mavericks
    sha256 "a776ebf2d22d7b5fa492308fff20409696064ea70149c5cac695b75bcf004d7c" => :mountain_lion
  end

  option "without-python", "Build without python 2 support"

  depends_on "openssl"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional

  # Remove on next release
  patch do
    url "https://patch-diff.githubusercontent.com/raw/bwall/HashPump/pull/14.diff"
    sha256 "47236fed281000726942740002e44ef8bb90b05f55b2e7deeb183d9f708906c1"
  end

  def install
    bin.mkpath
    system "make", "INSTALLLOCATION=#{bin}",
                   "CXX=#{ENV.cxx}",
                   "install"

    Language::Python.each_python(build) do |python, _version|
      system python, *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    output = %x(#{bin}/hashpump -s '6d5f807e23db210bc254a28be2d6759a0f5f5d99' \\
      -d 'count=10&lat=37.351&user_id=1&long=-119.827&waffle=eggo' \\
      -a '&waffle=liege' -k 14)
    assert output.include? "0e41270260895979317fff3898ab85668953aaa2"
    assert output.include? "&waffle=liege"
    assert_equal 0, $?.exitstatus
  end
end
