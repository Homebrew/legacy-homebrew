require 'formula'

class Poco < Formula
  homepage 'http://pocoproject.org/'
  url 'http://pocoproject.org/releases/poco-1.4.6/poco-1.4.6.tar.gz'
  sha1 'e96260f5a5309e129bdea4251c8e26e14bd0c9bc'

  option 'with-c++11', 'Compile using std=c++11 and stdlib=libc++' if MacOS.version >= :lion

  def install
    arch = Hardware.is_64_bit? ? 'Darwin64': 'Darwin32'
    if ENV.compilter == :clang
      arch << '-clang'
      arch << '-libc++' if build.include? 'with-c++11'
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--config=#{arch}",
                          "--omit=Data/MySQL,Data/ODBC",
                          "--no-samples",
                          "--no-tests"
    system "make install CC=#{ENV.cc} CXX=#{ENV.cxx}"
  end
end
