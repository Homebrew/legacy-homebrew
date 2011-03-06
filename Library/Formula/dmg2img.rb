require 'formula'

class Dmg2img <Formula
  url 'http://vu1tur.eu.org/tools/dmg2img-1.6.2.tar.gz'
  homepage 'http://vu1tur.eu.org/tools/'
  md5 '296d35daab76d63ff6adad54113a8caa'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "CC", ENV.cc
      s.change_make_var! "BIN_DIR", "#{prefix}/bin"
      
      # remove root permission in install
      s.gsub! /-[og] root/, ''
    end
    system "make install"
  end
end
