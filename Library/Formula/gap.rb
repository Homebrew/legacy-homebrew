require 'formula'

class Gap < Formula
  url 'ftp://ftp.gap-system.org/pub/gap/gap4/tar.gz/gap4r4p12.tar.gz'
  homepage 'http://www.gap-system.org'
  md5 'a0f439f9b33568d73eb99863dcc7f86b'
  version '4.4.12'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    # Either make $GAPROOT or find way to change gap.sh file
    inreplace 'bin/gap.sh' do |s|
      s.gsub! '/usr/bin/cc', 'cc'
      s.gsub! "#{Dir.pwd}", "/usr/local/lib/gap4r4"
    end
    bin.install 'bin/gap.sh' => 'gap'

    gaproot = lib+'gap4r4'
    # make install
    gaproot.install Dir['*']
  end

  def caveats
    puts <<-EOS
This formula only installs the GAP core: the packages, table of marks,
and developer tools need to be installed by hand. More information can
be found at the following URL:

http://www.gap-system.org/Download/UNIXInst.html
     EOS
  end
end
