class Mad < Formula
  desc "MPEG audio decoder"
  homepage "http://www.underbit.com/products/mad/"
  url "https://downloads.sourceforge.net/project/mad/libmad/0.15.1b/libmad-0.15.1b.tar.gz"
  sha256 "bbfac3ed6bfbc2823d3775ebb931087371e142bb0e9bb1bee51a76a6e0078690"

  bottle do
    cellar :any
    revision 1
    sha1 "ec696978cd2bbd43ed11b6b1d3b78156d2b97c71" => :yosemite
    sha1 "b8ea86acc3a5aab051e7df3d6e1b00ac1acac346" => :mavericks
    sha1 "7164d878d4467cda6bbed49fd46129a4ae3169ec" => :mountain_lion
  end

  def install
    fpm = MacOS.prefer_64_bit? ? "64bit": "intel"
    system "./configure", "--disable-debugging", "--enable-fpm=#{fpm}", "--prefix=#{prefix}"
    system "make", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", "install"
    (lib+"pkgconfig/mad.pc").write pc_file
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
