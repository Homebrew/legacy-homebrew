class Mdbm < Formula
  desc "super-fast memory-mapped key/value store."
  homepage "http://yahooeng.tumblr.com/post/104861108931/mdbm-high-speed-database"
  url "https://github.com/yahoo/mdbm/archive/v4.12.3.tar.gz"
  sha256 "1bdd27696980b8234893f2c7bfbd0d1ad5c06ccdb1eb91bcf053db27c61eea26"

  depends_on "coreutils"
  depends_on "cppunit"
  depends_on "readline"
  depends_on "openssl"

  def install
    ENV.delete "CC"
    ENV.delete "CXX"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mdbm = "/tmp/test-brew.mdbm"
    system "mdbm_create", mdbm
    assert File.exist? mdbm
  end
end
