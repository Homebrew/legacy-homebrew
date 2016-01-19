class Mad < Formula
  desc "MPEG audio decoder"
  homepage "http://www.underbit.com/products/mad/"
  url "https://downloads.sourceforge.net/project/mad/libmad/0.15.1b/libmad-0.15.1b.tar.gz"
  sha256 "bbfac3ed6bfbc2823d3775ebb931087371e142bb0e9bb1bee51a76a6e0078690"

  bottle do
    cellar :any
    revision 1
    sha256 "a8a162813aad00169410a8f14a39927028969c914929fafb0685f0eb80075546" => :el_capitan
    sha256 "863c71f31ecda8f97effc4dd148564e03219f8ddd162c89e054a7e57623c18c6" => :yosemite
    sha256 "7bd46d4da0f695b3a5bcc899b7139f14d11741f2e47d34f21a984f9bab953c81" => :mavericks
    sha256 "11391349b4ee378f31ae681ff5c96f7c8d1b5f2a6ad5ba6b28d12bc102cc9d6b" => :mountain_lion
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
