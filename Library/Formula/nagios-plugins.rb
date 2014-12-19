require 'formula'

class NagiosPlugins < Formula
  homepage 'https://www.nagios-plugins.org/'
  url 'https://www.nagios-plugins.org/download/nagios-plugins-2.0.tar.gz'
  sha1 '9b9be0dfb7026d30da0e3a5bbf4040211648ee39'

  bottle do
    sha1 "78fbc5df2f4426e7fc435ea9d597d14180d9e950" => :yosemite
    sha1 "52560d1d02b9710df9c4a2315d8357ee6d7bfda4" => :mavericks
    sha1 "0f3bb80908ff0cdfaae651c2100b48a048d69257" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--libexecdir=#{sbin}"
    system "make install"
    system "make install-root"
  end

  def caveats
    <<-EOS.undent
    All plugins have been installed in:
      #{HOMEBREW_PREFIX}/sbin
    EOS
  end
end
