require 'formula'

class Libstxxl < Formula
  url 'http://sourceforge.net/projects/stxxl/files/stxxl/1.3.1/stxxl-1.3.1.tar.gz'
  homepage 'http://stxxl.sourceforge.net/'
  md5 '8d0e8544c4c830cf9ae81c39b092438c'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "USE_MACOSX", "yes"
    end

    ENV['COMPILER'] = ENV.cxx

    system "make", "config_gnu"
    system "make", "library_g++"

    prefix.install Dir['include']
    prefix.install Dir['lib']
  end
end
