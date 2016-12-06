require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Openresty < Formula
  homepage 'http://openresty.org/'
  url 'http://agentzh.org/misc/nginx/ngx_openresty-1.2.3.8.tar.gz'
  version '1.2.3.8'
  sha1 '44ec3efe344c515041a1aa272e70223020c47ff9'

  devel do
    url 'http://agentzh.org/misc/nginx/ngx_openresty-1.2.4.3.tar.gz'
    version '1.2.4.3'
    sha1 '4b4af674a2d33751919cfdde861cd6093c25c77e'
  end

  env :userpaths

  depends_on 'pcre'

  def install
    args = ["--with-cc-opt=-I#{HOMEBREW_PREFIX}/include",
            "--with-ld-opt=-L#{HOMEBREW_PREFIX}/lib",
            "--with-luajit"]

    system "./configure", *args
    system "make"
    system "make install"
  end
end
