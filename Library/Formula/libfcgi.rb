require 'formula'

class Libfcgi < Formula
  url 'http://www.fastcgi.com/dist/fcgi-2.4.0.tar.gz'
  homepage 'http://www.fastcgi.com'
  md5 'd15060a813b91383a9f3c66faf84867e'

  def options
    [
      ['--universal', 'Build as a Universal Intel binary.']
    ]
  end

  def patches
    # fix the built lib with incorrect version 0.0.0 to 2.4.0
    { :p0 => "https://raw.github.com/gist/1646327/4ed91a403ff4c2eabc2d1034b7e4e4eddb055fe1/gistfile1.txt" }
  end

  def install
    ENV['CC'] = "#{ENV.cc}"
    ENV['CXX'] = "#{ENV.cxx}"

    if ARGV.build_universal?
      ENV['CFLAGS'] = "-arch i386 -arch x86_64"
      ENV['CXXFLAGS'] = "-arch i386 -arch x86_64"
      ENV['LDFLAGS'] = "-arch i386 -arch x86_64"
    end

    system "/usr/bin/autoreconf --install -fvi"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"

    man1.install Dir.entries('doc').select{|f| f.end_with?(".1") }.map {|f| "doc/#{f}"}
    man3.install Dir.entries('doc').select{|f| f.end_with?(".3") }.map {|f| "doc/#{f}"}
    doc.mkpath
    Dir.entries('doc').reject{|f| f.end_with?(".") ||  f.end_with?(".1") ||  f.end_with?(".3")}.each {|f| cp_r "doc/#{f}", doc}
  end

end