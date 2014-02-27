require 'formula'

class Mad < Formula
  homepage 'http://www.underbit.com/products/mad/'
  url 'https://downloads.sourceforge.net/project/mad/libmad/0.15.1b/libmad-0.15.1b.tar.gz'
  sha1 'cac19cd00e1a907f3150cc040ccc077783496d76'

  bottle do
    cellar :any
    sha1 "553ab873bc524e334ccc3adeb5d643cf2fac8892" => :mavericks
    sha1 "3b7653b4ccd90ad69faa8deb82eb7b9881797443" => :mountain_lion
    sha1 "f20398331482b492ab879597794624ce1ab351d7" => :lion
  end

  def install
    fpm = MacOS.prefer_64_bit? ? '64bit': 'intel'
    system "./configure", "--disable-debugging", "--enable-fpm=#{fpm}", "--prefix=#{prefix}"
    system "make", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", "install"
    (lib+'pkgconfig/mad.pc').write pc_file
  end

  def pc_file; <<-EOS.undent
    prefix=#{opt_prefix}
    exec_prefix=${prefix}
    libdir=${exec_prefix}/lib
    includedir=${prefix}/include

    Name: mad
    Description: MPEG Audio Decoder
    Version: #{version}
    Requires:
    Conflicts:
    Libs: -L${libdir} -lmad -lm
    Cflags: -I${includedir}
    EOS
  end
end
