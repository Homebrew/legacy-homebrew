class DnscryptWrapper < Formula
  desc "Server-side proxy that adds dnscrypt support to name resolvers"
  homepage "https://cofyc.github.io/dnscrypt-wrapper/"
  url "https://github.com/Cofyc/dnscrypt-wrapper/releases/download/v0.1.16/dnscrypt-wrapper-v0.1.16.tar.bz2"
  sha256 "848dc213f79cca6e75ecbbdeca1630fab2494ed10bf0afdd83b7ea6bfe8307a3"
  head "https://github.com/Cofyc/dnscrypt-wrapper.git"

  bottle do
    cellar :any
    sha256 "0a72369104ba7b69642f7cf48de1bf659185fece25d9c157b0b8e19a5db56b10" => :yosemite
    sha256 "5977dba418f3a05ca689e04025333d9ba0755d4c4a6bd5875afbe96242dcfe8c" => :mavericks
    sha256 "b15c78585bf3b49dcfb244c812804388f93b423198e465ce10129033edf27fd8" => :mountain_lion
  end

  depends_on "autoconf" => :build

  depends_on "libsodium"
  depends_on "libevent"

  def install
    system "make", "configure"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/dnscrypt-wrapper", "--gen-provider-keypair"
    system "#{sbin}/dnscrypt-wrapper", "--gen-crypt-keypair"
  end
end
