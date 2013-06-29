require 'formula'

class Afsctool < Formula
  homepage 'http://brkirch.wordpress.com/afsctool/'
  url 'https://docs.google.com/uc?export=download&id=0BwQlnXqL939ZQjBQNEhRQUo0aUk'
  version '1.6.4'
  sha1 '216d7ff54bad947781d9b49f9754c5d3c07349be'

  def install
    ENV.fast
    cd "afsctool_34" do
      system "#{ENV.cc} #{ENV.cflags} -lz -framework CoreServices -o afsctool afsctool.c"
      bin.install 'afsctool'
    end
  end
end
