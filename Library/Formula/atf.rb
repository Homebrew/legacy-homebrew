class Atf < Formula
  desc "ATF: Automated Testing Framework"
  homepage "https://github.com/jmmv/atf"
  url "https://github.com/jmmv/atf/releases/download/atf-0.21/atf-0.21.tar.gz"
  sha256 "92bc64180135eea8fe84c91c9f894e678767764f6dbc8482021d4dde09857505"

  bottle do
    sha256 "74493d4b4868628a7a84338eb28ecfce8afdd896962f3ba632b1e785def48737" => :el_capitan
    sha256 "e4caa0498d0caf2e99e0eea9ae9269240e4f4a49a41f712cf6a730fab8d72672" => :yosemite
    sha256 "240443a1a96ba8ed51ac7b263749f69013f05d42eb84018824791e419a6d5e81" => :mavericks
    sha256 "be1a15d142717902889cf540f02641c34fd3241a369bf25f1c9c31197f04dccf" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make"
    ENV.j1
    system "make", "install"
  end
end
