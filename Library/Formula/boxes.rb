require 'formula'

class Boxes <Formula
  url 'http://boxes.thomasjensen.com/download/boxes-1.1.src.tar.gz'
  homepage 'http://boxes.thomasjensen.com/'
  md5 'd2ef9fa28a87bf32b3fe0c47ab82fa97'

  def install
    # distro uses /usr/share/boxes change to prefix
    inreplace 'Makefile' do |contents| 
      contents.change_make_var! "GLOBALCONF", "#{prefix}/share/boxes"
    end

    # No autoconf system
    system "make"

    # No make install have to manually copy files
    man.install 'doc/boxes.1'
    share.install 'boxes-config' => 'boxes'
    bin.install 'src/boxes'
  end
end
