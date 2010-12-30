require 'formula'

def use_default_names?
  ARGV.include? '--default-names'
end

class GnuUnits <Formula
  url 'http://ftp.gnu.org/gnu/units/units-1.88.tar.gz'
  homepage 'http://www.gnu.org/software/units/'
  md5 '9b2ee6e7e0e9c62741944cf33fc8a656'
  version '1.88'

  def install
    args = ["--prefix=#{prefix}"]
    args << "--program-prefix=g" unless use_default_names?

    system "./configure", *args 
    system "make install"
    
  end
end
