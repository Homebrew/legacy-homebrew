require 'formula'

class Hmmer < Formula
  homepage 'http://hmmer.janelia.org/'
  url 'http://selab.janelia.org/software/hmmer3/3.0/hmmer-3.0.tar.gz'
  md5 '4cf685f3bc524ba5b5cdaaa070a83588'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    # Install man pages manually as long as automatic man page install
    # is deactivated in the HMMER makefile. If this changes in future
    # versions of HMMER, these lines can be removed.

    cd "documentation/man" do
      # rename all *.man files to *.1 and install them into man1 section
      Dir["*.man"].each do |f|
        man1.install f => f.sub(/\.man/, ".1")
      end
    end
  end
end
