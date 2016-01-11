class Libdaemon < Formula
  desc "C library that eases writing UNIX daemons"
  homepage "http://0pointer.de/lennart/projects/libdaemon/"
  url "http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz"
  sha256 "fd23eb5f6f986dcc7e708307355ba3289abe03cc381fc47a80bca4a50aa6b834"

  bottle do
    sha256 "c4884ebab076d0407fde818785d4ad6279aeeada83baf0255048221f454d3000" => :mavericks
    sha256 "79e977cafe04c9bc692e31896bfcf0fe01c6bc653da2bec6239a8b265f63f15d" => :mountain_lion
    sha256 "a0a969626ac1c9d3f93a483024e72222609ca00d6ddaaa5f556de082c591772a" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
