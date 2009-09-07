require 'brewkit'

class Chicken <Formula
  @url='http://www.call-with-current-continuation.org/chicken-4.1.0.tar.gz'
  @homepage='http://www.call-with-current-continuation.org/'
  @md5='9a43b536408c271b0eaf802307e8c415'

  def install
    ENV.deparallelize
    settings = "PREFIX=#{prefix} PLATFORM=macosx ARCH=x86-64"
    system "make #{settings}"
    system "make install #{settings}"
  end
end
