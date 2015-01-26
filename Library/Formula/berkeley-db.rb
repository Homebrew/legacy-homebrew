require 'formula'

class BerkeleyDb < Formula
  homepage 'http://www.oracle.com/technology/products/berkeley-db/index.html'
  url 'http://download.oracle.com/berkeley-db/db-6.1.19.tar.gz'
  sha1 'e266f8ab73f4f1ea276d203ce85426e5a6831501'

  bottle do
    cellar :any
    revision 1
    sha1 "a134b5effaa73fd296b2601180520292c0a6d095" => :yosemite
    sha1 "910660e253bf32a1ce730d4ba27e3090f645f5f6" => :mavericks
    sha1 "aaafa41026335a6b7e6c0792d1511325c79409fa" => :mountain_lion
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
