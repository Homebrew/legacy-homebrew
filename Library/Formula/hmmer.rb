require 'formula'

class Hmmer < Formula
  url 'http://selab.janelia.org/software/hmmer3/3.0/hmmer-3.0.tar.gz'
  homepage 'http://hmmer.janelia.org/'
  md5 '4cf685f3bc524ba5b5cdaaa070a83588'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    # Install man pages manually as long as automatic man page install
    # is deactivated in the HMMER makefile. If this changes in future
    # versions of HMMER, these lines can be removed:

    Dir.chdir "documentation/man"
    # rename all *.man files to *.1 and install them into man1 section
    Dir.glob("*.man") do |filename|
      man1.install filename => filename.sub(/\.man/, ".1")
    end
  end
end
