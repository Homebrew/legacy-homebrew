require 'formula'

class Flac < Formula
  homepage 'http://xiph.org/flac/'
  url 'http://downloads.xiph.org/releases/flac/flac-1.3.0.tar.xz'
  sha1 'a136e5748f8fb1e6c524c75000a765fc63bb7b1b'

  bottle do
    cellar :any
    sha1 "c317706ce41258cf009152e7cba2cd37e209c2f0" => :mavericks
    sha1 "df67e225d0db9999de767ee4478273f5f7c1ba4a" => :mountain_lion
    sha1 "41bca30e9f6e3a54db1af6cf510e1fd37902039c" => :lion
  end

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'lame'
  depends_on 'libogg' => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary if build.universal?

    ENV.append 'CFLAGS', '-std=gnu89'

    # sadly the asm optimisations won't compile since Leopard
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --mandir=#{man}
      --disable-asm-optimizations
      --enable-sse
      --enable-static
    ]

    args << "--without-ogg" if build.without? "libogg"

    system "./configure", *args

    ENV['OBJ_FORMAT']='macho'

    # adds universal flags to the generated libtool script
    inreplace "libtool" do |s|
      s.gsub! ":$verstring\"", ":$verstring -arch #{Hardware::CPU.arch_32_bit} -arch #{Hardware::CPU.arch_64_bit}\""
    end

    system "make install"
    (bin/'flac2mp3').write DATA.read
  end
end

__END__
#!/usr/bin/env ruby
# http://gist.github.com/gists/2998853/
# Forked from http://gist.github.com/gists/124242

filename, quality = ARGV[0], ARGV[1]
abort "Usage: flac2mp3 FLACFILE [V2|V1|V0|320]\nDefault (and recommended) quality is V0." if filename.nil?

qualarg = case quality
    when "V0","V1","V2" then quality
    when "320" then "b 320"
    else "V0"
end

map = {"TITLE" => "--tt", "ARTIST" => "--ta", "ALBUM" => "--tl", "TRACKNUMBER" => "--tn", "GENRE" => "--tg", "DATE" => "--ty"}
args = ""

`metaflac --export-tags-to=- "#{filename}"`.each_line do |line|
    key, value = line.strip.split('=', 2)
    key.upcase!
    args << %Q{#{map[key]} "#{value.gsub('"', '\"')}" } if map[key]
end

basename = File.basename(filename, File.extname(filename))

puts "Encoding #{basename}.mp3"
exec %Q[flac -sdc "#{filename}" | lame -#{qualarg} #{args} - "#{basename}.mp3"]
