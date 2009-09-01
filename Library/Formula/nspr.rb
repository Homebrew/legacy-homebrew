require 'brewkit'

class Nspr <Formula
  @url='https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.7.5/src/nspr-4.7.5.tar.gz'
  @homepage='http://www.mozilla.org/projects/nspr/'
  @md5='f76d459a9e589d41d65314357a853783'

  def install
    ENV.deparallelize
    Dir.chdir "mozilla/nsprpub" do
      system "./configure", "--prefix=#{prefix}", "--disable-debug", "--enable-strip"
      system "make"
      system "make install"
    end
  end
end
