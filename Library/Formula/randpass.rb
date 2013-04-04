require 'formula'

class Randpass < Formula
  homepage 'https://github.com/dogriffiths/randpass/wiki'
  url 'https://github.com/dogriffiths/randpass/archive/v1.0.8.tar.gz'
  sha1 '3fb65eef53f0da5d7d1bc2469ec35ad00f1157d1'

  def install
    system "./configure"
    system "make install" # if this fails, try separate make/make install steps
  end

  test do
    system "randpass"
  end
end
