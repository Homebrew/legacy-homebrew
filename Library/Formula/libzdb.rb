require 'formula'

class Libzdb < Formula
  homepage 'http://tildeslash.com/libzdb/'
  url 'http://tildeslash.com/libzdb/dist/libzdb-3.0.tar.gz'
  sha1 'bcf14c11cfcd0c05ecc8740f43cd0d6170406dc1'

  bottle do
    cellar :any
    sha1 "0fc6558081d2bdc7afe7b606f8dfff2ea1b6ad2b" => :mavericks
    sha1 "c6b1830eb2d66ae7ff7a14db7ceaf59ca9b5d073" => :mountain_lion
    sha1 "774f7d8719efdde090a409a5ee4772a24ab87fb7" => :lion
  end

  depends_on :postgresql => :recommended
  depends_on :mysql => :recommended
  depends_on 'sqlite' => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--without-postgresql" if build.without? 'postgresql'
    args << "--without-mysql" if build.without? 'mysql'
    args << "--without-sqlite" if build.without? 'sqlite'

    system "./configure", *args
    system "make install"
  end
end
