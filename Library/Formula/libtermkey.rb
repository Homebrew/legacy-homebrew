require 'formula'

class Libtermkey < Formula
  url 'http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.8.tar.gz'
  homepage 'http://www.leonerd.org.uk/code/libtermkey/'
  md5 '802616eec246e983fc31462afa9d92cf'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "PREFIX", prefix
      # Check if this is needed for newer versions
      s.change_make_var! "LIBTOOL", "glibtool"
    end
    system "make"
    system "make install"
  end
end
