require 'formula'

class Ssldump < Formula
  url 'http://www.rtfm.com/ssldump/ssldump-0.9b3.tar.gz'
  homepage 'http://www.rtfm.com/ssldump/'
  md5 'ac8c28fe87508d6bfb06344ec496b1dd'

  def install
    ENV["LIBS"] = "-lssl -lcrypto"

    # .dylib, not .a
    inreplace "configure", "if test -f $dir/libpcap.a; then", "if test -f $dir/libpcap.dylib; then"

    system "./configure", "osx", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    bin.install "ssldump"
    man1.install "ssldump.1"
  end

  def patches
    {
      :p1 => [
        # reorder include files
        # => http://sourceforge.net/tracker/index.php?func=detail&aid=1622854&group_id=68993&atid=523055
        'https://raw.github.com/gist/2321613/52c0a816d8dda102d5c1f5da2a2e857fcf4bad2a/reorder-include-files.diff',
        # increase pcap sample size from an arbitrary 5000 the max TLS packet size 18432
        'https://raw.github.com/gist/2321618/329aa95747beeec33aabf48d9c113af59493c3f4/increase-sample-buffer-size.diff'
      ],
    }
  end
end
