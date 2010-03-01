require 'formula'

class Ffmpeg <Formula
  head 'svn://svn.ffmpeg.org/ffmpeg/trunk',
    :revisions => { :trunk => 22916, 'libswscale' => 31045 }
  homepage 'http://ffmpeg.org/'

  depends_on 'x264' => :optional
  depends_on 'faac' => :optional
  depends_on 'faad2' => :optional
  depends_on 'lame' => :optional

  def install
    configure_flags = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--enable-shared",
      "--enable-pthreads",
      "--enable-nonfree",
      "--enable-gpl"
    ]

    configure_flags << "--enable-libx264" if Formula.factory('x264').installed?
    configure_flags << "--enable-libfaac" if Formula.factory('faac').installed?
    configure_flags << "--enable-libfaad" if Formula.factory('faad2').installed?
    configure_flags << "--enable-libmp3lame" if Formula.factory('lame').installed?

    # For 32-bit compilation under gcc 4.2, see:
    # http://trac.macports.org/ticket/20938#comment:22
    if MACOS_VERSION >= 10.6 and not Hardware.is_64_bit?
      ENV.append_to_cflags "-mdynamic-no-pic"
    end

    system "./configure", *configure_flags

    inreplace 'config.mak' do |s|
      if MACOS_VERSION >= 10.6 and Hardware.is_64_bit?
        shflags = s.get_make_var 'SHFLAGS'
        s.change_make_var! 'SHFLAGS', shflags.gsub!(' -Wl,-read_only_relocs,suppress', '')
      end
    end

    system "make install"
  end
end
