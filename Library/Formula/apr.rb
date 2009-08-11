require 'brewkit'

class AprUtil <Formula
  @url='http://www.mirrorservice.org/sites/ftp.apache.org/apr/apr-util-1.3.9.tar.bz2'
  @md5='29dd557f7bd891fc2bfdffcfa081db59'
end

class Apr <Formula
  @url='http://www.mirrorservice.org/sites/ftp.apache.org/apr/apr-1.3.8.tar.bz2'
  @homepage='http://apr.apache.org'
  @md5='3c7e3a39ae3d3573f49cb74e2dbf87a2'

  def install
    ENV.j1
    system "./configure --prefix=#{prefix} --disable-debug --disable-dependency-tracking"
    system "make install"

    AprUtil.new.brew do
      system "./configure", "--prefix=#{prefix}",
                            "--disable-debug",
                            "--disable-dependency-tracking",
                            "--with-apr=#{bin}/apr-1-config"
      system "make install"
    end

    (prefix+'build-1').rmtree # wtf?
  end
end
