require 'formula'

class BerkeleyDb <Formula
  @url='http://download.oracle.com/berkeley-db/db-4.8.24.tar.gz'
  @homepage='http://www.oracle.com/technology/products/berkeley-db/index.html'
  @md5='147afdecf438ff99ade105a5272db158'

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
