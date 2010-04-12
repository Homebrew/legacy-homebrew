require 'formula'

class Nspr <Formula
  url 'http://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.7.6/src/nspr-4.7.6.tar.gz'
  homepage 'http://www.mozilla.org/projects/nspr/'
  md5 'c78384602b4b466081a55025446641db'

  def install
    require 'hardware'

    ENV.deparallelize
    Dir.chdir "mozilla/nsprpub" do
      inreplace "pr/src/Makefile.in", "-framework CoreServices -framework CoreFoundation", "-framework Carbon"

      conf = %W[--prefix=#{prefix} --disable-debug --enable-strip --enable-optimize]
      conf << "--enable-64bit" if Hardware.is_64_bit? and MACOS_VERSION >= 10.6
      system "./configure", *conf

      inreplace "config/autoconf.mk", "-install_name @executable_path/$@ ", ""

      system "make"
      system "make install"
    end
  end
end
