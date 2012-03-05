require 'formula'

# This is a general purpose C++ library provided by Preferred Infrastructure.

class Pficommon < Formula
    homepage 'http://pfi.github.com/pficommon/'
    url 'https://github.com/pfi/pficommon.git', :using => :git
    version '1.3.1'

    # add optional dependency
    ARGV.each do |arg|
        if arg =~ /^--([a-z]+)$/
            depends_on $1
        end
    end

    def options
        [
            ['--mysql', 'database library with mysql'],
            ['--postgresql', 'database library with postgresql'],
            ['--msgpack', 'library using msgpack'],
            ['--fcgi', 'library for fcgi'],
            ['--gtest', 'execute unit test using gtest']
        ]
    end

    def install

        args = [
            "--prefix=#{prefix}",
            "--disable-magickpp",
            "--oldincludedir=/usr/local/include"
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

        # check is executed when library is built and installed
        if ARGV.include? '--gtest'
            args << '--checkall'
        end

        # system "./waf configure", *args
        # system "./waf build -j4"
        # system "./waf install"
        system "./configure", *args
        system "make"
        system "make install"

        # install everything
        prefix.install Dir['*']
    end

    def caveats
        <<-EOS.undent
        This is a general purpose C++ library provided by Preferred Infrastructure ( http://preferred.jp ).
        LICENSE: New BSD License
        EOS
    end

end
