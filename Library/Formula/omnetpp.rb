require 'formula'

class Omnetpp < Formula
  homepage 'http://omnetpp.org/'
  url 'http://omnetpp.org/download/release/omnetpp-4.3-src.tgz'
  sha1 '2380e3a864e38eb12f7ff780d78b1b7ab8f2e0c5'

  depends_on :x11

  def install

    system "./configure", "--disable-debug", "--disable-dependency-tracking"
    system "PATH=\"$PATH:\`pwd\`/bin\" make"
    prefix.install Dir['*']

  end

  def caveats; <<-EOS.undent
    omnetpp.app installed to:
      #{prefix}/ide
    To link the application to a normal Mac OS X location:
      ln -s #{prefix}/ide/omnetpp.app /Applications
    EOS
  end

  test do
    system "false"
  end
end
