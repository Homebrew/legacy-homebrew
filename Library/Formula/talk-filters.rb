require 'formula'

class TalkFilters <Formula
  url 'http://www.hyperrealm.com/talkfilters/talkfilters-2.3.8.tar.gz'
  homepage 'http://www.hyperrealm.com/main.php?s=talkfilters'
  md5 'c11c6863a1c246a8d49a80a1168b54c8'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    inreplace 'Makefile' do |s|
      s.change_make_var! "MKDIR_P", "mkdir -p"
    end

    system "make install"
  end
end
