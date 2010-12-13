require 'formula'

class Picoc <Formula
  url 'http://picoc.googlecode.com/files/picoc-1.0.tar.bz2'
  homepage 'http://code.google.com/p/picoc/'
  md5 '7af179f5f9351228df8a34ed7add436a'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! 'CC', ENV['CC']
      s.change_make_var! 'CFLAGS', ENV['CFLAGS'] + ' -DUNIX_HOST'
    end

    system "make"
    bin.install "picoc"
  end
end
