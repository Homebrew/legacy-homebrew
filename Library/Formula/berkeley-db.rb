require 'formula'

class BerkeleyDb <Formula
  @url='http://download.oracle.com/berkeley-db/db-5.0.21.tar.gz'
  @homepage='http://www.oracle.com/technology/products/berkeley-db/index.html'
  @md5='9a749fd2e98fe15840493ddc34cc66d8'

  aka 'db'

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize
    ENV.O3 # takes an hour or more with link time optimisation

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    Dir.chdir 'build_unix' do
      system "../dist/configure", "--disable-debug",
                                  "--prefix=#{prefix}",
                                  "--mandir=#{man}",
                                  "--enable-cxx",
                                  "--enable-java"

      system "make install"

      # use the standard docs location
      doc.parent.mkpath
      mv prefix+'docs', doc
    end
  end
end
