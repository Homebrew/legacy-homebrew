class Procmail < Formula
  desc "Autonomous mail processor"
  homepage "http://www.procmail.org"
  # Note the use of the patched version from Apple
  url "https://opensource.apple.com/tarballs/procmail/procmail-14.tar.gz"
  sha256 "f3bd815d82bb70625f2ae135df65769c31dd94b320377f0067cd3c2eab968e81"

  bottle do
    cellar :any_skip_relocation
    sha256 "3328bcda4649612afba606950e59f4cb0c22e10fe97a4f1e38f190e3e4115800" => :el_capitan
    sha256 "cd5a5cdfbe9d03067533df0ef3f09cc2c05bd16a9b75d2d19cd9c2d1da2986e5" => :yosemite
    sha256 "9e476567851a38caedbbb894afb83d3f5575bb494aaab296f884387feca9bf54" => :mavericks
  end

  keg_only :provided_pre_el_capitan

  def install
    system "make", "-C", "procmail", "BASENAME=#{prefix}", "MANDIR=#{man}",
           "LOCKINGTEST=1", "install"
  end

  test do
    path = testpath/"test.mail"
    path.write <<-EOS.undent
      From alice@example.net Tue Sep 15 15:33:41 2015
      Date: Tue, 15 Sep 2015 15:33:41 +0200
      From: Alice <alice@example.net>
      To: Bob <bob@example.net>
      Subject: Test

      please ignore
    EOS
    assert_match /Subject: Test/, shell_output("#{bin}/formail -X 'Subject' < #{path}")
    assert_match /please ignore/, shell_output("#{bin}/formail -I '' < #{path}")
  end
end
