class Eventlog < Formula
  desc "Replacement for syslog API providing structure to messages"
  homepage "https://www.balabit.com/downloads/files/eventlog/"
  url "https://www.balabit.com/downloads/files/syslog-ng/sources/3.4.3/source/eventlog_0.2.13.tar.gz"
  sha256 "7cb4e6f316daede4fa54547371d5c986395177c12dbdec74a66298e684ac8b85"

  bottle do
    cellar :any
    sha256 "9073fb11ae9c20375295c36b5bb6845639ea1f9c17a677c1d93ff206075ff871" => :el_capitan
    sha256 "2bdc1f762ea05e79f486e7e78b8a173ea99a5a76b4bedd28a03a1c8912f39925" => :yosemite
    sha256 "9d747019f60dfa8fc13472815c18c20c46c2cb2cd53dd754a99e8029afb85cbf" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
