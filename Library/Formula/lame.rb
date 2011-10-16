require 'formula'

class Lame < Formula
  homepage 'http://lame.sourceforge.net/'
  url 'http://downloads.sourceforge.net/sourceforge/lame/lame-3.98.4.tar.gz'
  mirror 'http://download.openpkg.org/components/cache/lame/lame-3.98.4.tar.gz'
  md5 '8e9866ad6b570c6c95c8cba48060473f'

  def options
    [[ '--universal', 'Build a universal library' ]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    args = ["--disable-dependency-tracking",
            "--disable-debug",
            "--prefix=#{prefix}",
            "--enable-nasm" ]
    system "./configure", *args
    system "make install"
    prefix.install 'testcase.wav'
  end

  def test
    a = prefix+'testcase.wav'
    b = 'output.mp3'
    l = "#{HOMEBREW_PREFIX}/bin/lame"
    q = '/usr/bin/qlmanage'
    if File.exists? a and File.exists? l and File.exists? q
      puts
      system "#{l} --nores -X6 -c -p --preset extreme #{a} #{b}"
      system "#{q} -p #{b}" if ARGV.verbose?
      oh1 "The test was successful using libmp3lame"
      puts
    else
      opoo <<-EOS.undent
        The test was skipped because of one or more missing files, which normally
        exist after a brew rm lame followed by brew install lame:
                    #{a}
                    #{l}
                    #{q}

      EOS
    end
  end
end