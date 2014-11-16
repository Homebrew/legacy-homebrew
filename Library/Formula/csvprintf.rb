require 'formula'

class Csvprintf < Formula
  homepage 'http://code.google.com/p/csvprintf/'
  url 'https://csvprintf.googlecode.com/files/csvprintf-1.0.3.tar.gz'
  sha1 'ee5ee6728a44cc7d0961b0960c7a444372752931'

  def install
    ENV.append 'LDFLAGS', '-liconv'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    assert_equal "Fred Smith\n",
                 pipe_output("#{bin}/csvprintf -i '%2$s %1$s\n'", "Last,First\nSmith,Fred\n")
  end
end
