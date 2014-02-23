require 'formula'

class Yajl < Formula
  homepage 'http://lloyd.github.io/yajl/'
  url 'https://github.com/lloyd/yajl/archive/2.0.4.tar.gz'
  sha256 '0e78f516dc53ecce7dc073f9a9bb0343186b58ef29dcd1dad74e5e853b216dd5'

  bottle do
    sha1 "a02d27cc6b98912176bd636ee30aaca464a44ae8" => :mavericks
    sha1 "1d8cec340ef78502d9e726a96c416c20ee7e85e1" => :mountain_lion
    sha1 "1e7bbbf4f37b9a251c430b2438f3449cc62d5903" => :lion
  end

  # Configure uses cmake internally
  depends_on 'cmake' => :build

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"
    system "make install"
    (include/'yajl').install Dir['src/api/*.h']
  end
end
