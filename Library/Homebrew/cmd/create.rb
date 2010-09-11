require 'formula'

module Homebrew extend self
  def create
    if ARGV.include? '--macports'
      exec "open", "http://www.macports.org/ports.php?by=name&substr=#{ARGV.next}"
    elsif ARGV.include? '--fink'
      exec "open", "http://pdb.finkproject.org/pdb/browse.php?summary=#{ARGV.next}"
    elsif ARGV.named.empty?
      raise UsageError
    else
      paths = ARGV.named.map do |url|
        fc = FormulaCreator.new
        fc.url = url
        fc.mode = if ARGV.include? '--cmake'
          :cmake
        elsif ARGV.include? '--autotools'
          :autotools
        end

        if fc.name.to_s.strip.empty?
          path = Pathname.new url
          print "Formula name [#{path.stem}]: "
          fc.name = __gets || path.stem
        end

        unless ARGV.force?
          if msg = blacklisted?(fc.name)
            raise "#{msg}\n\nIf you really want to make this formula use --force."
          end

          if Formula.aliases.include? fc.name
            realname = Formula.caniconical_name fc.name
            raise <<-EOS.undent
              The formula #{realname} is already aliased to #{fc.name}
              Please check that you are not creating a duplicate.
              To force creation use --force.
              EOS
          end
        end
        fc.generate
        fc.path
      end
      exec_editor *paths
    end
  end

  def __gets
    gots = $stdin.gets.chomp
    if gots.empty? then nil else gots end
  end

  def blacklisted? name
    case name.downcase
    when 'vim', 'screen' then <<-EOS.undent
      #{name} is blacklisted for creation
      Apple distributes this program with OS X.
      EOS
    when 'libarchive', 'libpcap' then <<-EOS.undent
      #{name} is blacklisted for creation
      Apple distributes this library with OS X, you can find it in /usr/lib.
      EOS
    when 'libxml', 'libxlst', 'freetype', 'libpng' then <<-EOS.undent
      #{name} is blacklisted for creation
      Apple distributes this library with OS X, you can find it in /usr/X11/lib.
      However not all build scripts look here, so you may need to call ENV.x11 or
      ENV.libxml2 in your formula's install function.
      EOS
    when /^rubygems?$/
      "Sorry RubyGems comes with OS X so we don't package it."
    when 'wxwidgets' then <<-EOS.undent
      #{name} is blacklisted for creation
      An older version of wxWidgets is provided by Apple with OS X, but
      a formula for wxWidgets 2.8.10 is provided:

      brew install wxmac
      EOS
    end
  end
end

class FormulaCreator
  attr :url
  attr :md5
  attr :name, true
  attr :path
  attr :mode, true

  def url= url
    @url = url
    path = Pathname.new url
    /(.*?)[-_.]?#{path.version}/.match path.basename
    @name = $1
    @path = Formula.path $1
  end

  def version
    Pathname.new(url).version
  end

  def generate
    raise "#{path} already exists" if path.exist?
    raise VersionUndetermined if version.nil?

    require 'digest'
    require 'erb'

    if version.nil?
      opoo "Version cannot be determined from URL."
      puts "You'll need to add an explicit 'version' to the formula."
    else
      puts "Version detected as #{version}."
    end

    unless ARGV.include? "--no-md5" and version
      strategy = detect_download_strategy url
      @md5 = strategy.new(url, name, version, nil).fetch.md5 if strategy == CurlDownloadStrategy
    end

    path.write ERB.new(template, nil, '>').result(binding)
  end

  def template; <<-EOS.undent
    require 'formula'

    class #{Formula.class_s name} <Formula
      url '#{url}'
      homepage ''
      md5 '#{md5}'

    <% if mode == :cmake %>
      depends_on 'cmake'
    <% elsif mode == nil %>
      # depends_on 'cmake'
    <% end %>

      def install
    <% if mode == :cmake %>
        system "cmake . \#{std_cmake_parameters}"
    <% elsif mode == :autotools %>
        system "./configure", "--disable-debug", "--disable-dependency-tracking",
                              "--prefix=\#{prefix}"
    <% else %>
        system "./configure", "--disable-debug", "--disable-dependency-tracking",
                              "--prefix=\#{prefix}"
        # system "cmake . \#{std_cmake_parameters}"
    <% end %>
        system "make install"
      end
    end
    EOS
  end
end
