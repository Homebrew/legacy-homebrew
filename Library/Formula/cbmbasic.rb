require 'formula'

class Cbmbasic < Formula
  url 'http://downloads.sourceforge.net/project/cbmbasic/cbmbasic/1.0/cbmbasic-1.0.tgz'
  homepage 'http://cbmbasic.sourceforge.net/'
  md5 '966cf93950809c3eace244af702cf895'

  def install
    inreplace 'Makefile' do |s|
      s.remove_make_var! %w[CFLAGS LDFLAGS]
    end
    system "make"
    bin.install('cbmbasic')
  end

  def test
    system 'echo "PRINT 1" | cbmbasic'
  end
end
