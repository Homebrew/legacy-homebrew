require 'formula'

class Lnav < Formula
  homepage 'http://lnav.org'
  url 'https://github.com/tstack/lnav/releases/download/v0.7.1/lnav-0.7.1.tar.gz'
  sha1 'c7ba019afd40742437211e4173e2a19f8971eb7f'

  head 'https://github.com/tstack/lnav.git'

  bottle do
    revision 1
    sha256 "2cd3c6c2a599c490ad66ce2800bb649cf9b41ba1c7d41ef173cdedaac179b303" => :yosemite
    sha256 "7aeefa9382d88272bf9ede19a03301db5853416f07f34e7a76b3285b0d29c4a6" => :mavericks
    sha256 "74c793c46875ff5b5349f88d322e6004dd522aded06e8a2482e973201dbc26dd" => :mountain_lion
  end

  depends_on 'readline'
  depends_on 'pcre'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end
end
