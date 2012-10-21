require 'formula'

class Movgrab < Formula
  homepage 'http://sites.google.com/site/columscode'
  url 'http://sites.google.com/site/columscode/files/movgrab-1.1.12.tar.gz'
  sha1 'de5e48e0cde9c038562798a6a9fdcc56746c31bc'

  def install
    # When configure recurses into libUseful-2.0, it puts CC and CFLAGS into
    # the second configure command line causing an error, invalid host type.
    # The workaround is to manually configure libUseful-2.0 without those.
    # The cache-file and srcdir arguments parse ok.  So those were left in.
    # Reported upstream. As of 1.1.12 the dev hasn't solved this yet.
    system './configure', "--prefix=#{prefix}", '--no-recursion'
    cd 'libUseful-2.0' do
      system './configure', "--prefix=#{prefix}",
                            '--cache-file=/dev/null',
                            '--srcdir=.'
    end
    system 'make'
    system 'make install'
  end
end
