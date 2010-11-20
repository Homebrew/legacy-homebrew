require 'formula'

class X264 <Formula
  homepage 'http://www.videolan.org/developers/x264.html'
  url 'git://git.videolan.org/x264.git',
        :branch => 'stable'
  head 'git://git.videolan.org/x264.git',
        :branch => 'master'

  depends_on 'yasm'

  def install
    system "./version.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared"

    inreplace 'config.mak' do |s|
      ldflags = s.get_make_var 'LDFLAGS'
      s.change_make_var! 'LDFLAGS', ldflags.gsub!(' -s', '')

      if snow_leopard_64?
        soflags = s.get_make_var 'SOFLAGS'
        s.change_make_var! 'SOFLAGS', soflags.gsub!(' -Wl,-read_only_relocs,suppress', '')
      end
    end

    system "make install"
  end
end
