require "formula"

class 	Hammer < Formula
	url "https://github.com/UpstandingHackers/hammer/archive/v1.0.0-rc2.tar.gz"
	homepage "https://github.com/UpstandingHackers/hammer"
	sha1 "2a38f8f5107afa52d5698c38b43d30e0f2fa0694"
	version "1.0.0-rc2"

	depends_on "scons" => :build

	depends_on "pkg-config" => :recomended
	depends_on "glib" => :recomended

	def install
    	system "scons"
    	system "scons install"
	end
end