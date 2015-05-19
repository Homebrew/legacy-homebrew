require 'formula'

class BerkeleyDb < Formula
  desc "High performance key/value database"
  homepage 'http://www.oracle.com/technology/products/berkeley-db/index.html'
  url 'http://download.oracle.com/berkeley-db/db-6.1.19.tar.gz'
  sha1 'e266f8ab73f4f1ea276d203ce85426e5a6831501'

  bottle do
    cellar :any
    sha1 "1e80c66e55a970b39829cc98e41f3252557d3736" => :yosemite
    sha1 "296738e8b7d2d23fafc19f3eaad6693e18bab05d" => :mavericks
    sha1 "9573e87c5c4a5bf39f89b712c59b5329cb7c0b41" => :mountain_lion
  end

  option 'with-java', 'Compile with Java support.'
  option 'enable-sql', 'Compile with SQL support.'

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize
    # --enable-compat185 is necessary because our build shadows
    # the system berkeley db 1.x
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-cxx
      --enable-compat185
    ]
    args << "--enable-java" if build.with? "java"
    args << "--enable-sql" if build.include? "enable-sql"

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    cd 'build_unix' do
      system "../dist/configure", *args
      system "make install"

      # use the standard docs location
      doc.parent.mkpath
      mv prefix/'docs', doc
    end
  end
end
