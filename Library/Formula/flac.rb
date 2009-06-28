require 'brewkit'

class Flac2Mp3 <GithubGistFormula
  @url='http://gist.github.com/raw/124242/b17123e5d1c1c88c3d6667a03d59d1cf6b8f8532/flac2mp3'
  @md5='a38d150b5ebbcbc010c777bccf1c19a6'
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
    system "OBJ_FORMAT=macho make install"

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