require 'formula'

class Frotz <Formula
  url 'http://downloads.sourceforge.net/project/frotz/frotz/2.43/frotz-2.43.tar.gz'
  homepage 'http://frotz.sourceforge.net/'
  md5 'efe51879e012b92bb8d5f4a82e982677'

  def install
    inreplace "Makefile" do |s|
      s.remove_make_var! %w[CC OPTS]
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "CONFIG_DIR", etc
    end

    system "make frotz"
    system "make install"
  end
end
