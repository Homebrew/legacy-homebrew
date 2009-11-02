require 'formula'

class Nspr <Formula
  @url='https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.7.6/src/nspr-4.7.6.tar.gz'
  @homepage='http://www.mozilla.org/projects/nspr/'
  @md5='c78384602b4b466081a55025446641db'

  def install
    ENV.deparallelize
    Dir.chdir "mozilla/nsprpub" do
      system "./configure", "--prefix=#{prefix}", "--disable-debug", "--enable-strip"
      system "make"
      system "make install"
    end
  end
end
