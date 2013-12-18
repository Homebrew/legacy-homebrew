require 'formula'

class Unpaper < Formula
  homepage 'http://unpaper.berlios.de/'
  url 'http://download.berlios.de/unpaper/unpaper-0.3.tar.gz'
  sha1 '120eee7c635eeb8ea75431c2dfba89bd8c132493'

  def install
    # Fix make.sh to take CFLAGS/LDFLAGS from environment
    inreplace "make.sh" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
      s.change_make_var! "LDFLAGS", ENV.ldflags
    end
    system 'bash make.sh'
    bin.install 'unpaper'
  end
end
