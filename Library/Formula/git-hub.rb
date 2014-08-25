require "formula"

class GitHub < Formula
	homepage "https://github.com/ingydotnet/git-hub"
	url "https://github.com/ingydotnet/git-hub/archive/0.1.3.tar.gz"
	sha1 "743517bc205ed4e3ac6c3077247d7b49ff249e87"

	def install
		system "make", "install", "PREFIX=#{prefix}"
	end
end
