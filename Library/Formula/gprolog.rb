require 'formula'

class Gprolog <Formula
  url 'http://www.gprolog.org/gprolog-1.3.1.tar.gz'
  homepage 'http://www.gprolog.org/'
  md5 'cbae19c31e17bcfca4b57fe35ec4aba2'

  def skip_clean? path; true; end

  def install
    # make won't run in parallel
    ENV.j1
    
    Dir.chdir 'src' do
      system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
      system "make"
      system "make install-strip"
    end
  end
end
