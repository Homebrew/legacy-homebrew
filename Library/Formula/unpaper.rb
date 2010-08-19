require 'formula'

class Unpaper <Formula
  url 'http://download.berlios.de/unpaper/unpaper-0.3.tar.gz'
  homepage 'http://unpaper.berlios.de/'
  md5 'be41eaf8556e7df39ab53939c99c4f7b'

  def install
    # Fix make.sh to take CFLAGS/LDFLAGS from environment
    inreplace "make.sh" do |s|
      s.change_make_var! "CFLAGS", ENV['CFLAGS']
      s.change_make_var! "LDFLAGS", ENV['LDFLAGS']
    end
    system 'bash make.sh'
    bin.install 'unpaper'
  end
end
