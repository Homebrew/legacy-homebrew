require 'formula'

class Cgminer < Formula
  homepage 'http://www.gnu.org/software/a2ps/'
  head 'https://github.com/ckolivas/cgminer.git'
  url 'https://github.com/ckolivas/cgminer/archive/v3.8.1.tar.gz'
  sha1 '29a0348685d0c1d3a89c3ee67b6decc0e5de59ad'
  depends_on 'pkg-config' => :build
  depends_on 'libtool' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'curl' => :recommended
  depends_on 'ncurses' => :recommended

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"]
    args<< "--disable-libcurl" if build.without? 'curl'
    
    mining = ["--enable-avalon", "--enable-bflsc", "--enable-bitforce", 
              "--enable-bitfury", "--enable-hashfast", "--enable-icarus",
              "--enable-bab", "--enable-klondike",
              "--enable-modminer"]
    args.concat(mining)  
    
    system "autoreconf", "-i"
    system "automake"
    
    system "./configure", *args
    system "make install"
  end
end
