class Hashpump < Formula
  homepage "https://github.com/bwall/HashPump"
  url "https://github.com/bwall/HashPump/archive/v1.2.0.tar.gz"
  sha256 "d002e24541c6604e5243e5325ef152e65f9fcd00168a9fa7a06ad130e28b811b"

  bottle do
    cellar :any
    sha256 "4f6c7963fec55f5c8cd8ef37771d839551f0def45183f78b4644798c615ab311" => :yosemite
    sha256 "5c5a3868482428e8ccfa12cbc4efad0e7a8027c82fe958106c8eed10310efaa3" => :mavericks
    sha256 "cf4a9cee9d04bef03016073dc0e516e5349861691ad80bae1706cbd846b03920" => :mountain_lion
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

    Language::Python.each_python(build) do |python, version|
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
