class Pwsafe < Formula
  desc "Generate passwords and manage encrypted password databases"
  homepage "http://nsd.dyndns.org/pwsafe/"
  url "http://nsd.dyndns.org/pwsafe/releases/pwsafe-0.2.0.tar.gz"
  sha256 "61e91dc5114fe014a49afabd574eda5ff49b36c81a6d492c03fcb10ba6af47b7"
  revision 1

  bottle do
    cellar :any
    sha256 "3484c4e83315adbbdf77155e2af0e1d41a4d3a99d9769e0f7c1520195d2a1a47" => :yosemite
    sha256 "3143d04abfb5df939c94d008bc6ccc716d3dec530572433c17ce665c52c37b8c" => :mavericks
    sha256 "e4537a372cb1f6e17d005fb8b2f73fad576722832058ad514bcf4fa7e0112e41" => :mountain_lion
  end

  depends_on "openssl"
  depends_on "readline"

  # A password database for testing is provided upstream. How nice!
  resource "test-pwsafe-db" do
    url "http://nsd.dyndns.org/pwsafe/test.dat"
    sha256 "7ecff955871e6e58e55e0794d21dfdea44a962ff5925c2cd0683875667fbcc79"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    test_db_passphrase = "abc"
    test_account_name = "testing"
    test_account_pass = "sg1rIWHL?WTOV=d#q~DmxiQq%_j-$f__U7EU"

    resource("test-pwsafe-db").stage do
      Utils.popen(
        "#{bin}/pwsafe -f test.dat -p #{test_account_name}", "r+"
      ) do |pipe|
        pipe.puts test_db_passphrase
        assert_match(/^#{Regexp.escape(test_account_pass)}$/, pipe.read)
      end
    end
  end
end
