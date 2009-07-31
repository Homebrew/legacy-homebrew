require 'brewkit'

class Flac2Mp3 <GithubGistFormula
  @url='http://gist.github.com/raw/124242/79857936f1d72824be0fb5d2ac845c02322abea0/flac2mp3'
  @md5='8351009b64afedfeb7a9e162ccd8d94c'
end

class Flac <Formula
  @homepage='http://flac.sourceforge.net'
  @url='http://kent.dl.sourceforge.net/sourceforge/flac/flac-1.2.1.tar.gz'
  @md5='153c8b15a54da428d1f0fadc756c22c7'

  def install
    # sadly the asm optimisations won't compile since Leopard, and nobody 
    # cares or knows how to fix it
    # TODO --enable-sse
    system "./configure --disable-debug --disable-asm-optimizations --prefix='#{prefix}' --mandir='#{prefix}/share/man'"
    ENV['OBJ_FORMAT']='macho'
    system "make install"

    (doc.parent+"#{@name}-#{@version}").mv doc

    Flac2Mp3.new.brew do |flac2mp3|
      FileUtils.chmod 0544, flac2mp3.name
      FileUtils.cp flac2mp3.name, bin
    end
  end

  def caveats
    "The flac2mp3 Ruby script depends on Lame." if `which lame`.empty?
  end
end