require 'formula'

class Libtermkey < Formula
  url 'http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.13.tar.gz'
  homepage 'http://www.leonerd.org.uk/code/libtermkey/'
  md5 'f3bd5912c7a0d9b3eede126528c25665'

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
