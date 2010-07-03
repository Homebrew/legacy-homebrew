require 'formula'

class Nspr <Formula
  url 'http://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.8.4/src/nspr-4.8.4.tar.gz'
  homepage 'http://www.mozilla.org/projects/nspr/'
  md5 'a85bdbe1eb646aa32c785a37d8e3a2f5'

  def install
    ENV.deparallelize
    Dir.chdir "mozilla/nsprpub" do
      # Fixes a bug with linking against CoreFoundation.
      # See: http://openradar.appspot.com/7209349
      # Needed to work with SpiderMonkey
      inreplace "pr/src/Makefile.in", "-framework CoreServices -framework CoreFoundation", ""

      conf = ["--prefix=#{prefix}", "--disable-debug", "--enable-strip", "--enable-optimize"]
      conf << "--enable-64bit" if Hardware.is_64_bit? and MACOS_VERSION >= 10.6
      system "./configure", *conf

      # Remove the broken *(for anyone but FF) install_name
      inreplace "config/autoconf.mk", "-install_name @executable_path/$@ ", ""

      system "make"
      system "make install"
    end
  end
end
