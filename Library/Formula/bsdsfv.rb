require 'formula'

class Bsdsfv <Formula
  url 'http://sourceforge.net/projects/bsdsfv/files/bsdsfv/1.18/bsdsfv-1.18.tar.gz'
  homepage 'http://bsdsfv.sourceforge.net/'
  sha1 '5e72c5e12bce2d5f77469d8f2425064a0ea6fc1e'

  def install
    bin.mkpath

    inreplace 'Makefile' do |s|
      s.gsub! 'INSTALL_PREFIX = /usr/local', "INSTALL_PREFIX = #{prefix}"
      s.gsub! 'INDENT = /usr/local/bin/gindent', 'INDENT = indent'
      s.gsub! '	${INSTALL_PROGRAM} bsdsfv ${INSTALL_PREFIX}/bin', "	${INSTALL_PROGRAM} bsdsfv #{bin}/"
    end

    system "make all"
    system "make install"
  end
end
