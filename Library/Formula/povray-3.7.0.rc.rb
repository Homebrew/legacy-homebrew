require 'formula'

class Povray370Rc < Formula
  homepage 'http://www.povray.org'
  url 'http://www.povray.org/redirect/www.povray.org/beta/source/povray-3.7.0.RC4.tar.gz'
  md5 'e87ea16c3e3f46bef01a9a20a079c57d'

  depends_on 'boost'   => :build
  depends_on 'libtiff' => :optional
  depends_on 'jpeg'    => :optional
  depends_on 'openexr' => :optional

  def install
    ENV.x11  # For libpng
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-boost-thread=boost_thread-mt",
                          "COMPILED_BY=homebrew",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end

  def test
    ohai "Rendering all test scenes; this may take a while"
    mktemp do
      system "#{share}/povray-3.6/scripts/allscene.sh -o ."
    end  
  end
end

