require 'formula'

class Pbzip2 <Formula
  url 'http://compression.ca/pbzip2/pbzip2-1.0.5.tar.gz'
  homepage 'http://compression.ca/pbzip2/'
  md5 'e2448d22ee29d1e6549ac58b98df11ab'

  def install
    # Won't compile with LLVM
    ENV.gcc_4_2
    
    inreplace "Makefile" do |s|
      s.change_make_var! 'PREFIX', prefix
      s.gsub! "/man/", "/share/man/"
      
      # Per fink and macport:
      s.gsub! "-pthread -lpthread", ""
    end
    
    system "make install"
  end
end
