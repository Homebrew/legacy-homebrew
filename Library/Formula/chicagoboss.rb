# The following formula relies on the presence of the bin/boss executable added in:
# https://github.com/pius/ChicagoBoss/commit/30170ef85037d111b48cb24d512cee7e0f786f93
# Upon the next Chicago Boss release, this formula should be updated to use the canonical source.

require 'formula'

class Chicagoboss < Formula
  homepage 'http://www.chicagoboss.org/'
  url 'https://github.com/pius/ChicagoBoss/archive/master.zip'
  sha1 '9c8826e37039a326e7c44db680024ce067dad716'
  version '0.8.7'

  option 'with-elixir', "Include Elixir support"

  depends_on "erlang"

  def install
    if build.with? 'elixir'
      system "touch", "rebar.config.new"
      system "sed", "-i", "", "-e", "/{elixir/ s/% *//", "rebar.config"
      copy "priv/web_controller.ex", "src"
    end

    system "./rebar", "get-deps"
    system "./rebar", "compile"
    system "make"

    bin.install "./boss"
    prefix.install Dir['*']
  end

  test do
    system "boss"
  end
end
