require "formula"

class Hammer < Formula
 url "https://github.com/UpstandingHackers/hammer/archive/v1.0.0-rc3.tar.gz"
 homepage "https://github.com/UpstandingHackers/hammer"
 sha1 "3e578d7f0e0a201aea7707c6041e48ec10ed7609"
 version "1.0.0-rc3"

 depends_on "scons" => :build
 depends_on "pkg-config" => :build
 depends_on "glib" => :build

 def install
 scons "install"
 end
end
