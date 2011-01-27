require 'formula'

class Agner <Formula
  url 'https://github.com/agner/agner/zipball/v0.4.2'
  homepage 'https://github.com/agner/agner'
  md5 '3819673b5a63158bf490ebd368b2c83f'
  version '0.4.2'
  head "https://github.com/agner/agner.git", :branch => "master", :using => :git

  # Just like in other formulae, since we don't want to build HEAD erlang and there is no way to specify that,
  # just skip depending on erlang if we're trying to build head agner
  depends_on 'erlang' unless ARGV.build_head?

  def install
    system "make"
    bin.install "agner"
  end
end
