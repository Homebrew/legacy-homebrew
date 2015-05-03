class GroongaNormalizerMysql < Formula
  homepage "https://github.com/groonga/groonga-normalizer-mysql"
  url "http://packages.groonga.org/source/groonga-normalizer-mysql/groonga-normalizer-mysql-1.0.9.tar.gz"
  sha1 "9057570c1f0e3b5974bf7ac58877af8971ef2a25"

  bottle do
    cellar :any
    sha256 "f418a3ff019b68959cd9da98b406a39c0e0d2a90e75d6f86ecd717b7c9ae4a67" => :yosemite
    sha256 "80cc94cbb3158e9459a5c95b274154f0e4d10ee9e6c73a17029b18ddf0b22df5" => :mavericks
    sha256 "7de3a15fd4120aa918222be1613757642f4f427f4e98b782be59af427f40b994" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
