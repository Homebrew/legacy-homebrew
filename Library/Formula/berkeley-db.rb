require 'formula'

class BerkeleyDb < Formula
  homepage 'http://www.oracle.com/technology/products/berkeley-db/index.html'
  url 'http://download.oracle.com/berkeley-db/db-5.3.21.tar.gz'
  sha1 '32e43c4898c8996750c958a90c174bd116fcba83'

  option 'without-java', 'Compile without Java support.'

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize

    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--mandir=#{man}",
            "--enable-cxx"]
    args << "--enable-java" unless build.include? "without-java"

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    cd 'build_unix' do
      system "../dist/configure", *args
      system "make install"

      # use the standard docs location
      doc.parent.mkpath
      mv prefix+'docs', doc
    end
  end
end
