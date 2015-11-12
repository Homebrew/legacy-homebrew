class GroongaNormalizerMysql < Formula
  desc "MySQL compatible normalizer plugin for Groonga"
  homepage "https://github.com/groonga/groonga-normalizer-mysql"
  url "http://packages.groonga.org/source/groonga-normalizer-mysql/groonga-normalizer-mysql-1.1.0.tar.gz"
  sha256 "525daffdb999b647ce87328ec2e94c004ab59803b00a71ce1afd0b5dfd167116"

  bottle do
    cellar :any
    sha256 "2ea7594e107a452df1122a6c878096b22198f2911ca9d9549e2e0df3a47c32b0" => :yosemite
    sha256 "d38a6d41e21685052716f7b1cdc2d286936d1902b3bdad74385c1f71e5e20130" => :mavericks
    sha256 "67622568e60dfa62be3ac7d480772bfa6c594484f8c4921ee5aa80348e8bd7cf" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
