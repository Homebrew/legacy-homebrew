class Takt < Formula
  desc "text-based music programming language"
  homepage "http://takt.sourceforge.net"
  url "https://downloads.sourceforge.net/project/takt/takt-0.309-src.tar.gz"
  sha256 "44fca667d610fba15deb441dd44e5b87dabbe5619d7fa8a13f5c8c1f054dd509"

  bottle do
    sha256 "3dbf255bf638d233a4c4eda5823bc3f4fa4d5fd6985ea25022edafef6864ce1d" => :yosemite
    sha256 "3b95c5b824c3616c6278d02718f511013aa6f1f921d04de62c5e674fae27aa1a" => :mavericks
    sha256 "12faf048c8ce38aa97ca1cd3e95aad70c8430315ecfd76a1c11208a0874ce87c" => :mountain_lion
  end

  depends_on "readline"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-lispdir=#{share}/emacs/site-lisp/#{name}"
    system "make", "install"
  end

  test do
    system bin/"takt", "-o etude1.mid", pkgshare/"examples/etude1.takt"
  end
end
