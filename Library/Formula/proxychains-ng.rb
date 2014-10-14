require "formula"

class ProxychainsNg < Formula
  homepage "https://sourceforge.net/projects/proxychains-ng"
  url "https://downloads.sourceforge.net/project/proxychains-ng/proxychains-4.7.tar.bz2"
  sha1 "5e5b10009f785434ebdbd7ede5a79efee4e59c5a"

  head "https://github.com/rofl0r/proxychains-ng.git"

  bottle do
    sha1 "2dec4dda5f1ee8656133141ee50a0a1bcf616c7d" => :mavericks
    sha1 "ff402165a6ad4edde426615ef64513f0bb3ce92a" => :mountain_lion
    sha1 "5f26998480a6c040cf016f0c1521299c052c24b3" => :lion
  end

  option :universal

  def install
    args = ["--prefix=#{prefix}", "--sysconfdir=#{prefix}/etc"]
    if build.universal?
      ENV.universal_binary
      args.unshift "--fat-binary"
    end
    system "./configure", *args
    system "make"
    system "make", "install"
    system "make", "install-config"
  end
end
