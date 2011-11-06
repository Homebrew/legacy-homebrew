require 'formula'

class Yaws < Formula
  homepage 'http://yaws.hyber.org'
  url 'http://yaws.hyber.org/download/yaws-1.90.tar.gz'
  md5 'c2aae5a4e01ad47d44955551c9a67333'

  depends_on 'erlang'

  def options
    [["--with-yapp", "Build and install yaws applications"]]
  end

  def install
    Dir.chdir 'yaws' do
      system "./configure", "--prefix=#{prefix}"
      system "make install"

      if ARGV.include? '--with-yapp'
        Dir.chdir 'applications/yapp' do
          system "make"
          system "make install"
        end
      end
    end
  end

  def caveats; <<-EOS.undent
    Usually you want to build yapp (yaws applications) as well.
    To do so, use:
      brew install yaws --with-yapp
    EOS
  end
end
