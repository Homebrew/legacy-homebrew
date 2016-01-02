class Ctemplate < Formula
  desc "Template language for C++"
  homepage "https://github.com/olafvdspek/ctemplate"
  url "https://github.com/OlafvdSpek/ctemplate/archive/ctemplate-2.3.tar.gz"
  sha256 "99e5cb6d3f8407d5b1ffef96b1d59ce3981cda3492814e5ef820684ebb782556"
  head "https://github.com/olafvdspek/ctemplate.git"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
