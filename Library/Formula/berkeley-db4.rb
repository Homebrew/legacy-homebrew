require 'formula'

class BerkeleyDb4 < Formula
  homepage 'http://www.oracle.com/technology/products/berkeley-db/index.html'
  url 'http://download.oracle.com/berkeley-db/db-4.8.30.tar.gz'
  sha1 'ab36c170dda5b2ceaad3915ced96e41c6b7e493c'

  keg_only "BDB 4.8.30 is provided for software that doesn't compile against newer versions."

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize

    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--mandir=#{man}",
            "--enable-cxx"]

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
