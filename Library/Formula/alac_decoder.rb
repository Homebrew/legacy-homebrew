require 'formula'

class AlacDecoder < Formula
  homepage 'http://craz.net/programs/itunes/alac.html'
  url 'http://craz.net/programs/itunes/files/alac_decoder-0.2.0.tgz'
  md5 'cec75c35f010d36e7bed91935b57f2d1'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "CFLAGS", '-Os -W -Wall'
      s.change_make_var! "CC", ENV.cc
    end
    system "make"
    bin.install('alac')
  end
end
