require 'formula'

class Rebar <Formula
	head 'http://hg.basho.com/rebar/get/tip.tar.gz'
	homepage 'http://hg.basho.com/rebar/'

	depends_on 'erlang'

	def install
		system "./bootstrap"
		bin.install "rebar"
	end
end
