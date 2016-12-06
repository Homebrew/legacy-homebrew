require 'formula'

class NgxOpenresty < Formula
  url 'http://agentzh.org/misc/nginx/ngx_openresty-1.0.11.28.tar.gz'
  homepage 'openresty.org'
  md5 '003d7a01e348abfd94ebe93978548559'
  
  depends_on 'pcre'
  

  def install
    system "./configure", 
#          "--disable-debug", 
#          "--disable-dependency-tracking",
          "--prefix=#{prefix}",
          "--with-luajit",
          "--with-http_iconv_module",
          "--with-http_drizzle_module"
    # system "cmake . #{std_cmake_parameters}"
    system "make"
    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test ngx_openresty`. Remove this comment before submitting
    # your pull request!
    system "true"
  end
end
