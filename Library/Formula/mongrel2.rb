require 'formula'

class Mongrel2 < Formula
  url 'http://mongrel2.org/static/downloads/mongrel2-1.5.tar.bz2'
  head 'fossil://http://mongrel2.org:44445/'
  homepage 'http://mongrel2.org/'
  md5 'b699ffc7ef922ad7d703fcd39a897910'

  depends_on 'zeromq'

  def install
    # Mongrel2 pulls from these ENV vars instead
    ENV['OPTFLAGS'] = "#{ENV.cflags} #{ENV.cppflags}"
    ENV['OPTLIBS'] = ENV.ldflags

    system "make all"
    system "make install PREFIX=#{prefix}"
  end
end
