require 'formula'

class Geos < Formula
  url 'http://download.osgeo.org/geos/geos-3.3.0.tar.bz2'
  homepage 'http://trac.osgeo.org/geos/'
  md5 '3301f3d1d747b95749384b8a356b022a'
  
  depends_on 'swig1' if ARGV.include? '--enable-ruby'
  
  def skip_clean? path
    path.extname == '.la'
  end
  
  def options
    [
      ['--enable-ruby', "Enable Ruby Swig Bindings"]
    ]
  end

  fails_with_llvm "Some symbols are missing during link step."

  def install
    ENV.O3
    args = ["--prefix=#{prefix}", "--disable-dependency-tracking"]
    if ARGV.include? '--enable-ruby'
      args << "--enable-ruby" 
      ohai "Building geos with ruby bindings."
    end
    system "./configure",  *args
    system "make install"
    if ARGV.include? '--enable-ruby'
      opoo "You will need to locate the geos.so library in your site_ruby and symlink it to geos.bundle, e.g. cd ~/.rvm/rubies/ruby-1.8.7-p352/lib/ruby/site_ruby/1.8/i686-darwin11.1.0/ and ln -s geos.so geos.bundle"
    end
    
  end
end