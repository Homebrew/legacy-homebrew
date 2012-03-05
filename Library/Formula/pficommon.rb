require 'formula'

class Pficommon < Formula
  homepage 'http://pfi.github.com/pficommon/'
  url 'https://github.com/pfi/pficommon/zipball/v1.3.1.0'
  md5 'e53e92351ddf157784fe791b778dfe8d'
  version '1.3.1'

  head 'git://github.com/pfi/pficommon.git'

  depends_on 'mysql' => :optional
  depends_on 'postgresql' => :optional
  depends_on 'msgpack' => :optional
  depends_on 'fcgi' => :optional
  depends_on 'imagemagick' => :optional
  depends_on 'gtest' => :optional

  def options
    [
      ['--mysql', 'database library with mysql'],
      ['--postgresql', 'database library with postgresql'],
      ['--msgpack', 'library using msgpack'],
      ['--fcgi', 'library for fcgi'],
      ['--imagemagick', 'visualization with imagemagick'],
      ['--gtest', 'execute unit test using gtest']
    ]
  end

  def install

    args = [
      "--prefix=#{prefix}"
    ]

    if not ( ARGV.include?('--mysql') or ARGV.include?('--postgresql') )
      args << '--disable-database'
    end

    if ARGV.include? '--fcgi'
      fcgi = Formula.factory 'fcgi'
      args << "--with-fcgi=#{fcgi.prefix}"
    else
      args << '--disable-fcgi'
    end

    if ARGV.include? '--msgpack'
      msgpack = Formula.factory 'msgpack'
      args << "--with-msgpack=#{msgpack.prefix}"
    end

    unless ARGV.include? '--imagemagick'
      args << "--disable-magickpp"
    end

    # check is executed when library is built and installed
    if ARGV.include? '--gtest'
      args << '--checkall'
    end

    system "./configure", *args
    system "make"
    system "make install"

    prefix.install Dir['*']
  end

end
