require 'formula'

class Imapfilter < Formula
  homepage 'https://github.com/lefcha/imapfilter/'
  url 'https://github.com/lefcha/imapfilter/archive/v2.5.6.tar.gz'
  sha1 '49ac7b7fb937b40eb42a162314de4f8866e33c11'

  depends_on 'lua'
  depends_on 'pcre'
  depends_on 'openssl'

  def install
    inreplace 'src/Makefile' do |s|
      s.change_make_var! 'CFLAGS', "#{s.get_make_var 'CFLAGS'} #{ENV.cflags}"
    end

    # find Homebrew's libpcre and lua
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"
    ENV.append 'LDFLAGS', '-liconv'
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "LDFLAGS=#{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "install"

    prefix.install 'samples'
  end

  def caveats; <<-EOS.undent
    You will need to create a ~/.imapfilter/config.lua file.
    Samples can be found in:
      #{prefix}/samples
    EOS
  end

  test do
    system "#{bin}/imapfilter", "-V"
  end
end
