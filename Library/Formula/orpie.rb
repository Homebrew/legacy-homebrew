class Orpie < Formula
  desc "RPN calculator for the terminal"
  homepage "http://pessimization.com/software/orpie/"
  url "http://pessimization.com/software/orpie/orpie-1.5.2.tar.gz"
  sha256 "de557fc7f608c6cb1f44a965d3ae07fc6baf2b02a0d7994b89d6a0e0d87d3d6d"

  bottle do
    sha256 "9f1c77ca5e604a97bf837459ab0aa524998b887d7c9eedb94b8b9a1f74d6e479" => :yosemite
    sha256 "1faea0bbbdbad1636010b54cd578e15064dee6881211864bf1bffbf89adca19f" => :mavericks
    sha256 "26013781f3da7b861365556b5d7b2ab797ea1b0fa6f97ef0d15a4c89cf849f33" => :mountain_lion
  end

  depends_on "gsl"
  depends_on "ocaml"
  depends_on "camlp4" => :build

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
