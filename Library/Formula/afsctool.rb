require 'formula'

class Afsctool < Formula
  homepage 'http://brkirch.wordpress.com/afsctool/'
  url 'https://docs.google.com/uc?export=download&id=0BwQlnXqL939ZQjBQNEhRQUo0aUk'
  version '1.6.4'
  md5 'd0f2b79676c0f3d8c22e95fcf859a05f'

  def install
    ENV.fast
    cd "afsctool_34" do
      system "#{ENV.cc} #{ENV.cflags} -lz -framework CoreServices -o afsctool afsctool.c"
      bin.install 'afsctool'
    end
  end
end
